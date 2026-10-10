begin;
\ir helpers.psql
select plan(8);

-- Ana (1, São Paulo). See 04_feed_and_match for the seed expectations.
select tests.login(1);

select ok(
  (select bool_and(distance_km is not null) from public.get_discover_feed('date')),
  'feed profiles come with their distance'
);

select results_eq(
  $$ select favorite_djs, date_looking_for::text
     from public.get_discover_feed('date') where first_name = 'Diego' $$,
  $$ values ('{"Vini Vici","Astrix"}'::text[], 'casual'::text) $$,
  'feed returns favorite DJs (Crew card) and intent (Date card)'
);

-- One-sided like: no match yet.
select results_eq(
  $$ select matched, match_id from public.swipe(tests.uid(5), 'crew', 'like') $$,
  $$ values (false, null::uuid) $$,
  'a one-sided like reports no match'
);

select throws_ok(
  $$ select * from public.swipe(tests.uid(5), 'crew', 'like') $$,
  '23505', null,
  'swiping the same person twice in a mode is rejected'
);

-- Elisa likes back: swipe() reports the new match and its conversation.
select tests.login(5);
select ok(
  (select matched and match_id is not null and conversation_id is not null
   from public.swipe(tests.uid(1), 'crew', 'like')),
  'a mutual like reports the match and conversation'
);

select results_eq(
  $$ select matched from public.swipe(tests.uid(8), 'crew', 'pass') $$,
  $$ values (false) $$,
  'passing never matches'
);

-- Fallback uses the radius: move Ana to Rio (≈360 km from her SP people)
-- and pass on everyone from her events.
select tests.logout();
update public.profiles set lat = -22.91, lng = -43.20 where id = tests.uid(1);
select tests.login(1);
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(1), tests.uid(4), 'date', 'pass'),
       (tests.uid(1), tests.uid(12), 'date', 'pass');

select ok(
  (select bool_and(is_fallback and state = 'RJ' and distance_km <= 50)
   from public.get_discover_feed('date')),
  'fallback only lists people inside the radius (now Rio, not São Paulo)'
);

select tests.logout();
update public.profiles set discovery_radius_km = 100, lat = -23.53, lng = -46.64
where id = tests.uid(1);
select tests.login(1);
select ok(
  (select bool_and(is_fallback and distance_km <= 100) from public.get_discover_feed('date')),
  'fallback lists nearby people with the same vibe'
);

select * from finish();
rollback;
