-- "Em destaque" on top of "Próximos": the paid highlights near the person,
-- in the same daily rotation as the list (a per-person, per-day shuffle),
-- now that the other sections sit above the list.

create or replace function public.event_sections()
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
      'featured', coalesce((
        select jsonb_agg(x.json order by x.turn)
        from (select c.*, md5(v_uid::text || (now() at time zone 'America/Sao_Paulo')::date::text || c.id::text) as turn
              from card c where c.nearby and c.featured_until > now()
              order by turn limit 10) x
      ), '[]'::jsonb),
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
