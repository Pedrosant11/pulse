-- Push notifications (SPEC 14, launch): device tokens and the database
-- triggers that ask the `send-push` Edge Function to deliver through FCM.
--
-- Firebase is only the carrier: tokens and data stay here, and the request
-- carries recipient ids and a kind. The function writes a generic text
-- (no names or message content on the lock screen).
--
-- Configuration lives in Vault (never in a migration):
--   push_function_url   e.g. https://<ref>.supabase.co/functions/v1/send-push
--   push_webhook_secret same value as the function's PUSH_WEBHOOK_SECRET
-- Without them, nothing is sent (local dev, tests, seed).

create extension if not exists pg_net with schema extensions;

-- ---------------------------------------------------------------------------
-- Device tokens
-- ---------------------------------------------------------------------------

create table public.push_tokens (
  token text primary key check (char_length(token) between 1 and 4096),
  user_id uuid not null references public.profiles (id) on delete cascade,
  platform text not null check (platform in ('android', 'ios')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index push_tokens_user_idx on public.push_tokens (user_id, updated_at desc);

-- Only the RPCs below and the Edge Function (service role) touch tokens.
alter table public.push_tokens enable row level security;
revoke all on public.push_tokens from anon, authenticated;

-- Saves this device's token for the signed-in user. A device that switches
-- accounts moves its token to the new owner.
create function public.register_push_token(p_token text, p_platform text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := (select auth.uid());
begin
  if v_user is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  insert into public.push_tokens (token, user_id, platform)
  values (p_token, v_user, p_platform)
  on conflict (token) do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        updated_at = now();

  -- Keeps the 10 most recent devices per person.
  delete from public.push_tokens t
  where t.user_id = v_user
    and t.token not in (
      select k.token from public.push_tokens k
      where k.user_id = v_user
      order by k.updated_at desc
      limit 10
    );
end;
$$;

-- Called before signing out, so the device stops getting this account's
-- notifications.
create function public.unregister_push_token(p_token text)
returns void
language sql
security definer
set search_path = ''
as $$
  delete from public.push_tokens
  where token = p_token
    and user_id = (select auth.uid());
$$;

-- "Sign out of all devices": none of them keeps getting notifications.
create function public.unregister_all_push_tokens()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from public.push_tokens where user_id = (select auth.uid());
$$;

revoke execute on function public.unregister_all_push_tokens() from public, anon;
grant execute on function public.unregister_all_push_tokens() to authenticated;
revoke execute on function public.register_push_token(text, text) from public, anon;
grant execute on function public.register_push_token(text, text) to authenticated;
revoke execute on function public.unregister_push_token(text) from public, anon;
grant execute on function public.unregister_push_token(text) to authenticated;

-- ---------------------------------------------------------------------------
-- Sending
-- ---------------------------------------------------------------------------

create function private.vault_secret(p_name text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select decrypted_secret from vault.decrypted_secrets where name = p_name limit 1;
$$;

-- Queues one HTTP call to `send-push` (pg_net sends it after the commit).
-- Skips people who are not active or have no device. Never raises: a push
-- problem must not undo a match or a message.
create function private.send_push(p_recipients uuid[], p_kind text, p_data jsonb)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_recipients uuid[];
  v_url text;
  v_secret text;
begin
  select array_agg(distinct p.id) into v_recipients
  from public.profiles p
  where p.id = any (p_recipients)
    and p.status = 'active'
    and exists (select 1 from public.push_tokens t where t.user_id = p.id);

  if v_recipients is null then
    return;
  end if;

  v_url := private.vault_secret('push_function_url');
  v_secret := private.vault_secret('push_webhook_secret');
  if v_url is null or v_secret is null then
    return;
  end if;

  perform net.http_post(
    url := v_url,
    body := jsonb_build_object(
      'kind', p_kind,
      'recipients', to_jsonb(v_recipients),
      'data', coalesce(p_data, '{}'::jsonb)
    ),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || v_secret
    ),
    timeout_milliseconds := 5000
  );
exception when others then
  raise warning 'send_push failed: %', sqlerrm;
end;
$$;

revoke execute on function private.send_push(uuid[], text, jsonb) from public;
revoke execute on function private.vault_secret(text) from public;

-- ---------------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------------

-- New match: the person who liked first (the one who just swiped already
-- sees the match screen).
create function private.push_on_match()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform private.send_push(
    array_remove(array[new.user_a, new.user_b], (select auth.uid())),
    'match',
    jsonb_build_object('mode', new.mode, 'route', '/chats')
  );
  return new;
end;
$$;

create trigger matches_push
  after insert on public.matches
  for each row execute function private.push_on_match();

-- New message: the other members, except anyone blocked either way. A burst
-- from the same sender notifies once (the phone keeps one notification per
-- conversation anyway).
create function private.push_on_message()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_type public.conversation_type;
  v_recipients uuid[];
begin
  if exists (
    select 1 from public.messages m
    where m.conversation_id = new.conversation_id
      and m.sender_id = new.sender_id
      and m.id <> new.id
      and m.created_at > new.created_at - interval '30 seconds'
  ) then
    return new;
  end if;

  select c.type into v_type
  from public.conversations c
  where c.id = new.conversation_id;

  select array_agg(cm.user_id) into v_recipients
  from public.conversation_members cm
  where cm.conversation_id = new.conversation_id
    and cm.user_id <> new.sender_id
    and not private.is_blocked(cm.user_id, new.sender_id);

  perform private.send_push(
    v_recipients,
    case v_type when 'crew' then 'crew_message' else 'message' end,
    jsonb_build_object(
      'conversation_id', new.conversation_id,
      'route', '/chats/' || new.conversation_id
    )
  );
  return new;
end;
$$;

create trigger messages_push
  after insert on public.messages
  for each row execute function private.push_on_message();

-- Crew invites and join requests, and their acceptance.
create function private.push_on_crew_request()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_crew_route text := '/crews/' || new.crew_id;
begin
  if tg_op = 'INSERT' then
    if new.kind = 'invite' then
      perform private.send_push(
        array[new.user_id], 'crew_invite', jsonb_build_object('route', '/chats')
      );
    else
      perform private.send_push(
        array(select c.owner_id from public.crews c where c.id = new.crew_id),
        'crew_request',
        jsonb_build_object('crew_id', new.crew_id, 'route', v_crew_route)
      );
    end if;
  elsif old.status = 'pending' and new.status = 'approved' then
    if new.kind = 'invite' then
      perform private.send_push(
        array[new.invited_by],
        'crew_invite_accepted',
        jsonb_build_object('crew_id', new.crew_id, 'route', v_crew_route)
      );
    else
      perform private.send_push(
        array[new.user_id],
        'crew_request_accepted',
        jsonb_build_object('crew_id', new.crew_id, 'route', v_crew_route)
      );
    end if;
  end if;
  return new;
end;
$$;

create trigger crew_join_requests_push
  after insert or update of status on public.crew_join_requests
  for each row execute function private.push_on_crew_request();
