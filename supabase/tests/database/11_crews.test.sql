begin;
\ir helpers.psql
select plan(16);

-- Ana (1), Elisa (5) and Natália (13) all go to event 1.
select tests.login(1);
insert into public.crews (id, event_id, owner_id, name, is_open)
values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', tests.event(1), tests.uid(1), 'Crew da Ana', true);

select results_eq(
  $$ select name, member_count, my_status from public.list_event_crews(tests.event(1)) $$,
  $$ values ('Crew da Ana'::text, 1, 'owner'::text) $$,
  'event crews show the user''s own crew'
);

select is(
  (select count(*)::int from public.get_crew_invite_candidates('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')),
  0,
  'without a Crew match there is nobody to invite'
);

-- Crew match Ana ↔ Elisa.
select * from public.swipe(tests.uid(5), 'crew', 'like');
select tests.login(5);
select * from public.swipe(tests.uid(1), 'crew', 'like');
select tests.login(1);

select results_eq(
  $$ select first_name from public.get_crew_invite_candidates('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') $$,
  $$ values ('Elisa'::text) $$,
  'Crew matches going to the event can be invited'
);

select lives_ok(
  $$ insert into public.crew_join_requests (crew_id, user_id, kind)
     values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', tests.uid(5), 'invite') $$,
  'the owner invites a Crew match'
);

select throws_ok(
  $$ insert into public.crew_join_requests (crew_id, user_id, kind)
     values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', tests.uid(13), 'invite') $$,
  '42501', null,
  'cannot invite someone without a Crew match'
);

select tests.login(5);
select results_eq(
  $$ select crew_name, invited_by_name, member_count from public.list_my_crew_invites() $$,
  $$ values ('Crew da Ana'::text, 'Ana'::text, 1) $$,
  'the invitee sees the invite'
);

select throws_ok(
  $$ update public.crew_join_requests set status = 'cancelled'
     where user_id = tests.uid(5) and kind = 'invite' $$,
  '42501', null,
  'the invitee answers, the owner cancels'
);

update public.crew_join_requests set status = 'approved'
where user_id = tests.uid(5) and kind = 'invite';

select results_eq(
  $$ select first_name, role::text from public.get_crew_members('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') $$,
  $$ values ('Ana'::text, 'owner'::text), ('Elisa'::text, 'member'::text) $$,
  'accepting the invite joins the crew'
);

select results_eq(
  $$ select crew_name, member_count, event_name from public.list_conversations()
     where type = 'crew' $$,
  $$ values ('Crew da Ana'::text, 2, 'Ritual'::text) $$,
  'the group chat shows up in the inbox'
);

select is(
  (select count(*)::int from public.get_conversation_members(
     (select conversation_id from public.get_crew('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')))),
  2,
  'group chat members (names for the bubbles)'
);

-- Natália: attendee, not a member.
select tests.login(13);
select is(
  (select conversation_id from public.get_crew('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')),
  null,
  'non-members don''t get the group chat'
);

select is(
  (select crew_size from public.get_discover_feed('crew') where first_name = 'Ana'),
  2,
  'Crew cards show the size of the person''s crew'
);

select is(
  (select crew_size from public.get_discover_feed('crew') where first_name = 'Hugo'),
  null,
  'people going solo have no crew size'
);

insert into public.crew_join_requests (crew_id, user_id)
values ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', tests.uid(13));

select tests.login(1);
select results_eq(
  $$ select first_name, kind::text from public.get_crew_pending('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') $$,
  $$ values ('Natália'::text, 'request'::text) $$,
  'the owner sees pending join requests'
);

-- Elisa leaves: membership and chat access go away.
select tests.login(5);
delete from public.crew_members
where crew_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa' and user_id = tests.uid(5);
select is(
  (select count(*)::int from public.list_conversations() where type = 'crew'),
  0,
  'leaving the crew removes its chat from the inbox'
);

select tests.login(1);
select is(
  (select member_count from public.get_crew('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa')),
  1,
  'member count follows'
);

select * from finish();
rollback;
