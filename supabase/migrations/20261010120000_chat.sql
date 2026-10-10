-- 1:1 chat (SPEC 9.1, Phase 6): conversation list, header, read receipts and
-- the private Realtime channel used for "digitando".

-- Conversations the user can access, newest activity first. For direct
-- chats it includes the other person (first name and main photo only).
create function public.list_conversations()
returns table (
  id uuid,
  type public.conversation_type,
  mode public.app_mode,
  match_id uuid,
  other_user_id uuid,
  other_first_name text,
  other_photo_path text,
  last_message text,
  last_message_sender_id uuid,
  last_message_at timestamptz,
  unread_count int,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select
    c.id,
    c.type,
    m.mode,
    c.match_id,
    other.id,
    other.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = other.id order by ph.position limit 1),
    last_msg.content,
    last_msg.sender_id,
    last_msg.created_at,
    (
      select count(*)::int from public.messages msg
      where msg.conversation_id = c.id
        and msg.sender_id <> me.id
        and msg.deleted_at is null
        and msg.created_at > coalesce(cm.last_read_at, '-infinity'::timestamptz)
    ),
    c.created_at
  from me
  join public.conversation_members cm on cm.user_id = me.id
  join public.conversations c on c.id = cm.conversation_id
  left join public.matches m on m.id = c.match_id
  left join public.profiles other
    on c.type = 'direct'
   and other.id = case when m.user_a = me.id then m.user_b else m.user_a end
  left join lateral (
    select msg.content, msg.sender_id, msg.created_at
    from public.messages msg
    where msg.conversation_id = c.id and msg.deleted_at is null
    order by msg.created_at desc
    limit 1
  ) last_msg on true
  where me.id is not null
    and private.can_access_conversation(c.id)
  order by coalesce(last_msg.created_at, c.created_at) desc;
$$;

-- Header of one conversation: the other person, when they last read it
-- (read receipts) and the upcoming events in common (icebreakers).
create function public.get_conversation(p_conversation_id uuid)
returns table (
  id uuid,
  type public.conversation_type,
  mode public.app_mode,
  match_id uuid,
  other_user_id uuid,
  other_first_name text,
  other_photo_path text,
  other_last_read_at timestamptz,
  common_events jsonb
)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select
    c.id,
    c.type,
    m.mode,
    c.match_id,
    other.id,
    other.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = other.id order by ph.position limit 1),
    (select ocm.last_read_at from public.conversation_members ocm
     where ocm.conversation_id = c.id and ocm.user_id = other.id),
    coalesce((
      select jsonb_agg(
        jsonb_build_object('id', e.id, 'name', e.name, 'starts_at', e.starts_at)
        order by e.starts_at
      )
      from public.events e
      where e.status = 'approved'
        and e.ends_at > now()
        and exists (select 1 from public.event_attendance a
                    where a.event_id = e.id and a.user_id = me.id)
        and exists (select 1 from public.event_attendance a
                    where a.event_id = e.id and a.user_id = other.id)
    ), '[]'::jsonb)
  from me
  join public.conversations c on c.id = p_conversation_id
  left join public.matches m on m.id = c.match_id
  left join public.profiles other
    on c.type = 'direct'
   and other.id = case when m.user_a = me.id then m.user_b else m.user_a end
  where me.id is not null
    and private.can_access_conversation(c.id);
$$;

-- Read receipt with the server clock (SPEC 9.1 "lido").
create function public.mark_conversation_read(p_conversation_id uuid)
returns void
language sql
security invoker
set search_path = ''
as $$
  update public.conversation_members
  set last_read_at = now()
  where conversation_id = p_conversation_id
    and user_id = (select auth.uid());
$$;

-- Private Realtime channel "conversation:<id>" (typing indicator): only
-- members of an accessible conversation can listen or send.
create function private.conversation_topic_id(p_topic text)
returns uuid
language plpgsql
immutable
set search_path = ''
as $$
begin
  if p_topic not like 'conversation:%' then
    return null;
  end if;
  return substr(p_topic, length('conversation:') + 1)::uuid;
exception when invalid_text_representation then
  return null;
end;
$$;

create policy "conversation channel: members receive"
  on realtime.messages for select to authenticated
  using (
    private.can_access_conversation(
      private.conversation_topic_id((select realtime.topic()))
    )
  );

create policy "conversation channel: members send"
  on realtime.messages for insert to authenticated
  with check (
    private.can_access_conversation(
      private.conversation_topic_id((select realtime.topic()))
    )
  );

revoke execute on function public.list_conversations() from public, anon;
grant execute on function public.list_conversations() to authenticated;
revoke execute on function public.get_conversation(uuid) from public, anon;
grant execute on function public.get_conversation(uuid) to authenticated;
revoke execute on function public.mark_conversation_read(uuid) from public, anon;
grant execute on function public.mark_conversation_read(uuid) to authenticated;
