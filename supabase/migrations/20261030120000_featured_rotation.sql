-- Featured events, round 2:
--   * Several paid highlights at once: all stay on top of "Próximos", in an
--     order that changes every day and differs per person (stable during the
--     day), so every producer who paid gets the first spot for part of the
--     audience.
--   * At most 5 highlights running at once per region (50 km around the
--     event, or the same state without coordinates), so a highlight keeps
--     its value and the other parties aren't buried.

insert into private.app_settings (key, value) values
  ('featured_max_per_region', '5'),
  ('featured_region_km', '50');

create or replace function public.admin_feature_event(p_event_id uuid, p_days int)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_event public.events;
  v_running int;
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  select * into v_event from public.events where id = p_event_id;

  if p_days is not null then
    -- Other highlights running now in the same region (extending this one
    -- is always fine).
    select count(*) into v_running
    from public.events o
    where o.id <> p_event_id
      and o.status = 'approved'
      and o.featured_until > now()
      and o.ends_at > now()
      and case
        when o.lat is not null and v_event.lat is not null then
          private.distance_km(o.lat, o.lng, v_event.lat, v_event.lng)
            <= private.setting_int('featured_region_km')
        else o.state = v_event.state
      end;
    if v_running >= private.setting_int('featured_max_per_region') then
      raise exception 'too many highlights in this region'
        using errcode = 'P0001', hint = 'featured_limit';
    end if;
  end if;

  update public.events
  set featured_until = case when p_days is null then null
                            else now() + make_interval(days => p_days) end
  where id = p_event_id;
end;
$$;

-- Same list as before; only the order among featured events changes.
create or replace function public.list_events(
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
  is_featured boolean
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
    coalesce(e.featured_until > now(), false)
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
