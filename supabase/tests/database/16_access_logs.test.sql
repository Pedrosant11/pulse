begin;
\ir helpers.psql
select plan(7);

-- Simulates the gateway headers PostgREST exposes.
select set_config(
  'request.headers',
  '{"x-forwarded-for": "200.150.10.20, 10.0.0.1", "user-agent": "Dart/3.13 (dart:io)"}',
  true
);

select tests.login(4);
select lives_ok($$ select public.log_access() $$, 'the app logs an access');

select throws_ok(
  $$ select count(*) from private.access_logs $$,
  '42501', null,
  'users cannot read the access logs'
);

select tests.logout();
select results_eq(
  $$ select user_id, host(ip), user_agent from private.access_logs
     where user_id = tests.uid(4) $$,
  $$ values (tests.uid(4), '200.150.10.20'::text, 'Dart/3.13 (dart:io)'::text) $$,
  'the IP comes from the request (first forwarded address) with date/time'
);

select tests.login(4);
select public.log_access();
select tests.logout();
select is(
  (select count(*)::int from private.access_logs where user_id = tests.uid(4)),
  1,
  'repeated opens within 10 minutes are logged once'
);

-- Survives account deletion (legal retention).
delete from auth.users where id = tests.uid(4);
select is(
  (select count(*)::int from private.access_logs where user_id = tests.uid(4)),
  1,
  'logs are kept after the account is deleted'
);

-- Six-month retention.
delete from private.access_logs where user_id <> tests.uid(4);
update private.access_logs set created_at = now() - interval '6 months 1 day';
select is(private.purge_access_logs(), 1, 'logs older than 6 months are purged');

select throws_ok(
  $$ select public.log_access() $$,
  '42501', null,
  'anonymous requests are not logged'
);

select * from finish();
rollback;
