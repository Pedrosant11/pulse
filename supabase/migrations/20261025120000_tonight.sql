-- "Modo Hoje" (launch plan): what happens on the party night.
--   * Check-in at the party ("Tô na festa"), honour-based (no GPS): from
--     2 h before the start until the end. Lasts until 2 h after the end or
--     until checking out.
--   * Who is here: everyone sees how many; people checked in also see
--     which of their matches and crew mates are here.
--   * Discover puts people at the same party right now first.
--   * Crews get a meeting point.
--   * "Mesmo rolê": for 24 h after the party, Date-compatible people who
--     checked in at the same event (who: Pulse Black; how many: everyone),
--     with a push when the party ends.

create table public.event_checkins (
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  checked_in_at timestamptz not null default now(),
  checked_out_at timestamptz,
  primary key (event_id, user_id)
);

create index event_checkins_user_idx on public.event_checkins (user_id, checked_in_at desc);

alter table public.event_checkins enable row level security;
revoke all on public.event_checkins from anon, authenticated;
grant select on public.event_checkins to authenticated;
create policy "event_checkins: own rows" on public.event_checkins
  for select to authenticated using (user_id = (select auth.uid()));

-- Events the person is at right now.
create function private.checked_in_events(p_user uuid)
returns setof uuid
language sql
stable
security definer
set search_path = ''
as $$
  select ci.event_id
  from public.event_checkins ci
  join public.events e on e.id = ci.event_id
  where ci.user_id = p_user
    and ci.checked_out_at is null
    and now() < e.ends_at + interval '2 hours';
$$;

-- "Tô na festa": also marks "Vou" when missing.
create function public.check_in(p_event_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null or not private.can_socialize() then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  if not exists (
    select 1 from public.events
    where id = p_event_id
      and status = 'approved'
      and now() between starts_at - interval '2 hours' and ends_at
  ) then
    raise exception 'Check-in opens 2 hours before the party'
      using errcode = 'P0001', hint = 'checkin_closed';
  end if;

  insert into public.event_attendance (event_id, user_id)
  values (p_event_id, v_uid)
  on conflict do nothing;

  insert into public.event_checkins (event_id, user_id)
  values (p_event_id, v_uid)
  on conflict (event_id, user_id) do update
    set checked_in_at = now(), checked_out_at = null;
end;
$$;

create function public.check_out(p_event_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.event_checkins set checked_out_at = now()
  where event_id = p_event_id and user_id = (select auth.uid())
    and checked_out_at is null;
$$;

-- How many people are at the party now (anyone who can see the event).
create function public.get_event_here_count(p_event_id uuid)
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::int
  from public.event_checkins ci
  join public.events e on e.id = ci.event_id
  join public.profiles p on p.id = ci.user_id
  where ci.event_id = p_event_id
    and ci.checked_out_at is null
    and now() < e.ends_at + interval '2 hours'
    and e.status = 'approved'
    and p.status = 'active';
$$;

-- Matches and crew mates at the party now. Only for people checked in
-- there too (who's here is shared both ways).
create function public.get_event_here_friends(p_event_id uuid)
returns table (user_id uuid, first_name text, photo_path text, relation text)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select p.id, p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    case when exists (
      select 1 from public.crew_members a
      join public.crew_members b on b.crew_id = a.crew_id
      join public.crews c on c.id = a.crew_id
      where a.user_id = me.id and b.user_id = p.id and c.event_id = p_event_id
    ) then 'crew' else 'match' end
  from me
  join public.profiles p on p.id <> me.id
  where p_event_id in (select private.checked_in_events(me.id))
    and p_event_id in (select private.checked_in_events(p.id))
    and p.status = 'active'
    and not private.is_blocked(me.id, p.id)
    and (
      exists (
        select 1 from public.matches m
        where m.unmatched_at is null
          and m.user_a = least(me.id, p.id) and m.user_b = greatest(me.id, p.id)
      )
      or exists (
        select 1 from public.crew_members a
        join public.crew_members b on b.crew_id = a.crew_id
        join public.crews c on c.id = a.crew_id
        where a.user_id = me.id and b.user_id = p.id and c.event_id = p_event_id
      )
    )
  order by p.first_name;
$$;

revoke execute on function public.check_in(uuid) from public, anon;
grant execute on function public.check_in(uuid) to authenticated;
revoke execute on function public.check_out(uuid) from public, anon;
grant execute on function public.check_out(uuid) to authenticated;
revoke execute on function public.get_event_here_count(uuid) from public, anon;
grant execute on function public.get_event_here_count(uuid) to authenticated;
revoke execute on function public.get_event_here_friends(uuid) from public, anon;
grant execute on function public.get_event_here_friends(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Crew meeting point
-- ---------------------------------------------------------------------------

alter table public.crews
  add column meeting_point text check (char_length(meeting_point) <= 120);

create function public.set_crew_meeting_point(p_crew_id uuid, p_text text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_crew_member(p_crew_id) then
    raise exception 'Members only' using errcode = '42501';
  end if;
  update public.crews set meeting_point = nullif(btrim(p_text), '')
  where id = p_crew_id;
end;
$$;

revoke execute on function public.set_crew_meeting_point(uuid, text) from public, anon;
grant execute on function public.set_crew_meeting_point(uuid, text) to authenticated;

drop function public.get_crew(uuid);

create function public.get_crew(p_crew_id uuid)
returns table (
  id uuid,
  name text,
  description text,
  is_open boolean,
  same_gender_only boolean,
  max_members int,
  member_count int,
  owner_id uuid,
  event_id uuid,
  event_name text,
  event_starts_at timestamptz,
  conversation_id uuid,
  my_status text,
  my_request_id uuid,
  meeting_point text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    c.id, c.name, c.description, c.is_open, c.same_gender_only,
    c.max_members::int,
    (select count(*)::int from public.crew_members cm where cm.crew_id = c.id),
    c.owner_id,
    e.id, e.name, e.starts_at,
    -- The chat is only revealed to members.
    case when private.is_crew_member(c.id)
      then (select conv.id from public.conversations conv where conv.crew_id = c.id)
    end,
    private.crew_status(c.id),
    -- The user's pending request/invite (to cancel or answer it).
    (select r.id from public.crew_join_requests r
     where r.crew_id = c.id and r.user_id = (select auth.uid())
       and r.status = 'pending'
     limit 1),
    -- Members only.
    case when private.is_crew_member(c.id) then c.meeting_point end
  from public.crews c
  join public.events e on e.id = c.event_id
  where c.id = p_crew_id and private.can_see_crew(c);
$$;

revoke execute on function public.get_crew(uuid) from public, anon;
grant execute on function public.get_crew(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- "Mesmo rolê": the 24 h after a party
-- ---------------------------------------------------------------------------

-- Date-compatible people who checked in at an event p_uid checked in, which
-- ended less than 24 h ago, not answered or matched yet.
create function private.same_night_candidates(p_uid uuid)
returns table (user_id uuid, event_id uuid)
language sql
stable
security definer
set search_path = ''
as $$
  select distinct on (p.id) p.id, e.id
  from public.event_checkins mine
  join public.events e on e.id = mine.event_id
  join public.event_checkins theirs
    on theirs.event_id = mine.event_id and theirs.user_id <> mine.user_id
  join public.profiles me on me.id = mine.user_id
  join public.profiles p on p.id = theirs.user_id
  where mine.user_id = p_uid
    and e.ends_at <= now()
    and e.ends_at > now() - interval '24 hours'
    and p.status = 'active'
    and 'date' = any (me.modes) and 'date' = any (p.modes)
    and (cardinality(me.date_show_me) = 0 or p.gender = any (me.date_show_me))
    and (cardinality(p.date_show_me) = 0 or me.gender = any (p.date_show_me))
    and date_part('year', age(p.birth_date)) between me.date_age_min and me.date_age_max
    and date_part('year', age(me.birth_date)) between p.date_age_min and p.date_age_max
    and not private.is_blocked(p_uid, p.id)
    and not exists (
      select 1 from public.swipes s
      where s.swiper_id = p_uid and s.swiped_id = p.id and s.mode = 'date'
    )
  order by p.id, e.ends_at desc;
$$;

create function public.get_same_night_count()
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::int from private.same_night_candidates((select auth.uid()));
$$;

-- Who they are: Pulse Black.
create function public.get_same_night()
returns table (
  user_id uuid,
  first_name text,
  age int,
  photo_path text,
  event_name text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if private.plan_tier(v_uid) is distinct from 'black' then
    raise exception 'Mesmo rolê needs Pulse Black'
      using errcode = 'P0001', hint = 'plan_required';
  end if;
  return query
  select p.id, p.first_name, date_part('year', age(p.birth_date))::int,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    e.name
  from private.same_night_candidates(v_uid) c
  join public.profiles p on p.id = c.user_id
  join public.events e on e.id = c.event_id
  order by p.first_name;
end;
$$;

revoke execute on function public.get_same_night_count() from public, anon;
grant execute on function public.get_same_night_count() to authenticated;
revoke execute on function public.get_same_night() from public, anon;
grant execute on function public.get_same_night() to authenticated;

-- Hourly: people who checked in at a party that just ended hear how many
-- people from that night they can still meet (send-push kind same_night).
create function private.notify_same_night()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid;
  v_sent int := 0;
begin
  for v_user in
    select distinct ci.user_id
    from public.event_checkins ci
    join public.events e on e.id = ci.event_id
    where e.ends_at <= now() and e.ends_at > now() - interval '1 hour'
  loop
    if exists (select 1 from private.same_night_candidates(v_user)) then
      perform private.send_push(
        array[v_user], 'same_night', jsonb_build_object('route', '/same-night')
      );
      v_sent := v_sent + 1;
    end if;
  end loop;
  return v_sent;
end;
$$;

select cron.schedule('notify-same-night', '5 * * * *', 'select private.notify_same_night()');

-- Check-ins are only useful around the night: removed after 30 days.
create function private.purge_checkins()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  delete from public.event_checkins where checked_in_at < now() - interval '30 days';
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

select cron.schedule('purge-checkins', '50 3 * * *', 'select private.purge_checkins()');

-- ---------------------------------------------------------------------------
-- Discover: people at the same party right now come first
-- ---------------------------------------------------------------------------

drop function public.get_discover_feed(public.app_mode, int);

create function public.get_discover_feed(
  p_mode public.app_mode,
  p_limit int default 20
)
returns table (
  id uuid,
  first_name text,
  age int,
  city text,
  state text,
  occupation text,
  bio text,
  gender public.gender,
  is_verified boolean,
  music_genres public.music_genre[],
  photo_paths text[],
  common_events jsonb,
  common_event_count int,
  is_fallback boolean,
  distance_km double precision,
  favorite_djs text[],
  date_looking_for public.date_intent,
  crew_size int,
  super_liked_me boolean,
  here_now boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_uid uuid := (select auth.uid());
  v_me public.profiles;
  v_my_age int;
  v_limit int := least(greatest(coalesce(p_limit, 20), 1), 50);
  v_travel public.travel_locations;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  select * into v_me from public.profiles p where p.id = v_uid;
  if v_me.id is null
     or v_me.status <> 'active'
     or not v_me.onboarding_completed
     or not (p_mode = any(v_me.modes)) then
    return;
  end if;
  v_my_age := date_part('year', age(v_me.birth_date))::int;

  -- Travel mode (plan): Date looks around the chosen city.
  if private.plan_tier(v_uid) is not null then
    select * into v_travel from public.travel_locations t where t.user_id = v_uid;
    if v_travel.user_id is not null then
      v_me.lat := v_travel.lat;
      v_me.lng := v_travel.lng;
      v_me.city := v_travel.city;
      v_me.state := v_travel.state;
    end if;
  end if;

  return query
  with my_events as (
    select e.id as event_id, e.name, e.starts_at
    from public.event_attendance ea
    join public.events e on e.id = ea.event_id
    where ea.user_id = v_uid
      and e.status = 'approved'
      and e.ends_at > now()
  ),
  candidates as (
    select
      p.*,
      private.distance_km(v_me.lat, v_me.lng, p.lat, p.lng) as dist,
      p_mode = 'date' and exists (
        select 1 from public.swipes s
        where s.swiper_id = p.id and s.swiped_id = v_uid and s.mode = 'date'
          and s.direction = 'like' and s.is_super
      ) as super_like,
      exists (
        select 1 from public.boosts b
        where b.user_id = p.id and b.ends_at > now()
      ) as boosted,
      exists (
        select 1 from private.checked_in_events(p.id) theirs
        where theirs in (select private.checked_in_events(v_uid))
      ) as here
    from public.profiles p
    where p.id <> v_uid
      and p.status = 'active'
      and p.onboarding_completed
      and p_mode = any(p.modes)
      and (select count(*) from public.profile_photos ph where ph.user_id = p.id) >= 2
      and not exists (
        select 1 from public.swipes s
        where s.swiper_id = v_uid and s.swiped_id = p.id and s.mode = p_mode
      )
      and not private.is_blocked(v_uid, p.id)
      -- Incognito: only people they liked see them.
      and (not private.is_incognito(p.id) or exists (
        select 1 from public.swipes s
        where s.swiper_id = p.id and s.swiped_id = v_uid and s.direction = 'like'
      ))
      and (
        (p_mode = 'date'
          and (cardinality(v_me.date_show_me) = 0 or p.gender = any(v_me.date_show_me))
          and (cardinality(p.date_show_me) = 0 or v_me.gender = any(p.date_show_me))
          and date_part('year', age(p.birth_date)) between v_me.date_age_min and v_me.date_age_max
          and v_my_age between p.date_age_min and p.date_age_max)
        or
        (p_mode = 'crew'
          and (not v_me.crew_same_gender_only
               or (p.gender = v_me.gender and v_me.gender <> 'prefer_not_say'))
          and (not p.crew_same_gender_only
               or (p.gender = v_me.gender and p.gender <> 'prefer_not_say')))
      )
  ),
  common as (
    select
      ea.user_id,
      count(*)::int as event_count,
      min(me.starts_at) as next_event_at,
      jsonb_agg(
        jsonb_build_object('id', me.event_id, 'name', me.name, 'starts_at', me.starts_at)
        order by me.starts_at
      ) as events
    from public.event_attendance ea
    join my_events me on me.event_id = ea.event_id
    where ea.user_id in (select c.id from candidates c)
    group by ea.user_id
  ),
  ranked as (
    select
      c.*,
      co.events,
      co.event_count,
      co.next_event_at,
      co.user_id is null as fallback,
      cardinality(array(
        select unnest(c.music_genres) intersect select unnest(v_me.music_genres)
      )) as shared_genres
    from candidates c
    left join common co on co.user_id = c.id
    where co.user_id is not null
       -- Date also shows people nearby; Crew is only the same parties.
       or (p_mode = 'date' and (
             (c.dist is not null and c.dist <= v_me.discovery_radius_km)
             -- Without coordinates on either side, same state.
             or (c.dist is null and c.state = v_me.state)
           ))
  )
  select
    r.id,
    r.first_name,
    date_part('year', age(r.birth_date))::int,
    r.city,
    r.state,
    r.occupation,
    r.bio,
    r.gender,
    r.is_verified,
    r.music_genres,
    array(
      select ph.storage_path from public.profile_photos ph
      where ph.user_id = r.id order by ph.position
    ),
    coalesce(r.events, '[]'::jsonb),
    coalesce(r.event_count, 0),
    r.fallback,
    r.dist,
    r.favorite_djs,
    r.date_looking_for,
    -- Crew mode: size of the crew they're in for the first common event
    -- (null = going solo).
    case when p_mode = 'crew' then nullif((
      select count(*)::int from public.crew_members cm2
      where cm2.crew_id = (
        select cm.crew_id from public.crew_members cm
        join public.crews cr on cr.id = cm.crew_id
        where cm.user_id = r.id
          and cr.event_id = (r.events -> 0 ->> 'id')::uuid
        limit 1
      )
    ), 0) end,
    r.super_like,
    r.here
  from ranked r
  order by
    -- Boosts, then people who superliked the viewer.
    r.boosted desc,
    -- At the same party right now.
    r.here desc,
    r.super_like desc,
    -- Same parties first, soonest first.
    r.event_count desc nulls last,
    r.next_event_at asc nulls last,
    -- Then nearby: shared genres, nearest.
    r.shared_genres desc,
    r.dist asc nulls last,
    r.last_active_at desc
  limit v_limit;
end;
$$;

revoke execute on function public.get_discover_feed(public.app_mode, int) from public, anon;
grant execute on function public.get_discover_feed(public.app_mode, int) to authenticated;

-- LGPD export: check-ins too.
create or replace function public.export_my_data()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  return private.export_my_data_base() || jsonb_build_object(
    'plan', (
      select jsonb_build_object(
        'tier', s.tier, 'source', s.source, 'expires_at', s.expires_at,
        'will_renew', s.will_renew
      )
      from public.subscriptions s where s.user_id = v_uid
    ),
    'wallet', (
      select jsonb_build_object('superlikes', w.superlikes, 'boosts', w.boosts)
      from public.wallets w where w.user_id = v_uid
    ),
    'boosts', coalesce((
      select jsonb_agg(
        jsonb_build_object('starts_at', b.starts_at, 'ends_at', b.ends_at)
        order by b.starts_at
      )
      from public.boosts b where b.user_id = v_uid
    ), '[]'::jsonb),
    'travel_mode', (
      select jsonb_build_object('city', t.city, 'state', t.state)
      from public.travel_locations t where t.user_id = v_uid
    ),
    'ticket_clicks', coalesce((
      select jsonb_agg(
        jsonb_build_object('event', e.name, 'at', c.created_at)
        order by c.created_at
      )
      from public.ticket_clicks c
      join public.events e on e.id = c.event_id
      where c.user_id = v_uid
    ), '[]'::jsonb),
    'verification', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'status', v.status, 'pose', v.pose, 'consent_at', v.consent_at,
          'created_at', v.created_at, 'reviewed_at', v.reviewed_at,
          'rejection_reason', v.rejection_reason
        ) order by v.created_at
      )
      from public.verification_requests v where v.user_id = v_uid
    ), '[]'::jsonb),
    'checkins', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'event', e.name, 'checked_in_at', ci.checked_in_at,
          'checked_out_at', ci.checked_out_at
        ) order by ci.checked_in_at
      )
      from public.event_checkins ci
      join public.events e on e.id = ci.event_id
      where ci.user_id = v_uid
    ), '[]'::jsonb)
  );
end;
$$;
