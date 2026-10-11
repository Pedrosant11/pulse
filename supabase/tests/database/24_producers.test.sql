begin;
\ir helpers.psql
select plan(9);

-- Featured events --------------------------------------------------------------

-- Carla (3) is the producer who created event 3 (seed).
select tests.login(3);
select throws_ok(
  $$ update public.events set featured_until = now() + interval '7 days'
     where created_by = tests.uid(3) $$,
  '42501', 'Only admins feature events',
  'producers cannot feature their own events'
);
select throws_ok(
  $$ select public.admin_feature_event(tests.event(2), 7) $$,
  '42501', null,
  'only admins feature events'
);

-- Ana (1) is admin.
select tests.login(1);
select lives_ok(
  $$ select public.admin_feature_event(tests.event(2), 7) $$,
  'an admin features an event for 7 days'
);
select is(
  (select id from public.list_events('nearby') limit 1),
  tests.event(2),
  'a featured event comes first in "Próximos"'
);
select is(
  (select is_featured from public.list_events('nearby') where id = tests.event(2)),
  true,
  'and is flagged as featured'
);
select public.admin_feature_event(tests.event(2), null);
select is(
  (select is_featured from public.list_events('nearby') where id = tests.event(2)),
  false,
  'removing the highlight'
);

-- Insights ------------------------------------------------------------------

select tests.login(4);
select throws_ok(
  $$ select public.get_event_insights(tests.event(1)) $$,
  '42501', null,
  'only the creator or moderators see the insights'
);

select tests.login(1);
select ok(
  (select (i ->> 'going')::int > 0 and i ? 'genres'
   from (select public.get_event_insights(tests.event(1)) i) t),
  'moderators see the numbers and breakdowns'
);

-- Few people: breakdowns hidden.
select tests.logout();
delete from public.event_attendance
where event_id = tests.event(2)
  and user_id not in (select user_id from public.event_attendance
                      where event_id = tests.event(2) limit 2);
select tests.login(1);
select is(
  (select (i ->> 'breakdowns_hidden')::boolean and i -> 'genres' = 'null'::jsonb
   from (select public.get_event_insights(tests.event(2)) i) t),
  true,
  'below 5 people the breakdowns are hidden'
);

select * from finish();
rollback;
