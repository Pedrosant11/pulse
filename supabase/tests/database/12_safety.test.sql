begin;
\ir helpers.psql
select plan(26);

-- Setup: Ana (1, admin) owns a crew for event 1; Elisa (5) joins after a
-- Crew match; Natália (13) asks to join.
select tests.login(1);
insert into public.crews (id, event_id, owner_id, name, is_open)
values ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', tests.event(1), tests.uid(1), 'Crew da Ana', true);
select * from public.swipe(tests.uid(5), 'crew', 'like');
select tests.login(5);
select * from public.swipe(tests.uid(1), 'crew', 'like');
select tests.login(1);
insert into public.crew_join_requests (crew_id, user_id, kind)
values ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', tests.uid(5), 'invite');
select tests.login(5);
update public.crew_join_requests set status = 'approved'
where crew_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb' and user_id = tests.uid(5);
select tests.login(13);
insert into public.crew_join_requests (crew_id, user_id)
values ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', tests.uid(13));

select tests.logout();
create temp table ids as
select
  (select id from public.conversations
   where crew_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') as crew_chat,
  'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid as msg;
grant select on ids to authenticated;

select tests.login(5);
insert into public.messages (id, conversation_id, sender_id, content)
select msg, crew_chat, tests.uid(5), 'mensagem ofensiva' from ids;

-- Reports --------------------------------------------------------------

select tests.login(1);
insert into public.reports (target_type, target_id, reason)
select 'message', msg, 'harassment' from ids;

select results_eq(
  $$ select reported_user_id, snapshot ->> 'content', snapshot ->> 'first_name'
     from public.reports $$,
  $$ values (tests.uid(5), 'mensagem ofensiva'::text, 'Elisa'::text) $$,
  'a message report keeps the sender and a snapshot of the content'
);

insert into public.reports (target_type, target_id, reason)
select 'message', msg, 'spam' from ids;
select is(
  (select count(*)::int from public.reports),
  1,
  'reporting the same target again while pending is ignored'
);

select throws_ok(
  $$ insert into public.reports (target_type, target_id, reason)
     values ('user', tests.uid(1), 'spam') $$,
  '22023', null,
  'nobody reports themselves'
);

select tests.login(13);
select throws_ok(
  $$ insert into public.reports (target_type, target_id, reason)
     select 'message', msg, 'spam' from ids $$,
  'P0002', null,
  'messages can only be reported from inside the conversation'
);

select lives_ok(
  $$ insert into public.reports (target_type, target_id, reason, details)
     values ('user', tests.uid(5), 'fake_profile', 'fotos de outra pessoa') $$,
  'users can be reported'
);

select lives_ok(
  $$ insert into public.reports (target_type, target_id, reason)
     values ('event', tests.event(1), 'scam') $$,
  'approved events can be reported'
);

select is(
  (select count(*)::int from public.reports),
  2,
  'reporters only see their own reports'
);

-- Admin panel ------------------------------------------------------------

select tests.login(5);
select is(
  (select count(*)::int from public.admin_list_reports()),
  0,
  'non-admins get no reports'
);
select throws_ok(
  $$ select public.admin_resolve_report(
       (select id from public.reports limit 1), 'dismiss') $$,
  '42501', null,
  'non-admins cannot resolve reports'
);

select tests.login(1);
select is(
  (select count(*)::int from public.admin_list_reports()),
  3,
  'the admin sees every pending report'
);
select is(
  (select reports_against_user from public.admin_list_reports()
   where target_type = 'message'),
  2,
  'the admin sees how many reports the person has'
);

select throws_ok(
  $$ select public.admin_resolve_report(
       (select r.id from public.reports r where r.target_type = 'message'),
       'suspension', 'assédio', null) $$,
  '22023', null,
  'a suspension needs a duration'
);

select lives_ok(
  $$ select public.admin_resolve_report(
       (select r.id from public.reports r where r.target_type = 'message'),
       'suspension', 'Assédio no chat do grupo', 7, true) $$,
  'the admin suspends for 7 days and removes the message'
);

select results_eq(
  $$ select
       (select status::text from public.profiles where id = tests.uid(5)),
       (select content from public.messages m join ids on m.id = ids.msg),
       (select status::text from public.reports where target_type = 'message')
  $$,
  $$ values ('suspended'::text, ''::text, 'resolved'::text) $$,
  'account suspended, message wiped, report resolved'
);

select tests.login(5);
select results_eq(
  $$ select action::text, reason from public.get_my_moderation_notice() $$,
  $$ values ('suspension'::text, 'Assédio no chat do grupo'::text) $$,
  'the suspended user sees why'
);
select throws_ok(
  $$ insert into public.messages (conversation_id, sender_id, content)
     select crew_chat, tests.uid(5), 'oi' from ids $$,
  '42501', null,
  'suspended users cannot send messages'
);

-- Suspensions end by themselves.
select tests.logout();
update public.moderation_actions set expires_at = now() - interval '1 minute'
where target_user_id = tests.uid(5);
select is(private.expire_suspensions(), 1, 'expired suspensions are lifted');
select is(
  (select status::text from public.profiles where id = tests.uid(5)),
  'active',
  'the account is active again'
);

-- Warnings are shown once.
select tests.login(1);
select public.admin_resolve_report(
  (select r.id from public.reports r where r.target_type = 'user'),
  'warning', 'Use fotos suas no perfil');
select tests.login(5);
select results_eq(
  $$ select action::text from public.get_my_moderation_notice() $$,
  $$ values ('warning'::text) $$,
  'an active user sees an unseen warning'
);
select public.ack_moderation_notice((select id from public.get_my_moderation_notice()));
select is_empty(
  $$ select * from public.get_my_moderation_notice() $$,
  'acknowledged warnings are not shown again'
);

-- Blocking -------------------------------------------------------------

select tests.login(5);
insert into public.messages (conversation_id, sender_id, content)
select crew_chat, tests.uid(5), 'voltei' from ids;

select tests.login(1);
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(1), tests.uid(5));
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(1), tests.uid(13));

select is(
  (select count(*)::int from public.messages m join ids on m.conversation_id = ids.crew_chat
   where m.sender_id = tests.uid(5)),
  0,
  'blocked people''s messages disappear from group chats'
);
select is(
  (select count(*)::int from public.crew_join_requests
   where user_id = tests.uid(13) and status = 'pending'),
  0,
  'blocking drops pending crew requests between the two'
);
select results_eq(
  $$ select first_name from public.list_my_blocks() order by first_name $$,
  $$ values ('Elisa'::text), ('Natália'::text) $$,
  'the blocked list shows who was blocked'
);

-- Rate limit: at most 10 reports per hour.
select tests.login(20);
do $$
begin
  for i in 21..30 loop
    insert into public.reports (target_type, target_id, reason)
    values ('user', tests.uid(i), 'spam');
  end loop;
end;
$$;
select throws_ok(
  $$ insert into public.reports (target_type, target_id, reason)
     values ('user', tests.uid(19), 'spam') $$,
  'P0429', null,
  'reporting is rate limited'
);

-- Account deletion: crews pass to the oldest member, suggestions go away.
select tests.login(4);
insert into public.events (id, name, venue_name, city, state, starts_at, ends_at)
values ('dddddddd-dddd-4ddd-8ddd-dddddddddddd', 'Sugestão do Diego', 'Galpão',
        'São Paulo', 'SP', now() + interval '10 days', now() + interval '10 days 6 hours');

select tests.logout();
delete from auth.users where id in (tests.uid(1), tests.uid(4));
select results_eq(
  $$ select owner_id from public.crews where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb' $$,
  $$ values (tests.uid(5)) $$,
  'deleting the owner hands the crew to the oldest member'
);
select is(
  (select count(*)::int from public.events where id = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd'),
  0,
  'pending suggestions are deleted with the account'
);

select * from finish();
rollback;
