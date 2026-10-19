begin;
\ir helpers.psql
select plan(9);

update public.events set featured_until = null;

-- São Paulo has six running parties (1-6); Rio has 7-10.
select tests.login(1);
select lives_ok(
  $$select public.admin_feature_event(e, 7)
    from unnest(array[tests.event(1), tests.event(2), tests.event(3), tests.event(4), tests.event(5)]) e$$,
  'five highlights in the same region'
);
select throws_ok(
  format('select public.admin_feature_event(%L, 7)', tests.event(6)),
  'P0001', 'too many highlights in this region',
  'a sixth one in the same region is refused'
);
select lives_ok(
  format('select public.admin_feature_event(%L, 7)', tests.event(7)),
  'another region has its own five'
);
select lives_ok(
  format('select public.admin_feature_event(%L, 14)', tests.event(1)),
  'extending a running highlight is fine'
);
select public.admin_feature_event(tests.event(5), null);
select lives_ok(
  format('select public.admin_feature_event(%L, 7)', tests.event(6)),
  'when one ends, there is room again'
);
select tests.logout();

-- Everyone sees all highlights on top, in their own order of the day.
create temp table orders (uid int, ids text);
grant all on orders to authenticated;

do $$
declare
  n int;
begin
  foreach n in array array[13, 14, 15, 16, 17, 18] loop
    perform tests.login(n);
    insert into orders
    select n, string_agg(right(id::text, 2), ',' order by rn)
    from (
      select id, row_number() over () as rn
      from public.list_events('nearby') where is_featured
    ) f;
    perform tests.logout();
  end loop;
end;
$$;

select is(
  (select count(*)::int from orders where ids is not null),
  6,
  'featured events show up for everyone'
);

select tests.login(13);
select ok(
  (select bool_and(is_featured) from (
     select is_featured from public.list_events('nearby') limit 5
   ) top),
  'and all of them come first'
);
select is(
  (select string_agg(right(id::text, 2), ',' order by rn) from (
     select id, row_number() over () as rn
     from public.list_events('nearby') where is_featured
   ) f),
  (select ids from orders where uid = 13),
  'the order stays the same during the day'
);
select tests.logout();

select ok(
  (select count(distinct ids) > 1 from orders),
  'different people get different orders'
);

select * from finish();
rollback;
