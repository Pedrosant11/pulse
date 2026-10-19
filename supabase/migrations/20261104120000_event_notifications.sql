-- Event notifications (what brings people back between parties):
--   * event_dj: a party with a DJ the person follows (favorite_djs) was
--     approved near them.
--   * event_new: a party near them with a genre they like was approved.
--   * event_reminder: ~24 h before a party they're going to, with how many
--     people they liked are going too.
-- Near = within their discovery radius (same state without coordinates).
-- At most one "new party" push a day per person (DJ or genre); reminders
-- don't count. Anyone can turn them off ("Avisos de festas").
-- Event names and DJs are public, so they can show on the lock screen.

insert into private.app_settings (key, value) values
  ('event_push_daily_cap', '1'),
  ('event_push_horizon_days', '60');

alter table public.profiles add column notify_events boolean not null default true;

create function public.set_notify_events(p_enabled boolean)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.profiles set notify_events = coalesce(p_enabled, true)
  where id = auth.uid();
$$;

revoke execute on function public.set_notify_events(boolean) from public, anon;
grant execute on function public.set_notify_events(boolean) to authenticated;

-- Who got what (no repeats, daily cap).
create table private.event_push_log (
  user_id uuid not null references public.profiles (id) on delete cascade,
  event_id uuid not null references public.events (id) on delete cascade,
  kind text not null check (kind in ('event_dj', 'event_new', 'event_reminder')),
  sent_at timestamptz not null default now(),
  primary key (user_id, event_id, kind)
);

create index event_push_log_recent_idx on private.event_push_log (user_id, sent_at);

-- People near [p_event] who want event pushes and haven't used today's
-- "new party" push yet.
create function private.event_audience(p_event public.events)
returns setof public.profiles
language sql
stable
security definer
set search_path = ''
as $$
  select p.*
  from public.profiles p
  where p.status = 'active'
    and p.onboarding_completed
    and p.notify_events
    and p.id is distinct from p_event.created_by
    and not private.is_blocked(p.id, p_event.created_by)
    and not exists (
      select 1 from private.event_push_log l
      where l.user_id = p.id and l.event_id = p_event.id
    )
    and (
      select count(*) from private.event_push_log l
      where l.user_id = p.id
        and l.kind in ('event_dj', 'event_new')
        and l.sent_at > now() - interval '24 hours'
    ) < private.setting_int('event_push_daily_cap')
    and case
      when p.lat is not null and p_event.lat is not null then
        private.distance_km(p.lat, p.lng, p_event.lat, p_event.lng) <= p.discovery_radius_km
      else p.state = p_event.state
    end;
$$;

create function private.notify_new_event(p_event public.events)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_dj text;
  v_users uuid[];
  v_route text := '/events/' || p_event.id;
begin
  if p_event.starts_at > now() + make_interval(days => private.setting_int('event_push_horizon_days')) then
    return;
  end if;

  -- DJ fans first (one push per DJ, so the text can name them).
  foreach v_dj in array p_event.lineup loop
    select array_agg(a.id) into v_users
    from private.event_audience(p_event) a
    where exists (
      select 1 from unnest(a.favorite_djs) f
      where lower(btrim(f)) = lower(btrim(v_dj))
    );
    if v_users is not null then
      insert into private.event_push_log (user_id, event_id, kind)
      select unnest(v_users), p_event.id, 'event_dj'
      on conflict do nothing;
      perform private.send_push(
        v_users, 'event_dj',
        jsonb_build_object('route', v_route, 'event', p_event.name, 'dj', v_dj)
      );
    end if;
  end loop;

  -- Then people who like one of its genres.
  select array_agg(a.id) into v_users
  from private.event_audience(p_event) a
  where a.music_genres && p_event.genres;
  if v_users is not null then
    insert into private.event_push_log (user_id, event_id, kind)
    select unnest(v_users), p_event.id, 'event_new'
    on conflict do nothing;
    perform private.send_push(
      v_users, 'event_new',
      jsonb_build_object('route', v_route, 'event', p_event.name, 'city', p_event.city)
    );
  end if;
end;
$$;

create function private.on_event_approved()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'approved'
     and (tg_op = 'INSERT' or old.status is distinct from 'approved')
     and new.ends_at > now() then
    perform private.notify_new_event(new);
  end if;
  return new;
end;
$$;

create trigger events_notify_approved
  after insert or update of status on public.events
  for each row execute function private.on_event_approved();

-- Reminders: run hourly, for parties starting in 23–25 h.
create function private.send_event_reminders()
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
    select ea.user_id, e.id as event_id, e.name,
      (
        select count(*)::int
        from public.event_attendance other
        join public.swipes s
          on s.swiper_id = ea.user_id and s.swiped_id = other.user_id
         and s.direction = 'like'
        join public.profiles op on op.id = other.user_id and op.status = 'active'
        where other.event_id = e.id
          and other.user_id <> ea.user_id
          and not private.is_blocked(ea.user_id, other.user_id)
      ) as liked
    from public.events e
    join public.event_attendance ea on ea.event_id = e.id
    join public.profiles p on p.id = ea.user_id
    where e.status = 'approved'
      and e.starts_at between now() + interval '23 hours' and now() + interval '25 hours'
      and p.status = 'active'
      and p.notify_events
      and not exists (
        select 1 from private.event_push_log l
        where l.user_id = ea.user_id and l.event_id = e.id and l.kind = 'event_reminder'
      )
  loop
    insert into private.event_push_log (user_id, event_id, kind)
    values (v_row.user_id, v_row.event_id, 'event_reminder');
    perform private.send_push(
      array[v_row.user_id], 'event_reminder',
      jsonb_build_object(
        'route', '/events/' || v_row.event_id,
        'event', v_row.name,
        'liked', v_row.liked
      )
    );
    v_count := v_count + 1;
  end loop;
  return v_count;
end;
$$;

select cron.schedule(
  'event-reminders',
  '5 * * * *',
  $$select private.send_event_reminders()$$
);
