-- Safety and moderation (SPEC 10, 5.2): reports with context, admin
-- actions, timed suspensions, user-facing notices, blocking inside group
-- chats and the database side of account deletion.

create extension if not exists pg_cron with schema pg_catalog;

-- ---------------------------------------------------------------------------
-- Reports: who is reported and a snapshot of the content at report time
-- (messages can be deleted and wiped afterwards; admins can't read chats).
-- ---------------------------------------------------------------------------

alter table public.reports
  add column reported_user_id uuid references public.profiles (id) on delete set null,
  add column snapshot jsonb not null default '{}'::jsonb;

create index reports_reported_user_idx
  on public.reports (reported_user_id, created_at desc);

-- One pending report per reporter and target (repeats are ignored).
create unique index reports_one_pending_idx
  on public.reports (reporter_id, target_type, target_id)
  where status = 'pending';

-- Validates the target (the reporter must be able to see it), fills the
-- reported user and the snapshot, and rate-limits reporting.
create or replace function private.before_report_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.reporter_id := coalesce((select auth.uid()), new.reporter_id);
  new.status := 'pending';
  new.resolved_by := null;
  new.resolved_at := null;
  new.resolution_note := null;
  new.created_at := now();

  if new.reporter_id is null then
    raise exception 'Not signed in' using errcode = '42501';
  end if;

  if exists (
    select 1 from public.reports
    where reporter_id = new.reporter_id
      and target_type = new.target_type
      and target_id = new.target_id
      and status = 'pending'
  ) then
    return null;
  end if;

  if (
    select count(*) from public.reports
    where reporter_id = new.reporter_id
      and created_at > now() - interval '1 hour'
  ) >= 10 then
    perform private.raise_rate_limited('reports');
  end if;

  case new.target_type
    when 'user' then
      select p.id, jsonb_build_object('first_name', p.first_name)
      into new.reported_user_id, new.snapshot
      from public.profiles p
      where p.id = new.target_id;
    when 'message' then
      select
        msg.sender_id,
        jsonb_build_object(
          'first_name', p.first_name,
          'content', msg.content,
          'sent_at', msg.created_at,
          'conversation_type', c.type
        )
      into new.reported_user_id, new.snapshot
      from public.messages msg
      join public.conversations c on c.id = msg.conversation_id
      join public.profiles p on p.id = msg.sender_id
      where msg.id = new.target_id
        and msg.deleted_at is null
        and exists (
          select 1 from public.conversation_members cm
          where cm.conversation_id = msg.conversation_id
            and cm.user_id = new.reporter_id
        );
    when 'event' then
      select
        e.created_by,
        jsonb_build_object(
          'name', e.name,
          'starts_at', e.starts_at,
          'city', e.city,
          'state', e.state,
          'venue_name', e.venue_name
        )
      into new.reported_user_id, new.snapshot
      from public.events e
      where e.id = new.target_id and e.status = 'approved';
  end case;

  if not found then
    raise exception 'Report target not found' using errcode = 'P0002';
  end if;
  if new.reported_user_id = new.reporter_id then
    raise exception 'Cannot report yourself' using errcode = '22023';
  end if;
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Moderation actions: notices for the affected user and timed suspensions.
-- ---------------------------------------------------------------------------

alter table public.moderation_actions
  add column seen_at timestamptz,
  add constraint moderation_actions_expiry_check
    check (expires_at is null or action = 'suspension');

-- Suspensions end by themselves (latest action is a suspension that
-- expired). Runs as the job owner, so the profile guard lets it through.
create function private.expire_suspensions()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  with expired as (
    select p.id
    from public.profiles p
    where p.status = 'suspended'
      and (
        select ma.expires_at from public.moderation_actions ma
        where ma.target_user_id = p.id
          and ma.action in ('suspension', 'ban', 'reactivation')
        order by ma.created_at desc
        limit 1
      ) <= now()
  )
  update public.profiles p set status = 'active'
  from expired
  where p.id = expired.id;
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

select cron.schedule(
  'expire-suspensions',
  '*/5 * * * *',
  'select private.expire_suspensions()'
);

-- What the signed-in user should be told: the suspension/ban while the
-- account is restricted, otherwise the latest warning not yet seen.
create function public.get_my_moderation_notice()
returns table (
  id uuid,
  action public.moderation_action_type,
  reason text,
  expires_at timestamptz,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select ma.id, ma.action, ma.reason, ma.expires_at, ma.created_at
  from public.moderation_actions ma
  join public.profiles p on p.id = ma.target_user_id
  where ma.target_user_id = (select auth.uid())
    and case
      when p.status = 'active' then ma.action = 'warning' and ma.seen_at is null
      else ma.action in ('suspension', 'ban')
    end
  order by ma.created_at desc
  limit 1;
$$;

create function public.ack_moderation_notice(p_action_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.moderation_actions
  set seen_at = coalesce(seen_at, now())
  where id = p_action_id
    and target_user_id = (select auth.uid());
$$;

-- ---------------------------------------------------------------------------
-- Admin panel RPCs (empty / refused for anyone else).
-- ---------------------------------------------------------------------------

create function public.admin_list_reports()
returns table (
  id uuid,
  target_type public.report_target,
  target_id uuid,
  reason public.report_reason,
  details text,
  snapshot jsonb,
  created_at timestamptz,
  reporter_id uuid,
  reporter_first_name text,
  reported_user_id uuid,
  reported_first_name text,
  reported_photo_path text,
  reported_status public.account_status,
  reports_against_user int,
  previous_actions int
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    r.id,
    r.target_type,
    r.target_id,
    r.reason,
    r.details,
    r.snapshot,
    r.created_at,
    r.reporter_id,
    rep.first_name,
    r.reported_user_id,
    tgt.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = tgt.id order by ph.position limit 1),
    tgt.status,
    (select count(*)::int from public.reports o
     where o.reported_user_id = r.reported_user_id),
    (select count(*)::int from public.moderation_actions ma
     where ma.target_user_id = r.reported_user_id
       and ma.action <> 'reactivation')
  from public.reports r
  left join public.profiles rep on rep.id = r.reporter_id
  left join public.profiles tgt on tgt.id = r.reported_user_id
  where private.is_admin() and r.status = 'pending'
  order by r.created_at;
$$;

-- Resolves a report in one step: optional action on the reported account,
-- optional removal of the reported content, and closes the other pending
-- reports about the same target (or, for a ban, about the same person).
create function public.admin_resolve_report(
  p_report_id uuid,
  p_outcome text,
  p_note text default null,
  p_suspension_days int default null,
  p_remove_content boolean default false
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_report public.reports;
  v_action public.moderation_action_type;
  v_note text := nullif(btrim(p_note), '');
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;

  select * into v_report from public.reports where id = p_report_id for update;
  if not found then
    raise exception 'Report not found' using errcode = 'P0002';
  end if;
  if v_report.status <> 'pending' then
    raise exception 'Report already handled' using errcode = 'P0001';
  end if;

  if p_outcome not in ('dismiss', 'resolve', 'warning', 'suspension', 'ban') then
    raise exception 'Unknown outcome %', p_outcome using errcode = '22023';
  end if;

  if p_outcome in ('warning', 'suspension', 'ban') then
    if v_report.reported_user_id is null then
      raise exception 'The reported account no longer exists' using errcode = 'P0002';
    end if;
    if v_note is null or char_length(v_note) < 3 then
      raise exception 'A reason is required' using errcode = '22023';
    end if;
    if p_outcome = 'suspension'
       and (p_suspension_days is null or p_suspension_days not between 1 and 365) then
      raise exception 'Suspension needs 1 to 365 days' using errcode = '22023';
    end if;
    v_action := p_outcome::public.moderation_action_type;
    insert into public.moderation_actions
      (target_user_id, action, reason, report_id, expires_at)
    values (
      v_report.reported_user_id,
      v_action,
      v_note,
      v_report.id,
      case when p_outcome = 'suspension'
        then now() + make_interval(days => p_suspension_days) end
    );
  end if;

  if p_remove_content then
    if v_report.target_type = 'message' then
      update public.messages set deleted_at = now()
      where id = v_report.target_id and deleted_at is null;
    elsif v_report.target_type = 'event' then
      update public.events
      set status = 'rejected',
          rejection_reason = coalesce(v_note, 'Removido pela moderação')
      where id = v_report.target_id;
    end if;
  end if;

  update public.reports
  set status = case when p_outcome = 'dismiss'
        then 'dismissed'::public.report_status
        else 'resolved'::public.report_status end,
      resolution_note = v_note
  where status = 'pending'
    and (
      id = v_report.id
      or (target_type = v_report.target_type and target_id = v_report.target_id)
      or (p_outcome = 'ban' and reported_user_id = v_report.reported_user_id)
    );
end;
$$;

-- Suspended and banned accounts, for reactivation.
create function public.admin_list_restricted_users()
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  status public.account_status,
  reason text,
  expires_at timestamptz,
  acted_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    p.id,
    p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    p.status,
    last_action.reason,
    last_action.expires_at,
    last_action.created_at
  from public.profiles p
  left join lateral (
    select ma.reason, ma.expires_at, ma.created_at
    from public.moderation_actions ma
    where ma.target_user_id = p.id and ma.action in ('suspension', 'ban')
    order by ma.created_at desc
    limit 1
  ) last_action on true
  where private.is_admin() and p.status <> 'active'
  order by last_action.created_at desc nulls last;
$$;

-- ---------------------------------------------------------------------------
-- Blocking (SPEC 10): hidden everywhere, in both directions.
-- ---------------------------------------------------------------------------

-- Blocked people's messages disappear from shared group chats too.
drop policy "messages: members read" on public.messages;
create policy "messages: members read"
  on public.messages for select to authenticated
  using (
    private.can_access_conversation(conversation_id)
    and not private.is_blocked((select auth.uid()), sender_id)
  );

-- Blocking also drops pending crew requests/invites between the two.
create or replace function private.after_block()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.matches
  set unmatched_at = now(), unmatched_by = new.blocker_id
  where user_a = least(new.blocker_id, new.blocked_id)
    and user_b = greatest(new.blocker_id, new.blocked_id)
    and unmatched_at is null;

  delete from public.crew_join_requests r
  using public.crews c
  where c.id = r.crew_id
    and r.status = 'pending'
    and (
      (c.owner_id = new.blocker_id and r.user_id = new.blocked_id)
      or (c.owner_id = new.blocked_id and r.user_id = new.blocker_id)
    );
  return new;
end;
$$;

-- The blocked list (blocked people are hidden from public_profiles).
create function public.list_my_blocks()
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  blocked_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    b.blocked_id,
    p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    b.created_at
  from public.blocks b
  join public.profiles p on p.id = b.blocked_id
  where b.blocker_id = (select auth.uid())
  order by b.created_at desc;
$$;

-- Inbox previews and unread counts skip blocked senders (group chats).
create or replace function public.list_conversations()
returns table (
  id uuid,
  type public.conversation_type,
  mode public.app_mode,
  match_id uuid,
  other_user_id uuid,
  other_first_name text,
  other_photo_path text,
  last_message text,
  last_message_sender_id uuid,
  last_message_at timestamptz,
  unread_count int,
  created_at timestamptz,
  crew_id uuid,
  crew_name text,
  event_name text,
  member_count int
)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select
    c.id,
    c.type,
    m.mode,
    c.match_id,
    other.id,
    other.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = other.id order by ph.position limit 1),
    last_msg.content,
    last_msg.sender_id,
    last_msg.created_at,
    (
      select count(*)::int from public.messages msg
      where msg.conversation_id = c.id
        and msg.sender_id <> me.id
        and msg.deleted_at is null
        and msg.created_at > coalesce(cm.last_read_at, '-infinity'::timestamptz)
        and not private.is_blocked(me.id, msg.sender_id)
    ),
    c.created_at,
    cr.id,
    cr.name,
    ev.name,
    (select count(*)::int from public.crew_members cmm where cmm.crew_id = cr.id)
  from me
  join public.conversation_members cm on cm.user_id = me.id
  join public.conversations c on c.id = cm.conversation_id
  left join public.matches m on m.id = c.match_id
  left join public.profiles other
    on c.type = 'direct'
   and other.id = case when m.user_a = me.id then m.user_b else m.user_a end
  left join public.crews cr on cr.id = c.crew_id
  left join public.events ev on ev.id = cr.event_id
  left join lateral (
    select msg.content, msg.sender_id, msg.created_at
    from public.messages msg
    where msg.conversation_id = c.id
      and msg.deleted_at is null
      and not private.is_blocked(me.id, msg.sender_id)
    order by msg.created_at desc
    limit 1
  ) last_msg on true
  where me.id is not null
    and private.can_access_conversation(c.id)
  order by coalesce(last_msg.created_at, c.created_at) desc;
$$;

-- ---------------------------------------------------------------------------
-- Account deletion (SPEC 5.2). The Edge Function `delete-account` removes
-- the Storage files and then the Auth user; the cascade does the rest.
-- Before that, crews the person owns go to their oldest member (or are
-- deleted when empty), so the owner guard never blocks the cascade.
-- ---------------------------------------------------------------------------

create function private.before_profile_delete()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_crew record;
  v_heir uuid;
begin
  for v_crew in select id from public.crews where owner_id = old.id loop
    select cm.user_id into v_heir
    from public.crew_members cm
    where cm.crew_id = v_crew.id and cm.user_id <> old.id
    order by cm.joined_at
    limit 1;

    if v_heir is null then
      delete from public.crews where id = v_crew.id;
    else
      update public.crew_members set role = 'member'
      where crew_id = v_crew.id and user_id = old.id;
      update public.crew_members set role = 'owner'
      where crew_id = v_crew.id and user_id = v_heir;
      update public.crews set owner_id = v_heir where id = v_crew.id;
    end if;
  end loop;

  -- Suggestions nobody else can see go with the account.
  delete from public.events
  where created_by = old.id and status in ('pending', 'rejected');
  return old;
end;
$$;

create trigger profiles_before_delete
  before delete on public.profiles
  for each row execute function private.before_profile_delete();

-- Answered requests are frozen, except for the inviter being cleared when
-- that account is deleted (invited_by is ON DELETE SET NULL).
create or replace function private.before_crew_join_request_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.status <> 'pending' then
    if new.invited_by is null
       and old.invited_by is not null
       and new.status = old.status then
      new := old;
      new.invited_by := null;
      return new;
    end if;
    raise exception 'Request already answered' using errcode = 'P0001';
  end if;
  new.crew_id := old.crew_id;
  new.user_id := old.user_id;
  new.created_at := old.created_at;
  new.responded_at := now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------

revoke execute on function public.get_my_moderation_notice() from public, anon;
grant execute on function public.get_my_moderation_notice() to authenticated;
revoke execute on function public.ack_moderation_notice(uuid) from public, anon;
grant execute on function public.ack_moderation_notice(uuid) to authenticated;
revoke execute on function public.admin_list_reports() from public, anon;
grant execute on function public.admin_list_reports() to authenticated;
revoke execute on function public.admin_resolve_report(uuid, text, text, int, boolean)
  from public, anon;
grant execute on function public.admin_resolve_report(uuid, text, text, int, boolean)
  to authenticated;
revoke execute on function public.admin_list_restricted_users() from public, anon;
grant execute on function public.admin_list_restricted_users() to authenticated;
revoke execute on function public.list_my_blocks() from public, anon;
grant execute on function public.list_my_blocks() to authenticated;
revoke execute on function private.expire_suspensions() from public, anon, authenticated;
