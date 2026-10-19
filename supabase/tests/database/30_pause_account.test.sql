begin;
\ir helpers.psql
select plan(7);

-- 14 likes 1 (Ana); Ana would see 14 in Discover and in "who liked you".
delete from public.swipes where swiper_id in (tests.uid(1), tests.uid(14)) or swiped_id in (tests.uid(1), tests.uid(14));
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(14), tests.uid(1), 'date', 'like');

select tests.login(1);
create temp table before_feed as
  select id from public.get_discover_feed('date');
grant select on before_feed to authenticated;
select tests.logout();

select tests.login(14);
select isnt(public.set_paused(true), null, '14 pauses the account');
select throws_ok(
  format($$insert into public.swipes (swiper_id, swiped_id, mode, direction)
           values (%L, %L, 'date', 'like')$$, tests.uid(14), tests.uid(2)),
  'P0001', 'account paused', 'no swiping while paused'
);
select tests.logout();

select tests.login(1);
select ok(
  (select tests.uid(14) in (select id from before_feed)),
  'before: 14 was in Ana''s Discover'
);
select ok(
  tests.uid(14) not in (select id from public.get_discover_feed('date')),
  'paused: 14 is gone from Discover'
);
select is(
  (select count(*)::int from private.likes_received(tests.uid(1)) where user_id = tests.uid(14)),
  0,
  'and from "who liked you"'
);
select tests.logout();

select tests.login(14);
select is(public.set_paused(false), null, 'unpausing');
select tests.logout();

select tests.login(1);
select ok(
  tests.uid(14) in (select id from public.get_discover_feed('date')),
  'brings them back'
);
select tests.logout();

select * from finish();
rollback;
