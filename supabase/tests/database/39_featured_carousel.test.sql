begin;
\ir helpers.psql
select plan(3);

-- Ritual (event 1, São Paulo) is featured.
set local session_replication_role = replica;
update public.events set featured_until = now() + interval '3 days' where id = tests.event(1);
set local session_replication_role = origin;

select tests.login(1);
select ok(
  (public.event_sections() -> 'featured') @> jsonb_build_array(jsonb_build_object('id', tests.event(1))),
  '"Em destaque" shows the highlight near the person'
);
select is(
  jsonb_array_length(public.event_sections() -> 'featured'),
  1,
  'and only highlights'
);
select tests.logout();

select tests.login(16); -- Rio
select is(
  jsonb_array_length(public.event_sections() -> 'featured'),
  0,
  'far away it doesn''t show'
);
select tests.logout();

select * from finish();
rollback;
