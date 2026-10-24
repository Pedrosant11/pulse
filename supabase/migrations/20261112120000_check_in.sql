-- Check-in: proof that someone was really at the party.
--   * GPS: on the party night (1 h before the start until the end), the app
--     reads the location once and check_in_gps() compares it with the
--     venue (event_venues). Within 300 m (plus the GPS accuracy, up to
--     200 m) counts. Mock locations are refused. Only "checked in at X"
--     is stored, never the coordinates.
--   * QR: the producer (or a curator) shows a code that changes every
--     minute (checkin_code(), HMAC of a per-party secret); the app scans it
--     (check_in_qr(), current or previous minute). Works where GPS doesn't.
--   * A push ~2 h after the start reminds who said "Eu vou" and hasn't
--     checked in (checkin_reminder).
--   * A check-in also marks "Eu vou" and, if asked, "Tô ON".
--   * Conquistas and the passport now count only check-ins; the producer's
--     panel shows how many really went.

insert into private.app_settings (key, value) values
  ('checkin_radius_m', '300'),
  ('checkin_hours_before', '1');

create table public.event_checkins (
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  method text not null check (method in ('gps', 'qr')),
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);
create index event_checkins_user_idx on public.event_checkins (user_id);

alter table public.event_checkins enable row level security;

create policy "event_checkins: own" on public.event_checkins
  for select to authenticated
  using (user_id = (select auth.uid()));

create table private.event_checkin_secrets (
  event_id uuid primary key references public.events (id) on delete cascade,
  secret text not null default encode(extensions.gen_random_bytes(32), 'hex')
);

-- The party is on (1 h before the start until the end) and approved.
create function private.checkin_open(p_event uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.events e
    where e.id = p_event
      and e.status = 'approved'
      and now() between e.starts_at - make_interval(hours => private.setting_int('checkin_hours_before'))
                    and e.ends_at
  );
$$;

-- Records the check-in (and "Eu vou", and "Tô ON" when asked).
create function private.record_checkin(p_event uuid, p_method text, p_on boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  insert into public.event_attendance (event_id, user_id) values (p_event, v_uid)
  on conflict do nothing;
  insert into public.event_checkins (event_id, user_id, method) values (p_event, v_uid, p_method)
  on conflict do nothing;
  if coalesce(p_on, false) then
    insert into public.event_on (event_id, user_id) values (p_event, v_uid)
    on conflict do nothing;
  end if;
end;
$$;

create function public.check_in_gps(
  p_event uuid,
  p_lat double precision,
  p_lng double precision,
  p_accuracy double precision default null,
  p_mocked boolean default false,
  p_on boolean default true
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_venue public.event_venues;
  v_meters double precision;
begin
  if (select auth.uid()) is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if not private.checkin_open(p_event) then
    raise exception 'Check-in only during the party' using errcode = 'P0001', hint = 'checkin_closed';
  end if;
  if coalesce(p_mocked, false) then
    raise exception 'Mock location' using errcode = 'P0001', hint = 'checkin_mocked';
  end if;
  select * into v_venue from public.event_venues v where v.event_id = p_event;
  if v_venue.lat is null or v_venue.lng is null then
    raise exception 'No venue point' using errcode = 'P0001', hint = 'checkin_no_venue';
  end if;
  v_meters := private.distance_km(p_lat::numeric, p_lng::numeric, v_venue.lat::numeric, v_venue.lng::numeric) * 1000;
  if v_meters > private.setting_int('checkin_radius_m') + least(coalesce(p_accuracy, 0), 200) then
    raise exception 'Too far from the party' using errcode = 'P0001', hint = 'checkin_too_far';
  end if;
  perform private.record_checkin(p_event, 'gps', p_on);
end;
$$;

revoke execute on function public.check_in_gps(uuid, double precision, double precision, double precision, boolean, boolean) from public, anon;
grant execute on function public.check_in_gps(uuid, double precision, double precision, double precision, boolean, boolean) to authenticated;

-- The code for minute p_minute (epoch minutes).
create function private.checkin_code_at(p_event uuid, p_minute bigint)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_secret text;
begin
  insert into private.event_checkin_secrets (event_id) values (p_event)
  on conflict do nothing;
  select s.secret into v_secret from private.event_checkin_secrets s where s.event_id = p_event;
  return upper(substr(encode(extensions.hmac(p_minute::text, v_secret, 'sha256'), 'hex'), 1, 8));
end;
$$;

-- For who can edit the party: the code to show now, and until when.
create function public.checkin_code(p_event uuid)
returns jsonb
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_minute bigint := floor(extract(epoch from now()) / 60);
begin
  if not private.can_edit_event_id(p_event) then
    raise exception 'Only who runs the party' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'code', private.checkin_code_at(p_event, v_minute),
    'expires_at', to_timestamp((v_minute + 1) * 60),
    'open', private.checkin_open(p_event),
    'checked_in', (select count(*) from public.event_checkins c where c.event_id = p_event)
  );
end;
$$;

revoke execute on function public.checkin_code(uuid) from public, anon;
grant execute on function public.checkin_code(uuid) to authenticated;

create function public.check_in_qr(p_event uuid, p_code text, p_on boolean default true)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_minute bigint := floor(extract(epoch from now()) / 60);
  v_code text := upper(btrim(coalesce(p_code, '')));
begin
  if (select auth.uid()) is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;
  if not private.checkin_open(p_event) then
    raise exception 'Check-in only during the party' using errcode = 'P0001', hint = 'checkin_closed';
  end if;
  if v_code not in (private.checkin_code_at(p_event, v_minute),
                    private.checkin_code_at(p_event, v_minute - 1)) then
    raise exception 'Invalid code' using errcode = 'P0001', hint = 'checkin_bad_code';
  end if;
  perform private.record_checkin(p_event, 'qr', p_on);
end;
$$;

revoke execute on function public.check_in_qr(uuid, text, boolean) from public, anon;
grant execute on function public.check_in_qr(uuid, text, boolean) to authenticated;

-- Reminder ~2 h after the start for who said "Eu vou" and hasn't checked in.
alter table private.event_push_log drop constraint event_push_log_kind_check;
alter table private.event_push_log add constraint event_push_log_kind_check
  check (kind in ('event_dj', 'event_new', 'event_reminder', 'venue_new', 'after_party', 'checkin_reminder'));

create function private.send_checkin_reminders()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_row record;
  v_count int := 0;
begin
  for v_row in
    select e.id, e.name, array_agg(ea.user_id) as users
    from public.events e
    join public.event_attendance ea on ea.event_id = e.id
    join public.profiles p on p.id = ea.user_id
    where e.status = 'approved'
      and e.starts_at between now() - interval '3 hours' and now() - interval '2 hours'
      and e.ends_at > now()
      and p.status = 'active'
      and p.notify_events
      and not exists (
        select 1 from public.event_checkins c where c.event_id = e.id and c.user_id = ea.user_id
      )
      and not exists (
        select 1 from private.event_push_log l
        where l.user_id = ea.user_id and l.event_id = e.id and l.kind = 'checkin_reminder'
      )
    group by e.id, e.name
  loop
    insert into private.event_push_log (user_id, event_id, kind)
    select unnest(v_row.users), v_row.id, 'checkin_reminder'
    on conflict do nothing;
    perform private.send_push(
      v_row.users, 'checkin_reminder',
      jsonb_build_object('route', '/events/' || v_row.id, 'event', v_row.name)
    );
    v_count := v_count + cardinality(v_row.users);
  end loop;
  return v_count;
end;
$$;

select cron.schedule(
  'checkin-reminders',
  '40 * * * *',
  $$select private.send_checkin_reminders()$$
);

-- Conquistas and the passport: only parties with a check-in.
create or replace function private.past_parties(p_user uuid)
returns setof public.events
language sql
stable
security definer
set search_path = ''
as $$
  select e.*
  from public.events e
  join public.event_checkins c on c.event_id = e.id and c.user_id = p_user
  where e.status = 'approved';
$$;

-- My check-ins (event detail: done or not).
create function public.my_checkin(p_event uuid)
returns timestamptz
language sql
stable
security definer
set search_path = ''
as $$
  select c.created_at from public.event_checkins c
  where c.event_id = p_event and c.user_id = (select auth.uid());
$$;

revoke execute on function public.my_checkin(uuid) from public, anon;
grant execute on function public.my_checkin(uuid) to authenticated;

-- Producer's panel: how many really went.
create or replace function public.get_event_insights(p_event_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_min constant int := 5;
begin
  if not exists (
    select 1 from public.events e
    where e.id = p_event_id
      and (e.created_by = v_uid or private.is_moderator())
  ) then
    raise exception 'Only the creator or moderators' using errcode = '42501';
  end if;

  return (
    with people as (
      select p.modes, p.gender, p.city, p.state, p.music_genres,
             date_part('year', age(p.birth_date))::int as age
      from public.event_attendance a
      join public.profiles p on p.id = a.user_id
      where a.event_id = p_event_id and p.status = 'active'
    ),
    total as (select count(*)::int as n from people)
    select jsonb_build_object(
      'going', total.n,
      'going_date', (select count(*) from people where 'date' = any (modes)),
      'going_crew', (select count(*) from people where 'crew' = any (modes)),
      'ticket_clicks', (select count(*) from public.ticket_clicks where event_id = p_event_id),
      'crews', (select count(*) from public.crews where event_id = p_event_id),
      'checked_in', (select count(*) from public.event_checkins where event_id = p_event_id),
      'breakdowns_hidden', total.n < v_min,
      'genres', case when total.n >= v_min then coalesce((
        select jsonb_agg(jsonb_build_object('genre', g, 'count', c) order by c desc)
        from (
          select g, count(*) c from people, unnest(music_genres) g
          group by g order by count(*) desc limit 5
        ) t
      ), '[]'::jsonb) end,
      'cities', case when total.n >= v_min then coalesce((
        select jsonb_agg(jsonb_build_object('city', city, 'state', state, 'count', c) order by c desc)
        from (
          select city, state, count(*) c from people where city is not null
          group by city, state order by count(*) desc limit 5
        ) t
      ), '[]'::jsonb) end,
      'genders', case when total.n >= v_min then coalesce((
        select jsonb_object_agg(coalesce(gender::text, 'unknown'), c)
        from (select gender, count(*) c from people group by gender) t
      ), '{}'::jsonb) end,
      'ages', case when total.n >= v_min then (
        select jsonb_build_object(
          '18_24', count(*) filter (where age < 25),
          '25_34', count(*) filter (where age between 25 and 34),
          '35_plus', count(*) filter (where age >= 35)
        ) from people
      ) end
    )
    from total
  );
end;
$$;

-- LGPD export: check-ins too (never coordinates).
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
    ), '[]'::jsonb),
    'followed_venues', coalesce((
      select jsonb_agg(jsonb_build_object('venue', v.name, 'since', f.created_at)
        order by f.created_at)
      from public.venue_follows f join public.venues v on v.id = f.venue_id
      where f.user_id = v_uid
    ), '[]'::jsonb),
    'venue_reviews', coalesce((
      select jsonb_agg(jsonb_build_object(
          'venue', v.name, 'rating', r.rating, 'comment', r.comment,
          'at', r.updated_at
        ) order by r.updated_at)
      from public.venue_reviews r join public.venues v on v.id = r.venue_id
      where r.user_id = v_uid
    ), '[]'::jsonb),
    'poll_votes', coalesce((
      select jsonb_agg(jsonb_build_object(
          'question', p.question, 'option', p.options[v.option + 1],
          'at', v.voted_at
        ) order by v.voted_at)
      from public.poll_votes v join public.polls p on p.id = v.poll_id
      where v.user_id = v_uid
    ), '[]'::jsonb),
    'saved_events', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', s.created_at)
        order by s.created_at)
      from public.event_saves s join public.events e on e.id = s.event_id
      where s.user_id = v_uid
    ), '[]'::jsonb),
    'on_tonight', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'at', o.created_at)
        order by o.created_at)
      from public.event_on o join public.events e on e.id = o.event_id
      where o.user_id = v_uid
    ), '[]'::jsonb),
    'check_ins', coalesce((
      select jsonb_agg(jsonb_build_object('event', e.name, 'method', c.method, 'at', c.created_at)
        order by c.created_at)
      from public.event_checkins c join public.events e on e.id = c.event_id
      where c.user_id = v_uid
    ), '[]'::jsonb)
  );
end;
$$;
