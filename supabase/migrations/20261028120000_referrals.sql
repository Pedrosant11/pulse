-- Referrals (SPEC roadmap 7):
--   * Everyone has a short code to share ("Indique e ganhe").
--   * A new person types a friend's code before their first match and gets
--     3 superlikes right away (useless on a fake account, so no gate).
--   * The friend who invited gets 3 superlikes + 1 boost only when the
--     invited person makes their first match, up to 10 rewards a month.
-- Amounts live in private.app_settings.

insert into private.app_settings (key, value) values
  ('referral_referrer_superlikes', '3'),
  ('referral_referrer_boosts', '1'),
  ('referral_referred_superlikes', '3'),
  ('referral_monthly_cap', '10');

create table private.referral_codes (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  code text not null unique check (code ~ '^[A-Z0-9]{6}$'),
  created_at timestamptz not null default now()
);

-- One row per invited person; kept if the friend deletes their account so
-- the code can't be used twice.
create table private.referrals (
  referred_id uuid primary key references public.profiles (id) on delete cascade,
  referrer_id uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  -- Set on the invited person's first match.
  rewarded_at timestamptz,
  -- False when the friend was over the monthly cap.
  referrer_rewarded boolean not null default false
);

create index referrals_referrer_idx on private.referrals (referrer_id, rewarded_at);

create function private.wallet_add(p_user uuid, p_superlikes int, p_boosts int)
returns void
language sql
security definer
set search_path = ''
as $$
  insert into public.wallets (user_id, superlikes, boosts)
  values (p_user, p_superlikes, p_boosts)
  on conflict (user_id) do update
    set superlikes = public.wallets.superlikes + excluded.superlikes,
        boosts = public.wallets.boosts + excluded.boosts,
        updated_at = now();
$$;

-- The caller's code (created on first use), how it went and whether they
-- can still type a friend's code.
create function public.get_my_referral()
returns table (
  code text,
  invited int,
  rewarded int,
  can_redeem boolean,
  referrer_superlikes int,
  referrer_boosts int,
  referred_superlikes int
)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_code text;
  v_alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  select c.code into v_code from private.referral_codes c where c.user_id = v_uid;
  while v_code is null loop
    v_code := (
      select string_agg(substr(v_alphabet, 1 + floor(random() * length(v_alphabet))::int, 1), '')
      from generate_series(1, 6)
    );
    begin
      insert into private.referral_codes (user_id, code) values (v_uid, v_code);
    exception when unique_violation then
      -- Same code taken (or a parallel call created ours): try again.
      select c.code into v_code from private.referral_codes c where c.user_id = v_uid;
    end;
  end loop;

  return query
  select
    v_code,
    (select count(*)::int from private.referrals r where r.referrer_id = v_uid),
    (select count(*)::int from private.referrals r
      where r.referrer_id = v_uid and r.referrer_rewarded),
    not exists (select 1 from private.referrals r where r.referred_id = v_uid)
      and not exists (
        select 1 from public.matches m where v_uid in (m.user_a, m.user_b)
      ),
    private.setting_int('referral_referrer_superlikes'),
    private.setting_int('referral_referrer_boosts'),
    private.setting_int('referral_referred_superlikes');
end;
$$;

revoke execute on function public.get_my_referral() from public, anon;
grant execute on function public.get_my_referral() to authenticated;

-- A new person types a friend's code.
create function public.redeem_referral(p_code text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_referrer uuid;
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  select c.user_id into v_referrer
  from private.referral_codes c
  where c.code = upper(btrim(coalesce(p_code, '')));

  if v_referrer is null then
    raise exception 'unknown code' using errcode = 'P0001', hint = 'referral_invalid';
  end if;
  -- Own code, or the friend used the caller's code (no swapping codes).
  if v_referrer = v_uid or exists (
    select 1 from private.referrals r
    where r.referred_id = v_referrer and r.referrer_id = v_uid
  ) then
    raise exception 'own code' using errcode = 'P0001', hint = 'referral_own';
  end if;
  if exists (select 1 from private.referrals r where r.referred_id = v_uid) then
    raise exception 'already used' using errcode = 'P0001', hint = 'referral_used';
  end if;
  if exists (select 1 from public.matches m where v_uid in (m.user_a, m.user_b)) then
    raise exception 'after first match' using errcode = 'P0001', hint = 'referral_too_late';
  end if;

  insert into private.referrals (referred_id, referrer_id) values (v_uid, v_referrer);
  perform private.wallet_add(
    v_uid, private.setting_int('referral_referred_superlikes'), 0
  );
end;
$$;

revoke execute on function public.redeem_referral(text) from public, anon;
grant execute on function public.redeem_referral(text) to authenticated;

-- The invited person's first match pays the friend (within the cap).
create function private.reward_referral(p_user uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_referrer uuid;
  v_paid boolean;
begin
  select r.referrer_id into v_referrer
  from private.referrals r
  where r.referred_id = p_user and r.rewarded_at is null
  for update;
  if not found then
    return;
  end if;

  v_paid := v_referrer is not null and (
    select count(*) from private.referrals r
    where r.referrer_id = v_referrer
      and r.referrer_rewarded
      and r.rewarded_at >= private.period_start('month')
  ) < private.setting_int('referral_monthly_cap');

  update private.referrals
  set rewarded_at = now(), referrer_rewarded = v_paid
  where referred_id = p_user;

  if v_paid then
    perform private.wallet_add(
      v_referrer,
      private.setting_int('referral_referrer_superlikes'),
      private.setting_int('referral_referrer_boosts')
    );
    perform private.send_push(
      array[v_referrer], 'referral_reward',
      jsonb_build_object('route', '/settings/referral')
    );
  end if;
end;
$$;

create function private.referral_on_match()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform private.reward_referral(new.user_a);
  perform private.reward_referral(new.user_b);
  return new;
end;
$$;

create trigger matches_referral_reward
  after insert on public.matches
  for each row execute function private.referral_on_match();

-- LGPD export: the code and who used it (no names of the invited).
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
    )
  );
end;
$$;
