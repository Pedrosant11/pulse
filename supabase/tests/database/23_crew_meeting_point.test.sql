begin;
\ir helpers.psql
select plan(3);

insert into public.crews (id, event_id, owner_id, name)
values ('00000000-0000-4000-d000-000000000023', tests.event(1), tests.uid(5), 'Crew do ponto');

select tests.login(5);
select lives_ok(
  $$ select public.set_crew_meeting_point('00000000-0000-4000-d000-000000000023', 'Bar do fundo, 1h') $$,
  'members set the meeting point'
);
select is(
  (select meeting_point from public.get_crew('00000000-0000-4000-d000-000000000023')),
  'Bar do fundo, 1h',
  'members see the meeting point'
);
select tests.login(4);
select throws_ok(
  $$ select public.set_crew_meeting_point('00000000-0000-4000-d000-000000000023', 'x') $$,
  '42501', null,
  'others cannot change it'
);

select * from finish();
rollback;
