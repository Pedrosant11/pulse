-- Admin web console: the numbers for the dashboard and the app settings
-- that used to need SQL (prices of highlights stay in featured_prices).
-- Admins only; everything else the console does goes through the same
-- RPCs and RLS as the admin screens in the app.

create function public.admin_dashboard()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_today date := (now() at time zone 'America/Sao_Paulo')::date;
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;

  return jsonb_build_object(
    'users', (
      select jsonb_build_object(
        'total', count(*) filter (where p.status = 'active' and p.onboarding_completed),
        'new_today', count(*) filter (
          where (p.created_at at time zone 'America/Sao_Paulo')::date = v_today),
        'new_7d', count(*) filter (where p.created_at > now() - interval '7 days'),
        'new_30d', count(*) filter (where p.created_at > now() - interval '30 days'),
        'active_24h', count(*) filter (
          where p.status = 'active' and p.last_active_at > now() - interval '24 hours'),
        'active_7d', count(*) filter (
          where p.status = 'active' and p.last_active_at > now() - interval '7 days'),
        'paused', count(*) filter (where p.paused_at is not null),
        'restricted', count(*) filter (where p.status <> 'active')
      )
      from public.profiles p
    ),
    'activity', jsonb_build_object(
      'matches_24h', (select count(*) from public.matches where created_at > now() - interval '24 hours'),
      'matches_7d', (select count(*) from public.matches where created_at > now() - interval '7 days'),
      'messages_24h', (select count(*) from public.messages where created_at > now() - interval '24 hours'),
      'messages_7d', (select count(*) from public.messages where created_at > now() - interval '7 days'),
      'upcoming_events', (
        select count(*) from public.events where status = 'approved' and ends_at > now()),
      'featured_now', (
        select count(*) from public.events
        where status = 'approved' and featured_until > now() and ends_at > now())
    ),
    'pending', jsonb_build_object(
      'events', (select count(*) from public.events where status = 'pending'),
      'reports', (select count(*) from public.reports where status = 'pending'),
      'verifications', (select count(*) from public.verification_requests where status = 'pending'),
      'badges', (select count(*) from public.badge_requests where status = 'pending'),
      'roles', (select count(*) from public.role_requests where status = 'pending'),
      'featured', (
        select count(*) from public.featured_requests
        where status = 'pending' and method = 'team')
    ),
    'plans', (
      select jsonb_build_object(
        'plus', count(*) filter (where s.tier = 'plus' and s.source <> 'trial'),
        'black', count(*) filter (where s.tier = 'black' and s.source <> 'trial'),
        'trial', count(*) filter (where s.source = 'trial'),
        'store', count(*) filter (where s.source = 'store')
      )
      from public.subscriptions s
      where s.expires_at is null or s.expires_at > now()
    ),
    'revenue_30d', jsonb_build_object(
      -- RevenueCat sends the price in USD ("price"), before the store's cut.
      'store_usd', coalesce((
        select round(sum((e.payload ->> 'price')::numeric), 2)
        from private.store_events e
        where e.created_at > now() - interval '30 days'
          and e.type in ('INITIAL_PURCHASE', 'RENEWAL', 'NON_RENEWING_PURCHASE')
          and e.payload ->> 'price' ~ '^-?[0-9.]+$'
      ), 0),
      'featured_team_cents', coalesce((
        select sum(r.price_cents) from public.featured_requests r
        where r.status = 'paid' and r.method = 'team'
          and r.decided_at > now() - interval '30 days'
      ), 0)
    ),
    -- Last 30 days, oldest first (Brazil dates).
    'daily', (
      select jsonb_agg(jsonb_build_object(
        'day', d.day,
        'signups', (
          select count(*) from public.profiles p
          where (p.created_at at time zone 'America/Sao_Paulo')::date = d.day),
        'matches', (
          select count(*) from public.matches m
          where (m.created_at at time zone 'America/Sao_Paulo')::date = d.day)
      ) order by d.day)
      from (
        select generate_series(v_today - 29, v_today, interval '1 day')::date as day
      ) d
    )
  );
end;
$$;

revoke execute on function public.admin_dashboard() from public, anon;
grant execute on function public.admin_dashboard() to authenticated;

-- Settings: read all, change existing numeric ones.
create function public.admin_settings()
returns table (key text, value text)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  return query select s.key, s.value from private.app_settings s order by s.key;
end;
$$;

create function public.admin_set_setting(p_key text, p_value int)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  if p_value is null or p_value < 0 then
    raise exception 'invalid value' using errcode = '22023';
  end if;
  update private.app_settings
  set value = p_value::text
  where key = p_key and value ~ '^[0-9]+$';
  if not found then
    raise exception 'unknown setting' using errcode = 'P0002';
  end if;
end;
$$;

revoke execute on function public.admin_settings() from public, anon;
grant execute on function public.admin_settings() to authenticated;
revoke execute on function public.admin_set_setting(text, int) from public, anon;
grant execute on function public.admin_set_setting(text, int) to authenticated;
