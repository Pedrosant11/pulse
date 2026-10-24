begin;
\ir helpers.psql
select plan(19);

delete from private.event_push_log;

-- Beltran (event 7, Rio) is happening now. Sofia (17) and Rafael (16) go
-- and have a match; Victor (20) goes too, with no match with them.
update public.events set starts_at = now() - interval '1 hour', ends_at = now() + interval '5 hours'
where id = tests.event(7);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(16), tests.uid(17)), greatest(tests.uid(16), tests.uid(17)), 'date');

-- "Tô ON"
select tests.login(17);
select lives_ok($$select public.set_on(tests.event(7), true)$$, 'going + tonight: Sofia turns ON');
select tests.logout();

select tests.login(1);
select throws_ok(
  $$select public.set_on(tests.event(7), true)$$,
  'P0001', 'Only on the night of a party you are going to',
  'not going: can''t turn ON'
);
select throws_ok(
  $$select public.set_on(tests.event(1), true)$$,
  'P0001', 'Only on the night of a party you are going to',
  'going, but not tonight: can''t either'
);
select tests.logout();

select tests.login(16);
select results_eq(
  $$select first_name from public.event_on_people(tests.event(7))$$,
  $$values ('Sofia'::text)$$,
  'a match sees Sofia is ON'
);
select tests.logout();

select tests.login(20);
select is(
  (select count(*)::int from public.event_on_people(tests.event(7))),
  0,
  'someone else at the party doesn''t'
);
select is(
  (select count(*)::int from public.event_on where user_id = tests.uid(17)),
  0,
  'nor reads the table directly'
);
select tests.logout();

select tests.login(17);
select public.set_on(tests.event(7), false);
select is(
  (select count(*)::int from public.event_on where user_id = tests.uid(17)),
  0,
  'turning OFF removes it'
);
select tests.logout();

-- "Depois da festa": Diego (4) lives in São Paulo and went too.
insert into public.event_attendance (event_id, user_id) values (tests.event(7), tests.uid(4));
update public.events set starts_at = now() - interval '9 hours', ends_at = now() - interval '2 hours'
where id = tests.event(7);

select tests.login(17);
select ok(
  tests.uid(4) not in (select id from public.get_discover_feed('date')),
  'normal Date: Diego is too far'
);
select ok(
  tests.uid(4) in (select id from public.get_discover_feed('date', 20, tests.event(7))),
  'after the party: everyone who went, wherever they live'
);
create temp table after_feed as
  select id from public.get_discover_feed('date', 20, tests.event(7));
select tests.logout();
select ok(
  (select count(*) from after_feed) > 0
  and not exists (
    select 1 from after_feed f
    where not exists (
      select 1 from public.event_attendance ea
      where ea.event_id = tests.event(7) and ea.user_id = f.id
    )
  ),
  'and only them'
);
select tests.login(17);
select is(
  (select count(*)::int from public.get_discover_feed('crew', 20, tests.event(7))),
  0,
  'Crew has no after-party deck'
);
select is(
  (select name from public.my_after_parties()),
  'Beltran na D-EDGE Rio',
  'the Discover banner lists it'
);
select tests.logout();

select tests.login(1);
select is(
  (select count(*)::int from public.get_discover_feed('date', 20, tests.event(7))),
  0,
  'who didn''t go gets nothing'
);
select tests.logout();

update public.events set starts_at = now() - interval '56 hours', ends_at = now() - interval '49 hours'
where id = tests.event(7);
select tests.login(17);
select is(
  (select count(*)::int from public.get_discover_feed('date', 20, tests.event(7))),
  0,
  'it closes after 48 h'
);
select tests.logout();

-- The morning after: a push to who went.
update public.events set starts_at = now() - interval '11 hours', ends_at = now() - interval '4 hours 30 minutes'
where id = tests.event(7);
select private.send_after_party_pushes();
select is(
  (select kind from private.event_push_log where user_id = tests.uid(17) and event_id = tests.event(7)),
  'after_party',
  'who went gets the "Depois da festa" push'
);

-- "Salvar"
select tests.login(1);
insert into public.event_saves (event_id, user_id) values (tests.event(2), tests.uid(1));
select ok(
  (select is_saved from public.list_events('mine') where id = tests.event(2)),
  'a saved party shows in "Meus eventos"'
);
select throws_ok(
  $$insert into public.event_saves (event_id, user_id) values (tests.event(11), tests.uid(1))$$,
  '42501', null,
  'pending parties can''t be saved'
);
select ok(
  (public.event_sections() -> 'this_week') @> jsonb_build_array(jsonb_build_object('id', tests.event(1))),
  'sections: this week near me'
);
select tests.logout();

update public.events set starts_at = now() + interval '24 hours', ends_at = now() + interval '32 hours'
where id = tests.event(2);
select private.send_event_reminders();
select ok(
  exists (select 1 from private.event_push_log
          where user_id = tests.uid(1) and event_id = tests.event(2) and kind = 'event_reminder'),
  'who saved it gets the reminder the day before'
);

select * from finish();
rollback;
