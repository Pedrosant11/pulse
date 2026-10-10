begin;
\ir helpers.psql
select plan(10);

-- Diego (4) suggests an event; Bruno (2) is a curator; Ana (1) is admin.
select tests.login(4);
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values (
  '99999999-9999-4999-8999-999999999999', 'Sugestão do Diego', 'Galpão',
  'São Paulo', 'SP', now() + interval '30 days', now() + interval '30 days 6 hours'
);

select tests.login(2);
select throws_ok(
  $$ update public.events set status = 'cancelled' where id = tests.event(1) $$,
  '42501', null,
  'curators cannot cancel someone else''s event'
);

select lives_ok(
  $$ update public.events set lineup = '{"Novo DJ"}' where id = tests.event(1) $$,
  'curators can still edit any event'
);

select lives_ok(
  $$ update public.events set status = 'approved'
     where id = '99999999-9999-4999-8999-999999999999' $$,
  'curators approve pending events'
);

-- Attendance rows are private (RLS): check as the superuser.
select tests.logout();
select ok(
  exists (
    select 1 from public.event_attendance
    where event_id = '99999999-9999-4999-8999-999999999999'
      and user_id = tests.uid(4)
  ),
  'approval marks the creator as going'
);
select tests.login(2);

select throws_ok(
  $$ update public.events set status = 'rejected'
     where id = '99999999-9999-4999-8999-999999999999' $$,
  '42501', null,
  'curators do not change the status of reviewed events'
);

select results_eq(
  $$ select first_name, events_created, email
     from public.get_event_creator('99999999-9999-4999-8999-999999999999') $$,
  $$ values ('Diego'::text, 1, null::text) $$,
  'curators see who created the event, without the e-mail'
);

select tests.login(4);
select lives_ok(
  $$ update public.events set status = 'cancelled'
     where id = '99999999-9999-4999-8999-999999999999' $$,
  'the creator can cancel their event'
);

select throws_ok(
  $$ select * from public.get_event_creator(tests.event(1)) $$,
  '42501', null,
  'regular users cannot look up creators'
);

select tests.login(1);
select is(
  (select email from public.get_event_creator('99999999-9999-4999-8999-999999999999')),
  'seed04@pulse.test',
  'admins see the creator e-mail'
);

select lives_ok(
  $$ update public.events set status = 'cancelled' where id = tests.event(2) $$,
  'admins can cancel any event'
);

select * from finish();
rollback;
