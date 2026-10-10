begin;
\ir helpers.psql
select plan(11);

-- Seed: event 1 (D-Edge) is public; event 3 (Mamba Negra) reveals its
-- venue 24 h before and starts in 8 days. Ana (1) is in São Paulo.

select tests.login(4); -- Diego, a regular user

select results_eq(
  $$ select address, lat from public.event_venues where event_id = tests.event(1) $$,
  $$ values ('Al. Olga, 170 - Barra Funda'::text, -23.5262::double precision) $$,
  'public venues are readable'
);

select is_empty(
  $$ select * from public.event_venues where event_id = tests.event(3) $$,
  'a secret venue is hidden before the reveal'
);

select results_eq(
  $$ select pin_lat, pin_lng, pin_exact from public.list_events()
     where id = tests.event(1) $$,
  $$ values (-23.5262::double precision, -46.6658::double precision, true) $$,
  'the map pin of a public event is the venue'
);

select results_eq(
  $$ select pin_lat, pin_lng, pin_exact from public.list_events()
     where id = tests.event(3) $$,
  $$ values (-23.56::double precision, -46.60::double precision, false) $$,
  'a secret event only shows the area (rounded to ~1 km)'
);

select isnt(
  (select location_reveal_at from public.list_events() where id = tests.event(3)),
  null,
  'the list says when the location is revealed'
);

-- Creator (Bruno, 2) and moderators always see it.
select tests.login(2);
select isnt_empty(
  $$ select * from public.event_venues where event_id = tests.event(3) $$,
  'the creator sees the secret venue'
);

-- After the reveal time everyone sees it.
select tests.logout();
update public.events
set starts_at = now() + interval '2 hours', ends_at = now() + interval '8 hours'
where id = tests.event(3);
select tests.login(4);
select results_eq(
  $$ select pin_exact from public.list_events() where id = tests.event(3) $$,
  $$ values (true) $$,
  'once revealed, the pin is exact'
);

-- Only event editors write venues.
select throws_ok(
  $$ insert into public.event_venues (event_id, lat, lng)
     values (tests.event(2), -23.5, -46.6) $$,
  '42501', null,
  'regular users cannot set the venue of others'' events'
);

select tests.login(5); -- Elisa suggests an event and places it
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee', 'Festa da Elisa', 'Galpão',
        'São Paulo', 'SP', now() + interval '9 days', now() + interval '9 days 6 hours');
select lives_ok(
  $$ insert into public.event_venues (event_id, address, lat, lng)
     values ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee', 'Rua X, 10', -23.55, -46.63) $$,
  'the creator places a pending suggestion'
);

select throws_ok(
  $$ insert into public.event_venues (event_id, lat)
     values ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee', -23.5) $$,
  '23514', null,
  'latitude and longitude go together'
);

select tests.login(4);
select is_empty(
  $$ select * from public.event_venues
     where event_id = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee' $$,
  'venues of pending events stay private'
);

select * from finish();
rollback;
