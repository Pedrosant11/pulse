begin;
\ir helpers.psql
select plan(10);

-- Seed: SP events 1–6 (+ pending 11, past 12), RJ events 7–10.
select tests.login(1); -- Ana, São Paulo, radius 50 km

select set_eq(
  $$ select id from public.list_events('nearby') $$,
  $$ select tests.event(n) from generate_series(1, 6) as n $$,
  'nearby lists approved upcoming events within the radius only'
);

select ok(
  (select bool_and(distance_km < 50) from public.list_events('nearby')),
  'nearby events come with their distance'
);

select results_eq(
  $$ select id from public.list_events('nearby', 'portal psy') $$,
  $$ values (tests.event(9)) $$,
  'searching by name is nationwide (free, SPEC 15)'
);

select is(
  (select count(*)::int from public.list_events('nearby', p_genres => '{afro_house}')),
  1,
  'genre filter'
);

select is(
  (select going_count from public.list_events('nearby') where id = tests.event(1)),
  7,
  'going_count counts active attendees'
);

-- Mine: events the user goes to or created (any status for own events).
select tests.login(4); -- Diego goes to events 1 and 3
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values (
  '88888888-8888-4888-8888-888888888888', 'Sugestão do Diego', 'Galpão',
  'São Paulo', 'SP', now() + interval '30 days', now() + interval '30 days 6 hours'
);

select set_eq(
  $$ select id from public.list_events('mine') $$,
  $$ values (tests.event(1)), (tests.event(3)),
            ('88888888-8888-4888-8888-888888888888'::uuid) $$,
  'mine = attending + created (pending included)'
);

select is(
  (select status::text from public.list_events('mine')
   where id = '88888888-8888-4888-8888-888888888888'),
  'pending',
  'own pending suggestion shows its status'
);

-- "Quem vai": anonymous unless matched.
select tests.login(1);
select ok(
  not exists (
    select 1 from public.get_event_attendees(tests.event(1))
    where first_name is not null or user_id = tests.uid(1)
  ),
  'attendees are anonymous without a match and exclude the user'
);

insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(1), tests.uid(5), 'crew', 'like');
select tests.login(5);
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(5), tests.uid(1), 'crew', 'like');
select tests.login(1);

select results_eq(
  $$ select first_name, is_match from public.get_event_attendees(tests.event(1)) limit 1 $$,
  $$ values ('Elisa'::text, true) $$,
  'matches come first and show their name'
);

select ok(
  (select bool_and(photo_path is not null) from public.get_event_attendees(tests.event(1))),
  'every attendee has an avatar'
);

select * from finish();
rollback;
