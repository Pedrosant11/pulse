-- Plans and purchases (product decision, 2026-10-10).
--
--   Free         50 likes/day, 1 superlike/week.
--   Pulse+       unlimited likes, rewind, travel mode, 5 superlikes/week.
--   Pulse Black  Pulse+ and who liked you, incognito, 1 boost/month.
--   One-off      superlike and boost packs (wallet).
--
-- Purchases happen in the stores (Google Play / App Store, required for
-- digital goods). RevenueCat validates them and calls the
-- `revenuecat-webhook` Edge Function, which applies each event here
-- (`apply_store_event`, service role only). Every limit is enforced below;
-- the app only shows them. Numbers live in private.app_settings.

insert into private.app_settings (key, value) values
  ('free_daily_likes', '50'),
  ('free_weekly_superlikes', '1'),
  ('plan_weekly_superlikes', '5'),
  ('black_monthly_boosts', '1'),
  ('boost_minutes', '30');

create function private.setting_int(p_key text)
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select value::int from private.app_settings where key = p_key;
$$;

-- Day/week/month boundaries follow Brazil (the audience).
create function private.period_start(p_unit text)
returns timestamptz
language sql
stable
set search_path = ''
as $$
  select date_trunc(p_unit, now() at time zone 'America/Sao_Paulo')
         at time zone 'America/Sao_Paulo';
$$;

-- ---------------------------------------------------------------------------
-- Plans, wallet and store events
-- ---------------------------------------------------------------------------

create type public.plan_tier as enum ('plus', 'black');

create table public.subscriptions (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  tier public.plan_tier not null,
  -- 'store' (RevenueCat) or 'admin' (granted, e.g. tests and partners).
  source text not null check (source in ('store', 'admin')),
  product_id text,
  expires_at timestamptz,
  will_renew boolean not null default false,
  updated_at timestamptz not null default now()
);

create table public.wallets (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  superlikes int not null default 0 check (superlikes >= 0),
  boosts int not null default 0 check (boosts >= 0),
  updated_at timestamptz not null default now()
);

-- One-off products sold in the stores (ids must match Play Console /
-- App Store Connect / RevenueCat).
create table private.store_products (
  product_id text primary key,
  superlikes int not null default 0,
  boosts int not null default 0
);

insert into private.store_products (product_id, superlikes, boosts) values
  ('pulse_superlikes_5', 5, 0),
  ('pulse_superlikes_15', 15, 0),
  ('pulse_boost_1', 0, 1),
  ('pulse_boosts_5', 0, 5);

-- Webhook events already applied (RevenueCat retries; ids make it safe).
create table private.store_events (
  id text primary key,
  user_id uuid,
  type text not null,
  product_id text,
  payload jsonb not null,
  created_at timestamptz not null default now()
);

alter table public.subscriptions enable row level security;
alter table public.wallets enable row level security;

create policy "subscriptions: own row" on public.subscriptions
  for select to authenticated using (user_id = (select auth.uid()));
create policy "wallets: own row" on public.wallets
  for select to authenticated using (user_id = (select auth.uid()));

revoke insert, update, delete on public.subscriptions, public.wallets
  from anon, authenticated;

-- Active plan of a person, or null.
create function private.plan_tier(p_user uuid)
returns public.plan_tier
language sql
stable
security definer
set search_path = ''
as $$
  select s.tier from public.subscriptions s
  where s.user_id = p_user
    and (s.expires_at is null or s.expires_at > now());
$$;

-- ---------------------------------------------------------------------------
-- Superlikes and the daily like limit
-- ---------------------------------------------------------------------------

alter table public.swipes
  add column is_super boolean not null default false,
  -- Paid from the wallet (refunded if undone).
  add column paid_super boolean not null default false;

create function private.before_swipe_limits()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_tier public.plan_tier := private.plan_tier(new.swiper_id);
  v_used int;
begin
  new.paid_super := false;
  if new.direction = 'pass' then
    new.is_super := false;
    return new;
  end if;

  if new.is_super then
    select count(*) into v_used from public.swipes
    where swiper_id = new.swiper_id
      and is_super and not paid_super
      and created_at >= private.period_start('week');
    if v_used >= private.setting_int(
         case when v_tier is null then 'free_weekly_superlikes'
              else 'plan_weekly_superlikes' end) then
      update public.wallets
      set superlikes = superlikes - 1, updated_at = now()
      where user_id = new.swiper_id and superlikes > 0;
      if not found then
        raise exception 'No superlikes left'
          using errcode = 'P0001', hint = 'superlike_limit';
      end if;
      new.paid_super := true;
    end if;
  elsif v_tier is null and (
    select count(*) from public.swipes
    where swiper_id = new.swiper_id
      and direction = 'like' and not is_super
      and created_at >= private.period_start('day')
  ) >= private.setting_int('free_daily_likes') then
    raise exception 'Daily likes used up'
      using errcode = 'P0001', hint = 'like_limit';
  end if;
  return new;
end;
$$;

create trigger swipes_limits
  before insert on public.swipes
  for each row execute function private.before_swipe_limits();

drop function public.swipe(uuid, public.app_mode, public.swipe_direction);

create function public.swipe(
  p_target uuid,
  p_mode public.app_mode,
  p_direction public.swipe_direction,
  p_super boolean default false
)
returns table (matched boolean, match_id uuid, conversation_id uuid)
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_match_id uuid;
  v_conversation_id uuid;
begin
  insert into public.swipes (swiper_id, swiped_id, mode, direction, is_super)
  values (v_uid, p_target, p_mode, p_direction, coalesce(p_super, false));

  if p_direction = 'like' then
    select m.id, c.id into v_match_id, v_conversation_id
    from public.matches m
    left join public.conversations c on c.match_id = m.id
    where m.user_a = least(v_uid, p_target)
      and m.user_b = greatest(v_uid, p_target)
      and m.mode = p_mode
      and m.unmatched_at is null;
  end if;

  return query select v_match_id is not null, v_match_id, v_conversation_id;
end;
$$;

revoke execute on function public.swipe(uuid, public.app_mode, public.swipe_direction, boolean) from public, anon;
grant execute on function public.swipe(uuid, public.app_mode, public.swipe_direction, boolean) to authenticated;

-- Rewind is a plan benefit; an undone paid superlike goes back to the
-- wallet.
create or replace function public.undo_last_swipe(p_mode public.app_mode)
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
  if private.plan_tier(v_uid) is null then
    raise exception 'Rewind needs a plan'
      using errcode = 'P0001', hint = 'plan_required';
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

  if v_swipe.paid_super then
    update public.wallets set superlikes = superlikes + 1, updated_at = now()
    where user_id = v_uid;
  end if;
  return v_swipe.swiped_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Boost: shown first in Discover for 30 minutes
-- ---------------------------------------------------------------------------

create table public.boosts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  -- Monthly Black allowance (true) or wallet (false).
  from_allowance boolean not null,
  starts_at timestamptz not null default now(),
  ends_at timestamptz not null
);

create index boosts_active_idx on public.boosts (user_id, ends_at desc);

alter table public.boosts enable row level security;
create policy "boosts: own rows" on public.boosts
  for select to authenticated using (user_id = (select auth.uid()));
revoke insert, update, delete on public.boosts from anon, authenticated;

create function public.activate_boost()
returns timestamptz
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_allowance boolean := false;
  v_ends timestamptz;
begin
  if v_uid is null or not private.can_socialize() then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  if not exists (
    select 1 from public.profiles where id = v_uid and cardinality(modes) > 0
  ) then
    raise exception 'A mode is required' using errcode = '42501';
  end if;
  if exists (
    select 1 from public.boosts where user_id = v_uid and ends_at > now()
  ) then
    raise exception 'A boost is already running'
      using errcode = 'P0001', hint = 'boost_active';
  end if;

  if private.plan_tier(v_uid) = 'black' and (
    select count(*) from public.boosts
    where user_id = v_uid and from_allowance
      and starts_at >= private.period_start('month')
  ) < private.setting_int('black_monthly_boosts') then
    v_allowance := true;
  else
    update public.wallets set boosts = boosts - 1, updated_at = now()
    where user_id = v_uid and boosts > 0;
    if not found then
      raise exception 'No boosts left'
        using errcode = 'P0001', hint = 'boost_unavailable';
    end if;
  end if;

  v_ends := now() + make_interval(mins => private.setting_int('boost_minutes'));
  insert into public.boosts (user_id, from_allowance, ends_at)
  values (v_uid, v_allowance, v_ends);
  return v_ends;
end;
$$;

revoke execute on function public.activate_boost() from public, anon;
grant execute on function public.activate_boost() to authenticated;

-- ---------------------------------------------------------------------------
-- Travel mode and incognito
-- ---------------------------------------------------------------------------

-- Discover around another city (festival, trip). Works while a plan is
-- active; the row stays so it comes back with the plan.
create table public.travel_locations (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  city text not null,
  state text not null check (char_length(state) = 2),
  lat double precision not null check (lat between -90 and 90),
  lng double precision not null check (lng between -180 and 180),
  created_at timestamptz not null default now()
);

alter table public.travel_locations enable row level security;
create policy "travel_locations: own row" on public.travel_locations
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Only seen by people they liked. Effective with Black only.
alter table public.profiles
  add column incognito boolean not null default false;

create function private.is_incognito(p_user uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = p_user and p.incognito
      and private.plan_tier(p_user) = 'black'
  );
$$;

-- ---------------------------------------------------------------------------
-- Who liked you
-- ---------------------------------------------------------------------------

-- Pending likes on the user: not answered, not matched, not blocked.
create function private.likes_received(p_uid uuid)
returns table (
  user_id uuid,
  mode public.app_mode,
  is_super boolean,
  liked_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select s.swiper_id, s.mode, s.is_super, s.created_at
  from public.swipes s
  join public.profiles p on p.id = s.swiper_id
  join public.profiles me on me.id = p_uid
  where s.swiped_id = p_uid
    and s.direction = 'like'
    and p.status = 'active'
    and s.mode = any (p.modes)
    and s.mode = any (me.modes)
    and not private.is_blocked(p_uid, p.id)
    and not exists (
      select 1 from public.swipes r
      where r.swiper_id = p_uid and r.swiped_id = s.swiper_id and r.mode = s.mode
    );
$$;

-- Everyone sees how many.
create function public.get_likes_received_count()
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::int from private.likes_received((select auth.uid()));
$$;

-- Who they are: Pulse Black only.
create function public.get_likes_received()
returns table (
  user_id uuid,
  first_name text,
  age int,
  city text,
  photo_path text,
  mode public.app_mode,
  is_super boolean,
  liked_at timestamptz
)
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
  if private.plan_tier(v_uid) is distinct from 'black' then
    raise exception 'Who liked you needs Pulse Black'
      using errcode = 'P0001', hint = 'plan_required';
  end if;

  return query
  select
    l.user_id,
    p.first_name,
    date_part('year', age(p.birth_date))::int,
    p.city,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    l.mode,
    l.is_super,
    l.liked_at
  from private.likes_received(v_uid) l
  join public.profiles p on p.id = l.user_id
  order by l.is_super desc, l.liked_at desc;
end;
$$;

revoke execute on function public.get_likes_received_count() from public, anon;
grant execute on function public.get_likes_received_count() to authenticated;
revoke execute on function public.get_likes_received() from public, anon;
grant execute on function public.get_likes_received() to authenticated;

-- ---------------------------------------------------------------------------
-- What the app shows: plan, limits left, wallet
-- ---------------------------------------------------------------------------

create function public.get_my_entitlements()
returns table (
  tier public.plan_tier,
  source text,
  expires_at timestamptz,
  will_renew boolean,
  likes_left_today int,
  free_superlikes_left int,
  superlike_balance int,
  free_boosts_left int,
  boost_balance int,
  boost_ends_at timestamptz,
  travel_city text,
  travel_state text,
  incognito boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_tier public.plan_tier;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  v_tier := private.plan_tier(v_uid);

  return query
  select
    v_tier,
    s.source,
    s.expires_at,
    coalesce(s.will_renew, false),
    -- null = unlimited.
    case when v_tier is null then greatest(
      private.setting_int('free_daily_likes') - (
        select count(*)::int from public.swipes sw
        where sw.swiper_id = v_uid and sw.direction = 'like' and not sw.is_super
          and sw.created_at >= private.period_start('day')), 0)
    end,
    greatest(
      private.setting_int(case when v_tier is null then 'free_weekly_superlikes'
                               else 'plan_weekly_superlikes' end) - (
        select count(*)::int from public.swipes sw
        where sw.swiper_id = v_uid and sw.is_super and not sw.paid_super
          and sw.created_at >= private.period_start('week')), 0),
    coalesce(w.superlikes, 0),
    case when v_tier = 'black' then greatest(
      private.setting_int('black_monthly_boosts') - (
        select count(*)::int from public.boosts b
        where b.user_id = v_uid and b.from_allowance
          and b.starts_at >= private.period_start('month')), 0)
    else 0 end,
    coalesce(w.boosts, 0),
    (select max(b.ends_at) from public.boosts b
     where b.user_id = v_uid and b.ends_at > now()),
    t.city,
    t.state,
    p.incognito
  from public.profiles p
  left join public.subscriptions s
    on s.user_id = p.id and (s.expires_at is null or s.expires_at > now())
  left join public.wallets w on w.user_id = p.id
  left join public.travel_locations t on t.user_id = p.id
  where p.id = v_uid;
end;
$$;

revoke execute on function public.get_my_entitlements() from public, anon;
grant execute on function public.get_my_entitlements() to authenticated;

-- ---------------------------------------------------------------------------
-- Store events (RevenueCat webhook, service role only)
-- ---------------------------------------------------------------------------

-- Applies one RevenueCat event: subscriptions set the plan from the
-- entitlement ids ("black" beats "plus"); one-off purchases fill the wallet.
-- Returns what happened (for the function log).
create function public.apply_store_event(p_event jsonb)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_id text := p_event ->> 'id';
  v_type text := p_event ->> 'type';
  v_product text := p_event ->> 'product_id';
  v_user uuid;
  v_tier public.plan_tier;
  v_expires timestamptz;
  v_pack private.store_products;
begin
  if v_id is null or v_type is null then
    return 'ignored: malformed';
  end if;
  if exists (select 1 from private.store_events where id = v_id) then
    return 'ignored: duplicate';
  end if;

  begin
    v_user := (p_event ->> 'app_user_id')::uuid;
  exception when invalid_text_representation then
    v_user := null;
  end;
  insert into private.store_events (id, user_id, type, product_id, payload)
  values (v_id, v_user, v_type, v_product, p_event);

  if v_user is null
     or not exists (select 1 from public.profiles where id = v_user) then
    return 'ignored: unknown user';
  end if;

  v_tier := case
    when p_event -> 'entitlement_ids' ? 'black' then 'black'
    when p_event -> 'entitlement_ids' ? 'plus' then 'plus'
  end;
  v_expires := to_timestamp((p_event ->> 'expiration_at_ms')::bigint / 1000.0);

  case
    when v_type in ('INITIAL_PURCHASE', 'RENEWAL', 'PRODUCT_CHANGE',
                    'UNCANCELLATION', 'SUBSCRIPTION_EXTENDED',
                    'TEMPORARY_ENTITLEMENT_GRANT') and v_tier is not null then
      insert into public.subscriptions
        (user_id, tier, source, product_id, expires_at, will_renew)
      values (v_user, v_tier, 'store', v_product, v_expires, true)
      on conflict (user_id) do update
        set tier = excluded.tier, source = 'store',
            product_id = excluded.product_id,
            expires_at = excluded.expires_at, will_renew = true,
            updated_at = now();
      return 'plan: ' || v_tier;

    when v_type = 'CANCELLATION' then
      -- Still active until it expires.
      update public.subscriptions set will_renew = false, updated_at = now()
      where user_id = v_user and source = 'store';
      return 'plan: will not renew';

    when v_type = 'EXPIRATION' then
      delete from public.subscriptions where user_id = v_user and source = 'store';
      return 'plan: expired';

    when v_type = 'NON_RENEWING_PURCHASE' then
      select * into v_pack from private.store_products where product_id = v_product;
      if v_pack.product_id is null then
        return 'ignored: unknown product';
      end if;
      insert into public.wallets (user_id, superlikes, boosts)
      values (v_user, v_pack.superlikes, v_pack.boosts)
      on conflict (user_id) do update
        set superlikes = public.wallets.superlikes + excluded.superlikes,
            boosts = public.wallets.boosts + excluded.boosts,
            updated_at = now();
      return 'wallet: ' || v_product;

    else
      return 'ignored: ' || v_type;
  end case;
end;
$$;

revoke execute on function public.apply_store_event(jsonb) from public, anon, authenticated;
grant execute on function public.apply_store_event(jsonb) to service_role;

-- ---------------------------------------------------------------------------
-- Admin: grant a plan or packs (tests, partners, support)
-- ---------------------------------------------------------------------------

-- p_tier null removes a granted plan. p_days null = no end date.
create function public.admin_grant_plan(
  p_user uuid,
  p_tier public.plan_tier,
  p_days int default 30
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  if p_tier is null then
    delete from public.subscriptions where user_id = p_user and source = 'admin';
    return;
  end if;
  insert into public.subscriptions (user_id, tier, source, expires_at)
  values (p_user, p_tier, 'admin',
          case when p_days is null then null else now() + make_interval(days => p_days) end)
  on conflict (user_id) do update
    set tier = excluded.tier, source = 'admin', product_id = null,
        expires_at = excluded.expires_at, will_renew = false, updated_at = now();
end;
$$;

create function public.admin_grant_wallet(
  p_user uuid,
  p_superlikes int default 0,
  p_boosts int default 0
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  insert into public.wallets (user_id, superlikes, boosts)
  values (p_user, greatest(p_superlikes, 0), greatest(p_boosts, 0))
  on conflict (user_id) do update
    set superlikes = public.wallets.superlikes + greatest(p_superlikes, 0),
        boosts = public.wallets.boosts + greatest(p_boosts, 0),
        updated_at = now();
end;
$$;

-- What an admin sees about someone's plan (manage sheet).
create function public.admin_get_plan(p_user uuid)
returns table (
  tier public.plan_tier,
  source text,
  expires_at timestamptz,
  superlike_balance int,
  boost_balance int
)
language sql
stable
security definer
set search_path = ''
as $$
  select s.tier, s.source, s.expires_at,
         coalesce(w.superlikes, 0), coalesce(w.boosts, 0)
  from (select p_user as id) u
  left join public.subscriptions s
    on s.user_id = u.id and (s.expires_at is null or s.expires_at > now())
  left join public.wallets w on w.user_id = u.id
  where private.is_admin();
$$;

revoke execute on function public.admin_grant_plan(uuid, public.plan_tier, int) from public, anon;
grant execute on function public.admin_grant_plan(uuid, public.plan_tier, int) to authenticated;
revoke execute on function public.admin_grant_wallet(uuid, int, int) from public, anon;
grant execute on function public.admin_grant_wallet(uuid, int, int) to authenticated;
revoke execute on function public.admin_get_plan(uuid) from public, anon;
grant execute on function public.admin_get_plan(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Discover: travel mode, boosts first, superlikes first, incognito
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
  crew_size int,
  super_liked_me boolean
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
  v_travel public.travel_locations;
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

  -- Travel mode (plan): discover around the chosen city, even without an
  -- event marked there yet.
  if private.plan_tier(v_uid) is not null then
    select * into v_travel from public.travel_locations t where t.user_id = v_uid;
    if v_travel.user_id is not null then
      v_me.lat := v_travel.lat;
      v_me.lng := v_travel.lng;
      v_me.city := v_travel.city;
      v_me.state := v_travel.state;
    end if;
  end if;

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
      private.distance_km(v_me.lat, v_me.lng, p.lat, p.lng) as dist,
      exists (
        select 1 from public.swipes s
        where s.swiper_id = p.id and s.swiped_id = v_uid and s.mode = p_mode
          and s.direction = 'like' and s.is_super
      ) as super_like,
      exists (
        select 1 from public.boosts b
        where b.user_id = p.id and b.ends_at > now()
      ) as boosted
    from public.profiles p
    where (exists (select 1 from my_events) or v_travel.user_id is not null)
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
      -- Incognito: only people they liked see them.
      and (not private.is_incognito(p.id) or exists (
        select 1 from public.swipes s
        where s.swiper_id = p.id and s.swiped_id = v_uid and s.direction = 'like'
      ))
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
    ), 0) end,
    r.super_like
  from ranked r
  -- Fallback profiles only when nobody shares an event.
  where not r.fallback or not exists (select 1 from ranked x where not x.fallback)
  order by
    -- Boosts, then people who superliked the viewer.
    r.boosted desc,
    r.super_like desc,
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

-- Incognito people stay off event attendee lists (except for matches).
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
    and (m.matched or not private.is_incognito(p.id))
    and not private.is_blocked(me.id, p.id)
  order by m.matched desc, ea.created_at desc
  limit least(greatest(coalesce(p_limit, 60), 1), 200);
$$;

-- ---------------------------------------------------------------------------
-- LGPD export: plan, wallet, boosts and travel city too
-- ---------------------------------------------------------------------------

alter function public.export_my_data() rename to export_my_data_base;
alter function public.export_my_data_base() set schema private;
revoke execute on function private.export_my_data_base() from public, anon, authenticated;

create function public.export_my_data()
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
    )
  );
end;
$$;

revoke execute on function public.export_my_data() from public, anon;
grant execute on function public.export_my_data() to authenticated;

-- Purchase records are kept 5 years (consumer and tax rules; Privacy
-- Policy), then removed daily.
create function private.purge_store_events()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  delete from private.store_events where created_at < now() - interval '5 years';
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

select cron.schedule(
  'purge-store-events',
  '30 3 * * *',
  'select private.purge_store_events()'
);
