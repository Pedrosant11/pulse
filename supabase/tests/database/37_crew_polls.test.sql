begin;
\ir helpers.psql
select plan(11);

-- Ana (1) owns a crew for event 1 with Elisa (5); Hugo (8) is outside.
select tests.login(1);
insert into public.crews (id, event_id, owner_id, name, is_open)
values ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', tests.event(1), tests.uid(1), 'Crew da Enquete', true);
select tests.logout();
set local session_replication_role = replica;
insert into public.crew_members (crew_id, user_id)
values ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', tests.uid(5));
insert into public.conversation_members (conversation_id, user_id)
select c.id, tests.uid(5) from public.conversations c
where c.crew_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
set local session_replication_role = origin;

create temp table t as
select c.id as conv from public.conversations c
where c.crew_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
grant select on t to authenticated;

select tests.login(1);
select throws_ok(
  $$select public.create_poll((select conv from t), 'Qual festa?', array['Só uma'])$$,
  'P0001', 'A poll needs 2 to 4 options',
  'a poll needs at least 2 options'
);
create temp table p as
select public.create_poll(
  (select conv from t), '  Que horas o esquenta?  ',
  array['22h', ' 23h ', '22H', '']
) as id;
grant select on p to authenticated;
select is(
  (select options from public.polls where id = (select id from p)),
  array['22h', '23h'],
  'options are trimmed, without blanks or repeats'
);
select is(
  (select kind || ':' || content from public.messages where poll_id = (select id from p)),
  'poll:Que horas o esquenta?',
  'the poll shows in the chat'
);
insert into public.poll_votes (poll_id, user_id, option) values ((select id from p), tests.uid(1), 0);
select tests.logout();

select tests.login(5);
insert into public.poll_votes (poll_id, user_id, option) values ((select id from p), tests.uid(5), 0);
update public.poll_votes set option = 1 where poll_id = (select id from p) and user_id = tests.uid(5);
select results_eq(
  $$select option, count(*)::int from public.poll_votes
    where poll_id = (select id from p) group by option order by option$$,
  $$values (0::smallint, 1), (1::smallint, 1)$$,
  'members vote, change their vote and see everyone''s'
);
select throws_ok(
  $$insert into public.poll_votes (poll_id, user_id, option) values ((select id from p), tests.uid(1), 1)$$,
  '42501', null,
  'nobody votes for someone else'
);
select throws_ok(
  $$update public.poll_votes set option = 3 where poll_id = (select id from p) and user_id = tests.uid(5)$$,
  '22023', 'invalid option',
  'only existing options'
);
select tests.logout();

select tests.login(8);
select is(
  (select count(*)::int from public.polls where id = (select id from p)),
  0,
  'outsiders don''t see the poll'
);
select throws_ok(
  $$insert into public.poll_votes (poll_id, user_id, option) values ((select id from p), tests.uid(8), 0)$$,
  '42501', null,
  'nor vote'
);
select tests.logout();

-- Closed: no more votes.
update public.polls set closes_at = now() - interval '1 minute' where id = (select id from p);
select tests.login(5);
delete from public.poll_votes where poll_id = (select id from p) and user_id = tests.uid(5);
select tests.logout();
select is(
  (select count(*)::int from public.poll_votes where poll_id = (select id from p)),
  2,
  'a closed poll keeps its votes'
);

-- Polls only in crew chats; a poll message can't point to someone else's poll.
select tests.login(1);
select throws_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content, poll_id)
           values (%L, %L, 'poll', 'Falsa', %L)$$,
         (select conv from t), tests.uid(1), gen_random_uuid()),
  '22023', 'invalid poll',
  'poll messages only through create_poll'
);
select ok(
  public.export_my_data() -> 'poll_votes' @> '[{"option": "22h"}]'::jsonb,
  'votes are in the data export'
);
select tests.logout();

select * from finish();
rollback;
