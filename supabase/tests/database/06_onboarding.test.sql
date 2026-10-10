begin;
\ir helpers.psql
select plan(5);

-- A fresh user (no photos yet) with the onboarding basics filled in.
insert into auth.users (id, instance_id, aud, role, email, email_confirmed_at, raw_user_meta_data)
values (
  '77777777-7777-4777-8777-777777777777',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated', 'onboarding@pulse.test', now(),
  '{"first_name": "Nova", "birth_date": "1998-02-02"}'
);

create or replace function tests.login_new()
returns void
language plpgsql
as $$
begin
  perform set_config('role', 'authenticated', true);
  perform set_config(
    'request.jwt.claims',
    '{"sub": "77777777-7777-4777-8777-777777777777", "role": "authenticated"}',
    true
  );
end;
$$;
grant execute on function tests.login_new() to authenticated;

select tests.login_new();
update public.profiles
set gender = 'woman', modes = '{crew}', terms_version = '2026-10-01', onboarding_step = 5
where id = '77777777-7777-4777-8777-777777777777';

select is(
  (select onboarding_step::int from public.profiles
   where id = '77777777-7777-4777-8777-777777777777'),
  5,
  'onboarding progress is saved'
);

select throws_ok(
  $$ update public.profiles set onboarding_completed = true
     where id = '77777777-7777-4777-8777-777777777777' $$,
  'P0001', null,
  'cannot complete onboarding without 2 photos'
);

insert into public.profile_photos (user_id, storage_path, position) values
  ('77777777-7777-4777-8777-777777777777', '77777777-7777-4777-8777-777777777777/a.jpg', 0),
  ('77777777-7777-4777-8777-777777777777', '77777777-7777-4777-8777-777777777777/b.jpg', 1);

select lives_ok(
  $$ update public.profiles set onboarding_completed = true, onboarding_step = 6
     where id = '77777777-7777-4777-8777-777777777777' $$,
  'completes onboarding with 2 photos'
);

select throws_ok(
  $$ delete from public.profile_photos
     where storage_path = '77777777-7777-4777-8777-777777777777/a.jpg' $$,
  'P0001', null,
  'an onboarded profile cannot drop below 2 photos'
);

select tests.logout();
delete from auth.users where id = '77777777-7777-4777-8777-777777777777';
select is(
  (select count(*)::int from public.profile_photos
   where user_id = '77777777-7777-4777-8777-777777777777'),
  0,
  'deleting the account still removes every photo'
);

select * from finish();
rollback;
