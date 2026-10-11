begin;
\ir helpers.psql
select plan(15);

-- 13 invites 16 and 18; nobody has matches yet.
delete from public.matches
where tests.uid(13) in (user_a, user_b) or tests.uid(16) in (user_a, user_b)
   or tests.uid(18) in (user_a, user_b);
delete from public.wallets where user_id in (tests.uid(13), tests.uid(16), tests.uid(18));

select tests.login(13);
select matches(
  (select code from public.get_my_referral()), '^[A-Z0-9]{6}$',
  'everyone gets a 6-character code'
);
select is(
  (select code from public.get_my_referral()),
  (select code from public.get_my_referral()),
  'and keeps the same code'
);
select throws_ok(
  format('select public.redeem_referral(%L)', (select code from public.get_my_referral())),
  'P0001', 'own code', 'nobody can use their own code'
);
select tests.logout();

create temp table code13 as select code from private.referral_codes where user_id = tests.uid(13);
grant select on code13 to authenticated;

select tests.login(16);
select throws_ok(
  $$select public.redeem_referral('ZZZZZZ')$$,
  'P0001', 'unknown code', 'a wrong code is refused'
);
select lives_ok(
  format('select public.redeem_referral(%L)', lower((select code from code13))),
  'a friend''s code works (any case)'
);
select is(
  (select superlikes from public.wallets where user_id = tests.uid(16)),
  3,
  'the invited person gets 3 superlikes right away'
);
select is(
  (select can_redeem from public.get_my_referral()), false,
  'and cannot type another code'
);
select throws_ok(
  format('select public.redeem_referral(%L)', (select code from code13)),
  'P0001', 'already used', 'a second code is refused'
);
select tests.logout();
create temp table code16 as select code from private.referral_codes where user_id = tests.uid(16);
grant select on code16 to authenticated;

-- No swapping: 13 can't use the code of someone they invited.
select tests.login(13);
select throws_ok(
  format('select public.redeem_referral(%L)',
    (select code from code16)),
  'P0001', 'own code', 'people can''t swap codes'
);
select tests.logout();

-- The friend is paid on the invited person's first match only.
select is(
  (select count(*)::int from public.wallets where user_id = tests.uid(13)), 0,
  'the friend gets nothing before the first match'
);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(16), tests.uid(17)), greatest(tests.uid(16), tests.uid(17)), 'date');
select is(
  (select (superlikes, boosts)::text from public.wallets where user_id = tests.uid(13)),
  '(3,1)',
  'the first match gives the friend 3 superlikes and 1 boost'
);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(16), tests.uid(17)), greatest(tests.uid(16), tests.uid(17)), 'crew');
select is(
  (select (superlikes, boosts)::text from public.wallets where user_id = tests.uid(13)),
  '(3,1)',
  'only once'
);

-- After a match it's too late to type a code.
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(18), tests.uid(19)), greatest(tests.uid(18), tests.uid(19)), 'date');
select tests.login(18);
select throws_ok(
  format('select public.redeem_referral(%L)', (select code from code13)),
  'P0001', 'after first match', 'codes only work before the first match'
);
select tests.logout();

-- Monthly cap for the friend.
update private.app_settings set value = '1' where key = 'referral_monthly_cap';
delete from public.matches where tests.uid(20) in (user_a, user_b);
insert into private.referrals (referred_id, referrer_id) values (tests.uid(20), tests.uid(13));
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(20), tests.uid(21)), greatest(tests.uid(20), tests.uid(21)), 'date');
select is(
  (select (superlikes, boosts)::text from public.wallets where user_id = tests.uid(13)),
  '(3,1)',
  'over the monthly cap the friend gets nothing more'
);

-- The LGPD export has the code and the count.
select tests.login(13);
select is(
  (select public.export_my_data() -> 'referral' ->> 'code'),
  (select code from code13),
  'the data export includes the referral code'
);
select tests.logout();

select * from finish();
rollback;
