-- Profile onboarding (SPEC 6.2): saved progress and photo rules.

-- Index of the next onboarding step to show, so the app resumes where the
-- user stopped (0 photos, 1 basics, 2 about me, 3 music, 4 modes, 5 first
-- event, 6 done).
alter table public.profiles
  add column onboarding_step smallint not null default 0
    check (onboarding_step between 0 and 6);

-- Completing the onboarding requires at least 2 photos (SPEC 6.1/6.2).
create function private.enforce_onboarding_photos()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.onboarding_completed
     and not old.onboarding_completed
     and (select count(*) from public.profile_photos where user_id = new.id) < 2 then
    raise exception 'At least 2 photos are required'
      using errcode = 'P0001', hint = 'min_photos';
  end if;
  return new;
end;
$$;

create trigger profiles_enforce_onboarding_photos
  before update of onboarding_completed on public.profiles
  for each row execute function private.enforce_onboarding_photos();

-- Once onboarded, a profile can't go below 2 photos. Deleting the whole
-- account cascades after the profile row is gone, so it is not blocked.
create function private.guard_min_photos()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (
       select 1 from public.profiles
       where id = old.user_id and onboarding_completed
     )
     and (select count(*) from public.profile_photos where user_id = old.user_id) <= 2 then
    raise exception 'A profile needs at least 2 photos'
      using errcode = 'P0001', hint = 'min_photos';
  end if;
  return old;
end;
$$;

create trigger profile_photos_guard_min
  before delete on public.profile_photos
  for each row execute function private.guard_min_photos();
