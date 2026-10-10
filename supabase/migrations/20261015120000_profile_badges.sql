-- Identification badges on profiles (SPEC 6.4): DJ, Equipe Pulse and
-- Figura pública, granted only by admins, plus "Produtor" derived from the
-- producer role. People can ask for DJ / Figura pública; Equipe Pulse is
-- admin-only. Not to be confused with is_verified (identity, post-MVP).

create type public.profile_badge as enum ('dj', 'team', 'public_figure');

create table public.profile_badges (
  user_id uuid not null references public.profiles (id) on delete cascade,
  badge public.profile_badge not null,
  -- Optional label chosen by the admin, e.g. "CEO" or "Residente D-Edge".
  title text check (char_length(btrim(title)) between 1 and 40),
  granted_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (user_id, badge)
);

create function private.before_profile_badge_write()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.granted_by := coalesce((select auth.uid()), new.granted_by);
  new.title := nullif(btrim(new.title), '');
  if tg_op = 'INSERT' then
    new.created_at := now();
  else
    new.user_id := old.user_id;
    new.badge := old.badge;
    new.created_at := old.created_at;
  end if;
  return new;
end;
$$;

create trigger profile_badges_before_write
  before insert or update on public.profile_badges
  for each row execute function private.before_profile_badge_write();

alter table public.profile_badges enable row level security;

create policy "profile_badges: visible people"
  on public.profile_badges for select to authenticated
  using (private.is_visible_user(user_id) or private.is_admin());

create policy "profile_badges: admins grant"
  on public.profile_badges for insert to authenticated
  with check (private.is_admin());

create policy "profile_badges: admins edit"
  on public.profile_badges for update to authenticated
  using (private.is_admin())
  with check (private.is_admin());

create policy "profile_badges: admins revoke"
  on public.profile_badges for delete to authenticated
  using (private.is_admin());

revoke all on public.profile_badges from anon;

-- ---------------------------------------------------------------------------
-- Requests ("Quero um selo"): same flow as role_requests.
-- ---------------------------------------------------------------------------

create table public.badge_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  badge public.profile_badge not null check (badge <> 'team'),
  justification text not null
    check (char_length(btrim(justification)) between 10 and 1000),
  links text[] not null default '{}' check (cardinality(links) <= 5),
  status public.request_status not null default 'pending',
  reviewed_by uuid references public.profiles (id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index badge_requests_one_pending_idx
  on public.badge_requests (user_id, badge) where status = 'pending';

create function private.before_badge_request_insert()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.user_id := coalesce((select auth.uid()), new.user_id);
  new.status := 'pending';
  new.reviewed_by := null;
  new.reviewed_at := null;
  new.created_at := now();
  if exists (
    select 1 from public.profile_badges
    where user_id = new.user_id and badge = new.badge
  ) then
    raise exception 'Badge already granted' using errcode = '23505',
      hint = 'badge_already_granted';
  end if;
  return new;
end;
$$;

create trigger badge_requests_before_insert
  before insert on public.badge_requests
  for each row execute function private.before_badge_request_insert();

create function private.before_badge_request_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.status <> 'pending' then
    raise exception 'Request already reviewed' using errcode = 'P0001';
  end if;
  new.user_id := old.user_id;
  new.badge := old.badge;
  new.justification := old.justification;
  new.links := old.links;
  new.created_at := old.created_at;
  if new.status <> 'cancelled' then
    new.reviewed_by := (select auth.uid());
    new.reviewed_at := now();
  end if;
  return new;
end;
$$;

create trigger badge_requests_before_update
  before update on public.badge_requests
  for each row execute function private.before_badge_request_update();

-- Approval grants the badge.
create function private.after_badge_request_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'approved' and old.status = 'pending' then
    insert into public.profile_badges (user_id, badge, granted_by)
    values (new.user_id, new.badge, new.reviewed_by)
    on conflict (user_id, badge) do nothing;
  end if;
  return new;
end;
$$;

create trigger badge_requests_after_update
  after update on public.badge_requests
  for each row execute function private.after_badge_request_update();

alter table public.badge_requests enable row level security;

create policy "badge_requests: requester or admin reads"
  on public.badge_requests for select to authenticated
  using (user_id = (select auth.uid()) or private.is_admin());

create policy "badge_requests: users request"
  on public.badge_requests for insert to authenticated
  with check (user_id = (select auth.uid()) and private.can_socialize());

create policy "badge_requests: admin reviews, requester cancels"
  on public.badge_requests for update to authenticated
  using (private.is_admin() or user_id = (select auth.uid()))
  with check (
    (private.is_admin() and status in ('approved', 'rejected'))
    or (user_id = (select auth.uid()) and status = 'cancelled')
  );

revoke delete on public.badge_requests from authenticated;
revoke update on public.badge_requests from authenticated;
grant update (status) on public.badge_requests to authenticated;
revoke all on public.badge_requests from anon;

-- ---------------------------------------------------------------------------
-- Reading badges: granted ones plus "producer" from the role (roles are
-- private, so this is a definer RPC). Hidden like the profile itself.
-- ---------------------------------------------------------------------------

create function public.get_user_badges(p_user_id uuid)
returns table (badge text, title text)
language sql
stable
security definer
set search_path = ''
as $$
  select b.badge, b.title
  from (
    select pb.badge::text as badge, pb.title
    from public.profile_badges pb
    where pb.user_id = p_user_id
    union all
    select 'producer', null
    from public.profiles p
    where p.id = p_user_id and p.role = 'producer'
  ) b
  where (select auth.uid()) is not null
    and private.is_visible_user(p_user_id)
  order by
    -- Equipe Pulse first, then DJ, Figura pública, Produtor.
    case b.badge when 'team' then 0 when 'dj' then 1 when 'public_figure' then 2 else 3 end;
$$;

-- Admin panel: find people by name to grant badges.
create function public.admin_search_users(p_query text)
returns table (
  user_id uuid,
  first_name text,
  last_name text,
  city text,
  state text,
  photo_path text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    p.id, p.first_name, p.last_name, p.city, p.state,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1)
  from public.profiles p
  where private.is_admin()
    and char_length(btrim(p_query)) >= 2
    and (
      lower(extensions.unaccent('extensions.unaccent'::regdictionary,
        coalesce(p.first_name, '') || ' ' || coalesce(p.last_name, '')))
      like '%' || lower(extensions.unaccent('extensions.unaccent'::regdictionary,
        btrim(p_query))) || '%'
    )
  order by p.first_name, p.last_name
  limit 30;
$$;

revoke execute on function public.get_user_badges(uuid) from public, anon;
grant execute on function public.get_user_badges(uuid) to authenticated;
revoke execute on function public.admin_search_users(text) from public, anon;
grant execute on function public.admin_search_users(text) to authenticated;
