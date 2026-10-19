-- Profile prompts (Hinge-style): up to 3 short answers to questions about
-- the night ("Meu set dos sonhos é…"). They give people something to talk
-- about besides "oi". Same visibility as profile photos.

create table public.profile_prompts (
  user_id uuid not null references public.profiles (id) on delete cascade,
  position smallint not null check (position between 0 and 2),
  prompt text not null check (prompt in (
    'dream_set', 'on_the_floor', 'after_party', 'best_party', 'track_on_repeat',
    'festival_must', 'green_flag', 'crew_role', 'match_if', 'wins_me_over'
  )),
  answer text not null check (char_length(btrim(answer)) between 1 and 150),
  updated_at timestamptz not null default now(),
  primary key (user_id, position),
  -- The same question only once per profile.
  unique (user_id, prompt)
);

alter table public.profile_prompts enable row level security;

create policy "profile_prompts: visible users"
  on public.profile_prompts for select to authenticated
  using (private.is_visible_user(user_id));

-- Writes go through set_profile_prompts() (all at once, in order).
revoke insert, update, delete on public.profile_prompts from authenticated, anon;

-- Replaces the caller's prompts with [p_prompts]: [{prompt, answer}, ...].
create function public.set_profile_prompts(p_prompts jsonb)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;
  if jsonb_typeof(p_prompts) <> 'array' or jsonb_array_length(p_prompts) > 3 then
    raise exception 'up to 3 prompts' using errcode = '22023';
  end if;

  delete from public.profile_prompts where user_id = v_uid;
  insert into public.profile_prompts (user_id, position, prompt, answer)
  select v_uid, (item.ordinality - 1)::smallint, item.value ->> 'prompt',
         btrim(item.value ->> 'answer')
  from jsonb_array_elements(p_prompts) with ordinality as item;
end;
$$;

revoke execute on function public.set_profile_prompts(jsonb) from public, anon;
grant execute on function public.set_profile_prompts(jsonb) to authenticated;

-- LGPD export: the answers too.
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
    ), '[]'::jsonb)
  );
end;
$$;
