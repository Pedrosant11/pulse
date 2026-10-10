-- Deleting a message wipes its content on the server (Phase 6 feedback):
-- the flag alone would still let the other member read it through the API.

alter table public.messages drop constraint messages_content_check;

create or replace function private.guard_message_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.sender_id is distinct from old.sender_id
     or new.conversation_id is distinct from old.conversation_id
     or new.created_at is distinct from old.created_at then
    raise exception 'Messages can only be deleted' using errcode = '42501';
  end if;

  if new.deleted_at is not null or old.deleted_at is not null then
    -- Deleted for good: keep the first deletion time, drop the text.
    new.deleted_at := coalesce(old.deleted_at, now());
    new.content := '';
    return new;
  end if;

  if new.content is distinct from old.content then
    raise exception 'Messages can only be deleted' using errcode = '42501';
  end if;
  return new;
end;
$$;

-- Messages deleted before this migration (goes through the new trigger).
update public.messages set content = '' where deleted_at is not null;

alter table public.messages add constraint messages_content_check check (
  (deleted_at is not null and content = '')
  or (deleted_at is null and char_length(btrim(content)) between 1 and 2000)
);
