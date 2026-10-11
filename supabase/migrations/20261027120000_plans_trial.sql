-- Plans, round 2 (launch plan):
--   * Free trial: on a person's first match ever, 3 days of Pulse Black.
--     Granted here (no store, no payment details, no auto-renewal), once
--     per person. A store purchase simply replaces it.
--   * Weekly / monthly / annual subscriptions are store products only (no
--     database change: the plan comes from the entitlement ids).

insert into private.app_settings (key, value) values ('trial_days', '3');

alter table public.subscriptions drop constraint subscriptions_source_check;
alter table public.subscriptions
  add constraint subscriptions_source_check
    check (source in ('store', 'admin', 'trial'));

-- Who already had the trial (survives the subscription row changing).
create table private.trials (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  granted_at timestamptz not null default now()
);

create function private.grant_first_match_trial(p_user uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_user is null
     or exists (select 1 from private.trials where user_id = p_user) then
    return;
  end if;
  insert into private.trials (user_id) values (p_user);

  -- Someone with a plan doesn't need it (and won't get it later).
  if private.plan_tier(p_user) is not null then
    return;
  end if;

  insert into public.subscriptions (user_id, tier, source, expires_at)
  values (
    p_user, 'black', 'trial',
    now() + make_interval(days => private.setting_int('trial_days'))
  )
  on conflict (user_id) do update
    set tier = 'black', source = 'trial', product_id = null,
        expires_at = excluded.expires_at, will_renew = false,
        updated_at = now()
    -- Only over an expired row.
    where public.subscriptions.expires_at is not null
      and public.subscriptions.expires_at <= now();

  perform private.send_push(
    array[p_user], 'trial_started', jsonb_build_object('route', '/plans')
  );
end;
$$;

create function private.trial_on_first_match()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform private.grant_first_match_trial(new.user_a);
  perform private.grant_first_match_trial(new.user_b);
  return new;
end;
$$;

create trigger matches_first_trial
  after insert on public.matches
  for each row execute function private.trial_on_first_match();
