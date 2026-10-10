-- Event map (SPEC 7.4): exact venue location and the optional "secret
-- location" revealed some hours before the event.
--
-- The address and exact coordinates live in their own table so RLS can
-- hide the whole row until the reveal (events is read with select *).
-- events.lat/lng stay as the city centroid used by the radius filter.

alter table public.events
  add column location_reveal_hours smallint
    check (location_reveal_hours between 1 and 168);

comment on column public.events.location_reveal_hours is
  'Secret location: the venue is revealed this many hours before starts_at '
  '(null = always visible).';

create table public.event_venues (
  event_id uuid primary key references public.events (id) on delete cascade,
  address text check (char_length(address) <= 200),
  lat double precision check (lat between -90 and 90),
  lng double precision check (lng between -180 and 180),
  updated_at timestamptz not null default now(),
  check ((lat is null) = (lng is null))
);

create trigger event_venues_set_updated_at
  before update on public.event_venues
  for each row execute function private.set_updated_at();

-- Existing addresses move over; the column leaves events.
insert into public.event_venues (event_id, address)
select id, address from public.events where address is not null;

alter table public.events drop column address;

-- Whether the current user may see the venue of [p_event_id]: the event is
-- visible to them and the location is public or already revealed. The
-- creator and moderators always see it.
create function private.can_see_event_venue(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.events e
    where e.id = p_event_id
      and (
        e.created_by = (select auth.uid())
        or private.is_moderator()
        or (
          e.status = 'approved'
          and (
            e.location_reveal_hours is null
            or now() >= e.starts_at - make_interval(hours => e.location_reveal_hours)
          )
        )
      )
  );
$$;

alter table public.event_venues enable row level security;

create policy "event_venues: visible once revealed"
  on public.event_venues for select to authenticated
  using (private.can_see_event_venue(event_id));

create policy "event_venues: event editors insert"
  on public.event_venues for insert to authenticated
  with check (private.can_edit_event_id(event_id));

create policy "event_venues: event editors update"
  on public.event_venues for update to authenticated
  using (private.can_edit_event_id(event_id))
  with check (private.can_edit_event_id(event_id));

revoke delete, truncate on public.event_venues from authenticated;
revoke all on public.event_venues from anon;

-- ---------------------------------------------------------------------------
-- list_events: same filters, plus where to draw each event on the map.
--   pin_exact = true  → the venue itself;
--   pin_exact = false → approximate area (venue rounded to ~1 km while the
--                        location is secret, or the city centroid when
--                        there is no venue). The exact point never leaves
--                        the database before the reveal.
-- Distance now uses the venue area when known (closer to reality than the
-- city centroid).
-- ---------------------------------------------------------------------------

drop function public.list_events(
  text, text, public.music_genre[], timestamptz, timestamptz, int, int
);

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
  location_reveal_at timestamptz
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
    end
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
  order by e.starts_at
  limit least(greatest(coalesce(p_limit, 30), 1), 100)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

revoke execute on function public.list_events(
  text, text, public.music_genre[], timestamptz, timestamptz, int, int
) from public, anon;
grant execute on function public.list_events(
  text, text, public.music_genre[], timestamptz, timestamptz, int, int
) to authenticated;
