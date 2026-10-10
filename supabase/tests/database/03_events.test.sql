begin;
\ir helpers.psql
select plan(10);

-- Regular user: forced to pending, cannot spoof creator/status.
select tests.login(4); -- Diego
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at, status, is_official, created_by)
values (
  '33333333-3333-4333-8333-333333333333', 'Festa do Diego', 'Galpão', 'São Paulo', 'SP',
  now() + interval '40 days', now() + interval '40 days 8 hours',
  'approved', true, tests.uid(2)
);

select results_eq(
  $$ select status::text, is_official, created_by from public.events
     where id = '33333333-3333-4333-8333-333333333333' $$,
  $$ values ('pending', false, tests.uid(4)) $$,
  'events from regular users are pending, unofficial and owned by them'
);

select throws_ok(
  $$ update public.events set status = 'approved'
     where id = '33333333-3333-4333-8333-333333333333' $$,
  '42501', null,
  'regular users cannot approve events'
);

select throws_ok(
  $$ insert into public.event_attendance (user_id, event_id)
     values (tests.uid(4), tests.event(12)) $$,
  '42501', null,
  'cannot mark attendance on a past event'
);

select throws_ok(
  $$ insert into public.event_attendance (user_id, event_id)
     values (tests.uid(4), '33333333-3333-4333-8333-333333333333') $$,
  '42501', null,
  'cannot mark attendance on a pending event'
);

-- Curator: approved on insert, approves suggestions.
select tests.login(2); -- Bruno, curator
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values (
  '44444444-4444-4444-8444-444444444444', 'Festa do Bruno', 'Audio', 'São Paulo', 'SP',
  now() + interval '41 days', now() + interval '41 days 8 hours'
);

select is(
  (select status::text from public.events where id = '44444444-4444-4444-8444-444444444444'),
  'approved',
  'curator events are approved'
);

update public.events set status = 'approved'
where id = '33333333-3333-4333-8333-333333333333';

select results_eq(
  $$ select status::text, approved_by from public.events
     where id = '33333333-3333-4333-8333-333333333333' $$,
  $$ values ('approved', tests.uid(2)) $$,
  'curators approve suggestions and are recorded as approver'
);

-- Producer: approved and official.
select tests.login(3); -- Carla, producer
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values (
  '55555555-5555-4555-8555-555555555555', 'Festa da Carla', 'D-Edge', 'São Paulo', 'SP',
  now() + interval '42 days', now() + interval '42 days 8 hours'
);

select results_eq(
  $$ select status::text, is_official from public.events
     where id = '55555555-5555-4555-8555-555555555555' $$,
  $$ values ('approved', true) $$,
  'producer events are approved and official'
);

-- Anti-duplication and visibility.
select tests.login(4);

select is(
  (select id from public.find_similar_events(
     'noite acida',
     (select starts_at from public.events where id = tests.event(1)),
     'sao paulo'
  ) limit 1),
  tests.event(1),
  'find_similar_events finds the same party ignoring accents/case'
);

select is(
  (select count(*)::int from public.events where id = tests.event(11)),
  0,
  'other users'' pending suggestions are hidden'
);

select ok(
  (select total from public.get_event_attendee_counts(array[tests.event(1)])) > 0,
  'attendee counts are available as aggregates'
);

select * from finish();
rollback;
