-- Photos and voice messages in chats (1:1 and crews share `messages`).
--   * kind: text | image | audio. Images may carry a caption; audio has a
--     duration (up to 2 minutes).
--   * Files live in the private `chat-media` bucket at
--     {sender}/{conversation}/{random}.jpg|m4a: only members of that
--     conversation read them; the sender deletes them (the app removes the
--     file when the message is deleted; account deletion removes the
--     sender's folder).

alter table public.messages
  add column kind text not null default 'text'
    check (kind in ('text', 'image', 'audio')),
  add column media_path text,
  add column media_duration_ms int;

alter table public.messages drop constraint messages_content_check;
alter table public.messages add constraint messages_content_check check (
  (deleted_at is not null and content = '' and media_path is null)
  or (deleted_at is null and (
    (kind = 'text' and media_path is null
      and char_length(btrim(content)) between 1 and 2000)
    or (kind = 'image' and media_path is not null
      and char_length(content) <= 2000)
    or (kind = 'audio' and media_path is not null and content = ''
      and media_duration_ms between 300 and 120000)
  ))
);

-- The file must be the sender's, in this conversation, of the right type.
create function private.guard_message_media()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.kind = 'text' then
    new.media_path := null;
    new.media_duration_ms := null;
    return new;
  end if;
  if new.kind = 'image' then
    new.media_duration_ms := null;
  end if;
  if new.media_path is null
     or new.media_path !~ ('^' || new.sender_id || '/' || new.conversation_id
                           || '/[a-f0-9]{32}\.'
                           || case new.kind when 'image' then 'jpg' else 'm4a' end || '$') then
    raise exception 'invalid media' using errcode = '22023';
  end if;
  return new;
end;
$$;

create trigger messages_guard_media
  before insert on public.messages
  for each row execute function private.guard_message_media();

-- Deleting a message also drops the media reference.
create or replace function private.guard_message_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.sender_id is distinct from old.sender_id
     or new.conversation_id is distinct from old.conversation_id
     or new.created_at is distinct from old.created_at
     or new.kind is distinct from old.kind then
    raise exception 'Messages can only be deleted' using errcode = '42501';
  end if;

  if new.deleted_at is not null or old.deleted_at is not null then
    -- Deleted for good: keep the first deletion time, drop the content.
    new.deleted_at := coalesce(old.deleted_at, now());
    new.content := '';
    new.media_path := null;
    new.media_duration_ms := null;
    return new;
  end if;

  if new.content is distinct from old.content
     or new.media_path is distinct from old.media_path
     or new.media_duration_ms is distinct from old.media_duration_ms then
    raise exception 'Messages can only be deleted' using errcode = '42501';
  end if;
  return new;
end;
$$;

-- Storage --------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'chat-media', 'chat-media', false, 5242880,
  array['image/jpeg', 'audio/mp4', 'audio/m4a', 'audio/x-m4a', 'audio/aac']
)
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- Second path segment as uuid (the conversation), or null.
create function private.path_uuid_2(p_name text)
returns uuid
language plpgsql
immutable
set search_path = ''
as $$
begin
  return (storage.foldername(p_name))[2]::uuid;
exception when invalid_text_representation then
  return null;
end;
$$;

create policy "chat-media: members upload their own"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'chat-media'
    and private.path_uuid(name) = (select auth.uid())
    and private.can_access_conversation(private.path_uuid_2(name))
    and storage.extension(name) in ('jpg', 'm4a')
  );

create policy "chat-media: members and admins read"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'chat-media'
    and (
      private.can_access_conversation(private.path_uuid_2(name))
      or private.is_admin()
    )
  );

create policy "chat-media: sender deletes"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'chat-media'
    and private.path_uuid(name) = (select auth.uid())
  );

-- Inbox: the last message's kind, so the app can say "Foto" / "Áudio".
drop function public.list_conversations();
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
  last_message_kind text,
  unread_count int,
  created_at timestamptz,
  crew_id uuid,
  crew_name text,
  event_name text,
  member_count int
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
    last_msg.kind,
    (
      select count(*)::int from public.messages msg
      where msg.conversation_id = c.id
        and msg.sender_id <> me.id
        and msg.deleted_at is null
        and msg.created_at > coalesce(cm.last_read_at, '-infinity'::timestamptz)
        and not private.is_blocked(me.id, msg.sender_id)
    ),
    c.created_at,
    cr.id,
    cr.name,
    ev.name,
    (select count(*)::int from public.crew_members cmm where cmm.crew_id = cr.id)
  from me
  join public.conversation_members cm on cm.user_id = me.id
  join public.conversations c on c.id = cm.conversation_id
  left join public.matches m on m.id = c.match_id
  left join public.profiles other
    on c.type = 'direct'
   and other.id = case when m.user_a = me.id then m.user_b else m.user_a end
  left join public.crews cr on cr.id = c.crew_id
  left join public.events ev on ev.id = cr.event_id
  left join lateral (
    select msg.content, msg.sender_id, msg.created_at, msg.kind
    from public.messages msg
    where msg.conversation_id = c.id
      and msg.deleted_at is null
      and not private.is_blocked(me.id, msg.sender_id)
    order by msg.created_at desc
    limit 1
  ) last_msg on true
  where me.id is not null
    and private.can_access_conversation(c.id)
  order by coalesce(last_msg.created_at, c.created_at) desc;
$$;

revoke execute on function public.list_conversations() from public, anon;
grant execute on function public.list_conversations() to authenticated;

-- Reports on a photo or voice message keep what it was.
create or replace function private.before_report_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.reporter_id := coalesce((select auth.uid()), new.reporter_id);
  new.status := 'pending';
  new.resolved_by := null;
  new.resolved_at := null;
  new.resolution_note := null;
  new.created_at := now();

  if new.reporter_id is null then
    raise exception 'Not signed in' using errcode = '42501';
  end if;

  if exists (
    select 1 from public.reports
    where reporter_id = new.reporter_id
      and target_type = new.target_type
      and target_id = new.target_id
      and status = 'pending'
  ) then
    return null;
  end if;

  if (
    select count(*) from public.reports
    where reporter_id = new.reporter_id
      and created_at > now() - interval '1 hour'
  ) >= 10 then
    perform private.raise_rate_limited('reports');
  end if;

  case new.target_type
    when 'user' then
      select p.id, jsonb_build_object('first_name', p.first_name)
      into new.reported_user_id, new.snapshot
      from public.profiles p
      where p.id = new.target_id;
    when 'message' then
      select
        msg.sender_id,
        jsonb_build_object(
          'first_name', p.first_name,
          'content', msg.content,
          'kind', msg.kind,
          'media_path', msg.media_path,
          'sent_at', msg.created_at,
          'conversation_type', c.type
        )
      into new.reported_user_id, new.snapshot
      from public.messages msg
      join public.conversations c on c.id = msg.conversation_id
      join public.profiles p on p.id = msg.sender_id
      where msg.id = new.target_id
        and msg.deleted_at is null
        and exists (
          select 1 from public.conversation_members cm
          where cm.conversation_id = msg.conversation_id
            and cm.user_id = new.reporter_id
        );
    when 'event' then
      select
        e.created_by,
        jsonb_build_object(
          'name', e.name,
          'starts_at', e.starts_at,
          'city', e.city,
          'state', e.state,
          'venue_name', e.venue_name
        )
      into new.reported_user_id, new.snapshot
      from public.events e
      where e.id = new.target_id and e.status = 'approved';
  end case;

  if not found then
    raise exception 'Report target not found' using errcode = 'P0002';
  end if;
  if new.reported_user_id = new.reporter_id then
    raise exception 'Cannot report yourself' using errcode = '22023';
  end if;
  return new;
end;
$$;
