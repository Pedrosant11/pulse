-- Crews (SPEC 9.2, Phase 7): invites, crew RPCs, group chats in the inbox
-- and the "vai sozinho / já tem crew" info on Crew discovery cards.

-- ---------------------------------------------------------------------------
-- Invites: same table as join requests, with a kind.
-- ---------------------------------------------------------------------------

create type public.crew_request_kind as enum ('request', 'invite');

alter table public.crew_join_requests
  add column kind public.crew_request_kind not null default 'request',
  add column invited_by uuid references public.profiles (id) on delete set null;

-- Active Crew-mode match between the current user and [p_user].
create function private.has_crew_match(p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.matches m
    where m.mode = 'crew'
      and m.unmatched_at is null
      and m.user_a = least((select auth.uid()), p_user)
      and m.user_b = greatest((select auth.uid()), p_user)
  );
$$;

-- Whether [p_user] goes to the crew's event. Attendance rows are private
-- (RLS), so policies ask through this yes/no helper.
create function private.goes_to_crew_event(p_crew_id uuid, p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.crews c
    join public.event_attendance a on a.event_id = c.event_id
    where c.id = p_crew_id and a.user_id = p_user
  );
$$;

create function private.before_crew_join_request_insert()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.invited_by := case when new.kind = 'invite' then (select auth.uid()) end;
  new.status := 'pending';
  new.created_at := now();
  new.responded_at := null;
  return new;
end;
$$;

create trigger crew_join_requests_before_insert
  before insert on public.crew_join_requests
  for each row execute function private.before_crew_join_request_insert();

drop policy "crew_join_requests: requester and owner" on public.crew_join_requests;
drop policy "crew_join_requests: attendees ask to join open crews" on public.crew_join_requests;
drop policy "crew_join_requests: owner answers, requester cancels" on public.crew_join_requests;

create policy "crew_join_requests: involved people read"
  on public.crew_join_requests for select to authenticated
  using (user_id = (select auth.uid()) or private.is_crew_owner(crew_id));

create policy "crew_join_requests: attendees ask to join open crews"
  on public.crew_join_requests for insert to authenticated
  with check (
    kind = 'request'
    and user_id = (select auth.uid())
    and private.can_socialize()
    and exists (
      select 1 from public.crews c
      where c.id = crew_id and c.is_open and private.can_see_crew(c)
    )
    and not private.is_crew_member(crew_id)
  );

-- SPEC 9.2: the owner invites people they matched with in Crew mode who go
-- to the same event.
create policy "crew_join_requests: owner invites crew matches"
  on public.crew_join_requests for insert to authenticated
  with check (
    kind = 'invite'
    and private.can_socialize()
    and private.is_crew_owner(crew_id)
    and private.has_crew_match(user_id)
    and not private.is_blocked((select auth.uid()), user_id)
    and private.goes_to_crew_event(crew_id, user_id)
    and not exists (
      select 1 from public.crew_members cm
      where cm.crew_id = crew_join_requests.crew_id
        and cm.user_id = crew_join_requests.user_id
    )
  );

-- Requests: the owner answers, the requester cancels.
-- Invites: the invitee answers, the owner cancels.
create policy "crew_join_requests: answer or cancel"
  on public.crew_join_requests for update to authenticated
  using (
    status = 'pending'
    and (user_id = (select auth.uid()) or private.is_crew_owner(crew_id))
  )
  with check (
    (kind = 'request' and private.is_crew_owner(crew_id)
      and status in ('approved', 'rejected'))
    or (kind = 'request' and user_id = (select auth.uid())
      and status = 'cancelled')
    or (kind = 'invite' and user_id = (select auth.uid())
      and status in ('approved', 'rejected'))
    or (kind = 'invite' and private.is_crew_owner(crew_id)
      and status = 'cancelled')
  );

-- ---------------------------------------------------------------------------
-- Crew RPCs
-- ---------------------------------------------------------------------------

-- The user's relation to a crew: owner, member, requested, invited or null.
create function private.crew_status(p_crew_id uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    (select cm.role::text from public.crew_members cm
     where cm.crew_id = p_crew_id and cm.user_id = (select auth.uid())),
    (select case r.kind when 'invite' then 'invited' else 'requested' end
     from public.crew_join_requests r
     where r.crew_id = p_crew_id
       and r.user_id = (select auth.uid())
       and r.status = 'pending'
     limit 1)
  );
$$;

-- Crews of an event visible to the user (SPEC 7.3 "Crews deste evento").
create function public.list_event_crews(p_event_id uuid)
returns table (
  id uuid,
  name text,
  description text,
  is_open boolean,
  same_gender_only boolean,
  max_members int,
  member_count int,
  owner_first_name text,
  member_photos text[],
  my_status text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    c.id, c.name, c.description, c.is_open, c.same_gender_only,
    c.max_members::int,
    (select count(*)::int from public.crew_members cm where cm.crew_id = c.id),
    (select p.first_name from public.profiles p where p.id = c.owner_id),
    array(
      select ph.storage_path
      from public.crew_members cm
      join lateral (
        select storage_path from public.profile_photos
        where user_id = cm.user_id order by position limit 1
      ) ph on true
      where cm.crew_id = c.id
      order by cm.role, cm.joined_at
      limit 4
    ),
    private.crew_status(c.id)
  from public.crews c
  where c.event_id = p_event_id
    and private.can_see_crew(c)
  order by (private.crew_status(c.id) is not null) desc, c.created_at;
$$;

-- One crew with its event and chat (visible to members and attendees).
create function public.get_crew(p_crew_id uuid)
returns table (
  id uuid,
  name text,
  description text,
  is_open boolean,
  same_gender_only boolean,
  max_members int,
  member_count int,
  owner_id uuid,
  event_id uuid,
  event_name text,
  event_starts_at timestamptz,
  conversation_id uuid,
  my_status text,
  my_request_id uuid
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    c.id, c.name, c.description, c.is_open, c.same_gender_only,
    c.max_members::int,
    (select count(*)::int from public.crew_members cm where cm.crew_id = c.id),
    c.owner_id,
    e.id, e.name, e.starts_at,
    -- The chat is only revealed to members.
    case when private.is_crew_member(c.id)
      then (select conv.id from public.conversations conv where conv.crew_id = c.id)
    end,
    private.crew_status(c.id),
    -- The user's pending request/invite (to cancel or answer it).
    (select r.id from public.crew_join_requests r
     where r.crew_id = c.id and r.user_id = (select auth.uid())
       and r.status = 'pending'
     limit 1)
  from public.crews c
  join public.events e on e.id = c.event_id
  where c.id = p_crew_id and private.can_see_crew(c);
$$;

create function public.get_crew_members(p_crew_id uuid)
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  role public.crew_member_role,
  joined_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    p.id, p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    cm.role, cm.joined_at
  from public.crew_members cm
  join public.crews c on c.id = cm.crew_id
  join public.profiles p on p.id = cm.user_id
  where cm.crew_id = p_crew_id
    and private.can_see_crew(c)
  order by cm.role, cm.joined_at;
$$;

-- Pending requests and invites of a crew (owner only).
create function public.get_crew_pending(p_crew_id uuid)
returns table (
  request_id uuid,
  user_id uuid,
  first_name text,
  photo_path text,
  kind public.crew_request_kind,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    r.id, p.id, p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    r.kind, r.created_at
  from public.crew_join_requests r
  join public.profiles p on p.id = r.user_id
  where r.crew_id = p_crew_id
    and r.status = 'pending'
    and private.is_crew_owner(p_crew_id)
    and not private.is_blocked((select auth.uid()), p.id)
  order by r.created_at;
$$;

-- People the owner can invite: Crew matches going to the crew's event who
-- aren't members and have no pending request/invite.
create function public.get_crew_invite_candidates(p_crew_id uuid)
returns table (user_id uuid, first_name text, photo_path text)
language sql
stable
security definer
set search_path = ''
as $$
  select
    p.id, p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1)
  from public.crews c
  join public.event_attendance a on a.event_id = c.event_id
  join public.profiles p on p.id = a.user_id
  where c.id = p_crew_id
    and private.is_crew_owner(p_crew_id)
    and p.id <> (select auth.uid())
    and p.status = 'active'
    and private.has_crew_match(p.id)
    and not private.is_blocked((select auth.uid()), p.id)
    and not exists (select 1 from public.crew_members cm
                    where cm.crew_id = c.id and cm.user_id = p.id)
    and not exists (select 1 from public.crew_join_requests r
                    where r.crew_id = c.id and r.user_id = p.id
                      and r.status = 'pending')
    and (not c.same_gender_only or p.gender = c.gender)
  order by p.first_name;
$$;

-- Pending invites for the user (shown in Chats → Grupos).
create function public.list_my_crew_invites()
returns table (
  request_id uuid,
  crew_id uuid,
  crew_name text,
  event_name text,
  event_starts_at timestamptz,
  invited_by_name text,
  member_count int
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    r.id, c.id, c.name, e.name, e.starts_at,
    (select p.first_name from public.profiles p where p.id = r.invited_by),
    (select count(*)::int from public.crew_members cm where cm.crew_id = c.id)
  from public.crew_join_requests r
  join public.crews c on c.id = r.crew_id
  join public.events e on e.id = c.event_id
  where r.user_id = (select auth.uid())
    and r.kind = 'invite'
    and r.status = 'pending'
    and e.ends_at > now()
    and not private.is_blocked((select auth.uid()), c.owner_id)
  order by r.created_at desc;
$$;

-- Names/photos of a conversation's members (group chat bubbles).
create function public.get_conversation_members(p_conversation_id uuid)
returns table (user_id uuid, first_name text, photo_path text)
language sql
stable
security definer
set search_path = ''
as $$
  select
    p.id, p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1)
  from public.conversation_members cm
  join public.profiles p on p.id = cm.user_id
  where cm.conversation_id = p_conversation_id
    and private.can_access_conversation(p_conversation_id);
$$;

revoke execute on function public.list_event_crews(uuid) from public, anon;
grant execute on function public.list_event_crews(uuid) to authenticated;
revoke execute on function public.get_crew(uuid) from public, anon;
grant execute on function public.get_crew(uuid) to authenticated;
revoke execute on function public.get_crew_members(uuid) from public, anon;
grant execute on function public.get_crew_members(uuid) to authenticated;
revoke execute on function public.get_crew_pending(uuid) from public, anon;
grant execute on function public.get_crew_pending(uuid) to authenticated;
revoke execute on function public.get_crew_invite_candidates(uuid) from public, anon;
grant execute on function public.get_crew_invite_candidates(uuid) to authenticated;
revoke execute on function public.list_my_crew_invites() from public, anon;
grant execute on function public.list_my_crew_invites() to authenticated;
revoke execute on function public.get_conversation_members(uuid) from public, anon;
grant execute on function public.get_conversation_members(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Group chats in the inbox: conversation RPCs gain crew fields (the return
-- types change, so they are recreated).
-- ---------------------------------------------------------------------------

drop function public.list_conversations();
drop function public.get_conversation(uuid);

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
    (
      select count(*)::int from public.messages msg
      where msg.conversation_id = c.id
        and msg.sender_id <> me.id
        and msg.deleted_at is null
        and msg.created_at > coalesce(cm.last_read_at, '-infinity'::timestamptz)
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
  common_events jsonb,
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
    ), '[]'::jsonb),
    cr.id,
    cr.name,
    ev.name,
    (select count(*)::int from public.crew_members cmm where cmm.crew_id = cr.id)
  from me
  join public.conversations c on c.id = p_conversation_id
  left join public.matches m on m.id = c.match_id
  left join public.crews cr on cr.id = c.crew_id
  left join public.events ev on ev.id = cr.event_id
  left join public.profiles other
    on c.type = 'direct'
   and other.id = case when m.user_a = me.id then m.user_b else m.user_a end
  where me.id is not null
    and private.can_access_conversation(c.id);
$$;

revoke execute on function public.list_conversations() from public, anon;
grant execute on function public.list_conversations() to authenticated;
revoke execute on function public.get_conversation(uuid) from public, anon;
grant execute on function public.get_conversation(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Crew discovery cards: "vai sozinho(a)" / "já tem crew de N".
-- ---------------------------------------------------------------------------

drop function public.get_discover_feed(public.app_mode, int);

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
  is_fallback boolean,
  distance_km double precision,
  favorite_djs text[],
  date_looking_for public.date_intent,
  crew_size int
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
    select
      p.*,
      private.distance_km(v_me.lat, v_me.lng, p.lat, p.lng) as dist
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
       or (c.music_genres && v_me.music_genres
           and (
             (c.dist is not null and c.dist <= v_me.discovery_radius_km)
             -- Without coordinates on either side, same state.
             or (c.dist is null and c.state = v_me.state)
           ))
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
    r.fallback,
    r.dist,
    r.favorite_djs,
    r.date_looking_for,
    -- Crew mode: size of the crew they're in for the first common event
    -- (null = going solo).
    case when p_mode = 'crew' then nullif((
      select count(*)::int from public.crew_members cm2
      where cm2.crew_id = (
        select cm.crew_id from public.crew_members cm
        join public.crews cr on cr.id = cm.crew_id
        where cm.user_id = r.id
          and cr.event_id = (r.events -> 0 ->> 'id')::uuid
        limit 1
      )
    ), 0) end
  from ranked r
  -- Fallback profiles only when nobody shares an event.
  where not r.fallback or not exists (select 1 from ranked x where not x.fallback)
  order by
    r.event_count desc nulls last,
    r.next_event_at asc nulls last,
    -- Fallback: shared genres, then nearest (SPEC 8.1).
    case when r.fallback then r.shared_genres end desc nulls last,
    case when r.fallback then r.dist end asc nulls last,
    r.last_active_at desc
  limit v_limit;
end;
$$;

revoke execute on function public.get_discover_feed(public.app_mode, int) from public, anon;
grant execute on function public.get_discover_feed(public.app_mode, int) to authenticated;
