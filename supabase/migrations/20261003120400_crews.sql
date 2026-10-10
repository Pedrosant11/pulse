-- Crews: groups tied to one event, max 8 members (SPEC 9.2).
-- The crew's group chat is the conversation with conversations.crew_id
-- pointing to it (single source of truth; no crews.conversation_id).

create table public.crews (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events (id) on delete cascade,
  owner_id uuid not null references public.profiles (id) on delete cascade,
  name text not null check (char_length(btrim(name)) between 2 and 40),
  description text check (char_length(description) <= 280),
  max_members smallint not null default 8 check (max_members between 2 and 8),
  is_open boolean not null default true,
  same_gender_only boolean not null default false,
  -- Owner's gender at creation, used by same_gender_only.
  gender public.gender,
  created_at timestamptz not null default now(),
  check (not same_gender_only or (gender is not null and gender <> 'prefer_not_say'))
);

create index crews_event_idx on public.crews (event_id);

alter table public.conversations
  add constraint conversations_crew_id_fkey
  foreign key (crew_id) references public.crews (id) on delete cascade;

create table public.crew_members (
  crew_id uuid not null references public.crews (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role public.crew_member_role not null default 'member',
  joined_at timestamptz not null default now(),
  primary key (crew_id, user_id)
);

create index crew_members_user_idx on public.crew_members (user_id);
create unique index crew_members_one_owner_idx
  on public.crew_members (crew_id) where role = 'owner';

create table public.crew_join_requests (
  id uuid primary key default gen_random_uuid(),
  crew_id uuid not null references public.crews (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  status public.request_status not null default 'pending',
  created_at timestamptz not null default now(),
  responded_at timestamptz
);

create unique index crew_join_requests_one_pending_idx
  on public.crew_join_requests (crew_id, user_id) where status = 'pending';

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

create function private.is_crew_member(p_crew_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.crew_members
    where crew_id = p_crew_id and user_id = (select auth.uid())
  );
$$;

create function private.is_crew_owner(p_crew_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.crews
    where id = p_crew_id and owner_id = (select auth.uid())
  );
$$;

-- Crews are visible to people going to the event (and to members).
create function private.can_see_crew(p_crew public.crews)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.is_crew_member(p_crew.id)
    or (
      private.attends_event(p_crew.event_id)
      and not private.is_blocked((select auth.uid()), p_crew.owner_id)
    );
$$;

-- ---------------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------------

create function private.before_crew_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is not null then
    new.owner_id := (select auth.uid());
  end if;
  new.gender := (select gender from public.profiles where id = new.owner_id);
  new.created_at := now();
  return new;
end;
$$;

create trigger crews_before_insert
  before insert on public.crews
  for each row execute function private.before_crew_insert();

-- Creates the group chat and adds the owner.
create function private.after_crew_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.conversations (type, crew_id) values ('crew', new.id);
  insert into public.crew_members (crew_id, user_id, role)
  values (new.id, new.owner_id, 'owner');
  return new;
end;
$$;

create trigger crews_after_insert
  after insert on public.crews
  for each row execute function private.after_crew_insert();

-- Capacity, same-gender rule and event attendance on join.
create function private.before_crew_member_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_crew public.crews;
  v_gender public.gender;
begin
  select * into v_crew from public.crews where id = new.crew_id for update;

  if (select count(*) from public.crew_members where crew_id = new.crew_id)
     >= v_crew.max_members then
    raise exception 'Crew is full' using errcode = 'P0001', hint = 'crew_full';
  end if;

  if new.role = 'member' then
    select gender into v_gender from public.profiles where id = new.user_id;
    if v_crew.same_gender_only and v_gender is distinct from v_crew.gender then
      raise exception 'This crew is same-gender only'
        using errcode = 'P0001', hint = 'crew_gender';
    end if;
    if not exists (
      select 1 from public.event_attendance
      where event_id = v_crew.event_id and user_id = new.user_id
    ) then
      raise exception 'Only people going to the event can join'
        using errcode = 'P0001', hint = 'crew_not_attending';
    end if;
  end if;

  new.joined_at := now();
  return new;
end;
$$;

create trigger crew_members_before_insert
  before insert on public.crew_members
  for each row execute function private.before_crew_member_insert();

-- Keep the group chat membership in sync.
create function private.sync_crew_conversation_members()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.conversation_members (conversation_id, user_id)
    select c.id, new.user_id from public.conversations c where c.crew_id = new.crew_id
    on conflict do nothing;
    return new;
  end if;

  delete from public.conversation_members cm
  using public.conversations c
  where c.crew_id = old.crew_id
    and cm.conversation_id = c.id
    and cm.user_id = old.user_id;
  return old;
end;
$$;

create trigger crew_members_sync_conversation
  after insert or delete on public.crew_members
  for each row execute function private.sync_crew_conversation_members();

-- The owner can't simply leave: transfer ownership first (or delete the crew).
create function private.guard_crew_owner_leave()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.role = 'owner'
     and exists (select 1 from public.crews where id = old.crew_id) then
    raise exception 'Transfer ownership before leaving the crew'
      using errcode = 'P0001', hint = 'crew_owner_leave';
  end if;
  return old;
end;
$$;

create trigger crew_members_guard_owner_leave
  before delete on public.crew_members
  for each row execute function private.guard_crew_owner_leave();

-- Approving a join request adds the member.
create function private.after_crew_join_request_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'approved' and old.status = 'pending' then
    insert into public.crew_members (crew_id, user_id, role)
    values (new.crew_id, new.user_id, 'member')
    on conflict do nothing;
  end if;
  return new;
end;
$$;

create function private.before_crew_join_request_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.status <> 'pending' then
    raise exception 'Request already answered' using errcode = 'P0001';
  end if;
  new.crew_id := old.crew_id;
  new.user_id := old.user_id;
  new.created_at := old.created_at;
  new.responded_at := now();
  return new;
end;
$$;

create trigger crew_join_requests_before_update
  before update on public.crew_join_requests
  for each row execute function private.before_crew_join_request_update();

create trigger crew_join_requests_after_update
  after update on public.crew_join_requests
  for each row execute function private.after_crew_join_request_update();

-- Ownership transfer to an existing member.
create function public.transfer_crew_ownership(p_crew_id uuid, p_new_owner uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_crew_owner(p_crew_id) then
    raise exception 'Only the owner can transfer the crew' using errcode = '42501';
  end if;
  if not exists (
    select 1 from public.crew_members
    where crew_id = p_crew_id and user_id = p_new_owner and role = 'member'
  ) then
    raise exception 'New owner must be a member' using errcode = '22023';
  end if;

  update public.crew_members set role = 'member'
  where crew_id = p_crew_id and role = 'owner';
  update public.crew_members set role = 'owner'
  where crew_id = p_crew_id and user_id = p_new_owner;
  update public.crews set owner_id = p_new_owner where id = p_crew_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.crews enable row level security;
alter table public.crew_members enable row level security;
alter table public.crew_join_requests enable row level security;

create policy "crews: attendees and members"
  on public.crews for select to authenticated
  using (private.can_see_crew(crews));

create policy "crews: attendees create"
  on public.crews for insert to authenticated
  with check (
    owner_id = (select auth.uid())
    and private.can_socialize()
    and private.attends_event(event_id)
    and private.is_upcoming_approved_event(event_id)
  );

create policy "crews: owner edits"
  on public.crews for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

create policy "crews: owner deletes"
  on public.crews for delete to authenticated
  using (owner_id = (select auth.uid()));

-- Only descriptive fields are editable; owner changes use the RPC.
revoke update on public.crews from authenticated;
grant update (name, description, is_open, max_members) on public.crews to authenticated;

create policy "crew_members: members and attendees"
  on public.crew_members for select to authenticated
  using (
    exists (
      select 1 from public.crews c
      where c.id = crew_id and private.can_see_crew(c)
    )
  );

-- Members leave; the owner removes members. Joining happens through
-- approved requests (and invites, in Phase 7).
create policy "crew_members: leave or owner removes"
  on public.crew_members for delete to authenticated
  using (
    user_id = (select auth.uid())
    or private.is_crew_owner(crew_id)
  );

revoke insert, update on public.crew_members from authenticated;

create policy "crew_join_requests: requester and owner"
  on public.crew_join_requests for select to authenticated
  using (user_id = (select auth.uid()) or private.is_crew_owner(crew_id));

create policy "crew_join_requests: attendees ask to join open crews"
  on public.crew_join_requests for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and status = 'pending'
    and private.can_socialize()
    and exists (
      select 1 from public.crews c
      where c.id = crew_id
        and c.is_open
        and private.can_see_crew(c)
    )
    and not private.is_crew_member(crew_id)
  );

-- Owner approves/rejects; requester cancels.
create policy "crew_join_requests: owner answers, requester cancels"
  on public.crew_join_requests for update to authenticated
  using (
    status = 'pending'
    and (private.is_crew_owner(crew_id) or user_id = (select auth.uid()))
  )
  with check (
    (private.is_crew_owner(crew_id) and status in ('approved', 'rejected'))
    or (user_id = (select auth.uid()) and status = 'cancelled')
  );

revoke delete on public.crew_join_requests from authenticated;
revoke update on public.crew_join_requests from authenticated;
grant update (status) on public.crew_join_requests to authenticated;

revoke execute on function public.transfer_crew_ownership(uuid, uuid) from public, anon;
grant execute on function public.transfer_crew_ownership(uuid, uuid) to authenticated;
