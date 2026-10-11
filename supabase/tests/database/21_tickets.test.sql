begin;
\ir helpers.psql
select plan(6);

update public.events
set ticket_url = 'https://shotgun.live/events/noite-acida?ref=pedro', ticket_coupon = 'PEDRO10'
where id = tests.event(1);

select throws_ok(
  $$ update public.events set ticket_coupon = 'X' where id = tests.event(1) $$,
  '23514', null,
  'a coupon has at least 2 characters'
);

-- Taps are counted once per person per hour.
select tests.login(4);
select public.log_ticket_click(tests.event(1));
select public.log_ticket_click(tests.event(1));
select tests.login(5);
select public.log_ticket_click(tests.event(1));

select throws_ok(
  $$ select count(*) from public.ticket_clicks $$,
  '42501', null,
  'people cannot read the taps'
);
select is(
  public.get_ticket_click_count(tests.event(1)),
  0,
  'other users do not see the count'
);

-- Ana is admin (seed): moderators see it.
select tests.login(1);
select is(
  public.get_ticket_click_count(tests.event(1)),
  2,
  'moderators see how many people tapped (deduplicated)'
);

-- After 90 days only the count remains.
select tests.logout();
update public.ticket_clicks set created_at = now() - interval '91 days'
where event_id = tests.event(1);
select is(private.anonymize_ticket_clicks(), 2, 'old taps lose the user id');
select is(
  (select count(*)::int from public.ticket_clicks
   where event_id = tests.event(1) and user_id is null),
  2,
  'but still count'
);

select * from finish();
rollback;
