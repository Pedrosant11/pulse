-- Producers buy highlights for their own parties (SPEC roadmap 5, round 3):
--   * They pick 3, 7, 14 or 30 days; longer is cheaper per day. Prices live
--     in public.featured_prices (the admin changes them without a release).
--   * Two ways to pay: in the app through the store (consumable products
--     pulse_featured_N, applied by the RevenueCat webhook), or a request the
--     Pulse team settles directly (packages, several parties) and confirms
--     in the admin panel.
--   * Either way the highlight starts when paid, extends a running one and
--     respects the limit per region.

create table public.featured_prices (
  days int primary key check (days > 0),
  price_cents int not null check (price_cents > 0),
  store_product_id text not null unique
);

insert into public.featured_prices (days, price_cents, store_product_id) values
  (3, 7900, 'pulse_featured_3'),
  (7, 14900, 'pulse_featured_7'),
  (14, 24900, 'pulse_featured_14'),
  (30, 44900, 'pulse_featured_30');

alter table public.featured_prices enable row level security;

create policy "featured_prices: everyone reads" on public.featured_prices
  for select to authenticated using (true);
create policy "featured_prices: admin manages" on public.featured_prices
  for all to authenticated
  using (private.is_admin()) with check (private.is_admin());

create table public.featured_requests (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events (id) on delete cascade,
  requested_by uuid references public.profiles (id) on delete set null,
  days int not null check (days > 0),
  -- Price when asked (the table may change later).
  price_cents int not null,
  method text not null check (method in ('store', 'team')),
  status text not null default 'pending'
    check (status in ('pending', 'paid', 'rejected', 'cancelled')),
  created_at timestamptz not null default now(),
  decided_at timestamptz,
  decided_by uuid references public.profiles (id) on delete set null
);

-- One open request per party.
create unique index featured_requests_one_open
  on public.featured_requests (event_id) where status = 'pending';

alter table public.featured_requests enable row level security;

create policy "featured_requests: own or admin" on public.featured_requests
  for select to authenticated
  using (requested_by = (select auth.uid()) or private.is_admin());

revoke insert, update, delete on public.featured_requests from authenticated, anon;

-- Other highlights running now in the event's region.
create function private.featured_in_region(p_event public.events)
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::int
  from public.events o
  where o.id <> p_event.id
    and o.status = 'approved'
    and o.featured_until > now()
    and o.ends_at > now()
    and case
      when o.lat is not null and p_event.lat is not null then
        private.distance_km(o.lat, o.lng, p_event.lat, p_event.lng)
          <= private.setting_int('featured_region_km')
      else o.state = p_event.state
    end;
$$;

-- Region full and this party isn't featured yet.
create function private.featured_region_full(p_event public.events)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(p_event.featured_until <= now(), true)
     and private.featured_in_region(p_event)
         >= private.setting_int('featured_max_per_region');
$$;

-- Turns a paid highlight on, or adds the days to a running one.
create function private.apply_featured(p_event_id uuid, p_days int)
returns timestamptz
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_event public.events;
  v_until timestamptz;
begin
  select * into v_event from public.events where id = p_event_id for update;
  if v_event.id is null then
    raise exception 'event not found' using errcode = 'P0002';
  end if;
  if private.featured_region_full(v_event) then
    raise exception 'too many highlights in this region'
      using errcode = 'P0001', hint = 'featured_limit';
  end if;
  v_until := greatest(coalesce(v_event.featured_until, now()), now())
             + make_interval(days => p_days);
  update public.events set featured_until = v_until where id = p_event_id;
  return v_until;
end;
$$;

-- The admin's own switch follows the same limit (length counted from now).
create or replace function public.admin_feature_event(p_event_id uuid, p_days int)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_event public.events;
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  if p_days is not null then
    select * into v_event from public.events where id = p_event_id;
    if private.featured_region_full(v_event) then
      raise exception 'too many highlights in this region'
        using errcode = 'P0001', hint = 'featured_limit';
    end if;
  end if;
  update public.events
  set featured_until = case when p_days is null then null
                            else now() + make_interval(days => p_days) end
  where id = p_event_id;
end;
$$;

-- A producer asks to highlight one of their parties.
create function public.request_featured(p_event_id uuid, p_days int, p_method text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_event public.events;
  v_price int;
  v_id uuid;
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;
  select * into v_event from public.events where id = p_event_id;
  if v_event.id is null or v_event.created_by is distinct from v_uid then
    raise exception 'only the creator highlights a party' using errcode = '42501';
  end if;
  if v_event.status <> 'approved' or v_event.ends_at <= now() then
    raise exception 'party not open'
      using errcode = 'P0001', hint = 'featured_unavailable';
  end if;
  if p_method is null or p_method not in ('store', 'team') then
    raise exception 'bad method' using errcode = '22023';
  end if;
  select price_cents into v_price from public.featured_prices where days = p_days;
  if v_price is null then
    raise exception 'bad length' using errcode = '22023';
  end if;
  -- Say it now rather than after paying.
  if private.featured_region_full(v_event) then
    raise exception 'too many highlights in this region'
      using errcode = 'P0001', hint = 'featured_limit';
  end if;

  -- A new choice replaces an open one.
  update public.featured_requests set status = 'cancelled', decided_at = now()
  where event_id = p_event_id and status = 'pending';

  insert into public.featured_requests (event_id, requested_by, days, price_cents, method)
  values (p_event_id, v_uid, p_days, v_price, p_method)
  returning id into v_id;
  return v_id;
end;
$$;

revoke execute on function public.request_featured(uuid, int, text) from public, anon;
grant execute on function public.request_featured(uuid, int, text) to authenticated;

-- Paid: turn it on and tell the producer.
create function private.settle_featured(p_request uuid, p_admin uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_request public.featured_requests;
begin
  select * into v_request from public.featured_requests
  where id = p_request and status = 'pending' for update;
  if v_request.id is null then
    return;
  end if;
  perform private.apply_featured(v_request.event_id, v_request.days);
  update public.featured_requests
  set status = 'paid', decided_at = now(), decided_by = p_admin
  where id = p_request;
  if v_request.requested_by is not null then
    perform private.send_push(
      array[v_request.requested_by], 'featured_on',
      jsonb_build_object('route', '/events/' || v_request.event_id)
    );
  end if;
end;
$$;

-- Admin: the team request was paid (approve) or won't happen (reject).
create function public.admin_review_featured(p_request uuid, p_approve boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  if p_approve then
    perform private.settle_featured(p_request, auth.uid());
  else
    update public.featured_requests
    set status = 'rejected', decided_at = now(), decided_by = auth.uid()
    where id = p_request and status = 'pending';
  end if;
end;
$$;

revoke execute on function public.admin_review_featured(uuid, boolean) from public, anon;
grant execute on function public.admin_review_featured(uuid, boolean) to authenticated;

-- Admin queue: open team requests with the party and who asked.
create function public.admin_featured_requests()
returns table (
  id uuid, event_id uuid, event_name text, event_starts_at timestamptz,
  city text, requester_name text, days int, price_cents int,
  created_at timestamptz
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  return query
  select r.id, r.event_id, e.name, e.starts_at, e.city, p.first_name,
         r.days, r.price_cents, r.created_at
  from public.featured_requests r
  join public.events e on e.id = r.event_id
  left join public.profiles p on p.id = r.requested_by
  where r.status = 'pending' and r.method = 'team'
  order by r.created_at;
end;
$$;

revoke execute on function public.admin_featured_requests() from public, anon;
grant execute on function public.admin_featured_requests() to authenticated;

-- Store purchases: a pulse_featured_N product pays the buyer's latest open
-- store request of N days.
create or replace function public.apply_store_event(p_event jsonb)
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
  v_request uuid;
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

    when v_type = 'NON_RENEWING_PURCHASE' and v_product like 'pulse_featured_%' then
      select r.id into v_request
      from public.featured_requests r
      join public.featured_prices fp on fp.days = r.days
      where r.requested_by = v_user and r.status = 'pending'
        and r.method = 'store' and fp.store_product_id = v_product
      order by r.created_at desc
      limit 1;
      if v_request is null then
        return 'featured: no open request';
      end if;
      perform private.settle_featured(v_request, null);
      return 'featured: ' || v_request;

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
