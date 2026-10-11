begin;
\ir helpers.psql
select plan(6);

-- Seed users have no matches; a first match grants Black for 3 days.
delete from public.matches
where tests.uid(13) in (user_a, user_b) or tests.uid(16) in (user_a, user_b);

insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(13), tests.uid(16)), greatest(tests.uid(13), tests.uid(16)), 'date');

select is(
  (select (tier, source)::text from public.subscriptions where user_id = tests.uid(13)),
  '(black,trial)',
  'the first match gives a Pulse Black trial'
);
select ok(
  (select expires_at between now() + interval '71 hours' and now() + interval '73 hours'
   from public.subscriptions where user_id = tests.uid(13)),
  'for 3 days'
);
select is(
  (select will_renew from public.subscriptions where user_id = tests.uid(13)),
  false,
  'with no auto-renewal'
);

-- Only once per person, even after it ends.
update public.subscriptions set expires_at = now() - interval '1 minute'
where user_id = tests.uid(13);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(13), tests.uid(16)), greatest(tests.uid(13), tests.uid(16)), 'crew');
select is(
  private.plan_tier(tests.uid(13)),
  null,
  'a second match does not give another trial'
);

-- People who already pay keep their plan (and don't get it later).
delete from public.matches where tests.uid(6) in (user_a, user_b);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(6), tests.uid(17)), greatest(tests.uid(6), tests.uid(17)), 'date');
select is(
  (select (tier, source)::text from public.subscriptions where user_id = tests.uid(6)),
  '(plus,admin)',
  'an existing plan is not replaced by the trial'
);

-- A store purchase replaces the trial.
select public.apply_store_event(jsonb_build_object(
  'id', 'evt-trial', 'type', 'INITIAL_PURCHASE', 'app_user_id', tests.uid(16),
  'product_id', 'pulse_plus_monthly', 'entitlement_ids', jsonb_build_array('plus'),
  'expiration_at_ms', (extract(epoch from now() + interval '30 days') * 1000)::bigint
));
select is(
  (select (tier, source)::text from public.subscriptions where user_id = tests.uid(16)),
  '(plus,store)',
  'buying a plan replaces the trial'
);

select * from finish();
rollback;
