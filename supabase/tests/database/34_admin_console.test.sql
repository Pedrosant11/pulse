begin;
\ir helpers.psql
select plan(8);

-- Ana (1) is an admin; Bruno (2) is not.
select tests.login(2);
select throws_ok($$select public.admin_dashboard()$$, '42501', 'Admins only',
  'only admins see the dashboard');
select throws_ok($$select * from public.admin_settings()$$, '42501', 'Admins only',
  'and the settings');
select throws_ok($$select public.admin_set_setting('trial_days', 5)$$, '42501', 'Admins only',
  'or change them');
select tests.logout();

select tests.login(1);
select ok(
  (public.admin_dashboard() -> 'users' ->> 'total')::int > 0,
  'the dashboard counts people'
);
select is(
  jsonb_array_length(public.admin_dashboard() -> 'daily'),
  30,
  'with the last 30 days'
);
select lives_ok($$select public.admin_set_setting('trial_days', 5)$$, 'admins change a setting');
select is(
  (select value from public.admin_settings() where key = 'trial_days'),
  '5',
  'and see the new value'
);
select throws_ok($$select public.admin_set_setting('nope', 1)$$, 'P0002', 'unknown setting',
  'only existing settings');
select tests.logout();

select * from finish();
rollback;
