begin;
\ir helpers.psql
select plan(12);

-- Ana (1) and Elisa (5) match in Crew; both go to events 1 and 4.
select tests.login(1);
select * from public.swipe(tests.uid(5), 'crew', 'like');
select tests.login(5);
select * from public.swipe(tests.uid(1), 'crew', 'like');

select tests.login(1);
select results_eq(
  $$ select type::text, mode::text, other_first_name, last_message, unread_count
     from public.list_conversations() $$,
  $$ values ('direct', 'crew', 'Elisa'::text, null::text, 0) $$,
  'a new match shows up as a conversation without messages'
);

select is(
  (select jsonb_array_length(common_events)
   from public.get_conversation((select id from public.list_conversations()))),
  2,
  'the header lists the upcoming events in common (icebreakers)'
);

insert into public.messages (conversation_id, sender_id, content)
select id, tests.uid(1), 'Bora pra Noite Ácida?' from public.list_conversations();

select tests.login(5);
select results_eq(
  $$ select last_message, unread_count from public.list_conversations() $$,
  $$ values ('Bora pra Noite Ácida?'::text, 1) $$,
  'the other side sees the last message as unread'
);

select public.mark_conversation_read((select id from public.list_conversations()));
select is(
  (select unread_count from public.list_conversations()),
  0,
  'mark_conversation_read clears the unread count'
);

select tests.login(1);
select ok(
  (select other_last_read_at is not null
   from public.get_conversation((select id from public.list_conversations()))),
  'the sender sees when it was read'
);

-- RLS filters the row out: the update silently changes nothing.
update public.conversation_members set last_read_at = '2000-01-01'
where user_id = tests.uid(5);
select tests.logout();
select ok(
  (select last_read_at > '2000-01-01' from public.conversation_members
   where user_id = tests.uid(5)),
  'users cannot change someone else''s read receipt'
);
select tests.login(1);

-- Deleting wipes the text for everyone (not just a flag).
update public.messages set deleted_at = now()
where sender_id = tests.uid(1);
select tests.login(5);
select results_eq(
  $$ select content, deleted_at is not null from public.messages $$,
  $$ values (''::text, true) $$,
  'a deleted message has no content left for the other member'
);
select throws_ok(
  $$ update public.messages set content = 'editado' where sender_id = tests.uid(1) $$,
  '42501', null,
  'messages cannot be edited'
);
select tests.login(1);

-- Realtime channel authorization (typing indicator).
select is(
  private.conversation_topic_id('conversation:' || (select id from public.list_conversations())),
  (select id from public.list_conversations()),
  'channel topic resolves to the conversation'
);
select is(private.conversation_topic_id('conversation:not-a-uuid'), null, 'bad topics are ignored');

select tests.login(9); -- Isabela is not a member
select is(
  (select count(*)::int from public.list_conversations()),
  0,
  'outsiders see no conversations'
);

-- Unmatch hides it from the list.
select tests.login(1);
select public.unmatch((select match_id from public.list_conversations()));
select is(
  (select count(*)::int from public.list_conversations()),
  0,
  'unmatched conversations leave the list'
);

select * from finish();
rollback;
