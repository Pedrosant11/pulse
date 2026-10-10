-- Storage buckets/policies, Realtime publication and final grants.

-- ---------------------------------------------------------------------------
-- Buckets (mirrored in config.toml for local development)
-- ---------------------------------------------------------------------------

-- Profile photos: private bucket, read through signed URLs by authenticated
-- users allowed to see the owner. Path: {user_id}/{uuid}.jpg
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('profile-photos', 'profile-photos', false, 5242880, array['image/jpeg'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- Event covers: public read. Path: {event_id}/{uuid}.jpg
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'event-covers', 'event-covers', true, 5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- First path segment as uuid, or null when it isn't one.
create function private.path_uuid(p_name text)
returns uuid
language plpgsql
immutable
set search_path = ''
as $$
begin
  return (storage.foldername(p_name))[1]::uuid;
exception when invalid_text_representation then
  return null;
end;
$$;

create function private.can_edit_event_id(p_event_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.events e
    where e.id = p_event_id and private.can_edit_event(e)
  );
$$;

create policy "profile-photos: owner uploads"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'profile-photos'
    and private.path_uuid(name) = (select auth.uid())
    and storage.extension(name) = 'jpg'
  );

create policy "profile-photos: owner replaces"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'profile-photos'
    and private.path_uuid(name) = (select auth.uid())
  )
  with check (
    bucket_id = 'profile-photos'
    and private.path_uuid(name) = (select auth.uid())
  );

create policy "profile-photos: owner deletes"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'profile-photos'
    and private.path_uuid(name) = (select auth.uid())
  );

create policy "profile-photos: visible users read"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'profile-photos'
    and private.is_visible_user(private.path_uuid(name))
  );

create policy "event-covers: editors upload"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'event-covers'
    and private.can_edit_event_id(private.path_uuid(name))
  );

create policy "event-covers: editors replace"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'event-covers'
    and private.can_edit_event_id(private.path_uuid(name))
  );

create policy "event-covers: editors delete"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'event-covers'
    and private.can_edit_event_id(private.path_uuid(name))
  );

-- ---------------------------------------------------------------------------
-- Realtime (postgres_changes respects RLS)
-- ---------------------------------------------------------------------------

alter publication supabase_realtime add table
  public.messages,
  public.conversation_members,
  public.matches;

-- ---------------------------------------------------------------------------
-- Final grants: nothing for anon (the app always requires a session).
-- ---------------------------------------------------------------------------

revoke all on all tables in schema public from anon;
revoke all on all sequences in schema public from anon;
revoke execute on all functions in schema public from anon;
