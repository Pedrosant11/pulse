-- Casas (venues): a page for each club with its upcoming parties, followers
-- and ratings.
--   * Curators and admins add venues already approved; producers suggest
--     one (pending) and the curators approve or refuse it.
--   * Events may point to a venue (events.venue_id); the event keeps its own
--     venue_name/address, filled from the venue by the app.
--   * Anyone follows a venue; followers get a push when a new party there is
--     approved (venue_new, same daily cap as the other "new party" pushes).
--   * Only people who went to a party there (marked "Eu vou" on an approved
--     event at the venue that is already over) can rate it, 1 to 5.

create type public.venue_status as enum ('pending', 'approved', 'rejected');

create table public.venues (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(btrim(name)) between 2 and 80),
  description text check (char_length(description) <= 1000),
  address text check (char_length(address) <= 200),
  neighborhood text check (char_length(neighborhood) <= 80),
  city text not null check (char_length(city) between 2 and 80),
  state text not null check (state ~ '^[A-Z]{2}$'),
  lat double precision check (lat between -90 and 90),
  lng double precision check (lng between -180 and 180),
  photo_path text,
  instagram text check (instagram ~ '^[A-Za-z0-9._]{1,30}$'),
  status public.venue_status not null default 'pending',
  created_by uuid references public.profiles (id) on delete set null,
  reviewed_by uuid references public.profiles (id) on delete set null,
  rejection_reason text check (char_length(rejection_reason) <= 300),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- One live venue per name and city.
create unique index venues_name_city_idx
  on public.venues (lower(btrim(name)), lower(city), state)
  where status <> 'rejected';
create index venues_status_state_idx on public.venues (status, state);

alter table public.events
  add column venue_id uuid references public.venues (id) on delete set null;
create index events_venue_idx on public.events (venue_id) where venue_id is not null;

create table public.venue_follows (
  venue_id uuid not null references public.venues (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (venue_id, user_id)
);
create index venue_follows_user_idx on public.venue_follows (user_id);

create table public.venue_reviews (
  venue_id uuid not null references public.venues (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  rating smallint not null check (rating between 1 and 5),
  comment text check (char_length(comment) <= 500),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (venue_id, user_id)
);

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Went to a party there: "Eu vou" on an approved event at the venue that is
-- already over.
create function private.went_to_venue(p_user uuid, p_venue uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.event_attendance ea
    join public.events e on e.id = ea.event_id
    where ea.user_id = p_user
      and e.venue_id = p_venue
      and e.status = 'approved'
      and e.ends_at < now()
  );
$$;

-- Moderators edit any venue; whoever suggested one edits it while pending.
create function private.can_edit_venue(p_venue uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select private.is_moderator() or exists (
    select 1 from public.venues v
    where v.id = p_venue
      and v.created_by = (select auth.uid())
      and v.status = 'pending'
  );
$$;

-- ---------------------------------------------------------------------------
-- Guards
-- ---------------------------------------------------------------------------

-- New venue: who and status come from the database.
create function private.before_venue_insert()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_role public.user_role := private.current_user_role();
begin
  if v_role is null or v_role not in ('producer', 'curator', 'admin') then
    raise exception 'Only producers and the team add venues'
      using errcode = '42501';
  end if;
  new.created_by := auth.uid();
  new.rejection_reason := null;
  if v_role in ('curator', 'admin') then
    new.status := 'approved';
    new.reviewed_by := auth.uid();
  else
    new.status := 'pending';
    new.reviewed_by := null;
  end if;
  new.created_at := now();
  new.updated_at := now();
  return new;
end;
$$;

create trigger venues_before_insert
  before insert on public.venues
  for each row execute function private.before_venue_insert();

-- Status only changes through admin_review_venue().
create function private.before_venue_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if current_setting('pulse.venue_review', true) is distinct from 'on' then
    new.status := old.status;
    new.reviewed_by := old.reviewed_by;
    new.rejection_reason := old.rejection_reason;
  end if;
  new.created_by := old.created_by;
  new.created_at := old.created_at;
  new.updated_at := now();
  return new;
end;
$$;

create trigger venues_before_update
  before update on public.venues
  for each row execute function private.before_venue_update();

-- An event points to an approved venue, or to one its editor suggested.
create function private.guard_event_venue()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.venue_id is null
     or (tg_op = 'UPDATE' and new.venue_id is not distinct from old.venue_id) then
    return new;
  end if;
  if not exists (
    select 1 from public.venues v
    where v.id = new.venue_id
      and (v.status = 'approved'
           or (v.status = 'pending' and v.created_by = (select auth.uid()))
           or private.is_moderator())
  ) then
    raise exception 'Venue not available' using errcode = 'P0001', hint = 'venue_unavailable';
  end if;
  return new;
end;
$$;

create trigger events_guard_venue
  before insert or update of venue_id on public.events
  for each row execute function private.guard_event_venue();

-- Ratings: only after going to a party there.
create function private.before_venue_review()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.user_id := auth.uid();
  if not private.went_to_venue(new.user_id, new.venue_id) then
    raise exception 'Only people who went can rate' using errcode = 'P0001', hint = 'venue_review_not_allowed';
  end if;
  if tg_op = 'INSERT' then
    new.created_at := now();
  else
    new.created_at := old.created_at;
  end if;
  new.updated_at := now();
  new.comment := nullif(btrim(new.comment), '');
  return new;
end;
$$;

create trigger venue_reviews_before_write
  before insert or update on public.venue_reviews
  for each row execute function private.before_venue_review();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.venues enable row level security;
alter table public.venue_follows enable row level security;
alter table public.venue_reviews enable row level security;

create policy "venues: approved for everyone, pending for author and team"
  on public.venues for select to authenticated
  using (
    status = 'approved'
    or created_by = (select auth.uid())
    or private.is_moderator()
  );

create policy "venues: producers and team add"
  on public.venues for insert to authenticated
  with check (true); -- the trigger checks the role

create policy "venues: editors update"
  on public.venues for update to authenticated
  using (private.can_edit_venue(id))
  with check (private.can_edit_venue(id));

create policy "venues: admin deletes"
  on public.venues for delete to authenticated
  using (private.is_admin());

create policy "venue_follows: own"
  on public.venue_follows for all to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.venues v where v.id = venue_id and v.status = 'approved')
  );

create policy "venue_reviews: read on approved venues"
  on public.venue_reviews for select to authenticated
  using (
    exists (select 1 from public.venues v where v.id = venue_id and v.status = 'approved')
    and not private.is_blocked((select auth.uid()), user_id)
  );

create policy "venue_reviews: own"
  on public.venue_reviews for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy "venue_reviews: own update"
  on public.venue_reviews for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy "venue_reviews: own or team delete"
  on public.venue_reviews for delete to authenticated
  using (user_id = (select auth.uid()) or private.is_moderator());

-- ---------------------------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------------------------

-- Approved venues, for the "Casas" list and the event form picker. With a
-- query, nationwide by name; without, the given state (or all).
create function public.list_venues(
  p_query text default null,
  p_state text default null,
  p_limit int default 50
)
returns table (
  id uuid,
  name text,
  neighborhood text,
  city text,
  state text,
  address text,
  lat double precision,
  lng double precision,
  photo_path text,
  rating numeric,
  rating_count int,
  followers int,
  upcoming int,
  is_following boolean,
  status public.venue_status
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    v.id, v.name, v.neighborhood, v.city, v.state, v.address, v.lat, v.lng,
    v.photo_path,
    (select round(avg(r.rating), 1) from public.venue_reviews r where r.venue_id = v.id),
    (select count(*)::int from public.venue_reviews r where r.venue_id = v.id),
    (select count(*)::int from public.venue_follows f where f.venue_id = v.id),
    (select count(*)::int from public.events e
      where e.venue_id = v.id and e.status = 'approved' and e.ends_at > now()),
    exists (select 1 from public.venue_follows f
      where f.venue_id = v.id and f.user_id = (select auth.uid())),
    v.status
  from public.venues v
  where (select auth.uid()) is not null
    and (
      v.status = 'approved'
      -- My own pending suggestions, so I can use them in my event.
      or (v.status = 'pending' and v.created_by = (select auth.uid()))
    )
    and (
      nullif(btrim(p_query), '') is not null
        and lower(extensions.unaccent('extensions.unaccent'::regdictionary, v.name)) like '%' || lower(extensions.unaccent('extensions.unaccent'::regdictionary, btrim(p_query))) || '%'
      or nullif(btrim(p_query), '') is null
        and (p_state is null or v.state = p_state)
    )
  order by
    (select count(*) from public.events e
      where e.venue_id = v.id and e.status = 'approved' and e.ends_at > now()) desc,
    v.name
  limit least(greatest(coalesce(p_limit, 50), 1), 100);
$$;

revoke execute on function public.list_venues(text, text, int) from public, anon;
grant execute on function public.list_venues(text, text, int) to authenticated;

-- Venue page: the venue, its numbers, what I can do, and its parties.
create function public.get_venue(p_venue uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v public.venues;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  select * into v from public.venues where id = p_venue;
  if v.id is null
     or (v.status <> 'approved' and v.created_by is distinct from v_uid
         and not private.is_moderator()) then
    return null;
  end if;

  return to_jsonb(v) || jsonb_build_object(
    'rating', (select round(avg(r.rating), 1) from public.venue_reviews r where r.venue_id = v.id),
    'rating_count', (select count(*) from public.venue_reviews r where r.venue_id = v.id),
    'followers', (select count(*) from public.venue_follows f where f.venue_id = v.id),
    'is_following', exists (select 1 from public.venue_follows f
      where f.venue_id = v.id and f.user_id = v_uid),
    'can_review', private.went_to_venue(v_uid, v.id),
    'my_rating', (select r.rating from public.venue_reviews r
      where r.venue_id = v.id and r.user_id = v_uid),
    'my_comment', (select r.comment from public.venue_reviews r
      where r.venue_id = v.id and r.user_id = v_uid),
    'past_events', (select count(*) from public.events e
      where e.venue_id = v.id and e.status = 'approved' and e.ends_at <= now()),
    'can_edit', private.can_edit_venue(v.id),
    'upcoming', coalesce((
      select jsonb_agg(jsonb_build_object(
          'id', e.id, 'name', e.name, 'venue_name', e.venue_name,
          'city', e.city, 'state', e.state, 'starts_at', e.starts_at,
          'ends_at', e.ends_at, 'cover_path', e.cover_path,
          'genres', e.genres, 'is_official', e.is_official
        ) order by e.starts_at)
      from public.events e
      where e.venue_id = v.id and e.status = 'approved' and e.ends_at > now()
    ), '[]'::jsonb),
    'reviews', coalesce((
      select jsonb_agg(x.review order by x.updated_at desc)
      from (
        select r.updated_at, jsonb_build_object(
          'user_id', r.user_id, 'first_name', p.first_name, 'rating', r.rating,
          'comment', r.comment, 'updated_at', r.updated_at
        ) as review
        from public.venue_reviews r
        join public.profiles p on p.id = r.user_id and p.status = 'active'
        where r.venue_id = v.id and not private.is_blocked(v_uid, r.user_id)
        order by r.updated_at desc
        limit 20
      ) x
    ), '[]'::jsonb)
  );
end;
$$;

revoke execute on function public.get_venue(uuid) from public, anon;
grant execute on function public.get_venue(uuid) to authenticated;

-- Curators: pending suggestions, oldest first.
create function public.pending_venues()
returns setof public.venues
language sql
stable
security definer
set search_path = ''
as $$
  select * from public.venues
  where status = 'pending' and private.is_moderator()
  order by created_at;
$$;

revoke execute on function public.pending_venues() from public, anon;
grant execute on function public.pending_venues() to authenticated;

-- Curators approve or refuse a suggestion. Refusing unlinks its events.
create function public.admin_review_venue(
  p_venue uuid,
  p_approve boolean,
  p_reason text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_moderator() then
    raise exception 'Only curators' using errcode = '42501';
  end if;
  perform set_config('pulse.venue_review', 'on', true);
  update public.venues
  set status = case when p_approve then 'approved' else 'rejected' end::public.venue_status,
      reviewed_by = auth.uid(),
      rejection_reason = case when p_approve then null else nullif(btrim(p_reason), '') end
  where id = p_venue and status = 'pending';
  perform set_config('pulse.venue_review', 'off', true);
  if not p_approve then
    update public.events set venue_id = null where venue_id = p_venue;
  end if;
end;
$$;

revoke execute on function public.admin_review_venue(uuid, boolean, text) from public, anon;
grant execute on function public.admin_review_venue(uuid, boolean, text) to authenticated;

-- ---------------------------------------------------------------------------
-- Photos: venue-photos/{venue_id}/{random}.jpg
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('venue-photos', 'venue-photos', true, 5242880, array['image/jpeg'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

create policy "venue-photos: editors upload"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'venue-photos'
    and private.can_edit_venue(private.path_uuid(name))
  );

create policy "venue-photos: editors replace"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'venue-photos'
    and private.can_edit_venue(private.path_uuid(name))
  );

create policy "venue-photos: editors delete"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'venue-photos'
    and private.can_edit_venue(private.path_uuid(name))
  );

-- ---------------------------------------------------------------------------
-- Push: followers hear about new parties at the venue first.
-- ---------------------------------------------------------------------------

alter table private.event_push_log drop constraint event_push_log_kind_check;
alter table private.event_push_log add constraint event_push_log_kind_check
  check (kind in ('event_dj', 'event_new', 'event_reminder', 'venue_new'));

create or replace function private.event_audience(p_event public.events)
returns setof public.profiles
language sql
stable
security definer
set search_path = ''
as $$
  select p.*
  from public.profiles p
  where p.status = 'active'
    and p.onboarding_completed
    and p.notify_events
    and p.id is distinct from p_event.created_by
    and not private.is_blocked(p.id, p_event.created_by)
    and not exists (
      select 1 from private.event_push_log l
      where l.user_id = p.id and l.event_id = p_event.id
    )
    and (
      select count(*) from private.event_push_log l
      where l.user_id = p.id
        and l.kind in ('event_dj', 'event_new', 'venue_new')
        and l.sent_at > now() - interval '24 hours'
    ) < private.setting_int('event_push_daily_cap')
    and (
      case
        when p.lat is not null and p_event.lat is not null then
          private.distance_km(p.lat, p.lng, p_event.lat, p_event.lng) <= p.discovery_radius_km
        else p.state = p_event.state
      end
      -- Following the venue counts wherever they live.
      or exists (
        select 1 from public.venue_follows f
        where f.venue_id = p_event.venue_id and f.user_id = p.id
      )
    );
$$;

create or replace function private.notify_new_event(p_event public.events)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_dj text;
  v_users uuid[];
  v_route text := '/events/' || p_event.id;
  v_venue text;
begin
  if p_event.starts_at > now() + make_interval(days => private.setting_int('event_push_horizon_days')) then
    return;
  end if;

  -- Followers of the venue first.
  if p_event.venue_id is not null then
    select v.name into v_venue from public.venues v where v.id = p_event.venue_id;
    select array_agg(a.id) into v_users
    from private.event_audience(p_event) a
    where exists (
      select 1 from public.venue_follows f
      where f.venue_id = p_event.venue_id and f.user_id = a.id
    );
    if v_users is not null then
      insert into private.event_push_log (user_id, event_id, kind)
      select unnest(v_users), p_event.id, 'venue_new'
      on conflict do nothing;
      perform private.send_push(
        v_users, 'venue_new',
        jsonb_build_object('route', v_route, 'event', p_event.name, 'venue', v_venue)
      );
    end if;
  end if;

  -- Then DJ fans (one push per DJ, so the text can name them), nearby only.
  foreach v_dj in array p_event.lineup loop
    select array_agg(a.id) into v_users
    from private.event_audience(p_event) a
    where exists (
      select 1 from unnest(a.favorite_djs) f
      where lower(btrim(f)) = lower(btrim(v_dj))
    )
    and case
      when a.lat is not null and p_event.lat is not null then
        private.distance_km(a.lat, a.lng, p_event.lat, p_event.lng) <= a.discovery_radius_km
      else a.state = p_event.state
    end;
    if v_users is not null then
      insert into private.event_push_log (user_id, event_id, kind)
      select unnest(v_users), p_event.id, 'event_dj'
      on conflict do nothing;
      perform private.send_push(
        v_users, 'event_dj',
        jsonb_build_object('route', v_route, 'event', p_event.name, 'dj', v_dj)
      );
    end if;
  end loop;

  -- Then people nearby who like one of its genres.
  select array_agg(a.id) into v_users
  from private.event_audience(p_event) a
  where a.music_genres && p_event.genres
    and case
      when a.lat is not null and p_event.lat is not null then
        private.distance_km(a.lat, a.lng, p_event.lat, p_event.lng) <= a.discovery_radius_km
      else a.state = p_event.state
    end;
  if v_users is not null then
    insert into private.event_push_log (user_id, event_id, kind)
    select unnest(v_users), p_event.id, 'event_new'
    on conflict do nothing;
    perform private.send_push(
      v_users, 'event_new',
      jsonb_build_object('route', v_route, 'event', p_event.name, 'city', p_event.city)
    );
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- LGPD export: followed venues and ratings too.
-- ---------------------------------------------------------------------------

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
    ), '[]'::jsonb)
  );
end;
$$;
