begin;
\ir helpers.psql
select plan(20);

-- Beltran (event 7, by producer 2): Sofia (17) and Rafael (16) go;
-- Ana (1) doesn't.
insert into public.event_attendance (event_id, user_id)
values (tests.event(7), tests.uid(16)), (tests.event(7), tests.uid(17))
on conflict do nothing;
delete from public.event_attendance where event_id = tests.event(7) and user_id = tests.uid(4);

select tests.login(17);
select is(
  (public.event_chat_info(tests.event(7)) ->> 'state'),
  'open',
  'approved party: the chat is open before the night'
);
select lives_ok(
  $$select public.send_event_message(tests.event(7), '  Alguém de carona saindo de Botafogo?  ')$$,
  'going: Sofia writes'
);
select throws_ok(
  $$select public.send_event_message(tests.event(7), 'de novo')$$,
  'P0429', null,
  'one message every 2 s'
);
select throws_ok(
  $$select public.send_event_message(tests.event(7), repeat('a', 501))$$,
  '22023', null,
  'at most 500 characters'
);
select tests.logout();

select tests.login(16);
select results_eq(
  $$select first_name, content, is_team from public.event_chat_messages(tests.event(7))$$,
  $$values ('Sofia'::text, 'Alguém de carona saindo de Botafogo?'::text, false)$$,
  'Rafael reads it (trimmed, with who sent it)'
);
select is(
  (select count(*)::int from public.event_messages where event_id = tests.event(7)),
  1,
  'the raw rows (Realtime) are readable by who is in the chat'
);
select tests.logout();

-- Not going: no access.
select tests.login(4);
select is(
  (public.event_chat_info(tests.event(7)) ->> 'in_chat')::boolean,
  false,
  'not going: outside the chat'
);
select is(
  (select count(*)::int from public.event_chat_messages(tests.event(7))),
  0,
  'not going: reads nothing'
);
select is(
  (select count(*)::int from public.event_messages),
  0,
  'not going: no raw rows either'
);
select throws_ok(
  $$select public.send_event_message(tests.event(7), 'oi')$$,
  'P0001', 'Only who is going',
  'not going: can''t write'
);
select tests.logout();

-- The producer is in the chat with the "Produção" tag and moderates.
select tests.login(2);
select lives_ok(
  $$select public.send_event_message(tests.event(7), 'Portas abrem às 23h!')$$,
  'the producer writes without "Eu vou"'
);
select is(
  (select is_team from public.event_chat_messages(tests.event(7)) where first_name <> 'Sofia'),
  true,
  'tagged as the team'
);
select lives_ok(
  $$select public.set_event_chat_mute(tests.event(7), tests.uid(17), true)$$,
  'the producer mutes Sofia'
);
select lives_ok(
  $$select public.delete_event_message(
      (select id from public.event_messages where sender_id = tests.uid(17)))$$,
  'and deletes her message'
);
select tests.logout();

select tests.login(17);
select throws_ok(
  $$select public.send_event_message(tests.event(7), 'oi?')$$,
  'P0001', 'Muted',
  'muted: can''t write'
);
select tests.logout();

-- Rafael can't delete someone else's message.
select tests.login(16);
select throws_ok(
  $$select public.delete_event_message(
      (select id from public.event_messages where sender_id = tests.uid(2)))$$,
  '42501', null,
  'only your own message (or the team)'
);
-- Reporting a chat message keeps a copy for the moderation.
insert into public.reports (target_type, target_id, reason)
select 'message', id, 'spam' from public.event_messages where sender_id = tests.uid(2);
select is(
  (select snapshot ->> 'conversation_type' from public.reports
   where reporter_id = tests.uid(16) order by created_at desc limit 1),
  'event',
  'a report of a chat message keeps its text'
);
-- Blocking hides the person's messages.
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(16), tests.uid(2));
select is(
  (select count(*)::int from public.event_chat_messages(tests.event(7))),
  0,
  'blocked: their messages disappear'
);
select tests.logout();

-- After the party: read only, then closed and deleted.
update public.events set starts_at = now() - interval '20 hours', ends_at = now() - interval '13 hours'
where id = tests.event(7);
select tests.login(16);
select is(
  (public.event_chat_info(tests.event(7)) ->> 'state'),
  'read_only',
  '12 h after the end: read only'
);
select tests.logout();
update public.events set starts_at = now() - interval '5 days', ends_at = now() - interval '4 days 12 hours'
where id = tests.event(7);
select private.purge_event_chats();
select is(
  (select count(*)::int from public.event_messages where event_id = tests.event(7)),
  0,
  'days later: messages deleted'
);

select * from finish();
rollback;
