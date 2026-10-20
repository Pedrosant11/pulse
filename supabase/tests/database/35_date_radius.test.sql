begin;
\ir helpers.psql
select plan(4);

-- Rafael (16) lives in Rio (~360 km from Ana, 1, in São Paulo) and marks
-- Noite Ácida, Ana's party.
insert into public.event_attendance (event_id, user_id)
values ('00000000-0000-4000-b000-000000000001', tests.uid(16))
on conflict do nothing;

select tests.login(1);
select ok(
  tests.uid(16) not in (select id from public.get_discover_feed('date')),
  'Date: a party in common does not bring in someone outside the radius'
);
select ok(
  tests.uid(16) in (select id from public.get_discover_feed('crew')),
  'Crew: the same party is enough, wherever they live'
);
select ok(
  tests.uid(6) in (select id from public.get_discover_feed('date')),
  'Date: people nearby show up even without a party in common'
);
select is(
  (select common_events -> 0 ->> 'name' from public.get_discover_feed('date')
   where id = tests.uid(4)),
  'Noite Ácida',
  'Date: nearby people going to the same party carry it on the card'
);
select tests.logout();

select * from finish();
rollback;
