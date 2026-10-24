-- Event chat ("Chat da festa"): one open text chat per approved party.
--   * Who marked "Eu vou" reads and writes; the party's team (who can edit
--     it) and the moderation team too, with a "Produção" tag.
--   * Open from the approval until 12 h after the end; then read only for
--     3 days, and the messages are deleted (cron).
--   * Text only, up to 500 characters; at most 1 message every 2 s and 20
--     in 5 minutes per person.
--   * The team deletes messages and mutes people in its party's chat;
--     anyone deletes their own. Blocked people don't see each other.
--     Reports reuse the "message" report (snapshot kept in the report).
--   * Deleting is for real (no soft delete): the raw rows reach the app via
--     Realtime, so a removed message must not linger there.

insert into private.app_settings (key, value) values
  ('event_chat_hours_after', '12'),
  ('event_chat_keep_days', '3');

create table public.event_messages (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events (id) on delete cascade,
  sender_id uuid not null references public.profiles (id) on delete cascade,
  content text not null check (char_length(btrim(content)) between 1 and 500),
  created_at timestamptz not null default now()
);
create index event_messages_event_idx on public.event_messages (event_id, created_at desc);
create index event_messages_sender_idx on public.event_messages (sender_id, created_at desc);

create table public.event_chat_mutes (
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  muted_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);

alter table public.event_messages enable row level security;
alter table public.event_chat_mutes enable row level security;

-- 'open', 'read_only' or 'closed'.
create function private.event_chat_state(p_event uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((
    select case
      when e.status <> 'approved' then 'closed'
      when now() <= e.ends_at + make_interval(hours => private.setting_int('event_chat_hours_after'))
        then 'open'
      when now() <= e.ends_at + make_interval(hours => private.setting_int('event_chat_hours_after'))
                             + make_interval(days => private.setting_int('event_chat_keep_days'))
        then 'read_only'
      else 'closed'
    end
    from public.events e where e.id = p_event
  ), 'closed');
$$;

-- The party's team or the moderation team.
create function private.runs_event_chat(p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.can_edit_event_id(p_event) or private.is_moderator();
$$;

-- In the chat: "Eu vou" or the team.
create function private.in_event_chat(p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.event_attendance ea
    where ea.event_id = p_event and ea.user_id = (select auth.uid())
  ) or private.runs_event_chat(p_event);
$$;

create policy "event_messages: who is in the chat" on public.event_messages
  for select to authenticated
  using (
    private.in_event_chat(event_id)
    and private.event_chat_state(event_id) <> 'closed'
    and not private.is_blocked((select auth.uid()), sender_id)
  );

-- What the event page needs to show the chat entry.
create function public.event_chat_info(p_event uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'state', private.event_chat_state(p_event),
    'in_chat', private.in_event_chat(p_event),
    'can_moderate', private.runs_event_chat(p_event),
    'muted', exists (
      select 1 from public.event_chat_mutes m
      where m.event_id = p_event and m.user_id = (select auth.uid())
    ),
    'people', (select count(*) from public.event_attendance ea where ea.event_id = p_event),
    'messages', (select count(*) from public.event_messages m where m.event_id = p_event),
    'last_at', (select max(m.created_at) from public.event_messages m where m.event_id = p_event)
  );
$$;

revoke execute on function public.event_chat_info(uuid) from public, anon;
grant execute on function public.event_chat_info(uuid) to authenticated;

-- A page of messages, newest first (before p_before).
create function public.event_chat_messages(
  p_event uuid,
  p_before timestamptz default null,
  p_limit int default 50
)
returns table (
  id uuid,
  sender_id uuid,
  first_name text,
  photo_path text,
  is_verified boolean,
  is_team boolean,
  content text,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    m.id,
    m.sender_id,
    p.first_name,
    (select ph.storage_path from public.profile_photos ph
      where ph.user_id = p.id order by ph.position limit 1),
    p.is_verified,
    (p.id = e.created_by or p.role in ('curator', 'admin')),
    m.content,
    m.created_at
  from public.event_messages m
  join public.events e on e.id = m.event_id
  join public.profiles p on p.id = m.sender_id
  where m.event_id = p_event
    and private.in_event_chat(p_event)
    and private.event_chat_state(p_event) <> 'closed'
    and (p_before is null or m.created_at < p_before)
    and (p.status = 'active' or p.id = (select auth.uid()))
    and not private.is_blocked((select auth.uid()), p.id)
  order by m.created_at desc
  limit least(greatest(coalesce(p_limit, 50), 1), 100);
$$;

revoke execute on function public.event_chat_messages(uuid, timestamptz, int) from public, anon;
grant execute on function public.event_chat_messages(uuid, timestamptz, int) to authenticated;

create function public.send_event_message(p_event uuid, p_content text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_id uuid;
begin
  if v_uid is null or not private.can_socialize() then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  if not private.in_event_chat(p_event) then
    raise exception 'Only who is going' using errcode = 'P0001', hint = 'event_chat_not_going';
  end if;
  if private.event_chat_state(p_event) <> 'open' then
    raise exception 'Chat closed' using errcode = 'P0001', hint = 'event_chat_closed';
  end if;
  if exists (
    select 1 from public.event_chat_mutes m where m.event_id = p_event and m.user_id = v_uid
  ) then
    raise exception 'Muted' using errcode = 'P0001', hint = 'event_chat_muted';
  end if;
  if char_length(btrim(coalesce(p_content, ''))) not between 1 and 500 then
    raise exception 'Message must have 1 to 500 characters' using errcode = '22023';
  end if;
  if exists (
    select 1 from public.event_messages m
    where m.sender_id = v_uid and m.created_at > now() - interval '2 seconds'
  ) or (
    select count(*) from public.event_messages m
    where m.sender_id = v_uid and m.created_at > now() - interval '5 minutes'
  ) >= 20 then
    perform private.raise_rate_limited('event_chat');
  end if;

  insert into public.event_messages (event_id, sender_id, content)
  values (p_event, v_uid, btrim(p_content))
  returning id into v_id;
  return v_id;
end;
$$;

revoke execute on function public.send_event_message(uuid, text) from public, anon;
grant execute on function public.send_event_message(uuid, text) to authenticated;

-- Your own message, or any message for the party's team.
create function public.delete_event_message(p_message uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_msg public.event_messages;
begin
  select * into v_msg from public.event_messages m where m.id = p_message;
  if not found then
    return;
  end if;
  if v_msg.sender_id <> (select auth.uid()) and not private.runs_event_chat(v_msg.event_id) then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  delete from public.event_messages m where m.id = p_message;
end;
$$;

revoke execute on function public.delete_event_message(uuid) from public, anon;
grant execute on function public.delete_event_message(uuid) to authenticated;

-- The party's team mutes (or unmutes) someone in its chat.
create function public.set_event_chat_mute(p_event uuid, p_user uuid, p_muted boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.runs_event_chat(p_event) then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  if p_user = (select auth.uid()) then
    raise exception 'Not yourself' using errcode = '22023';
  end if;
  if p_muted then
    insert into public.event_chat_mutes (event_id, user_id, muted_by)
    values (p_event, p_user, (select auth.uid()))
    on conflict do nothing;
  else
    delete from public.event_chat_mutes m where m.event_id = p_event and m.user_id = p_user;
  end if;
end;
$$;

revoke execute on function public.set_event_chat_mute(uuid, uuid, boolean) from public, anon;
grant execute on function public.set_event_chat_mute(uuid, uuid, boolean) to authenticated;

-- Closed chats are deleted.
create function private.purge_event_chats()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  with gone as (
    delete from public.event_messages m
    using public.events e
    where e.id = m.event_id and private.event_chat_state(e.id) = 'closed'
    returning 1
  )
  select count(*) into v_count from gone;
  delete from public.event_chat_mutes mu
  where private.event_chat_state(mu.event_id) = 'closed';
  return v_count;
end;
$$;

select cron.schedule(
  'event-chat-purge',
  '15 5 * * *',
  $$select private.purge_event_chats()$$
);

alter publication supabase_realtime add table public.event_messages;

-- Reports: a "message" report can also be about an event chat message.
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
      if not found then
        select
          em.sender_id,
          jsonb_build_object(
            'first_name', p.first_name,
            'content', em.content,
            'kind', 'text',
            'sent_at', em.created_at,
            'conversation_type', 'event',
            'event_id', em.event_id
          )
        into new.reported_user_id, new.snapshot
        from public.event_messages em
        join public.profiles p on p.id = em.sender_id
        where em.id = new.target_id
          and private.in_event_chat(em.event_id);
      end if;
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

create or replace function public.admin_resolve_report(
  p_report_id uuid,
  p_outcome text,
  p_note text default null,
  p_suspension_days int default null,
  p_remove_content boolean default false
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_report public.reports;
  v_action public.moderation_action_type;
  v_note text := nullif(btrim(p_note), '');
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;

  select * into v_report from public.reports where id = p_report_id for update;
  if not found then
    raise exception 'Report not found' using errcode = 'P0002';
  end if;
  if v_report.status <> 'pending' then
    raise exception 'Report already handled' using errcode = 'P0001';
  end if;

  if p_outcome not in ('dismiss', 'resolve', 'warning', 'suspension', 'ban') then
    raise exception 'Unknown outcome %', p_outcome using errcode = '22023';
  end if;

  if p_outcome in ('warning', 'suspension', 'ban') then
    if v_report.reported_user_id is null then
      raise exception 'The reported account no longer exists' using errcode = 'P0002';
    end if;
    if v_note is null or char_length(v_note) < 3 then
      raise exception 'A reason is required' using errcode = '22023';
    end if;
    if p_outcome = 'suspension'
       and (p_suspension_days is null or p_suspension_days not between 1 and 365) then
      raise exception 'Suspension needs 1 to 365 days' using errcode = '22023';
    end if;
    v_action := p_outcome::public.moderation_action_type;
    insert into public.moderation_actions
      (target_user_id, action, reason, report_id, expires_at)
    values (
      v_report.reported_user_id,
      v_action,
      v_note,
      v_report.id,
      case when p_outcome = 'suspension'
        then now() + make_interval(days => p_suspension_days) end
    );
  end if;

  if p_remove_content then
    if v_report.target_type = 'message' then
      update public.messages set deleted_at = now()
      where id = v_report.target_id and deleted_at is null;
      delete from public.event_messages where id = v_report.target_id;
    elsif v_report.target_type = 'event' then
      update public.events
      set status = 'rejected',
          rejection_reason = coalesce(v_note, 'Removido pela moderação')
      where id = v_report.target_id;
    end if;
  end if;

  update public.reports
  set status = case when p_outcome = 'dismiss'
        then 'dismissed'::public.report_status
        else 'resolved'::public.report_status end,
      resolution_note = v_note
  where status = 'pending'
    and (
      id = v_report.id
      or (target_type = v_report.target_type and target_id = v_report.target_id)
      or (p_outcome = 'ban' and reported_user_id = v_report.reported_user_id)
    );
end;
$$;

-- LGPD export: event chat messages too.
create or replace function public.export_my_data()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  return private.export_my_data_base() || jsonb_build_object(
    'plan', (
      select jsonb_build_object(
        'tier', s.tier, 'source', s.source, 'expires_at', s.expires_at,
        'will_renew', s.will_renew
      )
      from public.subscriptions s where s.user_id = v_uid
    ),
    'wallet', (
      select jsonb_build_object('superlikes', w.superlikes, 'boosts', w.boosts)
      from public.wallets w where w.user_id = v_uid
    ),
    'boosts', coalesce((
      select jsonb_agg(
        jsonb_build_object('starts_at', b.starts_at, 'ends_at', b.ends_at)
        order by b.starts_at
      )
      from public.boosts b where b.user_id = v_uid
    ), '[]'::jsonb),
    'travel_mode', (
      select jsonb_build_object('city', t.city, 'state', t.state)
      from public.travel_locations t where t.user_id = v_uid
    ),
    'ticket_clicks', coalesce((
      select jsonb_agg(
        jsonb_build_object('event', e.name, 'at', c.created_at)
        order by c.created_at
      )
      from public.ticket_clicks c
      join public.events e on e.id = c.event_id
      where c.user_id = v_uid
    ), '[]'::jsonb),
    'verification', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'status', v.status, 'pose', v.pose, 'consent_at', v.consent_at,
          'created_at', v.created_at, 'reviewed_at', v.reviewed_at,
          'rejection_reason', v.rejection_reason
        ) order by v.created_at
      )
      from public.verification_requests v where v.user_id = v_uid
    ), '[]'::jsonb),
    'referral', jsonb_build_object(
      'code', (select c.code from private.referral_codes c where c.user_id = v_uid),
      'used_code_at', (select r.created_at from private.referrals r where r.referred_id = v_uid),
      'friends_invited', (select count(*) from private.referrals r where r.referrer_id = v_uid)
    ),
    'profile_prompts', coalesce((
      select jsonb_agg(
        jsonb_build_object('prompt', pp.prompt, 'answer', pp.answer)
        order by pp.position
      )
      from public.profile_prompts pp where pp.user_id = v_uid
    ), '[]'::jsonb),
    'followed_venues', coalesce((
      select jsonb_agg(jsonb_build_object('venue', v.name, 'since', f.created_at)
        order by f.created_at)
      from public.venue_follows f join public.venues v on v.id = f.venue_id
      where f.user_id = v_uid
    ), '[]'::jsonb),
    'venue_reviews', coalesce((
      select jsonb_agg(jsonb_build_object(
          'venue', v.name, 'rating', r.rating, 'comment', r.comment,
          'at', r.updated_at
        ) order by r.updated_at)
      from public.venue_reviews r join public.venues v on v.id = r.venue_id
      where r.user_id = v_uid
    ), '[]'::jsonb),
    'poll_votes', coalesce((
      select jsonb_agg(jsonb_build_object(
          'question', p.question, 'option', p.options[v.option + 1],
          'at', v.voted_at
        ) order by v.voted_at)
      from public.poll_votes v join public.polls p on p.id = v.poll_id
      where v.user_id = v_uid
    ), '[]'::jsonb),
    'saved_events', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', s.created_at)
        order by s.created_at)
      from public.event_saves s join public.events e on e.id = s.event_id
      where s.user_id = v_uid
    ), '[]'::jsonb),
    'on_tonight', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', o.created_at)
        order by o.created_at)
      from public.event_on o join public.events e on e.id = o.event_id
      where o.user_id = v_uid
    ), '[]'::jsonb),
    'check_ins', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'method', c.method, 'at', c.created_at)
        order by c.created_at)
      from public.event_checkins c join public.events e on e.id = c.event_id
      where c.user_id = v_uid
    ), '[]'::jsonb),
    'event_chat_messages', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'content', m.content, 'sent_at', m.created_at)
        order by m.created_at)
      from public.event_messages m join public.events e on e.id = m.event_id
      where m.sender_id = v_uid
    ), '[]'::jsonb)
  );
end;
$$;

-- Realtime: the app listens on the private channel "event-chat:<event id>";
-- only who is in the chat may join it (the rows still pass the RLS above).
create function private.event_chat_topic_id(p_topic text)
returns uuid
language plpgsql
immutable
set search_path = ''
as $$
begin
  if p_topic not like 'event-chat:%' then
    return null;
  end if;
  return substr(p_topic, length('event-chat:') + 1)::uuid;
exception when invalid_text_representation then
  return null;
end;
$$;

create policy "event chat channel: who is in the chat"
  on realtime.messages for select to authenticated
  using (
    private.event_chat_topic_id((select realtime.topic())) is not null
    and private.in_event_chat(private.event_chat_topic_id((select realtime.topic())))
  );
