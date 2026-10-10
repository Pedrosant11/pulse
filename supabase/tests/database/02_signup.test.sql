begin;
\ir helpers.psql
select plan(4);

select lives_ok(
  $$
    insert into auth.users (id, instance_id, aud, role, email, raw_user_meta_data)
    values (
      '11111111-1111-4111-8111-111111111111',
      '00000000-0000-0000-0000-000000000000',
      'authenticated', 'authenticated', 'adult@pulse.test',
      '{"first_name": "Maria", "last_name": "Silva", "birth_date": "2000-01-01"}'
    )
  $$,
  'adults can sign up'
);

select is(
  (select first_name || ' ' || last_name from public.profiles
   where id = '11111111-1111-4111-8111-111111111111'),
  'Maria Silva',
  'sign-up metadata creates the profile'
);

select ok(
  exists (select 1 from public.user_private
          where user_id = '11111111-1111-4111-8111-111111111111'),
  'sign-up creates the private row'
);

select throws_ok(
  format(
    $$
      insert into auth.users (id, instance_id, aud, role, email, raw_user_meta_data)
      values (
        '22222222-2222-4222-8222-222222222222',
        '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated', 'minor@pulse.test',
        '{"first_name": "Teen", "birth_date": "%s"}'
      )
    $$,
    current_date - interval '17 years'
  ),
  '23514', null,
  'minors cannot sign up'
);

select * from finish();
rollback;
