begin;
\ir helpers.psql
select plan(21);

-- Seed: Ana (1) goes to events 1 and 4 (+ a past one). See seed.sql.
select tests.login(1);

-- Date feed --------------------------------------------------------------

select set_eq(
  $$ select first_name, common_event_count
     from public.get_discover_feed('date') where not is_fallback $$,
  $$ values ('Diego', 1), ('Marcos', 1) $$,
  'Date feed: men going to Ana''s events who want women'
);

select is(
  (select bool_and(not is_fallback) from (
     select is_fallback from public.get_discover_feed('date') limit 2) f),
  true,
  'Date: people from the events come before people nearby'
);

select is(
  (select common_events -> 0 ->> 'name'
   from public.get_discover_feed('date') where first_name = 'Diego'),
  'Noite Ácida',
  'feed returns the common event'
);

select ok(
  not exists (select 1 from public.get_discover_feed('date') where id = tests.uid(1)),
  'feed never includes the user'
);

-- Crew feed -------------------------------------------------------------

select results_eq(
  $$ select first_name, common_event_count
     from public.get_discover_feed('crew') $$,
  $$ values ('Elisa', 2), ('Natália', 2), ('Hugo', 1) $$,
  'Crew feed: ordered by events in common; past events do not count'
);

select is(
  (select count(*)::int from public.get_discover_feed('crew') where is_fallback),
  0,
  'Crew only shows people going to the same parties'
);

-- Same-gender crews: Larissa (11) only wants women.
select tests.login(11);
select ok(
  not exists (
    select 1 from public.get_discover_feed('crew') where gender <> 'woman'
  ),
  'crew_same_gender_only shows only the same gender'
);

-- Hugo (8, man) never sees Larissa in Crew.
select tests.login(8);
select ok(
  not exists (select 1 from public.get_discover_feed('crew') where id = tests.uid(11)),
  'same-gender-only users are hidden from other genders'
);

-- Swipes, undo and fallback ---------------------------------------------

-- Rewind is a plan benefit (monetization migration).
select tests.logout();
insert into public.subscriptions (user_id, tier, source)
values (tests.uid(1), 'plus', 'admin');
select tests.login(1);
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(1), tests.uid(12), 'date', 'pass');

select is(
  public.undo_last_swipe('date'),
  tests.uid(12),
  'undo_last_swipe removes the latest swipe'
);

insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(1), tests.uid(12), 'date', 'pass'),
       (tests.uid(1), tests.uid(4), 'date', 'pass');

select results_eq(
  $$ select first_name, is_fallback from public.get_discover_feed('date') $$,
  $$ values ('Felipe', true), ('Otávio', true), ('Bruno', true), ('João', true) $$,
  'Date: then people nearby, shared genres first'
);

select throws_ok(
  $$ update public.swipes set direction = 'like' where swiped_id = tests.uid(4) $$,
  '42501', null,
  'swipes are immutable'
);

-- Mutual like → match + conversation -----------------------------------

select tests.login(1);
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(1), tests.uid(5), 'crew', 'like');

select is(
  (select count(*)::int from public.matches),
  0,
  'a one-sided like is not a match'
);

select tests.login(5); -- Elisa likes Ana back
insert into public.swipes (swiper_id, swiped_id, mode, direction)
values (tests.uid(5), tests.uid(1), 'crew', 'like');

select results_eq(
  $$ select user_a, user_b, mode::text from public.matches $$,
  $$ values (tests.uid(1), tests.uid(5), 'crew') $$,
  'mutual like creates the match in that mode'
);

select is(
  (select count(*)::int
   from public.conversation_members cm
   join public.conversations c on c.id = cm.conversation_id
   join public.matches m on m.id = c.match_id
   where c.type = 'direct'),
  2,
  'the match creates a direct conversation with both members'
);

select tests.login(1);
select is(
  public.undo_last_swipe('crew'),
  null,
  'a swipe that produced a match cannot be undone'
);

select lives_ok(
  $$ insert into public.messages (conversation_id, sender_id, content)
     select c.id, tests.uid(1), 'Bora pra Noite Ácida?'
     from public.conversations c where c.type = 'direct' $$,
  'matched users can message each other'
);

select tests.login(5);
select is(
  (select count(*)::int from public.messages),
  1,
  'the other member reads the message'
);

-- Outsiders see nothing.
select tests.login(9);
select is(
  (select count(*)::int from public.messages) + (select count(*)::int from public.conversations),
  0,
  'non-members cannot see the conversation'
);

-- Unmatch hides the conversation and blocks new messages.
select tests.login(1);
select public.unmatch((select id from public.matches limit 1));

select is(
  (select count(*)::int from public.conversations where type = 'direct'),
  0,
  'unmatch hides the conversation'
);

-- Blocking ------------------------------------------------------------

select tests.login(13); -- Natália blocks Ana
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(13), tests.uid(1));

select tests.login(1);
select ok(
  not exists (select 1 from public.get_discover_feed('crew') where id = tests.uid(13)),
  'blocked users disappear from the feed (both directions)'
);

select is(
  (select count(*)::int from public.public_profiles where id = tests.uid(13)),
  0,
  'blocked users disappear from public_profiles'
);

select * from finish();
rollback;
