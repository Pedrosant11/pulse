-- Events and attendance (SPEC 7).

create table public.events (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 3 and 120),
  description text check (char_length(description) <= 4000),
  cover_path text,
  venue_name text not null check (char_length(venue_name) between 2 and 120),
  address text check (char_length(address) <= 200),
  city text not null check (char_length(city) between 2 and 80),
  state text not null check (state ~ '^[A-Z]{2}$'),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  genres public.music_genre[] not null default '{}',
  lineup text[] not null default '{}' check (cardinality(lineup) <= 50),
  ticket_url text check (ticket_url ~* '^https?://'),
  min_age smallint not null default 18 check (min_age between 18 and 21),
  status public.event_status not null default 'pending',
  is_official boolean not null default false,
  created_by uuid references public.profiles (id) on delete set null,
  approved_by uuid references public.profiles (id) on delete set null,
  rejection_reason text check (char_length(rejection_reason) <= 500),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at > starts_at),
  check (ends_at <= starts_at + interval '7 days')
);

create index events_status_starts_idx on public.events (status, starts_at);
create index events_city_starts_idx on public.events (state, city, starts_at);
create index events_created_by_idx on public.events (created_by);
create index events_name_trgm_idx
  on public.events using gin (name extensions.gin_trgm_ops);

create trigger events_set_updated_at
  before update on public.events
  for each row execute function private.set_updated_at();

-- Status/official flag come from the creator's role, never from the app
-- (SPEC 7.2). Rows inserted without a JWT (seed, service role) keep their
-- values.
create function private.set_event_status_on_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_role public.user_role;
begin
  if v_uid is null then
    return new;
  end if;

  v_role := private.current_user_role();
  new.created_by := v_uid;
  new.rejection_reason := null;

  case v_role
    when 'curator', 'admin' then
      new.status := 'approved';
      new.approved_by := v_uid;
      new.is_official := false;
    when 'producer' then
      new.status := 'approved';
      new.approved_by := v_uid;
      new.is_official := true;
    else
      new.status := 'pending';
      new.approved_by := null;
      new.is_official := false;
  end case;
  return new;
end;
$$;

create trigger events_set_status_on_insert
  before insert on public.events
  for each row execute function private.set_event_status_on_insert();

-- Who can edit what (SPEC 7.2: creator, curators and admins):
--   * moderators (curator/admin): anything, including approving/rejecting;
--   * producers: their own events, but can only cancel (not re-approve);
--   * regular users: their own events while still pending.
-- Ownership and the official flag are immutable for non-admins.
create function private.can_edit_event(p_event public.events)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.is_moderator()
    or (
      p_event.created_by = (select auth.uid())
      and (
        p_event.status = 'pending'
        or private.current_user_role() = 'producer'
      )
    );
$$;

create function private.guard_event_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null or private.is_admin() then
    return new;
  end if;

  new.created_by := old.created_by;
  new.is_official := old.is_official;
  new.created_at := old.created_at;

  if private.is_moderator() then
    if new.status is distinct from old.status then
      new.approved_by := case
        when new.status = 'approved' then (select auth.uid())
        else old.approved_by
      end;
      if new.status <> 'rejected' then
        new.rejection_reason := null;
      end if;
    end if;
    return new;
  end if;

  -- Creators: only keep the status or cancel the event.
  if new.status is distinct from old.status and new.status <> 'cancelled' then
    raise exception 'Only curators can change the event status'
      using errcode = '42501';
  end if;
  new.approved_by := old.approved_by;
  new.rejection_reason := old.rejection_reason;
  return new;
end;
$$;

create trigger events_guard_update
  before update on public.events
  for each row execute function private.guard_event_update();

-- ---------------------------------------------------------------------------
-- event_attendance ("Eu vou")
-- ---------------------------------------------------------------------------

create table public.event_attendance (
  user_id uuid not null references public.profiles (id) on delete cascade,
  event_id uuid not null references public.events (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, event_id)
);

create index event_attendance_event_idx on public.event_attendance (event_id);

create function private.attends_event(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.event_attendance
    where event_id = p_event_id and user_id = (select auth.uid())
  );
$$;

create function private.is_upcoming_approved_event(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.events
    where id = p_event_id and status = 'approved' and ends_at > now()
  );
$$;

-- ---------------------------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------------------------

-- Anti-duplication (SPEC 7.2): same local day, same city, similar name.
-- Runs with the caller's rights, so it only sees approved events and the
-- caller's own suggestions.
create function public.find_similar_events(
  p_name text,
  p_starts_at timestamptz,
  p_city text
)
returns table (
  id uuid,
  name text,
  venue_name text,
  city text,
  starts_at timestamptz,
  status public.event_status,
  similarity real
)
language sql
stable
set search_path = ''
as $$
  select e.id, e.name, e.venue_name, e.city, e.starts_at, e.status,
         extensions.similarity(lower(e.name), lower(p_name)) as similarity
  from public.events e
  where e.status in ('approved', 'pending')
    and (e.starts_at at time zone 'America/Sao_Paulo')::date
        = (p_starts_at at time zone 'America/Sao_Paulo')::date
    -- Two-argument form: the dictionary must be explicit with search_path ''.
    and lower(extensions.unaccent('extensions.unaccent'::regdictionary, e.city))
        = lower(extensions.unaccent('extensions.unaccent'::regdictionary, p_city))
    and extensions.similarity(lower(e.name), lower(p_name)) > 0.3
  order by similarity desc
  limit 5;
$$;

-- "X pessoas vão" + count per mode (SPEC 7.3). Attendance rows themselves are
-- private; this returns aggregates only and skips blocked users.
create function public.get_event_attendee_counts(p_event_ids uuid[])
returns table (
  event_id uuid,
  total int,
  date_count int,
  crew_count int
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    ea.event_id,
    count(*)::int as total,
    count(*) filter (where 'date' = any(p.modes))::int as date_count,
    count(*) filter (where 'crew' = any(p.modes))::int as crew_count
  from public.event_attendance ea
  join public.profiles p on p.id = ea.user_id
  join public.events e on e.id = ea.event_id
  where ea.event_id = any(p_event_ids)
    and (select auth.uid()) is not null
    and (e.status = 'approved' or e.created_by = (select auth.uid()))
    and p.status = 'active'
    and not private.is_blocked((select auth.uid()), p.id)
  group by ea.event_id;
$$;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.events enable row level security;
alter table public.event_attendance enable row level security;

create policy "events: approved, own or moderator"
  on public.events for select to authenticated
  using (
    status = 'approved'
    or created_by = (select auth.uid())
    or private.is_moderator()
  );

-- Status/ownership are forced by the insert trigger, which runs before
-- this check.
create policy "events: active users create"
  on public.events for insert to authenticated
  with check (
    created_by = (select auth.uid())
    and private.can_socialize()
  );

create policy "events: creator or moderator edits"
  on public.events for update to authenticated
  using (private.can_edit_event(events))
  with check (
    private.is_moderator()
    or created_by = (select auth.uid())
  );

create policy "events: admin deletes"
  on public.events for delete to authenticated
  using (private.is_admin());

-- Attendance: users see and manage their own rows. Aggregates come from
-- get_event_attendee_counts(); matching uses SECURITY DEFINER RPCs.
create policy "event_attendance: own rows"
  on public.event_attendance for select to authenticated
  using (user_id = (select auth.uid()));

create policy "event_attendance: join upcoming approved events"
  on public.event_attendance for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and private.can_socialize()
    and private.is_upcoming_approved_event(event_id)
  );

create policy "event_attendance: leave"
  on public.event_attendance for delete to authenticated
  using (user_id = (select auth.uid()));

revoke update on public.event_attendance from authenticated;

revoke execute on function public.find_similar_events(text, timestamptz, text) from public, anon;
grant execute on function public.find_similar_events(text, timestamptz, text) to authenticated;
revoke execute on function public.get_event_attendee_counts(uuid[]) from public, anon;
grant execute on function public.get_event_attendee_counts(uuid[]) to authenticated;
