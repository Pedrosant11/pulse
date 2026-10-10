begin;
\ir helpers.psql
select plan(14);

-- Global guarantees ---------------------------------------------------------

select is(
  (select count(*)::int from pg_tables
   where schemaname = 'public' and not rowsecurity),
  0,
  'RLS is enabled on every public table'
);

select is(
  (select count(*)::int from information_schema.role_table_grants
   where grantee = 'anon' and table_schema = 'public'),
  0,
  'anon has no table privileges in public'
);

select hasnt_column('public', 'public_profiles', 'last_name',
  'public_profiles does not expose last_name');
select hasnt_column('public', 'public_profiles', 'birth_date',
  'public_profiles does not expose birth_date');
select hasnt_column('public', 'public_profiles', 'lat',
  'public_profiles does not expose coordinates');

-- Profiles ------------------------------------------------------------------

select tests.login(4); -- Diego, regular user

select is(
  (select count(*)::int from public.profiles where id <> tests.uid(4)),
  0,
  'users cannot read other rows of profiles'
);

select is(
  (select first_name from public.public_profiles where id = tests.uid(1)),
  'Ana',
  'users read other people through public_profiles'
);

select throws_ok(
  $$ update public.profiles set role = 'admin' where id = tests.uid(4) $$,
  '42501', null,
  'users cannot change their own role'
);

select throws_ok(
  $$ update public.profiles set birth_date = '2000-01-01' where id = tests.uid(4) $$,
  '42501', null,
  'birth date is locked once set'
);

select lives_ok(
  $$ update public.profiles set bio = 'Nova bio' where id = tests.uid(4) $$,
  'users edit their regular fields'
);

-- Phone: required in the app, one account per number, no code (launch
-- decision). The old mock verification is gone.

select lives_ok(
  $$ update public.user_private set phone = '+5511988887777' where user_id = tests.uid(4) $$,
  'users save their phone'
);

select throws_ok(
  $$ update public.user_private set phone = '+5511990000001' where user_id = tests.uid(4) $$,
  '23505', null,
  'a phone number belongs to one account only'
);

select throws_ok(
  $$ update public.user_private set phone = '11999' where user_id = tests.uid(4) $$,
  '23514', null,
  'phones are stored in E.164'
);

select hasnt_function('public', 'verify_phone_mock', 'the mock verification was removed');

select * from finish();
rollback;
