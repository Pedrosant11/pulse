-- Profiles, private user data, blocks, photos and the public profile view.

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text check (char_length(btrim(first_name)) between 1 and 50),
  last_name text check (char_length(last_name) <= 80),
  -- 18+ only (SPEC 1). Ages only grow, so the check stays valid over time.
  birth_date date check (birth_date <= (current_date - interval '18 years')),
  gender public.gender,
  orientation public.orientation,
  show_orientation boolean not null default false,
  city text check (char_length(city) <= 80),
  state text check (state ~ '^[A-Z]{2}$'),
  -- numeric(_,2) rounds to ~1 km on write (SPEC 6.1).
  lat numeric(5, 2) check (lat between -90 and 90),
  lng numeric(5, 2) check (lng between -180 and 180),
  occupation text check (char_length(occupation) <= 60),
  bio text check (char_length(bio) <= 500),
  height_cm smallint check (height_cm between 120 and 230),
  languages text[] not null default '{}' check (cardinality(languages) <= 10),
  zodiac public.zodiac_sign,
  drinks public.habit_frequency,
  smokes public.habit_frequency,
  pets text[] not null default '{}'
    check (pets <@ array['dog', 'cat', 'other', 'none', 'want']),
  music_genres public.music_genre[] not null default '{}',
  favorite_djs text[] not null default '{}'
    check (cardinality(favorite_djs) <= 10),
  modes public.app_mode[] not null default '{}',
  date_looking_for public.date_intent,
  -- Empty array = show everyone.
  date_show_me public.gender[] not null default '{}',
  date_age_min smallint not null default 18 check (date_age_min >= 18),
  date_age_max smallint not null default 99
    check (date_age_max <= 99 and date_age_max >= date_age_min),
  crew_same_gender_only boolean not null default false,
  role public.user_role not null default 'user',
  status public.account_status not null default 'active',
  is_verified boolean not null default false,
  onboarding_completed boolean not null default false,
  terms_accepted_at timestamptz,
  terms_version text,
  last_active_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_onboarding_requires_basics check (
    not onboarding_completed or (
      first_name is not null
      and birth_date is not null
      and gender is not null
      and cardinality(modes) >= 1
      and terms_accepted_at is not null
    )
  )
);

comment on column public.profiles.date_show_me is
  'Genders shown in Date mode. Empty array means everyone.';

create index profiles_city_idx on public.profiles (state, city);
create index profiles_last_active_idx on public.profiles (last_active_at desc);

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function private.set_updated_at();

-- ---------------------------------------------------------------------------
-- user_private: phone (SPEC 5.3). Only the owner reads it.
-- ---------------------------------------------------------------------------

create table public.user_private (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  phone text unique check (phone ~ '^\+[1-9][0-9]{7,14}$'),
  phone_verified_at timestamptz,
  updated_at timestamptz not null default now()
);

create trigger user_private_set_updated_at
  before update on public.user_private
  for each row execute function private.set_updated_at();

-- ---------------------------------------------------------------------------
-- blocks
-- ---------------------------------------------------------------------------

create table public.blocks (
  blocker_id uuid not null references public.profiles (id) on delete cascade,
  blocked_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);

create index blocks_blocked_idx on public.blocks (blocked_id);

-- ---------------------------------------------------------------------------
-- Helpers used by policies (private schema, SECURITY DEFINER to avoid RLS
-- recursion; each one only answers about the current user).
-- ---------------------------------------------------------------------------

create function private.is_blocked(p_a uuid, p_b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.blocks
    where (blocker_id = p_a and blocked_id = p_b)
       or (blocker_id = p_b and blocked_id = p_a)
  );
$$;

create function private.current_user_role()
returns public.user_role
language sql
stable
security definer
set search_path = ''
as $$
  select role from public.profiles where id = (select auth.uid());
$$;

create function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(private.current_user_role() = 'admin', false);
$$;

-- Curators and admins moderate events.
create function private.is_moderator()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(private.current_user_role() in ('curator', 'admin'), false);
$$;

-- Social features require an active account and a confirmed e-mail (SPEC 5.1).
create function private.can_socialize()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles p
    join auth.users u on u.id = p.id
    where p.id = (select auth.uid())
      and p.status = 'active'
      and u.email_confirmed_at is not null
  );
$$;

-- Whether the current user may see [p_target]'s public data.
create function private.is_visible_user(p_target uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select p_target = (select auth.uid())
    or exists (
      select 1 from public.profiles p
      where p.id = p_target
        and p.status = 'active'
        and not private.is_blocked((select auth.uid()), p_target)
    );
$$;

-- ---------------------------------------------------------------------------
-- profile_photos (2–6 per user, position 0 is the main one)
-- ---------------------------------------------------------------------------

create table public.profile_photos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  storage_path text not null unique,
  position smallint not null check (position between 0 and 5),
  created_at timestamptz not null default now(),
  -- Deferrable so reordering can swap positions inside one transaction.
  constraint profile_photos_position_unique
    unique (user_id, position) deferrable initially immediate,
  constraint profile_photos_path_owner
    check (storage_path like user_id::text || '/%')
);

create function private.enforce_photo_limit()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select count(*) from public.profile_photos where user_id = new.user_id) >= 6 then
    raise exception 'A profile can have at most 6 photos'
      using errcode = 'P0001', hint = 'photo_limit';
  end if;
  return new;
end;
$$;

create trigger profile_photos_limit
  before insert on public.profile_photos
  for each row execute function private.enforce_photo_limit();

-- Reorders the current user's photos: p_photo_ids[1] becomes position 0.
create function public.reorder_profile_photos(p_photo_ids uuid[])
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if (select count(*) from public.profile_photos where user_id = v_uid)
     <> cardinality(p_photo_ids)
     or exists (
       select 1 from unnest(p_photo_ids) as ids(id)
       where not exists (
         select 1 from public.profile_photos
         where profile_photos.id = ids.id and user_id = v_uid
       )
     ) then
    raise exception 'The list must contain exactly the user''s photos'
      using errcode = '22023';
  end if;

  set constraints public.profile_photos_position_unique deferred;
  update public.profile_photos ph
  set position = ids.ord - 1
  from unnest(p_photo_ids) with ordinality as ids(id, ord)
  where ph.id = ids.id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Auth hook: create the profile when the user signs up.
-- Sign-up metadata (options.data): first_name, last_name, birth_date.
-- A minor's birth_date violates the profiles check and aborts the sign-up.
-- ---------------------------------------------------------------------------

create function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, first_name, last_name, birth_date)
  values (
    new.id,
    nullif(btrim(new.raw_user_meta_data ->> 'first_name'), ''),
    nullif(btrim(new.raw_user_meta_data ->> 'last_name'), ''),
    nullif(new.raw_user_meta_data ->> 'birth_date', '')::date
  );
  insert into public.user_private (user_id) values (new.id);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

-- ---------------------------------------------------------------------------
-- Guard: users can't escalate privileges or rewrite protected fields.
-- Admins (and server-side code without a JWT) may change anything.
-- ---------------------------------------------------------------------------

create function private.prevent_role_change()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.id := old.id;
  new.created_at := old.created_at;

  -- Terms acceptance time is always the server clock (SPEC 5.1).
  if new.terms_version is distinct from old.terms_version then
    new.terms_accepted_at := now();
  else
    new.terms_accepted_at := old.terms_accepted_at;
  end if;

  if (select auth.uid()) is null or private.is_admin() then
    return new;
  end if;

  if new.role is distinct from old.role
     or new.status is distinct from old.status
     or new.is_verified is distinct from old.is_verified then
    raise exception 'Not allowed to change role, status or verification'
      using errcode = '42501';
  end if;

  -- Birth date is set once (sign-up/onboarding) and then locked.
  if old.birth_date is not null
     and new.birth_date is distinct from old.birth_date then
    raise exception 'Birth date cannot be changed' using errcode = '42501';
  end if;

  return new;
end;
$$;

create trigger profiles_prevent_role_change
  before update on public.profiles
  for each row execute function private.prevent_role_change();

-- Changing the phone number resets its verification.
create function private.reset_phone_verification()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.phone is distinct from old.phone then
    new.phone_verified_at := null;
  end if;
  return new;
end;
$$;

create trigger user_private_reset_phone_verification
  before update on public.user_private
  for each row execute function private.reset_phone_verification();

-- Mock phone verification (SPEC 5.3). Only works while the project is in
-- 'mock' mode; removed in the launch migration (Phase 10).
create function public.verify_phone_mock(p_code text)
returns timestamptz
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_verified_at timestamptz;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if private.setting('phone_verification_mode') is distinct from 'mock' then
    raise exception 'Mock phone verification is disabled'
      using errcode = '42501';
  end if;
  if p_code is distinct from '123456' then
    raise exception 'Invalid verification code'
      using errcode = '22023', hint = 'invalid_code';
  end if;

  update public.user_private
  set phone_verified_at = now()
  where user_id = v_uid and phone is not null
  returning phone_verified_at into v_verified_at;

  if v_verified_at is null then
    raise exception 'No phone number to verify'
      using errcode = '22023', hint = 'missing_phone';
  end if;
  return v_verified_at;
end;
$$;

-- ---------------------------------------------------------------------------
-- public_profiles: the only way to read other users (SPEC 5.4).
-- Exposes first name, age and city — never last name, birth date, phone,
-- e-mail or coordinates. Runs with the owner's rights on purpose (the
-- underlying profiles RLS only exposes the user's own row) and applies the
-- visibility rules itself.
-- ---------------------------------------------------------------------------

create view public.public_profiles
with (security_barrier = true)
as
select
  p.id,
  p.first_name,
  date_part('year', age(p.birth_date))::int as age,
  p.gender,
  case when p.show_orientation then p.orientation end as orientation,
  p.city,
  p.state,
  p.occupation,
  p.bio,
  p.height_cm,
  p.languages,
  p.zodiac,
  p.drinks,
  p.smokes,
  p.pets,
  p.music_genres,
  p.favorite_djs,
  p.modes,
  p.date_looking_for,
  p.is_verified,
  p.last_active_at
from public.profiles p
where (select auth.uid()) is not null
  and (
    p.id = (select auth.uid())
    or (
      p.status = 'active'
      and p.onboarding_completed
      and not private.is_blocked((select auth.uid()), p.id)
    )
  );

-- ---------------------------------------------------------------------------
-- RLS + grants
-- ---------------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.user_private enable row level security;
alter table public.blocks enable row level security;
alter table public.profile_photos enable row level security;

-- profiles: full row only for the owner (and admins). Inserts come from the
-- auth trigger, deletes from the account-deletion Edge Function.
create policy "profiles: owner or admin reads"
  on public.profiles for select to authenticated
  using (id = (select auth.uid()) or private.is_admin());

create policy "profiles: owner or admin updates"
  on public.profiles for update to authenticated
  using (id = (select auth.uid()) or private.is_admin())
  with check (id = (select auth.uid()) or private.is_admin());

revoke insert, delete, truncate on public.profiles from authenticated;

-- user_private: owner only; phone_verified_at only through the RPC.
create policy "user_private: owner reads"
  on public.user_private for select to authenticated
  using (user_id = (select auth.uid()));

create policy "user_private: owner updates phone"
  on public.user_private for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

revoke all on public.user_private from authenticated;
grant select on public.user_private to authenticated;
grant update (phone) on public.user_private to authenticated;

-- blocks: managed by the blocker.
create policy "blocks: blocker reads"
  on public.blocks for select to authenticated
  using (blocker_id = (select auth.uid()));

create policy "blocks: blocker creates"
  on public.blocks for insert to authenticated
  with check (blocker_id = (select auth.uid()));

create policy "blocks: blocker removes"
  on public.blocks for delete to authenticated
  using (blocker_id = (select auth.uid()));

revoke update on public.blocks from authenticated;

-- profile_photos: visible users' photos are readable; owner writes.
create policy "profile_photos: visible users"
  on public.profile_photos for select to authenticated
  using (private.is_visible_user(user_id));

create policy "profile_photos: owner inserts"
  on public.profile_photos for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy "profile_photos: owner deletes"
  on public.profile_photos for delete to authenticated
  using (user_id = (select auth.uid()));

-- Reordering goes through reorder_profile_photos().
revoke update on public.profile_photos from authenticated;

revoke all on public.public_profiles from anon;
grant select on public.public_profiles to authenticated;

revoke execute on function public.reorder_profile_photos(uuid[]) from public, anon;
grant execute on function public.reorder_profile_photos(uuid[]) to authenticated;
revoke execute on function public.verify_phone_mock(text) from public, anon;
grant execute on function public.verify_phone_mock(text) to authenticated;
