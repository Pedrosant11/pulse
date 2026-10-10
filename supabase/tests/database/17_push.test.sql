begin;
\ir helpers.psql
select plan(17);

-- Requests queued by pg_net in this transaction (bodies as JSON).
create or replace function tests.push_requests()
returns setof jsonb
language sql
as $$
  select convert_from(q.body, 'utf8')::jsonb
  from net.http_request_queue q
  where q.url = 'https://push.test/send-push'
  order by q.id;
$$;

-- Tokens --------------------------------------------------------------------

select tests.login(20);
select lives_ok(
  $$ select public.register_push_token('tok-20', 'android') $$,
  'a signed-in user registers the device token'
);
select throws_ok(
  $$ select count(*) from public.push_tokens $$,
  '42501', null,
  'the app cannot read tokens directly'
);
select throws_ok(
  $$ select public.register_push_token('tok-x', 'windows') $$,
  '23514', null,
  'only android and ios tokens'
);

select tests.login(21);
select public.register_push_token('tok-20', 'android');
select tests.logout();
select is(
  (select user_id from public.push_tokens where token = 'tok-20'),
  tests.uid(21),
  'a device that switches accounts moves its token to the new owner'
);

select tests.login(22);
select public.register_push_token('tok-22', 'android');
select tests.login(23);
select public.unregister_push_token('tok-22');
select tests.logout();
select is(
  (select count(*)::int from public.push_tokens where token = 'tok-22'),
  1,
  'nobody removes another person''s token'
);

select tests.login(21);
select public.unregister_push_token('tok-20');
select public.register_push_token('tok-21', 'android');
select tests.logout();
select is(
  (select count(*)::int from public.push_tokens where token = 'tok-20'),
  0,
  'signing out removes the device token'
);

select tests.login(25);
select public.register_push_token('tok-25-' || n, 'android') from generate_series(1, 12) n;
select tests.logout();
select is(
  (select count(*)::int from public.push_tokens where user_id = tests.uid(25)),
  10,
  'keeps at most 10 devices per person'
);

select tests.login(25);
select public.unregister_all_push_tokens();
select tests.logout();
select is(
  (select count(*)::int from public.push_tokens where user_id = tests.uid(25)),
  0,
  'signing out of all devices removes every token'
);

-- Sending -------------------------------------------------------------------

select tests.login(26);
select public.register_push_token('tok-26', 'android');
select tests.logout();

delete from public.matches
where user_a in (tests.uid(21), tests.uid(26))
  and user_b in (tests.uid(21), tests.uid(26));

insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(21), tests.uid(26)), greatest(tests.uid(21), tests.uid(26)), 'date');
select is(
  (select count(*)::int from tests.push_requests()),
  0,
  'without the Vault configuration nothing is sent'
);

select vault.create_secret('https://push.test/send-push', 'push_function_url');
select vault.create_secret('test-secret', 'push_webhook_secret');

-- Match created by 26's like: only 21 is told.
select set_config(
  'request.jwt.claims',
  json_build_object('sub', tests.uid(26), 'role', 'authenticated')::text,
  true
);
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(21), tests.uid(26)), greatest(tests.uid(21), tests.uid(26)), 'crew');
select set_config('request.jwt.claims', '', true);
select is(
  (select r from tests.push_requests() r),
  jsonb_build_object(
    'kind', 'match',
    'recipients', jsonb_build_array(tests.uid(21)),
    'data', jsonb_build_object('mode', 'crew', 'route', '/chats')
  ),
  'a match notifies the other person, with no personal data'
);
select is(
  (select q.headers ->> 'Authorization' from net.http_request_queue q
   where q.url = 'https://push.test/send-push' limit 1),
  'Bearer test-secret',
  'the call carries the shared secret'
);

-- Messages in a direct conversation between 21 and 26.
insert into public.conversations (id, type, match_id)
select '00000000-0000-4000-c000-000000000017', 'direct', m.id
from public.matches m
where m.user_a = least(tests.uid(21), tests.uid(26))
  and m.user_b = greatest(tests.uid(21), tests.uid(26))
  and m.mode = 'crew';
insert into public.conversation_members (conversation_id, user_id) values
  ('00000000-0000-4000-c000-000000000017', tests.uid(21)),
  ('00000000-0000-4000-c000-000000000017', tests.uid(26));

-- Pushes earlier messages back so the burst rule doesn't hide the next one.
create or replace function tests.age_messages()
returns void
language sql
as $$
  -- Messages can't be edited; skips that guard just for this fixture.
  alter table public.messages disable trigger messages_guard_update;
  update public.messages set created_at = now() - interval '1 minute'
  where conversation_id = '00000000-0000-4000-c000-000000000017';
  alter table public.messages enable trigger messages_guard_update;
  delete from net.http_request_queue where url = 'https://push.test/send-push';
$$;

select tests.age_messages();
insert into public.messages (conversation_id, sender_id, content)
values ('00000000-0000-4000-c000-000000000017', tests.uid(21), 'oi');
select is(
  (select r from tests.push_requests() r),
  jsonb_build_object(
    'kind', 'message',
    'recipients', jsonb_build_array(tests.uid(26)),
    'data', jsonb_build_object(
      'conversation_id', '00000000-0000-4000-c000-000000000017',
      'route', '/chats/00000000-0000-4000-c000-000000000017'
    )
  ),
  'a message notifies the other member, without its content'
);

insert into public.messages (conversation_id, sender_id, content)
values ('00000000-0000-4000-c000-000000000017', tests.uid(21), 'tudo bem?');
select is(
  (select count(*)::int from tests.push_requests()),
  1,
  'a burst from the same sender notifies once'
);

select tests.age_messages();
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(26), tests.uid(21));
insert into public.messages (conversation_id, sender_id, content)
values ('00000000-0000-4000-c000-000000000017', tests.uid(21), 'ei?');
select is(
  (select count(*)::int from tests.push_requests()),
  0,
  'blocked people are not notified'
);
delete from public.blocks where blocker_id = tests.uid(26);

select tests.age_messages();
update public.profiles set status = 'suspended' where id = tests.uid(26);
insert into public.messages (conversation_id, sender_id, content)
values ('00000000-0000-4000-c000-000000000017', tests.uid(21), 'alô');
select is(
  (select count(*)::int from tests.push_requests()),
  0,
  'suspended people are not notified'
);
update public.profiles set status = 'active' where id = tests.uid(26);

-- Crew owned by 26: a join request from 21, then accepted.
insert into public.event_attendance (event_id, user_id)
values (tests.event(1), tests.uid(21)), (tests.event(1), tests.uid(26))
on conflict do nothing;
insert into public.crews (id, event_id, owner_id, name)
values ('00000000-0000-4000-d000-000000000017', tests.event(1), tests.uid(26), 'Crew do teste');

delete from net.http_request_queue where url = 'https://push.test/send-push';
insert into public.crew_join_requests (id, crew_id, user_id, kind)
values (
  '00000000-0000-4000-e000-000000000017',
  '00000000-0000-4000-d000-000000000017',
  tests.uid(21),
  'request'
);
select is(
  (select r from tests.push_requests() r),
  jsonb_build_object(
    'kind', 'crew_request',
    'recipients', jsonb_build_array(tests.uid(26)),
    'data', jsonb_build_object(
      'crew_id', '00000000-0000-4000-d000-000000000017',
      'route', '/crews/00000000-0000-4000-d000-000000000017'
    )
  ),
  'a join request notifies the crew owner'
);

delete from net.http_request_queue where url = 'https://push.test/send-push';
update public.crew_join_requests set status = 'approved'
where id = '00000000-0000-4000-e000-000000000017';
select is(
  (select r ->> 'kind' || ':' || (r -> 'recipients' ->> 0) from tests.push_requests() r),
  'crew_request_accepted:' || tests.uid(21),
  'an accepted request notifies who asked'
);

select * from finish();
rollback;
