begin;
\ir helpers.psql
select plan(9);

select tests.login(4); -- Diego

-- Sensitive data (LGPD art. 11) ------------------------------------------

select throws_ok(
  $$ update public.profiles set orientation = 'bisexual' where id = tests.uid(4) $$,
  '22023', null,
  'sexual orientation is refused without consent'
);

update public.profiles
set orientation = 'bisexual', sensitive_data_consent_at = '2000-01-01'
where id = tests.uid(4);

select ok(
  (select sensitive_data_consent_at > now() - interval '1 minute'
   from public.profiles where id = tests.uid(4)),
  'consent is stored with the server clock, not the app''s'
);

update public.profiles set orientation = 'gay' where id = tests.uid(4);
select isnt(
  (select sensitive_data_consent_at from public.profiles where id = tests.uid(4)),
  null,
  'changing the orientation keeps the consent'
);

update public.profiles set orientation = null, show_orientation = true
where id = tests.uid(4);
select results_eq(
  $$ select sensitive_data_consent_at is null, show_orientation
     from public.profiles where id = tests.uid(4) $$,
  $$ values (true, false) $$,
  'removing the orientation withdraws the consent and hides it'
);

-- Export (LGPD art. 18) ----------------------------------------------------

select is(
  (public.export_my_data() -> 'profile' ->> 'first_name'),
  'Diego',
  'the export has the profile'
);

select is(
  (public.export_my_data() -> 'account' ->> 'email'),
  'seed04@pulse.test',
  'the export has the account e-mail'
);

select ok(
  jsonb_array_length(public.export_my_data() -> 'events_going') > 0,
  'the export lists the events the user is going to'
);

select ok(
  (public.export_my_data() -> 'phone' ->> 'phone') is not null,
  'the export has the phone number'
);

select tests.logout();
select throws_ok(
  $$ select public.export_my_data() $$,
  '42501', null,
  'nobody exports without signing in'
);

select * from finish();
rollback;
