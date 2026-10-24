begin;
\ir helpers.psql
select plan(18);

delete from private.event_push_log;

-- Beltran (event 7, D-EDGE Rio: -22.8963, -43.1858) is happening now.
update public.events set starts_at = now() - interval '2 hours 30 minutes', ends_at = now() + interval '4 hours'
where id = tests.event(7);

-- GPS ------------------------------------------------------------------------

select tests.login(17);
select throws_ok(
  $$select public.check_in_gps(tests.event(7), -22.9068, -43.1729)$$,
  'P0001', 'Too far from the party',
  'downtown, 1.7 km away: too far'
);
select throws_ok(
  $$select public.check_in_gps(tests.event(7), -22.8963, -43.1858, 10, true)$$,
  'P0001', 'Mock location',
  'mock location: refused'
);
select throws_ok(
  $$select public.check_in_gps(tests.event(1), -23.5262, -46.6658)$$,
  'P0001', 'Check-in only during the party',
  'a party that isn''t on yet: closed'
);
select lives_ok(
  $$select public.check_in_gps(tests.event(7), -22.8975, -43.1850, 25)$$,
  'at the door (~150 m): checked in'
);
select ok(public.my_checkin(tests.event(7)) is not null, 'my_checkin shows when');
select is(
  (select method from public.event_checkins where event_id = tests.event(7)),
  'gps',
  'she sees only her own check-in, by GPS'
);
select ok(
  exists (select 1 from public.event_attendance where event_id = tests.event(7) and user_id = tests.uid(17))
  and exists (select 1 from public.event_on where event_id = tests.event(7) and user_id = tests.uid(17)),
  'check-in also marks "Eu vou" and "Tô ON"'
);
select lives_ok(
  $$select public.check_in_gps(tests.event(7), -22.8963, -43.1858)$$,
  'checking in again is harmless'
);
select tests.logout();

-- The GPS accuracy widens the radius, up to 200 m.
select tests.login(16);
select lives_ok(
  $$select public.check_in_gps(tests.event(7), -22.9000, -43.1858, 150, false, false)$$,
  '410 m away with 150 m of accuracy: counts'
);
select ok(
  not exists (select 1 from public.event_on where event_id = tests.event(7) and user_id = tests.uid(16)),
  'without p_on, not ON'
);
select tests.logout();

-- QR -------------------------------------------------------------------------

select tests.login(4);
select throws_ok(
  $$select public.checkin_code(tests.event(7))$$,
  '42501', null,
  'only who runs the party sees the code'
);
select throws_ok(
  $$select public.check_in_qr(tests.event(7), 'ABCDEF12')$$,
  'P0001', 'Invalid code',
  'a wrong code is refused'
);
select tests.logout();

select tests.login(2);
create temp table code as select public.checkin_code(tests.event(7)) as c;
select ok(
  (select length(c ->> 'code') = 8 and (c ->> 'open')::boolean from code),
  'the producer gets an 8-character code'
);
select tests.logout();
grant select on code to authenticated;

select tests.login(4);
select lives_ok(
  $$select public.check_in_qr(tests.event(7), lower((select c ->> 'code' from code)))$$,
  'scanning the code (any case): checked in'
);
select tests.logout();

-- Producer's panel and reminders -----------------------------------------------

select tests.login(2);
select is(
  (public.get_event_insights(tests.event(7)) ->> 'checked_in')::int,
  3,
  'the panel shows who really went'
);
select tests.logout();

select private.send_checkin_reminders();
select ok(
  exists (select 1 from private.event_push_log l
          join public.event_attendance ea on ea.user_id = l.user_id and ea.event_id = l.event_id
          where l.event_id = tests.event(7) and l.kind = 'checkin_reminder')
  and not exists (select 1 from private.event_push_log l
          where l.event_id = tests.event(7) and l.kind = 'checkin_reminder'
            and l.user_id in (tests.uid(4), tests.uid(16), tests.uid(17))),
  'reminder only to who said "Eu vou" and hasn''t checked in'
);

-- Conquistas count only check-ins: "Eu vou" to a past party isn't enough.
set local session_replication_role = replica;
insert into public.event_attendance (event_id, user_id) values (tests.event(12), tests.uid(20))
on conflict do nothing;
delete from public.event_checkins where user_id = tests.uid(20);
set local session_replication_role = origin;
select tests.login(20);
select is(
  (select unlocked from public.my_achievements() where key = 'first_party'),
  false,
  'went without a check-in: no conquista'
);
select ok(
  jsonb_array_length(public.export_my_data() -> 'check_ins') = 0,
  'export lists check-ins'
);
select tests.logout();

select * from finish();
rollback;
