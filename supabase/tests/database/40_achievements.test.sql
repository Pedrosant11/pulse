begin;
\ir helpers.psql
select plan(9);

-- Ana (1) went to the past Ritual (event 12, Galpão 23). Two more past
-- parties there make her "Fiel à casa".
set local session_replication_role = replica;
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at,
  genres, status, created_by, venue_id)
select gen_random_uuid(), 'Ritual ' || n, 'Galpão 23', 'São Paulo', 'SP',
  now() - make_interval(days => 20 + n), now() - make_interval(days => 20 + n) + interval '11 hours',
  '{techno,house}', 'approved', tests.uid(2), '00000000-0000-4000-c000-000000000001'
from generate_series(1, 2) n;
insert into public.event_attendance (event_id, user_id)
select e.id, tests.uid(1) from public.events e where e.name like 'Ritual _';
set local session_replication_role = origin;

select tests.login(1);
select is(
  (select unlocked from public.my_achievements() where key = 'first_party'),
  true,
  'first party unlocked'
);
select is(
  (select unlocked from public.my_achievements() where key = 'loyal_to_the_house'),
  true,
  '3 parties at the same casa: Fiel à casa'
);
select results_eq(
  $$select progress, goal from public.my_achievements() where key = 'party_animal'$$,
  $$values (3, 5)$$,
  'progress towards 5 parties'
);
select is(
  (select unlocked from public.my_achievements() where key = 'marathoner'),
  false,
  'only 2 parties of 10 h: not a marathoner yet'
);
select is(
  (public.my_passport() ->> 'parties')::int,
  3,
  'passport totals count every party'
);
select is(
  jsonb_array_length(public.my_passport() -> 'entries'),
  3,
  'free: the last 3 parties'
);
select tests.logout();

-- Upcoming parties don't count.
select tests.login(16);
select is(
  (select unlocked from public.my_achievements() where key = 'first_party'),
  false,
  'parties that haven''t happened don''t count'
);
select tests.logout();

-- Others see only what she unlocked, rarest first.
select tests.login(5);
select is(
  public.user_achievements(tests.uid(1)),
  array['loyal_to_the_house', 'first_party'],
  'others see her unlocked conquistas, rarest first'
);
select tests.logout();

-- Black sees the whole history.
insert into public.subscriptions (user_id, tier, source) values (tests.uid(1), 'black', 'admin')
on conflict (user_id) do update set tier = 'black';
set local session_replication_role = replica;
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at, status, created_by)
values (gen_random_uuid(), 'Antiga', 'Outra', 'Rio de Janeiro', 'RJ', now() - interval '60 days',
  now() - interval '59 days', 'approved', tests.uid(2));
insert into public.event_attendance (event_id, user_id)
select id, tests.uid(1) from public.events where name = 'Antiga';
set local session_replication_role = origin;
select tests.login(1);
select is(
  jsonb_array_length(public.my_passport() -> 'entries'),
  4,
  'Black: the whole history'
);
select tests.logout();

select * from finish();
rollback;
