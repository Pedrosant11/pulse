-- "Só eventos": a profile may have no mode (empty `modes`) and use only the
-- events side of the app (product decision, 2026-10-10).
--
-- Such a person:
--   * finishes onboarding without photos or gender (only name, city, music);
--   * is invisible: not in Discover (already filtered by mode), not in event
--     attendee lists, can't be liked, invited to a crew or join one;
--   * still counts in an event's total "going".
-- Turning on Date or Crew later requires the full profile (2 photos and
-- gender), checked here when `modes` stops being empty.

-- ---------------------------------------------------------------------------
-- Onboarding requirements
-- ---------------------------------------------------------------------------

alter table public.profiles
  drop constraint profiles_onboarding_requires_basics,
  add constraint profiles_onboarding_requires_basics check (
    not onboarding_completed or (
      first_name is not null
      and birth_date is not null
      and terms_accepted_at is not null
      and (cardinality(modes) = 0 or gender is not null)
    )
  );

-- New step order (app OnboardingStep): 0 intent, 1 photos, 2 basics,
-- 3 location, 4 about, 5 music, 6 modes, 7 first event, 8 done. People in
-- the middle of the old flow restart at the first step (their answers stay).
alter table public.profiles drop constraint profiles_onboarding_step_check;
update public.profiles
set onboarding_step = case when onboarding_completed then 8 else 0 end;
alter table public.profiles
  add constraint profiles_onboarding_step_check
    check (onboarding_step between 0 and 8);

-- 2 photos only for people with a mode: when finishing onboarding with one,
-- or when an onboarded "events only" profile turns a mode on.
create or replace function private.enforce_onboarding_photos()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.onboarding_completed
     and cardinality(new.modes) > 0
     and (not old.onboarding_completed or cardinality(old.modes) = 0)
     and (select count(*) from public.profile_photos where user_id = new.id) < 2 then
    raise exception 'At least 2 photos are required'
      using errcode = 'P0001', hint = 'min_photos';
  end if;
  return new;
end;
$$;

drop trigger profiles_enforce_onboarding_photos on public.profiles;
create trigger profiles_enforce_onboarding_photos
  before update of onboarding_completed, modes on public.profiles
  for each row execute function private.enforce_onboarding_photos();

create or replace function private.guard_min_photos()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (
       select 1 from public.profiles
       where id = old.user_id
         and onboarding_completed
         and cardinality(modes) > 0
     )
     and (select count(*) from public.profile_photos where user_id = old.user_id) <= 2 then
    raise exception 'A profile needs at least 2 photos'
      using errcode = 'P0001', hint = 'min_photos';
  end if;
  return old;
end;
$$;

-- ---------------------------------------------------------------------------
-- Invisible without the mode
-- ---------------------------------------------------------------------------

-- Liking needs the mode on both sides (the feed already only shows those).
create function private.guard_swipe_modes()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select count(*) from public.profiles p
      where p.id in (new.swiper_id, new.swiped_id)
        and new.mode = any (p.modes)) < 2 then
    raise exception 'Both people need this mode on'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger swipes_guard_modes
  before insert on public.swipes
  for each row execute function private.guard_swipe_modes();

-- Creating, asking to join or being invited to a crew needs Crew mode.
create function private.raise_crew_mode_required()
returns void
language plpgsql
set search_path = ''
as $$
begin
  raise exception 'Crew mode is required'
    using errcode = 'P0001', hint = 'crew_mode_required';
end;
$$;

create function private.guard_crew_owner_mode()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.profiles
    where id = new.owner_id and 'crew' = any (modes)
  ) then
    perform private.raise_crew_mode_required();
  end if;
  return new;
end;
$$;

-- Runs after crews_before_insert (alphabetical), which sets owner_id.
create trigger crews_guard_owner_mode
  before insert on public.crews
  for each row execute function private.guard_crew_owner_mode();

create function private.guard_crew_request_mode()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.profiles
    where id = new.user_id and 'crew' = any (modes)
  ) then
    perform private.raise_crew_mode_required();
  end if;
  return new;
end;
$$;

create trigger crew_join_requests_guard_mode
  before insert on public.crew_join_requests
  for each row execute function private.guard_crew_request_mode();

-- Attendee avatars: only people with a mode (counts still include everyone).
create or replace function public.get_event_attendees(p_event_id uuid, p_limit int default 60)
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  modes public.app_mode[],
  is_match boolean
)
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select (select auth.uid()) as id)
  select
    p.id,
    case when m.matched then p.first_name end,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    p.modes,
    m.matched
  from public.event_attendance ea
  join public.events e on e.id = ea.event_id
  join public.profiles p on p.id = ea.user_id
  cross join me
  cross join lateral (
    select exists (
      select 1 from public.matches mt
      where mt.unmatched_at is null
        and mt.user_a = least(me.id, p.id)
        and mt.user_b = greatest(me.id, p.id)
    ) as matched
  ) m
  where ea.event_id = p_event_id
    and me.id is not null
    and (e.status = 'approved' or e.created_by = me.id or private.is_moderator())
    and p.id <> me.id
    and p.status = 'active'
    and p.onboarding_completed
    and cardinality(p.modes) > 0
    and not private.is_blocked(me.id, p.id)
  order by m.matched desc, ea.created_at desc
  limit least(greatest(coalesce(p_limit, 60), 1), 200);
$$;

create or replace function public.get_crew_invite_candidates(p_crew_id uuid)
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
    and 'crew' = any (p.modes)
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
