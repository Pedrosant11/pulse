-- Polls in crew chats ("qual festa?", "que horas o esquenta?").
--   * A member creates one through create_poll(): 2 to 4 options, open for
--     1 to 72 hours. It shows in the chat as a message of kind 'poll'.
--   * Each member votes once and can change or remove the vote while it is
--     open; members see everyone's votes (it's their crew).

create table public.polls (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  created_by uuid references public.profiles (id) on delete set null,
  question text not null check (char_length(btrim(question)) between 1 and 140),
  options text[] not null check (cardinality(options) between 2 and 4),
  closes_at timestamptz not null,
  created_at timestamptz not null default now()
);
create index polls_conversation_idx on public.polls (conversation_id);

create table public.poll_votes (
  poll_id uuid not null references public.polls (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  option smallint not null check (option between 0 and 3),
  voted_at timestamptz not null default now(),
  primary key (poll_id, user_id)
);

alter table public.messages
  add column poll_id uuid references public.polls (id) on delete set null;

alter table public.messages drop constraint messages_kind_check;
alter table public.messages add constraint messages_kind_check
  check (kind in ('text', 'image', 'audio', 'poll'));

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
    or (kind = 'poll' and media_path is null and poll_id is not null
      and char_length(btrim(content)) between 1 and 140)
  ))
);

-- A poll message points to a poll of the same conversation, by its author.
create or replace function private.guard_message_media()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.kind = 'poll' then
    new.media_path := null;
    new.media_duration_ms := null;
    if not exists (
      select 1 from public.polls p
      where p.id = new.poll_id
        and p.conversation_id = new.conversation_id
        and p.created_by = new.sender_id
    ) then
      raise exception 'invalid poll' using errcode = '22023';
    end if;
    return new;
  end if;
  new.poll_id := null;
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

-- Votes: members of an open poll, their own vote only.
create function private.can_vote(p_poll uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.polls p
    where p.id = p_poll
      and p.closes_at > now()
      and private.can_access_conversation(p.conversation_id)
  );
$$;

create function private.before_poll_vote()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.option >= (select cardinality(p.options) from public.polls p where p.id = new.poll_id) then
    raise exception 'invalid option' using errcode = '22023';
  end if;
  new.voted_at := now();
  return new;
end;
$$;

create trigger poll_votes_before_write
  before insert or update on public.poll_votes
  for each row execute function private.before_poll_vote();

alter table public.polls enable row level security;
alter table public.poll_votes enable row level security;

create policy "polls: members read"
  on public.polls for select to authenticated
  using (private.is_conversation_member(conversation_id));

create policy "poll_votes: members read"
  on public.poll_votes for select to authenticated
  using (exists (
    select 1 from public.polls p
    where p.id = poll_id and private.is_conversation_member(p.conversation_id)
  ));

create policy "poll_votes: vote while open"
  on public.poll_votes for insert to authenticated
  with check (user_id = (select auth.uid()) and private.can_vote(poll_id));

create policy "poll_votes: change while open"
  on public.poll_votes for update to authenticated
  using (user_id = (select auth.uid()) and private.can_vote(poll_id))
  with check (user_id = (select auth.uid()) and private.can_vote(poll_id));

create policy "poll_votes: remove while open"
  on public.poll_votes for delete to authenticated
  using (user_id = (select auth.uid()) and private.can_vote(poll_id));

-- Creates the poll and its chat message; returns the poll id.
create function public.create_poll(
  p_conversation uuid,
  p_question text,
  p_options text[],
  p_hours int default 24
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_options text[];
  v_poll uuid;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if not private.can_access_conversation(p_conversation)
     or not exists (select 1 from public.conversations c
                    where c.id = p_conversation and c.type = 'crew') then
    raise exception 'Polls are for crew chats' using errcode = '42501';
  end if;
  select array_agg(o order by ord) into v_options
  from (
    select distinct on (lower(btrim(o))) btrim(o) as o, ord
    from unnest(p_options) with ordinality as t(o, ord)
    where char_length(btrim(o)) between 1 and 60
    order by lower(btrim(o)), ord
  ) x;
  if coalesce(cardinality(v_options), 0) not between 2 and 4 then
    raise exception 'A poll needs 2 to 4 options' using errcode = 'P0001', hint = 'poll_options';
  end if;

  insert into public.polls (conversation_id, created_by, question, options, closes_at)
  values (
    p_conversation, v_uid, btrim(p_question), v_options,
    now() + make_interval(hours => least(greatest(coalesce(p_hours, 24), 1), 72))
  )
  returning id into v_poll;

  insert into public.messages (conversation_id, sender_id, kind, content, poll_id)
  values (p_conversation, v_uid, 'poll', btrim(p_question), v_poll);
  return v_poll;
end;
$$;

revoke execute on function public.create_poll(uuid, text, text[], int) from public, anon;
grant execute on function public.create_poll(uuid, text, text[], int) to authenticated;

alter publication supabase_realtime add table public.poll_votes;

-- LGPD export: poll votes too.
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
    ), '[]'::jsonb)
  );
end;
$$;
