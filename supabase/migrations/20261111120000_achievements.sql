-- Conquistas and the passport. Everything is computed from what happened:
-- approved parties already over where the person marked "Eu vou", crews
-- they joined. Nothing is stored, so nothing can be faked or go stale.
--   * Conquistas (free): first party, 5 and 20 parties, 3 at the same casa,
--     3 crews, 3 cities, 5 genres, 3 parties of 10 h or more. Others see
--     only the unlocked ones (user_achievements), never the parties.
--   * Passaporte (private, only the person): totals for free, the last 3
--     parties for free, the whole history with Pulse Black.

-- Approved parties already over that the person went to.
create function private.past_parties(p_user uuid)
returns setof public.events
language sql
stable
security definer
set search_path = ''
as $$
  select e.*
  from public.events e
  join public.event_attendance ea on ea.event_id = e.id and ea.user_id = p_user
  where e.status = 'approved' and e.ends_at < now();
$$;

create function private.achievements_of(p_user uuid)
returns table (key text, progress int, goal int, unlocked boolean)
language sql
stable
security definer
set search_path = ''
as $$
  with p as (select * from private.past_parties(p_user)),
  stats as (
    select
      (select count(*) from p)::int as parties,
      (select coalesce(max(x.n), 0) from (
        select count(*)::int as n from p where p.venue_id is not null group by p.venue_id
      ) x) as same_venue,
      (select count(distinct (p.city, p.state)) from p)::int as cities,
      (select count(distinct g) from p cross join lateral unnest(p.genres) as g)::int as genres,
      (select count(*) from p where p.ends_at - p.starts_at >= interval '10 hours')::int as marathons,
      (select count(distinct cm.crew_id) from public.crew_members cm where cm.user_id = p_user)::int as crews
  )
  select k.key, least(k.value, k.goal), k.goal, k.value >= k.goal
  from stats s
  cross join lateral (values
    (1, 'night_legend', s.parties, 20),
    (2, 'loyal_to_the_house', s.same_venue, 3),
    (3, 'marathoner', s.marathons, 3),
    (4, 'eclectic', s.genres, 5),
    (5, 'explorer', s.cities, 3),
    (6, 'never_alone', s.crews, 3),
    (7, 'party_animal', s.parties, 5),
    (8, 'first_party', s.parties, 1)
  ) as k(rank, key, value, goal)
  order by k.rank;
$$;

-- Mine, with progress.
create function public.my_achievements()
returns table (key text, progress int, goal int, unlocked boolean)
language sql
stable
security definer
set search_path = ''
as $$
  select * from private.achievements_of((select auth.uid()))
  where (select auth.uid()) is not null;
$$;

revoke execute on function public.my_achievements() from public, anon;
grant execute on function public.my_achievements() to authenticated;

-- Someone's unlocked ones, rarest first (for their profile).
create function public.user_achievements(p_user uuid)
returns text[]
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(array_agg(a.key), '{}')
  from private.achievements_of(p_user) a
  where a.unlocked and private.is_visible_user(p_user);
$$;

revoke execute on function public.user_achievements(uuid) from public, anon;
grant execute on function public.user_achievements(uuid) to authenticated;

-- My passport: totals, and the parties (last 3, or all with Black).
create function public.my_passport()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_full boolean;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  v_full := private.plan_tier(v_uid) = 'black';
  return (
    with p as (select * from private.past_parties(v_uid))
    select jsonb_build_object(
      'parties', (select count(*) from p),
      'venues', (select count(distinct coalesce(p.venue_id::text, lower(p.venue_name))) from p),
      'cities', (select count(distinct (p.city, p.state)) from p),
      'genres', (select count(distinct g) from p cross join lateral unnest(p.genres) as g),
      'full', v_full,
      'entries', coalesce((
        select jsonb_agg(x.json order by x.starts_at desc)
        from (
          select p.starts_at, jsonb_build_object(
            'id', p.id, 'name', p.name, 'venue_name', p.venue_name,
            'venue_id', p.venue_id, 'city', p.city, 'state', p.state,
            'starts_at', p.starts_at, 'ends_at', p.ends_at,
            'cover_path', p.cover_path, 'genres', p.genres,
            'is_official', p.is_official
          ) as json
          from p
          order by p.starts_at desc
          limit case when v_full then 1000 else 3 end
        ) x
      ), '[]'::jsonb)
    )
  );
end;
$$;

revoke execute on function public.my_passport() from public, anon;
grant execute on function public.my_passport() to authenticated;
