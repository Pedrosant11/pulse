begin;
\ir helpers.psql
select plan(10);

-- Crews ---------------------------------------------------------------

select tests.login(1); -- Ana goes to event 1
insert into public.crews (id, event_id, owner_id, name)
values ('66666666-6666-4666-8666-666666666666', tests.event(1), tests.uid(1), 'Crew da Ana');

select results_eq(
  $$ select user_id, role::text from public.crew_members
     where crew_id = '66666666-6666-4666-8666-666666666666' $$,
  $$ values (tests.uid(1), 'owner') $$,
  'creating a crew adds the owner'
);

select is(
  (select count(*)::int from public.conversations
   where crew_id = '66666666-6666-4666-8666-666666666666'),
  1,
  'creating a crew creates its group chat'
);

select throws_ok(
  $$ insert into public.crews (event_id, owner_id, name)
     values (tests.event(7), tests.uid(1), 'Crew no Rio') $$,
  '42501', null,
  'cannot create a crew for an event the user is not going to'
);

select tests.login(5); -- Elisa also goes to event 1
insert into public.crew_join_requests (crew_id, user_id)
values ('66666666-6666-4666-8666-666666666666', tests.uid(5));

select tests.login(1);
update public.crew_join_requests set status = 'approved'
where crew_id = '66666666-6666-4666-8666-666666666666' and user_id = tests.uid(5);

select is(
  (select count(*)::int from public.conversation_members cm
   join public.conversations c on c.id = cm.conversation_id
   where c.crew_id = '66666666-6666-4666-8666-666666666666'),
  2,
  'approved requests join the crew and its chat'
);

select throws_ok(
  $$ delete from public.crew_members
     where crew_id = '66666666-6666-4666-8666-666666666666' and user_id = tests.uid(1) $$,
  'P0001', null,
  'the owner must transfer ownership before leaving'
);

select tests.login(16); -- Rafael (Rio) does not go to event 1
select is(
  (select count(*)::int from public.crews
   where id = '66666666-6666-4666-8666-666666666666'),
  0,
  'crews are only visible to people going to the event'
);

-- Role requests and moderation -----------------------------------------

select tests.login(4); -- Diego asks to be a producer
insert into public.role_requests (user_id, requested_role, justification)
values (tests.uid(4), 'producer', 'Produzo festas há 5 anos em SP.');

-- RLS filters the row out, so the update silently affects nothing.
update public.role_requests set status = 'approved' where user_id = tests.uid(4);
select tests.logout();
select is(
  (select status::text from public.role_requests where user_id = tests.uid(4)),
  'pending',
  'users cannot approve their own role request'
);

select tests.login(1); -- admin approves
update public.role_requests set status = 'approved' where user_id = tests.uid(4);

select is(
  (select role::text from public.profiles where id = tests.uid(4)),
  'producer',
  'approving a role request grants the role'
);

insert into public.moderation_actions (target_user_id, action, reason)
values (tests.uid(20), 'suspension', 'Teste de suspensão');

select is(
  (select status::text from public.profiles where id = tests.uid(20)),
  'suspended',
  'suspension updates the account status'
);

select tests.login(1);
select is(
  (select count(*)::int from public.public_profiles where id = tests.uid(20)),
  0,
  'suspended users disappear from public_profiles'
);

select * from finish();
rollback;
