-- Ads:
--   * Own ads ("anúncios próprios"): parties and partners the admin sells
--     directly. Shown first; AdMob fills the slots when there are none.
--   * Slots: a card every N events in "Próximos" and every N profiles in
--     Discover. Never in chats, the match screen or safety screens.
--   * Who sees ads and how often lives in private.app_settings, so it can
--     change without a new app version.

insert into private.app_settings (key, value) values
  ('ads_enabled', '1'),
  -- 1 = paying people see ads too (the owner's choice at launch).
  ('ads_for_paid', '1'),
  ('ads_events_every', '6'),
  ('ads_discover_every', '20');

create table public.ads (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(btrim(title)) between 1 and 60),
  body text check (char_length(body) <= 140),
  -- Path in the public `ad-images` bucket.
  image_path text,
  cta text check (char_length(cta) <= 24),
  -- Where a tap goes: a party in the app, or a website.
  event_id uuid references public.events (id) on delete cascade,
  link_url text check (link_url ~ '^https://'),
  placements text[] not null default array['events', 'discover']
    check (placements <@ array['events', 'discover'] and cardinality(placements) > 0),
  starts_at timestamptz not null default now(),
  ends_at timestamptz,
  active boolean not null default true,
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  check (ends_at is null or ends_at > starts_at)
);

alter table public.ads enable row level security;

-- Only admins manage ads; everyone else gets them through get_ads().
create policy "ads: admin manages" on public.ads
  for all to authenticated
  using (private.is_admin())
  with check (private.is_admin());

-- Daily numbers per ad (for the advertiser), counted once per person a day.
create table private.ad_stats (
  ad_id uuid not null references public.ads (id) on delete cascade,
  day date not null,
  impressions int not null default 0,
  clicks int not null default 0,
  primary key (ad_id, day)
);

create table private.ad_seen (
  ad_id uuid not null references public.ads (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  day date not null,
  kind text not null check (kind in ('impression', 'click')),
  primary key (ad_id, user_id, day, kind)
);

-- What the app needs to place ads: on/off for this person, how often and
-- the own ads running now (shuffled, so each one gets its turn).
create function public.get_ads()
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_enabled boolean;
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  v_enabled := private.setting_int('ads_enabled') = 1
    and (private.setting_int('ads_for_paid') = 1 or private.plan_tier(v_uid) is null);

  return jsonb_build_object(
    'enabled', v_enabled,
    'events_every', private.setting_int('ads_events_every'),
    'discover_every', private.setting_int('ads_discover_every'),
    'ads', case when not v_enabled then '[]'::jsonb else coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', a.id, 'title', a.title, 'body', a.body,
        'image_path', a.image_path, 'cta', a.cta,
        'event_id', a.event_id, 'link_url', a.link_url,
        'placements', a.placements
      ) order by random())
      from public.ads a
      left join public.events e on e.id = a.event_id
      where a.active
        and a.starts_at <= now()
        and (a.ends_at is null or a.ends_at > now())
        -- An event ad stops with the event.
        and (a.event_id is null or (e.status = 'approved' and e.ends_at > now()))
    ), '[]'::jsonb) end
  );
end;
$$;

revoke execute on function public.get_ads() from public, anon;
grant execute on function public.get_ads() to authenticated;

-- An own ad was seen or tapped.
create function public.log_ad(p_ad uuid, p_kind text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_day date := (now() at time zone 'America/Sao_Paulo')::date;
begin
  if v_uid is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;
  if p_kind not in ('impression', 'click')
     or not exists (select 1 from public.ads where id = p_ad) then
    return;
  end if;

  insert into private.ad_seen (ad_id, user_id, day, kind)
  values (p_ad, v_uid, v_day, p_kind)
  on conflict do nothing;
  if not found then
    return;
  end if;

  insert into private.ad_stats (ad_id, day, impressions, clicks)
  values (
    p_ad, v_day,
    (p_kind = 'impression')::int, (p_kind = 'click')::int
  )
  on conflict (ad_id, day) do update
    set impressions = private.ad_stats.impressions + excluded.impressions,
        clicks = private.ad_stats.clicks + excluded.clicks;
end;
$$;

revoke execute on function public.log_ad(uuid, text) from public, anon;
grant execute on function public.log_ad(uuid, text) to authenticated;

-- Admin: totals per ad.
create function public.admin_ad_stats()
returns table (ad_id uuid, impressions int, clicks int)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'admins only' using errcode = '42501';
  end if;
  return query
  select s.ad_id, sum(s.impressions)::int, sum(s.clicks)::int
  from private.ad_stats s
  group by s.ad_id;
end;
$$;

revoke execute on function public.admin_ad_stats() from public, anon;
grant execute on function public.admin_ad_stats() to authenticated;

-- Ad images: public read, admins upload. Path: {uuid}.jpg
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('ad-images', 'ad-images', true, 5242880, array['image/jpeg'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

create policy "ad-images: admin uploads"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'ad-images' and private.is_admin());

create policy "ad-images: admin deletes"
  on storage.objects for delete to authenticated
  using (bucket_id = 'ad-images' and private.is_admin());
