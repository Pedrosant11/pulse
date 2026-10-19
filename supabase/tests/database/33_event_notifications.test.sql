begin;
\ir helpers.psql
select plan(8);

-- Seed parties are approved on load and already used today's push.
delete from private.event_push_log;

-- Ana (1) in São Paulo likes Techno and follows Charlotte de Witte; Bruno
-- (2) likes Techno; Elisa (5) turns event pushes off.
update public.profiles set music_genres = '{techno}', favorite_djs = '{"Charlotte de Witte"}',
  discovery_radius_km = 50, notify_events = true
where id = tests.uid(1);
update public.profiles set music_genres = '{techno}', favorite_djs = '{}',
  discovery_radius_km = 50, notify_events = true
where id = tests.uid(2);
select tests.login(5);
select public.set_notify_events(false);
select tests.logout();
update public.profiles set music_genres = '{techno}' where id = tests.uid(5);

-- A techno party in São Paulo with Charlotte, waiting for approval.
insert into public.events (id, name, venue_name, city, state, lat, lng, starts_at, ends_at,
  genres, lineup, status, created_by)
values ('00000000-0000-4000-b000-000000000099', 'Teste Push', 'Galpão', 'São Paulo', 'SP',
  -23.53, -46.64, now() + interval '5 days', now() + interval '5 days 8 hours',
  '{techno}', '{"charlotte de witte", "Outro DJ"}', 'pending', tests.uid(3));

select is(
  (select count(*)::int from private.event_push_log where event_id = '00000000-0000-4000-b000-000000000099'),
  0,
  'nothing while the party is pending'
);

update public.events set status = 'approved'
where id = '00000000-0000-4000-b000-000000000099';

select is(
  (select kind from private.event_push_log
   where user_id = tests.uid(1) and event_id = '00000000-0000-4000-b000-000000000099'),
  'event_dj',
  'fans of a DJ in the lineup hear about it (any case)'
);
select is(
  (select kind from private.event_push_log
   where user_id = tests.uid(2) and event_id = '00000000-0000-4000-b000-000000000099'),
  'event_new',
  'people who like the genre too'
);
select is(
  (select count(*)::int from private.event_push_log
   where user_id = tests.uid(1) and event_id = '00000000-0000-4000-b000-000000000099'),
  1,
  'once per person'
);
select is(
  (select count(*)::int from private.event_push_log where user_id = tests.uid(5)),
  0,
  'not for people who turned them off'
);
select is(
  (select count(*)::int from private.event_push_log where user_id = tests.uid(3)),
  0,
  'not for whoever created it'
);

-- A second party the same day: the daily cap holds.
insert into public.events (id, name, venue_name, city, state, lat, lng, starts_at, ends_at,
  genres, status, created_by)
values ('00000000-0000-4000-b000-000000000098', 'Outra', 'Galpão', 'São Paulo', 'SP',
  -23.53, -46.64, now() + interval '6 days', now() + interval '6 days 8 hours',
  '{techno}', 'approved', tests.uid(3));
select is(
  (select count(*)::int from private.event_push_log
   where user_id = tests.uid(2) and event_id = '00000000-0000-4000-b000-000000000098'),
  0,
  'at most one new-party push a day'
);

-- Reminder ~24 h before, for people going.
update public.events set starts_at = now() + interval '24 hours',
  ends_at = now() + interval '32 hours'
where id = '00000000-0000-4000-b000-000000000099';
delete from public.event_attendance where event_id = '00000000-0000-4000-b000-000000000099';
insert into public.event_attendance (event_id, user_id)
values ('00000000-0000-4000-b000-000000000099', tests.uid(2));
select private.send_event_reminders();
select ok(
  exists (select 1 from private.event_push_log
          where user_id = tests.uid(2) and kind = 'event_reminder'),
  'people going get a reminder the day before'
);

select * from finish();
rollback;
