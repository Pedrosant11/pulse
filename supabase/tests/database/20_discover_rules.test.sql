begin;
\ir helpers.psql
select plan(5);

-- No superlikes in Crew: it becomes a normal like.
select tests.login(5);
select public.swipe(tests.uid(8), 'crew', 'like', true);
select tests.logout();
select is(
  (select is_super from public.swipes
   where swiper_id = tests.uid(5) and swiped_id = tests.uid(8) and mode = 'crew'),
  false,
  'a superlike in Crew is stored as a normal like'
);

-- Crews of up to 15.
select lives_ok(
  $$ insert into public.crews (event_id, owner_id, name, max_members)
     values (tests.event(1), tests.uid(5), 'Crew grande', 15) $$,
  'a crew can hold 15 people'
);
select throws_ok(
  $$ insert into public.crews (event_id, owner_id, name, max_members)
     values (tests.event(1), tests.uid(6), 'Crew enorme', 16) $$,
  '23514', null,
  'but not more than 15'
);

-- Common events, only between Crew matches (attendance is private).
select tests.login(1);
select is(
  (select count(*)::int from public.get_common_events(tests.uid(5))),
  0,
  'no Crew match, no common events'
);
select tests.logout();
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(1), tests.uid(5)), greatest(tests.uid(1), tests.uid(5)), 'crew');
select tests.login(1);
select is(
  (select count(*)::int from public.get_common_events(tests.uid(5))),
  2,
  'Crew matches see the upcoming parties they both go to'
);

select * from finish();
rollback;
