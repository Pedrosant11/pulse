begin;
\ir helpers.psql
select plan(12);

-- Seed: Ana (1) admin with "Equipe Pulse · CEO", Carla (3) producer,
-- user 6 DJ, user 10 public figure, user 7 asked to be a DJ.

select tests.login(4);

select results_eq(
  $$ select badge, title from public.get_user_badges(tests.uid(1)) $$,
  $$ values ('team'::text, 'CEO'::text) $$,
  'granted badges are public, with the admin''s title'
);

select results_eq(
  $$ select badge from public.get_user_badges(tests.uid(3)) $$,
  $$ values ('producer'::text) $$,
  'producers get the badge from their role'
);

select throws_ok(
  $$ insert into public.profile_badges (user_id, badge) values (tests.uid(4), 'dj') $$,
  '42501', null,
  'nobody grants a badge to themselves'
);

select throws_ok(
  $$ insert into public.badge_requests (user_id, badge, justification)
     values (tests.uid(4), 'team', 'Quero entrar para a equipe') $$,
  '23514', null,
  'Equipe Pulse cannot be requested'
);

select lives_ok(
  $$ insert into public.badge_requests (user_id, badge, justification, links)
     values (tests.uid(4), 'public_figure', 'Tenho 200 mil seguidores no Instagram',
             '{"https://instagram.com/diego"}') $$,
  'users ask for a badge'
);

select throws_ok(
  $$ update public.badge_requests set status = 'approved'
     where user_id = tests.uid(4) $$,
  '42501', null,
  'users cannot approve their own request'
);

insert into public.badge_requests (user_id, badge, justification)
values (tests.uid(6), 'dj', 'Pedido em nome de outra pessoa');
select is(
  (select user_id from public.badge_requests
   where justification = 'Pedido em nome de outra pessoa'),
  tests.uid(4),
  'requests are always for oneself (the database sets who asked)'
);

-- Admin approves Diego's request.
select tests.login(1);
update public.badge_requests set status = 'approved'
where user_id = tests.uid(4) and badge = 'public_figure';

select results_eq(
  $$ select badge from public.get_user_badges(tests.uid(4)) $$,
  $$ values ('public_figure'::text) $$,
  'approving grants the badge'
);

select lives_ok(
  $$ update public.profile_badges set title = 'Influenciador'
     where user_id = tests.uid(4) and badge = 'public_figure' $$,
  'admins set the title'
);

select results_eq(
  $$ select first_name from public.admin_search_users('dieg') $$,
  $$ values ('Diego'::text) $$,
  'admins find people by name'
);

select tests.login(4);
select is_empty(
  $$ select * from public.admin_search_users('ana') $$,
  'only admins search people'
);

-- Blocked people's badges are hidden like their profile.
insert into public.blocks (blocker_id, blocked_id) values (tests.uid(4), tests.uid(1));
select is_empty(
  $$ select * from public.get_user_badges(tests.uid(1)) $$,
  'badges of blocked people are hidden'
);

select * from finish();
rollback;
