-- Selfie verification (launch plan): the app asks for a random pose, the
-- person takes a selfie with the camera and an admin compares it with the
-- profile photos. Approval sets profiles.is_verified (the existing badge).
--
-- The selfie is used only for this check: the admin's app deletes the file
-- right after the decision (selfie_path is cleared). Consent is recorded.
-- Reviewed manually for now; an automatic face check can come later.

create type public.verification_pose as enum (
  'thumbs_up', 'peace_sign', 'hand_on_head', 'point_up', 'hand_on_chin'
);

create table public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  pose public.verification_pose not null,
  -- verification-selfies/{user_id}/{uuid}.jpg; null once reviewed.
  selfie_path text,
  status public.request_status not null default 'pending',
  rejection_reason text check (char_length(rejection_reason) <= 300),
  consent_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles (id) on delete set null,
  reviewed_at timestamptz,
  check (status in ('pending', 'approved', 'rejected'))
);

create unique index verification_requests_one_pending_idx
  on public.verification_requests (user_id) where status = 'pending';
create index verification_requests_user_idx
  on public.verification_requests (user_id, created_at desc);

alter table public.verification_requests enable row level security;
revoke all on public.verification_requests from anon, authenticated;
grant select on public.verification_requests to authenticated;

create policy "verification_requests: own or admin"
  on public.verification_requests for select to authenticated
  using (user_id = (select auth.uid()) or private.is_admin());

-- ---------------------------------------------------------------------------
-- Storage: private bucket, the owner uploads, admins read and delete
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('verification-selfies', 'verification-selfies', false, 5242880, array['image/jpeg'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

create policy "verification-selfies: owner uploads"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'verification-selfies'
    and private.path_uuid(name) = (select auth.uid())
    and storage.extension(name) = 'jpg'
  );

create policy "verification-selfies: owner or admin reads"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'verification-selfies'
    and (private.path_uuid(name) = (select auth.uid()) or private.is_admin())
  );

create policy "verification-selfies: owner or admin deletes"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'verification-selfies'
    and (private.path_uuid(name) = (select auth.uid()) or private.is_admin())
  );

-- ---------------------------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------------------------

-- Sends the selfie for review. Needs 2 profile photos (something to compare
-- with), no pending request and at most 3 tries a day.
create function public.submit_verification(
  p_pose public.verification_pose,
  p_selfie_path text
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_id uuid;
begin
  if v_uid is null or not private.can_socialize() then
    raise exception 'Not allowed' using errcode = '42501';
  end if;
  if private.path_uuid(p_selfie_path) is distinct from v_uid then
    raise exception 'Invalid selfie path' using errcode = '42501';
  end if;
  if exists (select 1 from public.profiles where id = v_uid and is_verified) then
    raise exception 'Already verified'
      using errcode = 'P0001', hint = 'already_verified';
  end if;
  if (select count(*) from public.profile_photos where user_id = v_uid) < 2 then
    raise exception 'At least 2 photos are required'
      using errcode = 'P0001', hint = 'min_photos';
  end if;
  if exists (
    select 1 from public.verification_requests
    where user_id = v_uid and status = 'pending'
  ) then
    raise exception 'A request is already pending'
      using errcode = 'P0001', hint = 'verification_pending';
  end if;
  if (
    select count(*) from public.verification_requests
    where user_id = v_uid and created_at > now() - interval '1 day'
  ) >= 3 then
    perform private.raise_rate_limited('verification');
  end if;

  insert into public.verification_requests (user_id, pose, selfie_path)
  values (v_uid, p_pose, p_selfie_path)
  returning id into v_id;
  return v_id;
end;
$$;

-- Pending requests with what the admin compares: selfie, pose and the
-- profile photos.
create function public.admin_list_verifications()
returns table (
  id uuid,
  user_id uuid,
  first_name text,
  age int,
  pose public.verification_pose,
  selfie_path text,
  photo_paths text[],
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    v.id, v.user_id, p.first_name,
    date_part('year', age(p.birth_date))::int,
    v.pose, v.selfie_path,
    array(
      select ph.storage_path from public.profile_photos ph
      where ph.user_id = p.id order by ph.position
    ),
    v.created_at
  from public.verification_requests v
  join public.profiles p on p.id = v.user_id
  where v.status = 'pending' and private.is_admin()
  order by v.created_at;
$$;

-- Approves or rejects; returns the selfie path so the admin's app deletes
-- the file (SQL can't remove Storage objects).
create function public.admin_review_verification(
  p_request_id uuid,
  p_approve boolean,
  p_reason text default null
)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_request public.verification_requests;
  v_path text;
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;

  select selfie_path into v_path
  from public.verification_requests
  where id = p_request_id and status = 'pending'
  for update;

  update public.verification_requests
  set status = case when p_approve then 'approved'::public.request_status
                    else 'rejected'::public.request_status end,
      rejection_reason = case when p_approve then null else nullif(btrim(p_reason), '') end,
      reviewed_by = (select auth.uid()),
      reviewed_at = now(),
      selfie_path = null
  where id = p_request_id and status = 'pending'
  returning * into v_request;

  if v_request.id is null then
    raise exception 'Request not found or already reviewed'
      using errcode = 'P0002';
  end if;

  if p_approve then
    update public.profiles set is_verified = true where id = v_request.user_id;
  end if;
  return v_path;
end;
$$;

-- Removes (or gives back) the badge, e.g. after the photos were swapped.
create function public.admin_set_verified(p_user uuid, p_verified boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'Admins only' using errcode = '42501';
  end if;
  update public.profiles set is_verified = p_verified where id = p_user;
end;
$$;

revoke execute on function public.submit_verification(public.verification_pose, text) from public, anon;
grant execute on function public.submit_verification(public.verification_pose, text) to authenticated;
revoke execute on function public.admin_list_verifications() from public, anon;
grant execute on function public.admin_list_verifications() to authenticated;
revoke execute on function public.admin_review_verification(uuid, boolean, text) from public, anon;
grant execute on function public.admin_review_verification(uuid, boolean, text) to authenticated;
revoke execute on function public.admin_set_verified(uuid, boolean) from public, anon;
grant execute on function public.admin_set_verified(uuid, boolean) to authenticated;

-- The person hears back by push (send-push kinds verification_approved /
-- verification_rejected).
create function private.push_on_verification()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.status = 'pending' and new.status in ('approved', 'rejected') then
    perform private.send_push(
      array[new.user_id],
      'verification_' || new.status,
      jsonb_build_object('route', '/settings/verification')
    );
  end if;
  return new;
end;
$$;

create trigger verification_requests_push
  after update of status on public.verification_requests
  for each row execute function private.push_on_verification();

-- ---------------------------------------------------------------------------
-- LGPD export: verification history (no selfie: it is deleted on review)
-- ---------------------------------------------------------------------------

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
    ), '[]'::jsonb)
  );
end;
$$;
