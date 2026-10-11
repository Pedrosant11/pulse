-- Producers (launch plan):
--   * Featured events: an admin features an event for some days (paid by
--     the producer via Pix, outside the stores). It comes first in
--     "Próximos" and gets a highlighted pin.
--   * Event insights for the creator and moderators: aggregated numbers
--     only, with the breakdowns hidden below 5 people.

alter table public.events add column featured_until timestamptz;

-- Only admins feature events (the creator edits the rest of the row).
create function private.guard_event_featured()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.featured_until is distinct from old.featured_until
     and (select auth.uid()) is not null
     and not private.is_admin() then
    raise exception 'Only admins feature events' using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger events_guard_featured
  before update on public.events
  for each row execute function private.guard_event_featured();

-- p_days null removes the highlight.
create function public.admin_feature_event(p_event_id uuid, p_days int)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  update public.events
  set featured_until = case when p_days is null then null
                            else now() + make_interval(days => p_days) end
  where id = p_event_id;
end;
$$;

revoke execute on function public.admin_feature_event(uuid, int) from public, anon;
grant execute on function public.admin_feature_event(uuid, int) to authenticated;

-- ---------------------------------------------------------------------------
-- Event list: featured first
-- ---------------------------------------------------------------------------

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
  -- Featured events (paid by producers) first in the list.
  order by
    case when p_scope = 'nearby' then coalesce(e.featured_until > now(), false) end desc nulls last,
    e.starts_at
  limit least(greatest(coalesce(p_limit, 30), 1), 100)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

revoke execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) from public, anon;
grant execute on function public.list_events(text, text, public.music_genre[], timestamptz, timestamptz, int, int) to authenticated;

-- ---------------------------------------------------------------------------
-- Event insights (creator and moderators)
-- ---------------------------------------------------------------------------

-- Breakdowns (genres, cities, gender, age) need at least this many people,
-- so nobody can be singled out.
create function public.get_event_insights(p_event_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_min constant int := 5;
begin
  if not exists (
    select 1 from public.events e
    where e.id = p_event_id
      and (e.created_by = v_uid or private.is_moderator())
  ) then
    raise exception 'Only the creator or moderators' using errcode = '42501';
  end if;

  return (
    with people as (
      select p.modes, p.gender, p.city, p.state, p.music_genres,
             date_part('year', age(p.birth_date))::int as age
      from public.event_attendance a
      join public.profiles p on p.id = a.user_id
      where a.event_id = p_event_id and p.status = 'active'
    ),
    total as (select count(*)::int as n from people)
    select jsonb_build_object(
      'going', total.n,
      'going_date', (select count(*) from people where 'date' = any (modes)),
      'going_crew', (select count(*) from people where 'crew' = any (modes)),
      'ticket_clicks', (select count(*) from public.ticket_clicks where event_id = p_event_id),
      'crews', (select count(*) from public.crews where event_id = p_event_id),
      'breakdowns_hidden', total.n < v_min,
      'genres', case when total.n >= v_min then coalesce((
        select jsonb_agg(jsonb_build_object('genre', g, 'count', c) order by c desc)
        from (
          select g, count(*) c from people, unnest(music_genres) g
          group by g order by count(*) desc limit 5
        ) t
      ), '[]'::jsonb) end,
      'cities', case when total.n >= v_min then coalesce((
        select jsonb_agg(jsonb_build_object('city', city, 'state', state, 'count', c) order by c desc)
        from (
          select city, state, count(*) c from people where city is not null
          group by city, state order by count(*) desc limit 5
        ) t
      ), '[]'::jsonb) end,
      'genders', case when total.n >= v_min then coalesce((
        select jsonb_object_agg(coalesce(gender::text, 'unknown'), c)
        from (select gender, count(*) c from people group by gender) t
      ), '{}'::jsonb) end,
      'ages', case when total.n >= v_min then (
        select jsonb_build_object(
          '18_24', count(*) filter (where age < 25),
          '25_34', count(*) filter (where age between 25 and 34),
          '35_plus', count(*) filter (where age >= 35)
        ) from people
      ) end
    )
    from total
  );
end;
$$;

revoke execute on function public.get_event_insights(uuid) from public, anon;
grant execute on function public.get_event_insights(uuid) to authenticated;
