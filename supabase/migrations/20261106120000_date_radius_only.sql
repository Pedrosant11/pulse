-- Date shows only people inside the discovery radius (or the same state
-- when coordinates are missing). A party in common no longer brings in
-- someone from far away: that is Crew's job. In Date the party still shows
-- on the card ("Vocês vão: …") and puts those people first.
create or replace function public.get_discover_feed(
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
      -- Crew: only the same parties.
      (p_mode = 'crew' and co.user_id is not null)
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
