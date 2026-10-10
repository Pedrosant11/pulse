-- Swipes, matches, conversations and messages (SPEC 8 and 9.1).

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

create table public.swipes (
  swiper_id uuid not null references public.profiles (id) on delete cascade,
  swiped_id uuid not null references public.profiles (id) on delete cascade,
  mode public.app_mode not null,
  direction public.swipe_direction not null,
  created_at timestamptz not null default now(),
  primary key (swiper_id, swiped_id, mode),
  check (swiper_id <> swiped_id)
);

create index swipes_swiper_recent_idx on public.swipes (swiper_id, created_at desc);
-- Used to find the reverse like when checking for a match.
create index swipes_swiped_idx on public.swipes (swiped_id, swiper_id, mode)
  where direction = 'like';

create table public.matches (
  id uuid primary key default gen_random_uuid(),
  user_a uuid not null references public.profiles (id) on delete cascade,
  user_b uuid not null references public.profiles (id) on delete cascade,
  mode public.app_mode not null,
  created_at timestamptz not null default now(),
  unmatched_at timestamptz,
  unmatched_by uuid references public.profiles (id) on delete set null,
  check (user_a < user_b),
  unique (user_a, user_b, mode)
);

create index matches_user_b_idx on public.matches (user_b);

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  type public.conversation_type not null,
  match_id uuid unique references public.matches (id) on delete cascade,
  -- FK to crews is added by the crews migration.
  crew_id uuid unique,
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  check ((type = 'direct') = (match_id is not null)),
  check ((type = 'crew') = (crew_id is not null))
);

create table public.conversation_members (
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  last_read_at timestamptz,
  joined_at timestamptz not null default now(),
  primary key (conversation_id, user_id)
);

create index conversation_members_user_idx on public.conversation_members (user_id);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  sender_id uuid not null references public.profiles (id) on delete cascade,
  content text not null check (char_length(btrim(content)) between 1 and 2000),
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index messages_conversation_created_idx
  on public.messages (conversation_id, created_at desc);
create index messages_sender_recent_idx on public.messages (sender_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

create function private.is_conversation_member(p_conversation_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.conversation_members
    where conversation_id = p_conversation_id
      and user_id = (select auth.uid())
  );
$$;

-- A conversation is usable while the user is a member and, for direct
-- chats, the match is still active and nobody blocked the other.
create function private.can_access_conversation(p_conversation_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.is_conversation_member(p_conversation_id)
    and coalesce((
      select m.unmatched_at is null
        and not private.is_blocked(m.user_a, m.user_b)
      from public.conversations c
      join public.matches m on m.id = c.match_id
      where c.id = p_conversation_id
    ), true);
$$;

-- ---------------------------------------------------------------------------
-- Swipe triggers: rate limit, activity and match creation (SPEC 8.3, 10)
-- ---------------------------------------------------------------------------

create function private.before_swipe()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (
    select count(*) from public.swipes
    where swiper_id = new.swiper_id
      and created_at > now() - interval '1 minute'
  ) >= 60 then
    perform private.raise_rate_limited('swipes');
  end if;
  new.created_at := now();
  return new;
end;
$$;

create trigger swipes_before_insert
  before insert on public.swipes
  for each row execute function private.before_swipe();

create function private.create_match_on_mutual_like()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_match_id uuid;
  v_conversation_id uuid;
begin
  update public.profiles set last_active_at = now() where id = new.swiper_id;

  if new.direction <> 'like' then
    return new;
  end if;

  if not exists (
    select 1 from public.swipes
    where swiper_id = new.swiped_id
      and swiped_id = new.swiper_id
      and mode = new.mode
      and direction = 'like'
  ) or private.is_blocked(new.swiper_id, new.swiped_id) then
    return new;
  end if;

  insert into public.matches (user_a, user_b, mode)
  values (
    least(new.swiper_id, new.swiped_id),
    greatest(new.swiper_id, new.swiped_id),
    new.mode
  )
  on conflict (user_a, user_b, mode) do nothing
  returning id into v_match_id;

  if v_match_id is null then
    return new;
  end if;

  insert into public.conversations (type, match_id)
  values ('direct', v_match_id)
  returning id into v_conversation_id;

  insert into public.conversation_members (conversation_id, user_id)
  values (v_conversation_id, new.swiper_id), (v_conversation_id, new.swiped_id);

  return new;
end;
$$;

create trigger swipes_create_match
  after insert on public.swipes
  for each row execute function private.create_match_on_mutual_like();

-- ---------------------------------------------------------------------------
-- Message triggers: rate limit and conversation ordering
-- ---------------------------------------------------------------------------

create function private.before_message()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (
    select count(*) from public.messages
    where sender_id = new.sender_id
      and created_at > now() - interval '1 minute'
  ) >= 30 then
    perform private.raise_rate_limited('messages');
  end if;
  new.created_at := now();
  new.deleted_at := null;
  return new;
end;
$$;

create trigger messages_before_insert
  before insert on public.messages
  for each row execute function private.before_message();

create function private.after_message()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.conversations
  set last_message_at = new.created_at
  where id = new.conversation_id;

  update public.conversation_members
  set last_read_at = new.created_at
  where conversation_id = new.conversation_id and user_id = new.sender_id;

  update public.profiles set last_active_at = now() where id = new.sender_id;
  return new;
end;
$$;

create trigger messages_after_insert
  after insert on public.messages
  for each row execute function private.after_message();

-- Soft delete only: senders can set deleted_at, nothing else.
create function private.guard_message_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.content is distinct from old.content
     or new.sender_id is distinct from old.sender_id
     or new.conversation_id is distinct from old.conversation_id
     or new.created_at is distinct from old.created_at then
    raise exception 'Messages can only be deleted' using errcode = '42501';
  end if;
  if new.deleted_at is not null then
    new.deleted_at := coalesce(old.deleted_at, now());
  end if;
  return new;
end;
$$;

create trigger messages_guard_update
  before update on public.messages
  for each row execute function private.guard_message_update();

-- ---------------------------------------------------------------------------
-- Blocking removes the match in both directions (SPEC 10).
-- ---------------------------------------------------------------------------

create function private.after_block()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.matches
  set unmatched_at = now(), unmatched_by = new.blocker_id
  where user_a = least(new.blocker_id, new.blocked_id)
    and user_b = greatest(new.blocker_id, new.blocked_id)
    and unmatched_at is null;
  return new;
end;
$$;

create trigger blocks_after_insert
  after insert on public.blocks
  for each row execute function private.after_block();

-- ---------------------------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------------------------

-- Discovery feed (SPEC 8.1). Returns people going to the same upcoming
-- approved events, filtered by mode preferences on both sides, ordered by
-- events in common, nearest common event and recent activity.
-- When nobody matches, falls back to same-city people with shared music
-- genres (is_fallback = true). Returns nothing if the user has no upcoming
-- events (the UI then points to the Events tab).
create function public.get_discover_feed(
  p_mode public.app_mode,
  p_limit int default 20
)
returns table (
  id uuid,
  first_name text,
  age int,
  city text,
  state text,
  occupation text,
  bio text,
  gender public.gender,
  is_verified boolean,
  music_genres public.music_genre[],
  photo_paths text[],
  common_events jsonb,
  common_event_count int,
  is_fallback boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_uid uuid := (select auth.uid());
  v_me public.profiles;
  v_my_age int;
  v_limit int := least(greatest(coalesce(p_limit, 20), 1), 50);
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  select * into v_me from public.profiles p where p.id = v_uid;
  if v_me.id is null
     or v_me.status <> 'active'
     or not v_me.onboarding_completed
     or not (p_mode = any(v_me.modes)) then
    return;
  end if;
  v_my_age := date_part('year', age(v_me.birth_date))::int;

  return query
  with my_events as (
    select e.id as event_id, e.name, e.starts_at
    from public.event_attendance ea
    join public.events e on e.id = ea.event_id
    where ea.user_id = v_uid
      and e.status = 'approved'
      and e.ends_at > now()
  ),
  candidates as (
    select p.*
    from public.profiles p
    where exists (select 1 from my_events)
      and p.id <> v_uid
      and p.status = 'active'
      and p.onboarding_completed
      and p_mode = any(p.modes)
      and (select count(*) from public.profile_photos ph where ph.user_id = p.id) >= 2
      and not exists (
        select 1 from public.swipes s
        where s.swiper_id = v_uid and s.swiped_id = p.id and s.mode = p_mode
      )
      and not private.is_blocked(v_uid, p.id)
      and (
        (p_mode = 'date'
          and (cardinality(v_me.date_show_me) = 0 or p.gender = any(v_me.date_show_me))
          and (cardinality(p.date_show_me) = 0 or v_me.gender = any(p.date_show_me))
          and date_part('year', age(p.birth_date)) between v_me.date_age_min and v_me.date_age_max
          and v_my_age between p.date_age_min and p.date_age_max)
        or
        (p_mode = 'crew'
          and (not v_me.crew_same_gender_only
               or (p.gender = v_me.gender and v_me.gender <> 'prefer_not_say'))
          and (not p.crew_same_gender_only
               or (p.gender = v_me.gender and p.gender <> 'prefer_not_say')))
      )
  ),
  common as (
    select
      ea.user_id,
      count(*)::int as event_count,
      min(me.starts_at) as next_event_at,
      jsonb_agg(
        jsonb_build_object('id', me.event_id, 'name', me.name, 'starts_at', me.starts_at)
        order by me.starts_at
      ) as events
    from public.event_attendance ea
    join my_events me on me.event_id = ea.event_id
    where ea.user_id in (select c.id from candidates c)
    group by ea.user_id
  ),
  ranked as (
    select
      c.*,
      co.events,
      co.event_count,
      co.next_event_at,
      co.user_id is null as fallback,
      cardinality(array(
        select unnest(c.music_genres) intersect select unnest(v_me.music_genres)
      )) as shared_genres
    from candidates c
    left join common co on co.user_id = c.id
    where co.user_id is not null
       or (c.state = v_me.state
           and lower(c.city) = lower(v_me.city)
           and c.music_genres && v_me.music_genres)
  )
  select
    r.id,
    r.first_name,
    date_part('year', age(r.birth_date))::int,
    r.city,
    r.state,
    r.occupation,
    r.bio,
    r.gender,
    r.is_verified,
    r.music_genres,
    array(
      select ph.storage_path from public.profile_photos ph
      where ph.user_id = r.id order by ph.position
    ),
    coalesce(r.events, '[]'::jsonb),
    coalesce(r.event_count, 0),
    r.fallback
  from ranked r
  -- Fallback profiles only when nobody shares an event.
  where not r.fallback or not exists (select 1 from ranked x where not x.fallback)
  order by
    r.event_count desc nulls last,
    r.next_event_at asc nulls last,
    -- Shared genres only rank fallback profiles (SPEC 8.1 order otherwise).
    case when r.fallback then r.shared_genres end desc nulls last,
    r.last_active_at desc
  limit v_limit;
end;
$$;

-- Undo the user's latest swipe in a mode (SPEC 8.2), unless it already
-- produced a match. Returns the undone profile id, or null.
create function public.undo_last_swipe(p_mode public.app_mode)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_swipe public.swipes;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  select * into v_swipe
  from public.swipes
  where swiper_id = v_uid and mode = p_mode
  order by created_at desc
  limit 1;

  if v_swipe.swiper_id is null then
    return null;
  end if;

  if exists (
    select 1 from public.matches
    where user_a = least(v_uid, v_swipe.swiped_id)
      and user_b = greatest(v_uid, v_swipe.swiped_id)
      and mode = p_mode
  ) then
    return null;
  end if;

  delete from public.swipes
  where swiper_id = v_uid and swiped_id = v_swipe.swiped_id and mode = p_mode;
  return v_swipe.swiped_id;
end;
$$;

-- Undo a match (SPEC 9.1). The conversation becomes inaccessible.
create function public.unmatch(p_match_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  update public.matches
  set unmatched_at = now(), unmatched_by = v_uid
  where id = p_match_id
    and v_uid in (user_a, user_b)
    and unmatched_at is null;
  if not found then
    raise exception 'Match not found' using errcode = 'P0002';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.swipes enable row level security;
alter table public.matches enable row level security;
alter table public.conversations enable row level security;
alter table public.conversation_members enable row level security;
alter table public.messages enable row level security;

create policy "swipes: own rows"
  on public.swipes for select to authenticated
  using (swiper_id = (select auth.uid()));

create policy "swipes: active users swipe visible people"
  on public.swipes for insert to authenticated
  with check (
    swiper_id = (select auth.uid())
    and private.can_socialize()
    and private.is_visible_user(swiped_id)
  );

-- Undo goes through undo_last_swipe(); swipes are immutable.
revoke update, delete on public.swipes from authenticated;

create policy "matches: participants"
  on public.matches for select to authenticated
  using ((select auth.uid()) in (user_a, user_b));

-- Created by trigger, undone through unmatch().
revoke insert, update, delete on public.matches from authenticated;

create policy "conversations: accessible to members"
  on public.conversations for select to authenticated
  using (private.can_access_conversation(id));

revoke insert, update, delete on public.conversations from authenticated;

create policy "conversation_members: co-members"
  on public.conversation_members for select to authenticated
  using (private.can_access_conversation(conversation_id));

create policy "conversation_members: own read receipt"
  on public.conversation_members for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

revoke insert, delete, update on public.conversation_members from authenticated;
grant update (last_read_at) on public.conversation_members to authenticated;

create policy "messages: members read"
  on public.messages for select to authenticated
  using (private.can_access_conversation(conversation_id));

create policy "messages: members send"
  on public.messages for insert to authenticated
  with check (
    sender_id = (select auth.uid())
    and private.can_socialize()
    and private.can_access_conversation(conversation_id)
  );

create policy "messages: sender soft-deletes"
  on public.messages for update to authenticated
  using (sender_id = (select auth.uid()))
  with check (sender_id = (select auth.uid()));

revoke delete on public.messages from authenticated;
revoke update on public.messages from authenticated;
grant update (deleted_at) on public.messages to authenticated;

revoke execute on function public.get_discover_feed(public.app_mode, int) from public, anon;
grant execute on function public.get_discover_feed(public.app_mode, int) to authenticated;
revoke execute on function public.undo_last_swipe(public.app_mode) from public, anon;
grant execute on function public.undo_last_swipe(public.app_mode) to authenticated;
revoke execute on function public.unmatch(uuid) from public, anon;
grant execute on function public.unmatch(uuid) to authenticated;
