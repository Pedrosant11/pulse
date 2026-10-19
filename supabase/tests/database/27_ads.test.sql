begin;
\ir helpers.psql
select plan(12);

-- Two ads: one running, one that already ended.
insert into public.ads (id, title, link_url, placements)
values ('00000000-0000-4000-b000-000000000001', 'Sunset Club', 'https://example.com', array['events']);
insert into public.ads (id, title, starts_at, ends_at)
values ('00000000-0000-4000-b000-000000000002', 'Old party', now() - interval '2 days', now() - interval '1 day');

-- Free person (13).
select tests.login(13);
select is(
  (public.get_ads() ->> 'enabled')::boolean, true,
  'free people see ads'
);
select is(
  (select jsonb_agg(a ->> 'title') from jsonb_array_elements(public.get_ads() -> 'ads') a),
  '["Sunset Club"]'::jsonb,
  'only ads running now'
);
select is(
  (public.get_ads() ->> 'events_every')::int, 6,
  'with how often to show them'
);
select throws_ok(
  $$insert into public.ads (title) values ('Mine')$$,
  '42501', null, 'only admins create ads'
);
select is_empty(
  $$select 1 from public.ads$$,
  'and only admins read the table'
);

-- Impressions and clicks count once per person a day.
select public.log_ad('00000000-0000-4000-b000-000000000001', 'impression');
select public.log_ad('00000000-0000-4000-b000-000000000001', 'impression');
select public.log_ad('00000000-0000-4000-b000-000000000001', 'click');
select throws_ok(
  $$select * from public.admin_ad_stats()$$,
  '42501', 'admins only', 'only admins see the numbers'
);
select tests.logout();

select tests.login(14);
select public.log_ad('00000000-0000-4000-b000-000000000001', 'impression');
select tests.logout();

select tests.login(1);
select is(
  (select (impressions, clicks)::text from public.admin_ad_stats()
   where ad_id = '00000000-0000-4000-b000-000000000001'),
  '(2,1)',
  'one impression per person a day'
);
select lives_ok(
  $$insert into public.ads (title, placements) values ('Admin ad', array['discover'])$$,
  'admins create ads'
);
select throws_ok(
  $$insert into public.ads (title, placements) values ('Bad', array['chat'])$$,
  '23514', null, 'ads never go to other places'
);
select throws_ok(
  $$insert into public.ads (title, link_url) values ('Bad', 'http://x.com')$$,
  '23514', null, 'links must be https'
);
select tests.logout();

-- Paying people: on by default, off when the setting says so.
select tests.login(6);
select is(
  (public.get_ads() ->> 'enabled')::boolean, true,
  'paying people see ads at launch (ads_for_paid = 1)'
);
select tests.logout();
update private.app_settings set value = '0' where key = 'ads_for_paid';
select tests.login(6);
select is(
  public.get_ads() -> 'ads', '[]'::jsonb,
  'and none once ads_for_paid is 0'
);
select tests.logout();

select * from finish();
rollback;
