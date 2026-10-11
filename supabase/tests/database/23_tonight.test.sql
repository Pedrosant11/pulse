begin;
\ir helpers.psql
select plan(14);

-- Check-in window --------------------------------------------------------------

update public.events set starts_at = now() + interval '5 hours', ends_at = now() + interval '10 hours'
where id = tests.event(1);

select tests.login(4);
select throws_ok(
  $$ select public.check_in(tests.event(1)) $$,
  'P0001', 'Check-in opens 2 hours before the party',
  'check-in only opens close to the party'
);

select tests.logout();
update public.events set starts_at = now() - interval '1 hour', ends_at = now() + interval '4 hours'
where id = tests.event(1);

-- Diego (4) and Ana (1) both go to event 1 and Diego is Date-compatible.
select tests.login(4);
select lives_ok($$ select public.check_in(tests.event(1)) $$, 'Diego checks in');
select is(public.get_event_here_count(tests.event(1)), 1, 'everyone sees how many are here');

-- Who's here is shared both ways: Ana sees nothing until she checks in.
select tests.logout();
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(1), tests.uid(4)), greatest(tests.uid(1), tests.uid(4)), 'crew');
select tests.login(1);
select is(
  (select count(*)::int from public.get_event_here_friends(tests.event(1))),
  0,
  'without checking in, no list of friends here'
);
select public.check_in(tests.event(1));
select results_eq(
  $$ select user_id, relation from public.get_event_here_friends(tests.event(1)) $$,
  $$ values (tests.uid(4), 'match') $$,
  'checked in: matches at the party show up'
);

-- Discover: Diego, at the same party now, comes first with the flag.
select tests.logout();
delete from public.matches where user_a = least(tests.uid(1), tests.uid(4));
select tests.login(1);
select is(
  (select (first_name, here_now)::text from public.get_discover_feed('date') limit 1),
  '(Diego,t)',
  'people at the same party right now come first'
);

select public.check_out(tests.event(1));
select is(public.get_event_here_count(tests.event(1)), 1, 'checking out leaves the count');
select results_eq(
  $$ select user_id from public.event_checkins where event_id = tests.event(1) $$,
  $$ values (tests.uid(1)) $$,
  'the app reads only its own check-in (not Diego''s)'
);

-- Crew meeting point ---------------------------------------------------------

select tests.logout();
insert into public.crews (id, event_id, owner_id, name)
values ('00000000-0000-4000-d000-000000000023', tests.event(1), tests.uid(5), 'Crew do ponto');
select tests.login(5);
select lives_ok(
  $$ select public.set_crew_meeting_point('00000000-0000-4000-d000-000000000023', 'Bar do fundo, 1h') $$,
  'members set the meeting point'
);
select is(
  (select meeting_point from public.get_crew('00000000-0000-4000-d000-000000000023')),
  'Bar do fundo, 1h',
  'members see the meeting point'
);
select tests.login(4);
select throws_ok(
  $$ select public.set_crew_meeting_point('00000000-0000-4000-d000-000000000023', 'x') $$,
  '42501', null,
  'others cannot change it'
);

-- Mesmo rolê ----------------------------------------------------------------

select tests.logout();
update public.events set starts_at = now() - interval '6 hours', ends_at = now() - interval '30 minutes'
where id = tests.event(1);

select tests.login(1);
select ok(public.get_same_night_count() >= 1, 'after the party, how many from that night');
select throws_ok(
  $$ select * from public.get_same_night() $$,
  'P0001', 'Mesmo rolê needs Pulse Black',
  'who they are is Pulse Black'
);
select tests.logout();
insert into public.subscriptions (user_id, tier, source) values (tests.uid(1), 'black', 'admin');
select tests.login(1);
select ok(
  exists (select 1 from public.get_same_night() where user_id = tests.uid(4)),
  'Black sees who was there'
);

select * from finish();
rollback;
