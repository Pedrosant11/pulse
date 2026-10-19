begin;
\ir helpers.psql
select plan(14);

update public.events set featured_until = null;
-- Producer 3 (Carla) owns event 6 here.
update public.events set created_by = tests.uid(3) where id = tests.event(6);

select is(
  (select string_agg(days || ':' || price_cents, ',' order by days) from public.featured_prices),
  '3:7900,7:14900,14:24900,30:44900',
  'longer highlights cost more'
);

select tests.login(4);
select throws_ok(
  format('select public.request_featured(%L, 7, %L)', tests.event(6), 'team'),
  '42501', null, 'only the creator asks to highlight a party'
);
select tests.logout();

select tests.login(3);
select lives_ok(
  format('select public.request_featured(%L, 7, %L)', tests.event(6), 'team'),
  'the producer asks for 7 days'
);
select lives_ok(
  format('select public.request_featured(%L, 14, %L)', tests.event(6), 'team'),
  'and can change their mind'
);
select is(
  (select string_agg(days || ':' || status, ',' order by created_at) from public.featured_requests),
  '7:cancelled,14:pending',
  'a new choice replaces the open one'
);
select is(
  (select price_cents from public.featured_requests where status = 'pending'),
  24900,
  'with the price of the moment'
);
select throws_ok(
  $$select * from public.admin_featured_requests()$$,
  '42501', 'Admins only', 'only admins see the queue'
);
select tests.logout();

-- The team confirms the payment.
select tests.login(1);
select is(
  (select event_name || ' ' || requester_name from public.admin_featured_requests()),
  'Disco Inferno Carla',
  'the admin sees the party and who asked'
);
select public.admin_review_featured(
  (select id from public.featured_requests where status = 'pending'), true
);
select tests.logout();
select ok(
  (select featured_until between now() + interval '13 days 23 hours' and now() + interval '14 days 1 hour'
   from public.events where id = tests.event(6)),
  'paid: featured for 14 days'
);

-- Buying more days adds to the running highlight (store purchase).
select tests.login(3);
select public.request_featured(tests.event(6), 3, 'store');
select tests.logout();
select is(
  public.apply_store_event(jsonb_build_object(
    'id', 'evt-feat-1', 'type', 'NON_RENEWING_PURCHASE',
    'app_user_id', tests.uid(3), 'product_id', 'pulse_featured_3'
  )),
  'featured: ' || (select id from public.featured_requests where method = 'store')::text,
  'a store purchase pays the open store request'
);
select ok(
  (select featured_until between now() + interval '16 days 23 hours' and now() + interval '17 days 1 hour'
   from public.events where id = tests.event(6)),
  'and adds 3 days to the 14'
);
select is(
  public.apply_store_event(jsonb_build_object(
    'id', 'evt-feat-2', 'type', 'NON_RENEWING_PURCHASE',
    'app_user_id', tests.uid(3), 'product_id', 'pulse_featured_7'
  )),
  'featured: no open request',
  'a purchase without a request is kept for the team to sort out'
);

-- The region limit applies before paying.
update public.events set featured_until = now() + interval '7 days'
where id in (tests.event(1), tests.event(2), tests.event(3), tests.event(4), tests.event(5));
update public.events set featured_until = null where id = tests.event(6);
select tests.login(3);
select throws_ok(
  format('select public.request_featured(%L, 7, %L)', tests.event(6), 'team'),
  'P0001', 'too many highlights in this region',
  'a full region is refused before paying'
);
select tests.logout();

select tests.login(1);
select throws_ok(
  format('select public.admin_feature_event(%L, 7)', tests.event(6)),
  'P0001', 'too many highlights in this region',
  'the admin switch follows the same limit'
);
select tests.logout();

select * from finish();
rollback;
