begin;
\ir helpers.psql
select plan(20);

-- Small limits keep the suite short.
update private.app_settings set value = '2' where key = 'free_daily_likes';

-- Daily likes (free) ---------------------------------------------------------

select tests.login(13);
insert into public.swipes (swiper_id, swiped_id, mode, direction) values
  (tests.uid(13), tests.uid(2), 'date', 'like'),
  (tests.uid(13), tests.uid(4), 'date', 'like');
select throws_ok(
  $$ insert into public.swipes (swiper_id, swiped_id, mode, direction)
     values (tests.uid(13), tests.uid(10), 'date', 'like') $$,
  'P0001', 'Daily likes used up',
  'free accounts have a daily like limit'
);
select lives_ok(
  $$ insert into public.swipes (swiper_id, swiped_id, mode, direction)
     values (tests.uid(13), tests.uid(16), 'date', 'pass') $$,
  'passing is never limited'
);

select tests.logout();
insert into public.subscriptions (user_id, tier, source)
values (tests.uid(13), 'plus', 'admin');
select tests.login(13);
select lives_ok(
  $$ insert into public.swipes (swiper_id, swiped_id, mode, direction)
     values (tests.uid(13), tests.uid(10), 'date', 'like') $$,
  'a plan has unlimited likes'
);

-- Superlikes -----------------------------------------------------------------

select tests.login(17);
select lives_ok(
  $$ select public.swipe(tests.uid(2), 'date', 'like', true) $$,
  'one free superlike per week'
);
select throws_ok(
  $$ select public.swipe(tests.uid(4), 'date', 'like', true) $$,
  'P0001', 'No superlikes left',
  'then superlikes come from the wallet'
);

select tests.logout();
-- Same transaction = same clock; the free one goes back a minute so
-- "latest swipe" is clear for the rewind below.
update public.swipes set created_at = now() - interval '1 minute'
where swiper_id = tests.uid(17) and swiped_id = tests.uid(2);
insert into public.wallets (user_id, superlikes) values (tests.uid(17), 1);
select tests.login(17);
select public.swipe(tests.uid(4), 'date', 'like', true);
select tests.logout();
select is(
  (select (s.paid_super, w.superlikes)
   from public.swipes s, public.wallets w
   where s.swiper_id = tests.uid(17) and s.swiped_id = tests.uid(4)
     and w.user_id = tests.uid(17)),
  (true, 0),
  'a superlike beyond the allowance spends the wallet'
);

-- Rewind ---------------------------------------------------------------------

select tests.login(17);
select throws_ok(
  $$ select public.undo_last_swipe('date') $$,
  'P0001', 'Rewind needs a plan',
  'rewind is a plan benefit'
);
select tests.logout();
insert into public.subscriptions (user_id, tier, source)
values (tests.uid(17), 'plus', 'admin');
select tests.login(17);
select public.undo_last_swipe('date');
select tests.logout();
select is(
  (select superlikes from public.wallets where user_id = tests.uid(17)),
  1,
  'undoing a paid superlike refunds it'
);

-- Who liked you --------------------------------------------------------------

select tests.login(1);
select is(public.get_likes_received_count(), 2, 'everyone sees how many liked them');
select throws_ok(
  $$ select * from public.get_likes_received() $$,
  'P0001', 'Who liked you needs Pulse Black',
  'who they are is Pulse Black only'
);

select tests.login(5);
select results_eq(
  $$ select user_id, is_super from public.get_likes_received()
     order by is_super desc, user_id $$,
  $$ values (tests.uid(22), true), (tests.uid(2), false), (tests.uid(24), false) $$,
  'Black sees who liked them, superlikes first'
);

-- Entitlements ---------------------------------------------------------------

select tests.login(1);
select is(
  (select (tier, likes_left_today, free_superlikes_left)::text
   from public.get_my_entitlements()),
  '(,2,1)',
  'free: no plan, likes and superlikes left'
);

-- Boost ----------------------------------------------------------------------

select tests.login(5);
select lives_ok($$ select public.activate_boost() $$, 'Black has a monthly boost');
select throws_ok(
  $$ select public.activate_boost() $$,
  'P0001', 'A boost is already running',
  'one boost at a time'
);
select is(
  (select (free_boosts_left, boost_balance)::text from public.get_my_entitlements()),
  '(0,1)',
  'the monthly boost was used, the wallet kept'
);

select tests.login(13);
select throws_ok(
  $$ select public.activate_boost() $$,
  'P0001', 'No boosts left',
  'Pulse+ needs a boost from the wallet'
);

-- Store events (service role only) -------------------------------------------

select tests.login(13);
select throws_ok(
  $$ select public.apply_store_event('{}'::jsonb) $$,
  '42501', null,
  'the app cannot apply store events'
);

select tests.logout();
select public.apply_store_event(jsonb_build_object(
  'id', 'evt-1', 'type', 'INITIAL_PURCHASE', 'app_user_id', tests.uid(20),
  'product_id', 'pulse_black_monthly', 'entitlement_ids', jsonb_build_array('black'),
  'expiration_at_ms', (extract(epoch from now() + interval '30 days') * 1000)::bigint
));
select is(
  private.plan_tier(tests.uid(20)),
  'black'::public.plan_tier,
  'a purchase turns the plan on'
);
select is(
  public.apply_store_event(jsonb_build_object(
    'id', 'evt-1', 'type', 'EXPIRATION', 'app_user_id', tests.uid(20)
  )),
  'ignored: duplicate',
  'the same event is applied once'
);
select public.apply_store_event(jsonb_build_object(
  'id', 'evt-2', 'type', 'NON_RENEWING_PURCHASE', 'app_user_id', tests.uid(20),
  'product_id', 'pulse_superlikes_5'
));
select is(
  (select superlikes from public.wallets where user_id = tests.uid(20)),
  5,
  'a pack fills the wallet'
);

select * from finish();
rollback;
