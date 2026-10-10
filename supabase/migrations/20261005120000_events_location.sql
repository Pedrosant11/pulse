-- Events by location (SPEC 6.1, 7.3): discovery radius, event coordinates,
-- list/search RPCs and the "Quem vai" section.

alter table public.profiles
  add column discovery_radius_km smallint not null default 50
    check (discovery_radius_km between 5 and 100);

-- City centroid (from the bundled IBGE list), rounded like profiles.
alter table public.events
  add column lat numeric(5, 2) check (lat between -90 and 90),
  add column lng numeric(5, 2) check (lng between -180 and 180);

create index events_upcoming_idx on public.events (starts_at)
  where status = 'approved';

-- Great-circle distance in km (haversine). Null when a point is missing.
create function private.distance_km(
  p_lat1 numeric, p_lng1 numeric, p_lat2 numeric, p_lng2 numeric
)
returns double precision
language sql
immutable
set search_path = ''
as $$
  select case
    when p_lat1 is null or p_lng1 is null or p_lat2 is null or p_lng2 is null
      then null
    else 2 * 6371 * asin(sqrt(
      power(sin(radians((p_lat2 - p_lat1)::float8) / 2), 2)
      + cos(radians(p_lat1::float8)) * cos(radians(p_lat2::float8))
        * power(sin(radians((p_lng2 - p_lng1)::float8) / 2), 2)
    ))
  end;
$$;

-- Event list (SPEC 7.3).
--   p_scope 'nearby': approved upcoming events within the user's radius
--     (same state when the profile has no coordinates). A non-empty
--     p_query searches by name nationwide instead (free, SPEC 15).
--   p_scope 'mine': events the user is going to or created (any status),
--     upcoming only.
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
  distance_km double precision
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
    private.distance_km(v_me.lat, v_me.lng, e.lat, e.lng)
  from public.events e
  where e.ends_at > now()
    and (p_genres is null or cardinality(p_genres) = 0 or e.genres && p_genres)
    and (p_from is null or e.ends_at >= p_from)
    and (p_to is null or e.starts_at < p_to)
    and (
      (p_scope = 'mine'
        and (e.created_by = v_uid or exists (
          select 1 from public.event_attendance ea
          where ea.event_id = e.id and ea.user_id = v_uid
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
              (v_me.lat is not null and e.lat is not null
                and private.distance_km(v_me.lat, v_me.lng, e.lat, e.lng)
                    <= v_me.discovery_radius_km)
              or ((v_me.lat is null or e.lat is null) and e.state = v_me.state)
            ))
        ))
    )
  order by e.starts_at
  limit least(greatest(coalesce(p_limit, 30), 1), 100)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

-- "Quem vai" (SPEC 7.3): people going to an event. Names are only revealed
-- for matches; everyone else is an anonymous (blurred) avatar. Blocked and
-- inactive users are left out.
create function public.get_event_attendees(p_event_id uuid, p_limit int default 60)
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  modes public.app_mode[],
  is_match boolean
)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select
    p.id,
    case when m.matched then p.first_name end,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    p.modes,
    m.matched
  from public.event_attendance ea
  join public.events e on e.id = ea.event_id
  join public.profiles p on p.id = ea.user_id
  cross join me
  cross join lateral (
    select exists (
      select 1 from public.matches mt
      where mt.unmatched_at is null
        and mt.user_a = least(me.id, p.id)
        and mt.user_b = greatest(me.id, p.id)
    ) as matched
  ) m
  where ea.event_id = p_event_id
    and me.id is not null
    and (e.status = 'approved' or e.created_by = me.id or private.is_moderator())
    and p.id <> me.id
    and p.status = 'active'
    and p.onboarding_completed
    and not private.is_blocked(me.id, p.id)
  order by m.matched desc, ea.created_at desc
  limit least(greatest(coalesce(p_limit, 60), 1), 200);
$$;

revoke execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) from public, anon;
grant execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) to authenticated;
revoke execute on function public.get_event_attendees(uuid, int) from public, anon;
grant execute on function public.get_event_attendees(uuid, int) to authenticated;
