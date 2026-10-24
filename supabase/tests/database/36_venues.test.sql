begin;
\ir helpers.psql
select plan(18);

delete from private.event_push_log;

-- Who adds venues and with which status.
select tests.login(3); -- producer
insert into public.venues (id, name, city, state, status)
values ('00000000-0000-4000-c000-000000000099', 'Casa Nova', 'São Paulo', 'SP', 'approved');
select is(
  (select status::text from public.venues where id = '00000000-0000-4000-c000-000000000099'),
  'pending',
  'a producer''s venue waits for the curators (status from the database)'
);
select is(
  (select created_by from public.venues where id = '00000000-0000-4000-c000-000000000099'),
  tests.uid(3),
  'and is theirs'
);
update public.venues set status = 'approved', name = 'Casa Nova SP'
where id = '00000000-0000-4000-c000-000000000099';
select is(
  (select status::text || ' ' || name from public.venues where id = '00000000-0000-4000-c000-000000000099'),
  'pending Casa Nova SP',
  'they can edit it, but not approve it'
);
select tests.logout();

select tests.login(5); -- regular user
select throws_ok(
  $$insert into public.venues (name, city, state) values ('Minha Casa', 'São Paulo', 'SP')$$,
  '42501', 'Only producers and the team add venues',
  'regular users can''t add venues'
);
select is(
  (select count(*)::int from public.venues where id = '00000000-0000-4000-c000-000000000099'),
  0,
  'nor see someone else''s pending venue'
);
select is(
  (select count(*)::int from public.list_venues('casa nova')),
  0,
  'not even by name'
);
select throws_ok(
  $$select public.admin_review_venue('00000000-0000-4000-c000-000000000099', true)$$,
  '42501', 'Only curators',
  'and can''t approve it'
);
select tests.logout();

select tests.login(2); -- curator
insert into public.venues (id, name, city, state)
values ('00000000-0000-4000-c000-000000000098', 'Casa da Curadoria', 'São Paulo', 'SP');
select is(
  (select status::text from public.venues where id = '00000000-0000-4000-c000-000000000098'),
  'approved',
  'the team''s venues are approved right away'
);
select public.admin_review_venue('00000000-0000-4000-c000-000000000099', true);
select is(
  (select status::text from public.venues where id = '00000000-0000-4000-c000-000000000099'),
  'approved',
  'curators approve suggestions'
);
select tests.logout();

-- Linking an event to someone else's pending venue is refused.
select tests.logout();
set local session_replication_role = replica;
insert into public.venues (id, name, city, state, status, created_by)
values ('00000000-0000-4000-c000-000000000097', 'Pendente', 'São Paulo', 'SP', 'pending', tests.uid(2));
set local session_replication_role = origin;
select tests.login(3);
select throws_ok(
  format($$update public.events set venue_id = %L where id = %L$$,
    '00000000-0000-4000-c000-000000000097', tests.event(1)),
  'P0001', 'Venue not available',
  'an event can''t point to someone else''s pending venue'
);
select tests.logout();

-- Ratings: only people who went (Ana went to the past Ritual at Galpão 23).
select tests.login(1);
insert into public.venue_reviews (venue_id, user_id, rating, comment)
values ('00000000-0000-4000-c000-000000000001', tests.uid(1), 5, '  Som absurdo  ');
select is(
  (select comment from public.venue_reviews
   where venue_id = '00000000-0000-4000-c000-000000000001' and user_id = tests.uid(1)),
  'Som absurdo',
  'who went rates it'
);
select tests.logout();

select tests.login(16); -- Rio, never went
select throws_ok(
  $$insert into public.venue_reviews (venue_id, user_id, rating)
    values ('00000000-0000-4000-c000-000000000001', tests.uid(16), 1)$$,
  'P0001', 'Only people who went can rate',
  'who never went can''t rate'
);
select ok(
  not (public.get_venue('00000000-0000-4000-c000-000000000001') ->> 'can_review')::boolean,
  'and the page says so'
);

-- Following (wherever you live) brings the venue's new parties.
insert into public.venue_follows (venue_id, user_id)
values ('00000000-0000-4000-c000-000000000001', tests.uid(16));
select throws_ok(
  $$insert into public.venue_follows (venue_id, user_id)
    values ('00000000-0000-4000-c000-000000000097', tests.uid(16))$$,
  '42501', null,
  'pending venues can''t be followed'
);
select tests.logout();

select tests.login(1);
select is(
  (public.get_venue('00000000-0000-4000-c000-000000000001') ->> 'rating')::numeric,
  5.0,
  'the page shows the average rating'
);
select ok(
  (public.get_venue('00000000-0000-4000-c000-000000000001') -> 'upcoming') @> jsonb_build_array(
    jsonb_build_object('id', tests.event(1))),
  'and its upcoming parties'
);
select tests.logout();

update public.profiles set notify_events = true where id = tests.uid(16);
insert into public.events (id, name, venue_name, city, state, lat, lng, starts_at, ends_at,
  genres, status, created_by, venue_id)
values ('00000000-0000-4000-b000-000000000097', 'Ritual 2', 'Galpão 23', 'São Paulo', 'SP',
  -23.53, -46.64, now() + interval '9 days', now() + interval '9 days 8 hours',
  '{techno}', 'approved', tests.uid(2), '00000000-0000-4000-c000-000000000001');
select is(
  (select kind from private.event_push_log
   where user_id = tests.uid(16) and event_id = '00000000-0000-4000-b000-000000000097'),
  'venue_new',
  'followers in another city hear about a new party there'
);

select tests.login(16);
select ok(
  public.export_my_data() -> 'followed_venues' @> '[{"venue": "Galpão 23"}]'::jsonb,
  'followed venues are in the data export'
);
select tests.logout();

select * from finish();
rollback;
