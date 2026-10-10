begin;
\ir helpers.psql
select plan(12);

-- Gael (30, Crew only) switches to "events only".
select tests.login(30);
select lives_ok(
  $$ update public.profiles set modes = '{}' where id = tests.uid(30) $$,
  'an onboarded person can turn every mode off'
);
select lives_ok(
  $$ delete from public.profile_photos where user_id = tests.uid(30) $$,
  'without a mode, photos are optional'
);
select lives_ok(
  $$ update public.profiles set gender = null where id = tests.uid(30) $$,
  'without a mode, gender is optional'
);
select throws_ok(
  $$ update public.profiles set modes = '{crew}' where id = tests.uid(30) $$,
  'P0001', 'At least 2 photos are required',
  'turning a mode on needs 2 photos'
);

-- Invisible at events, but counted.
select tests.logout();
delete from public.event_attendance
where event_id = tests.event(1) and user_id = tests.uid(30);
select tests.login(1);
select coalesce(
  (select total from public.get_event_attendee_counts(array[tests.event(1)])),
  0
) as total_before \gset
select tests.logout();
insert into public.event_attendance (event_id, user_id)
values (tests.event(1), tests.uid(30));

select tests.login(1);
select is(
  (select count(*)::int from public.get_event_attendees(tests.event(1))
   where user_id = tests.uid(30)),
  0,
  'not shown among the event attendees'
);
select is(
  (select total from public.get_event_attendee_counts(array[tests.event(1)])),
  :total_before::int + 1,
  'still counts in the event total'
);

-- Can't be liked.
select tests.login(5);
select throws_ok(
  $$ select public.swipe(tests.uid(30), 'crew', 'like') $$,
  '42501', null,
  'nobody can like a person without that mode'
);

-- Crews need Crew mode.
select tests.logout();
insert into public.event_attendance (event_id, user_id)
values (tests.event(1), tests.uid(5))
on conflict do nothing;
insert into public.crews (id, event_id, owner_id, name)
values ('00000000-0000-4000-d000-000000000018', tests.event(1), tests.uid(5), 'Crew aberta');

select tests.login(30);
select throws_ok(
  $$ insert into public.crew_join_requests (crew_id, user_id)
     values ('00000000-0000-4000-d000-000000000018', tests.uid(30)) $$,
  'P0001', 'Crew mode is required',
  'asking to join a crew needs Crew mode'
);
select throws_ok(
  $$ insert into public.crews (event_id, owner_id, name)
     values (tests.event(1), tests.uid(30), 'Minha crew') $$,
  'P0001', 'Crew mode is required',
  'creating a crew needs Crew mode'
);

-- Back to Crew: needs photos and gender.
select tests.logout();
insert into public.profile_photos (user_id, storage_path, position) values
  (tests.uid(30), tests.uid(30) || '/a.jpg', 0),
  (tests.uid(30), tests.uid(30) || '/b.jpg', 1);
select tests.login(30);
select throws_ok(
  $$ update public.profiles set modes = '{crew}' where id = tests.uid(30) $$,
  '23514', null,
  'turning a mode on needs a gender'
);
select lives_ok(
  $$ update public.profiles set gender = 'man', modes = '{crew}'
     where id = tests.uid(30) $$,
  'with photos and gender the mode turns on'
);

-- A new account finishes onboarding as "events only" with no photos.
select tests.logout();
update public.profiles
set onboarding_completed = false, modes = '{}', gender = null
where id = tests.uid(29);
delete from public.profile_photos where user_id = tests.uid(29);
select tests.login(29);
select lives_ok(
  $$ update public.profiles set onboarding_completed = true, onboarding_step = 8
     where id = tests.uid(29) $$,
  'onboarding finishes without photos or gender when only using events'
);

select * from finish();
rollback;
