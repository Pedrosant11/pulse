-- Party night and the day after:
--   * "Tô ON": on the day of a party they marked "Eu vou" (from 6 h before
--     it starts until it ends), people can say they're there tonight. Only
--     their matches and crew-mates for that party see it; nothing is
--     public and there is no location.
--   * "Depois da festa": for 48 h after a party ends, the people who went
--     see a Date deck with everyone who marked "Eu vou" there, wherever
--     they live (get_discover_feed(p_event)). A push the next morning
--     (after_party) invites them. Crew stays for upcoming parties only.
--   * "Salvar": keep a party for later without saying "Eu vou". Saved
--     parties show in "Meus eventos" and get the reminder the day before.
--   * Sections on top of "Próximos" (event_sections): trending this week,
--     this week, and at casas the person follows.

insert into private.app_settings (key, value) values
  ('after_party_hours', '48'),
  ('on_hours_before', '6');

-- ---------------------------------------------------------------------------
-- "Tô ON"
-- ---------------------------------------------------------------------------

create table public.event_on (
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);

alter table public.event_on enable row level security;

-- Only your own row; who else is ON comes from event_on_people().
create policy "event_on: own" on public.event_on
  for select to authenticated
  using (user_id = (select auth.uid()));

-- Going to it, and it's tonight.
create function private.on_window_open(p_user uuid, p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.events e
    join public.event_attendance ea on ea.event_id = e.id and ea.user_id = p_user
    where e.id = p_event
      and e.status = 'approved'
      and now() between e.starts_at - make_interval(hours => private.setting_int('on_hours_before'))
                    and e.ends_at
  );
$$;

create function public.set_on(p_event uuid, p_on boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if not coalesce(p_on, false) then
    delete from public.event_on where event_id = p_event and user_id = v_uid;
    return;
  end if;
  if not private.on_window_open(v_uid, p_event) then
    raise exception 'Only on the night of a party you are going to'
      using errcode = 'P0001', hint = 'on_not_now';
  end if;
  insert into public.event_on (event_id, user_id) values (p_event, v_uid)
  on conflict do nothing;
end;
$$;

revoke execute on function public.set_on(uuid, boolean) from public, anon;
grant execute on function public.set_on(uuid, boolean) to authenticated;

-- Is p_other my match (any mode, still matched) or in a crew of mine for
-- p_event?
create function private.is_my_people(p_other uuid, p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.matches m
    where m.unmatched_at is null
      and ((m.user_a = (select auth.uid()) and m.user_b = p_other)
        or (m.user_b = (select auth.uid()) and m.user_a = p_other))
  ) or exists (
    select 1 from public.crews c
    join public.crew_members mine on mine.crew_id = c.id and mine.user_id = (select auth.uid())
    join public.crew_members theirs on theirs.crew_id = c.id and theirs.user_id = p_other
    where c.event_id = p_event
  );
$$;

-- My matches and crew-mates who are ON at this party right now.
create function public.event_on_people(p_event uuid)
returns table (
  user_id uuid,
  first_name text,
  photo_path text
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
      where ph.user_id = p.id order by ph.position limit 1)
  from public.event_on o
  join public.events e on e.id = o.event_id
  join public.profiles p on p.id = o.user_id
  where o.event_id = p_event
    and o.user_id <> (select auth.uid())
    and e.ends_at > now()
    and p.status = 'active'
    and not private.is_blocked((select auth.uid()), p.id)
    and private.is_my_people(p.id, p_event)
  order by o.created_at desc;
$$;

revoke execute on function public.event_on_people(uuid) from public, anon;
grant execute on function public.event_on_people(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- "Depois da festa"
-- ---------------------------------------------------------------------------

-- Went to it ("Eu vou") and it ended less than 48 h ago.
create function private.after_party_open(p_user uuid, p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.events e
    join public.event_attendance ea on ea.event_id = e.id and ea.user_id = p_user
    where e.id = p_event
      and e.status = 'approved'
      and now() between e.ends_at
                    and e.ends_at + make_interval(hours => private.setting_int('after_party_hours'))
  );
$$;

-- Parties I went to whose "Depois da festa" is open, with how many others
-- went (for the Discover banner).
create function public.my_after_parties()
returns table (
  id uuid,
  name text,
  ends_at timestamptz,
  closes_at timestamptz,
  people int
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    e.id, e.name, e.ends_at,
    e.ends_at + make_interval(hours => private.setting_int('after_party_hours')),
    (select count(*)::int from public.event_attendance o
      join public.profiles p on p.id = o.user_id
      where o.event_id = e.id and o.user_id <> (select auth.uid())
        and p.status = 'active' and 'date' = any(p.modes))
  from public.events e
  where e.ends_at < now()
    and e.ends_at > now() - make_interval(hours => private.setting_int('after_party_hours'))
    and private.after_party_open((select auth.uid()), e.id)
  order by e.ends_at desc;
$$;

revoke execute on function public.my_after_parties() from public, anon;
grant execute on function public.my_after_parties() to authenticated;

drop function public.get_discover_feed(public.app_mode, int);
create function public.get_discover_feed(
  p_mode public.app_mode,
  p_limit int default 20,
  -- "Depois da festa": only people who went to this party (Date, 48 h).
  p_event uuid default null
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
  super_liked_me boolean
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

  if p_event is not null
     and (p_mode <> 'date' or not private.after_party_open(v_uid, p_event)) then
    return;
  end if;

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
      ) as boosted
    from public.profiles p
    where p.id <> v_uid
      and p.status = 'active'
      and p.paused_at is null
      and p.onboarding_completed
      and p_mode = any(p.modes)
      and (p_event is null or exists (
        select 1 from public.event_attendance pa
        where pa.event_id = p_event and pa.user_id = p.id
      ))
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
    where
      -- After a party: everyone who went, wherever they live.
      p_event is not null
      -- Crew: only the same parties.
      or (p_mode = 'crew' and co.user_id is not null)
      -- Date: only people nearby, whatever parties they marked.
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
    r.super_like
  from ranked r
  order by
    -- Boosts, then people who superliked the viewer.
    r.boosted desc,
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

revoke execute on function public.get_discover_feed(public.app_mode, int, uuid) from public, anon;
grant execute on function public.get_discover_feed(public.app_mode, int, uuid) to authenticated;

-- The morning after (parties that ended 4–5 h ago): invite who went, if
-- at least 3 people went and they use Date.
alter table private.event_push_log drop constraint event_push_log_kind_check;
alter table private.event_push_log add constraint event_push_log_kind_check
  check (kind in ('event_dj', 'event_new', 'event_reminder', 'venue_new', 'after_party'));

create function private.send_after_party_pushes()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
  v_count int := 0;
begin
  for v_row in
    select e.id, e.name, array_agg(ea.user_id) as users
    from public.events e
    join public.event_attendance ea on ea.event_id = e.id
    join public.profiles p on p.id = ea.user_id
    where e.status = 'approved'
      and e.ends_at between now() - interval '5 hours' and now() - interval '4 hours'
      and (select count(*) from public.event_attendance x where x.event_id = e.id) >= 3
      and p.status = 'active'
      and p.notify_events
      and 'date' = any(p.modes)
      and not exists (
        select 1 from private.event_push_log l
        where l.user_id = ea.user_id and l.event_id = e.id and l.kind = 'after_party'
      )
    group by e.id, e.name
  loop
    insert into private.event_push_log (user_id, event_id, kind)
    select unnest(v_row.users), v_row.id, 'after_party'
    on conflict do nothing;
    perform private.send_push(
      v_row.users, 'after_party',
      jsonb_build_object('route', '/discover/after-party/' || v_row.id, 'event', v_row.name)
    );
    v_count := v_count + cardinality(v_row.users);
  end loop;
  return v_count;
end;
$$;

select cron.schedule(
  'after-party-pushes',
  '20 * * * *',
  $$select private.send_after_party_pushes()$$
);

-- ---------------------------------------------------------------------------
-- "Salvar"
-- ---------------------------------------------------------------------------

create table public.event_saves (
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);
create index event_saves_user_idx on public.event_saves (user_id);

alter table public.event_saves enable row level security;

create policy "event_saves: own" on public.event_saves
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.events e where e.id = event_id and e.status = 'approved')
  );

drop function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int);
create function public.list_events(
  p_scope text default 'nearby',
  p_query text default null,
  p_genres public.music_genre[] default null,
  p_from timestamptz default null,
  p_to timestamptz default null,
  p_limit int default 30,
  p_offset int default 0
)
returns table (
  id uuid,
  name text,
  venue_name text,
  city text,
  state text,
  starts_at timestamptz,
  ends_at timestamptz,
  cover_path text,
  genres public.music_genre[],
  is_official boolean,
  status public.event_status,
  is_mine boolean,
  is_going boolean,
  going_count int,
  distance_km double precision,
  pin_lat double precision,
  pin_lng double precision,
  pin_exact boolean,
  location_reveal_at timestamptz,
  is_featured boolean,
  is_saved boolean
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
  v_query text := nullif(btrim(p_query), '');
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  select * into v_me from public.profiles p where p.id = v_uid;

  return query
  select
    e.id, e.name, e.venue_name, e.city, e.state, e.starts_at, e.ends_at,
    e.cover_path, e.genres, e.is_official, e.status,
    e.created_by = v_uid,
    exists (
      select 1 from public.event_attendance ea
      where ea.event_id = e.id and ea.user_id = v_uid
    ),
    (
      select count(*)::int
      from public.event_attendance ea
      join public.profiles p on p.id = ea.user_id
      where ea.event_id = e.id
        and p.status = 'active'
        and not private.is_blocked(v_uid, p.id)
    ),
    private.distance_km(v_me.lat, v_me.lng, pin.lat::numeric, pin.lng::numeric),
    pin.lat,
    pin.lng,
    pin.exact,
    case when e.location_reveal_hours is not null
      then e.starts_at - make_interval(hours => e.location_reveal_hours)
    end,
    coalesce(e.featured_until > now(), false),
    exists (
      select 1 from public.event_saves s
      where s.event_id = e.id and s.user_id = v_uid
    )
  from public.events e
  left join public.event_venues v on v.event_id = e.id
  cross join lateral (
    select private.can_see_event_venue(e.id) as revealed
  ) r
  cross join lateral (
    select
      case
        when v.lat is null then e.lat::double precision
        when r.revealed then v.lat
        else round(v.lat::numeric, 2)::double precision
      end as lat,
      case
        when v.lng is null then e.lng::double precision
        when r.revealed then v.lng
        else round(v.lng::numeric, 2)::double precision
      end as lng,
      v.lat is not null and r.revealed as exact
  ) pin
  where e.ends_at > now()
    and (p_genres is null or cardinality(p_genres) = 0 or e.genres && p_genres)
    and (p_from is null or e.ends_at >= p_from)
    and (p_to is null or e.starts_at < p_to)
    and (
      (p_scope = 'mine'
        and (e.created_by = v_uid or exists (
          select 1 from public.event_attendance ea
          where ea.event_id = e.id and ea.user_id = v_uid
        ) or exists (
          select 1 from public.event_saves s
          where s.event_id = e.id and s.user_id = v_uid
        ))
        and (e.status in ('approved', 'cancelled') or e.created_by = v_uid))
      or
      (p_scope = 'nearby'
        and e.status = 'approved'
        and (
          (v_query is not null
            and (lower(extensions.unaccent('extensions.unaccent'::regdictionary, e.name))
                   like '%' || lower(extensions.unaccent('extensions.unaccent'::regdictionary, v_query)) || '%'
                 or extensions.similarity(lower(e.name), lower(v_query)) > 0.3))
          or
          (v_query is null
            and (
              (v_me.lat is not null and pin.lat is not null
                and private.distance_km(v_me.lat, v_me.lng, pin.lat::numeric, pin.lng::numeric)
                    <= v_me.discovery_radius_km)
              or ((v_me.lat is null or pin.lat is null) and e.state = v_me.state)
            ))
        ))
    )
  -- Featured events (paid by producers) first, taking turns: a per-person,
  -- per-day shuffle. Then the rest by date.
  order by
    case when p_scope = 'nearby' then coalesce(e.featured_until > now(), false) end desc nulls last,
    case when p_scope = 'nearby' and e.featured_until > now() then
      md5(v_uid::text || (now() at time zone 'America/Sao_Paulo')::date::text || e.id::text)
    end,
    e.starts_at
  limit least(greatest(coalesce(p_limit, 30), 1), 100)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

revoke execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) from public, anon;
grant execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) to authenticated;

-- The reminder the day before also goes to who saved it (once per person).
create or replace function private.send_event_reminders()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
  v_count int := 0;
begin
  for v_row in
    select x.user_id, e.id as event_id, e.name,
      (
        select count(*)::int
        from public.event_attendance other
        join public.swipes s
          on s.swiper_id = x.user_id and s.swiped_id = other.user_id
         and s.direction = 'like'
        join public.profiles op on op.id = other.user_id and op.status = 'active'
        where other.event_id = e.id
          and other.user_id <> x.user_id
          and not private.is_blocked(x.user_id, other.user_id)
      ) as liked
    from public.events e
    join (
      select ea.event_id, ea.user_id from public.event_attendance ea
      union
      select sv.event_id, sv.user_id from public.event_saves sv
    ) x on x.event_id = e.id
    join public.profiles p on p.id = x.user_id
    where e.status = 'approved'
      and e.starts_at between now() + interval '23 hours' and now() + interval '25 hours'
      and p.status = 'active'
      and p.notify_events
      and not exists (
        select 1 from private.event_push_log l
        where l.user_id = x.user_id and l.event_id = e.id and l.kind = 'event_reminder'
      )
  loop
    insert into private.event_push_log (user_id, event_id, kind)
    values (v_row.user_id, v_row.event_id, 'event_reminder');
    perform private.send_push(
      array[v_row.user_id], 'event_reminder',
      jsonb_build_object(
        'route', '/events/' || v_row.event_id,
        'event', v_row.name,
        'liked', v_row.liked
      )
    );
    v_count := v_count + 1;
  end loop;
  return v_count;
end;
$$;

-- ---------------------------------------------------------------------------
-- Sections on top of "Próximos"
-- ---------------------------------------------------------------------------

create function public.event_sections()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_me public.profiles;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  select * into v_me from public.profiles p where p.id = v_uid;

  return (
    with upcoming as (
      select e.*,
        (select count(*)::int from public.event_attendance ea
          join public.profiles p on p.id = ea.user_id
          where ea.event_id = e.id and p.status = 'active') as going,
        (select count(*)::int from public.event_attendance ea
          where ea.event_id = e.id and ea.created_at > now() - interval '7 days') as going_week,
        case
          when v_me.lat is not null and e.lat is not null then
            private.distance_km(v_me.lat, v_me.lng, e.lat, e.lng) <= v_me.discovery_radius_km
          else e.state = v_me.state
        end as nearby
      from public.events e
      where e.status = 'approved' and e.ends_at > now()
    ),
    card as (
      select u.*, jsonb_build_object(
        'id', u.id, 'name', u.name, 'venue_name', u.venue_name, 'city', u.city,
        'state', u.state, 'starts_at', u.starts_at, 'ends_at', u.ends_at,
        'cover_path', u.cover_path, 'genres', u.genres,
        'is_official', u.is_official, 'going_count', u.going
      ) as json
      from upcoming u
    )
    select jsonb_build_object(
      'trending', coalesce((
        select jsonb_agg(x.json order by x.going_week desc, x.going desc, x.starts_at)
        from (select * from card c where c.nearby and c.going_week > 0
              order by c.going_week desc, c.going desc, c.starts_at limit 10) x
      ), '[]'::jsonb),
      'this_week', coalesce((
        select jsonb_agg(x.json order by x.starts_at)
        from (select * from card c where c.nearby and c.starts_at < now() + interval '7 days'
              order by c.starts_at limit 10) x
      ), '[]'::jsonb),
      'followed_venues', coalesce((
        select jsonb_agg(x.json order by x.starts_at)
        from (select * from card c
              where exists (select 1 from public.venue_follows f
                            where f.venue_id = c.venue_id and f.user_id = v_uid)
              order by c.starts_at limit 10) x
      ), '[]'::jsonb)
    )
  );
end;
$$;

revoke execute on function public.event_sections() from public, anon;
grant execute on function public.event_sections() to authenticated;

-- LGPD export: saved parties and "Tô ON" too.
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
    'referral', jsonb_build_object(
      'code', (select c.code from private.referral_codes c where c.user_id = v_uid),
      'used_code_at', (select r.created_at from private.referrals r where r.referred_id = v_uid),
      'friends_invited', (select count(*) from private.referrals r where r.referrer_id = v_uid)
    ),
    'profile_prompts', coalesce((
      select jsonb_agg(
        jsonb_build_object('prompt', pp.prompt, 'answer', pp.answer)
        order by pp.position
      )
      from public.profile_prompts pp where pp.user_id = v_uid
    ), '[]'::jsonb),
    'followed_venues', coalesce((
      select jsonb_agg(jsonb_build_object('venue', v.name, 'since', f.created_at)
        order by f.created_at)
      from public.venue_follows f join public.venues v on v.id = f.venue_id
      where f.user_id = v_uid
    ), '[]'::jsonb),
    'venue_reviews', coalesce((
      select jsonb_agg(jsonb_build_object(
          'venue', v.name, 'rating', r.rating, 'comment', r.comment,
          'at', r.updated_at
        ) order by r.updated_at)
      from public.venue_reviews r join public.venues v on v.id = r.venue_id
      where r.user_id = v_uid
    ), '[]'::jsonb),
    'poll_votes', coalesce((
      select jsonb_agg(jsonb_build_object(
          'question', p.question, 'option', p.options[v.option + 1],
          'at', v.voted_at
        ) order by v.voted_at)
      from public.poll_votes v join public.polls p on p.id = v.poll_id
      where v.user_id = v_uid
    ), '[]'::jsonb),
    'saved_events', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', s.created_at)
        order by s.created_at)
      from public.event_saves s join public.events e on e.id = s.event_id
      where s.user_id = v_uid
    ), '[]'::jsonb),
    'on_tonight', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', o.created_at)
        order by o.created_at)
      from public.event_on o join public.events e on e.id = o.event_id
      where o.user_id = v_uid
    ), '[]'::jsonb)
  );
end;
$$;
