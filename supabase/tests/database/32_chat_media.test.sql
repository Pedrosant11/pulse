begin;
\ir helpers.psql
select plan(10);

-- A match between 1 and 2 (its chat), and someone outside it.
delete from public.matches
where user_a = least(tests.uid(1), tests.uid(2)) and user_b = greatest(tests.uid(1), tests.uid(2));
insert into public.matches (user_a, user_b, mode)
values (least(tests.uid(1), tests.uid(2)), greatest(tests.uid(1), tests.uid(2)), 'date');
-- (The swipe trigger normally opens the chat.)
insert into public.conversations (type, match_id)
select 'direct', m.id from public.matches m
where m.user_a = least(tests.uid(1), tests.uid(2))
  and m.user_b = greatest(tests.uid(1), tests.uid(2));
create temp table t as
select c.id as conv, tests.uid(1) as a, tests.uid(2) as b
from public.conversations c
join public.matches m on m.id = c.match_id
where m.user_a = least(tests.uid(1), tests.uid(2))
  and m.user_b = greatest(tests.uid(1), tests.uid(2));
insert into public.conversation_members (conversation_id, user_id)
select conv, a from t union all select conv, b from t;
alter table t add column outsider uuid;
update t set outsider = (
  select p.id from public.profiles p
  where p.id not in (select a from t union select b from t)
    and not exists (select 1 from public.conversation_members cm
                    where cm.conversation_id = (select conv from t) and cm.user_id = p.id)
  limit 1
);
grant select on t to authenticated;

create function pg_temp.as_user(p_user uuid) returns void language sql as $$
  select set_config('request.jwt.claims', json_build_object('sub', p_user, 'role', 'authenticated')::text, true);
$$;

select pg_temp.as_user((select a from t));
set local role authenticated;

select lives_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content, media_path)
           values (%L, %L, 'image', 'olha isso', %L)$$,
         (select conv from t), (select a from t),
         (select a from t) || '/' || (select conv from t) || '/' || repeat('a', 32) || '.jpg'),
  'a photo with a caption'
);
select lives_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content, media_path, media_duration_ms)
           values (%L, %L, 'audio', '', %L, 4200)$$,
         (select conv from t), (select a from t),
         (select a from t) || '/' || (select conv from t) || '/' || repeat('b', 32) || '.m4a'),
  'a voice message'
);
select throws_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content, media_path)
           values (%L, %L, 'image', '', %L)$$,
         (select conv from t), (select a from t),
         (select b from t) || '/' || (select conv from t) || '/' || repeat('c', 32) || '.jpg'),
  '22023', 'invalid media', 'only your own files'
);
select throws_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content, media_path, media_duration_ms)
           values (%L, %L, 'audio', '', %L, 999999)$$,
         (select conv from t), (select a from t),
         (select a from t) || '/' || (select conv from t) || '/' || repeat('d', 32) || '.m4a'),
  '23514', null, 'audio up to 2 minutes'
);
select throws_ok(
  format($$insert into public.messages (conversation_id, sender_id, kind, content)
           values (%L, %L, 'image', '')$$, (select conv from t), (select a from t)),
  '22023', 'invalid media', 'a photo needs the file'
);

-- Deleting wipes the reference.
update public.messages set deleted_at = now()
where conversation_id = (select conv from t) and kind = 'image';
select is(
  (select media_path from public.messages
   where conversation_id = (select conv from t) and kind = 'image'),
  null,
  'deleting a photo drops the file reference'
);

-- Storage: members upload into their own folder of this conversation.
select lives_ok(
  format($$insert into storage.objects (bucket_id, name, owner)
           values ('chat-media', %L, auth.uid())$$,
         (select a from t) || '/' || (select conv from t) || '/' || repeat('e', 32) || '.jpg'),
  'members upload chat photos'
);
select throws_ok(
  format($$insert into storage.objects (bucket_id, name, owner)
           values ('chat-media', %L, auth.uid())$$,
         (select b from t) || '/' || (select conv from t) || '/' || repeat('f', 32) || '.jpg'),
  '42501', null, 'not into someone else''s folder'
);
reset role;

-- The other member reads it; an outsider doesn't.
select pg_temp.as_user((select b from t));
set local role authenticated;
select is(
  (select count(*)::int from storage.objects where bucket_id = 'chat-media'
     and name like '%' || (select conv from t) || '%'),
  1,
  'the other member sees the file'
);
reset role;

select pg_temp.as_user((select outsider from t));
set local role authenticated;
select is(
  (select count(*)::int from storage.objects where bucket_id = 'chat-media'),
  0,
  'people outside the chat see nothing'
);
reset role;

select * from finish();
rollback;
