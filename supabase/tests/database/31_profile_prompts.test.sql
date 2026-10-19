begin;
\ir helpers.psql
select plan(8);

select tests.login(1);
select lives_ok(
  $$select public.set_profile_prompts('[
    {"prompt": "dream_set", "answer": "  Charlotte de Witte no nascer do sol  "},
    {"prompt": "on_the_floor", "answer": "a que não sai da frente da caixa"}
  ]'::jsonb)$$,
  'up to 3 answers are saved'
);
select is(
  (select string_agg(prompt || ':' || answer, ' | ' order by position)
   from public.profile_prompts where user_id = tests.uid(1)),
  'dream_set:Charlotte de Witte no nascer do sol | on_the_floor:a que não sai da frente da caixa',
  'in order, trimmed'
);
select throws_ok(
  $$select public.set_profile_prompts('[
    {"prompt": "dream_set", "answer": "a"}, {"prompt": "after_party", "answer": "b"},
    {"prompt": "best_party", "answer": "c"}, {"prompt": "green_flag", "answer": "d"}
  ]'::jsonb)$$,
  '22023', 'up to 3 prompts', 'never more than 3'
);
select throws_ok(
  $$select public.set_profile_prompts('[{"prompt": "dream_set", "answer": "a"},
    {"prompt": "dream_set", "answer": "b"}]'::jsonb)$$,
  '23505', null, 'the same question only once'
);
select throws_ok(
  $$select public.set_profile_prompts('[{"prompt": "anything", "answer": "a"}]'::jsonb)$$,
  '23514', null, 'only the listed questions'
);
select throws_ok(
  $$insert into public.profile_prompts (user_id, position, prompt, answer)
    values (auth.uid(), 2, 'green_flag', 'x')$$,
  '42501', null, 'no direct writes'
);
select tests.logout();

-- Others see them like they see the photos.
select tests.login(4);
select is(
  (select count(*)::int from public.profile_prompts where user_id = tests.uid(1)),
  2,
  'other people read the answers'
);
select tests.logout();

select tests.login(1);
select is(
  jsonb_array_length(public.export_my_data() -> 'profile_prompts'),
  2,
  'and they are in the data export'
);
select tests.logout();

select * from finish();
rollback;
