-- Reports, role requests and the admin moderation log (SPEC 4 and 10).

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references public.profiles (id) on delete set null,
  target_type public.report_target not null,
  target_id uuid not null,
  reason public.report_reason not null,
  details text check (char_length(details) <= 1000),
  status public.report_status not null default 'pending',
  resolved_by uuid references public.profiles (id) on delete set null,
  resolved_at timestamptz,
  resolution_note text check (char_length(resolution_note) <= 1000),
  created_at timestamptz not null default now()
);

create index reports_status_idx on public.reports (status, created_at);
create index reports_target_idx on public.reports (target_type, target_id);

create table public.role_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  requested_role public.user_role not null
    check (requested_role in ('curator', 'producer')),
  justification text not null check (char_length(btrim(justification)) between 10 and 1000),
  links text[] not null default '{}' check (cardinality(links) <= 5),
  status public.request_status not null default 'pending',
  reviewed_by uuid references public.profiles (id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create unique index role_requests_one_pending_idx
  on public.role_requests (user_id) where status = 'pending';

-- Audit log of admin actions on accounts (warnings have no profile status,
-- so they live here; suspensions/bans also update profiles.status).
create table public.moderation_actions (
  id uuid primary key default gen_random_uuid(),
  target_user_id uuid not null references public.profiles (id) on delete cascade,
  action public.moderation_action_type not null,
  reason text not null check (char_length(btrim(reason)) between 3 and 1000),
  report_id uuid references public.reports (id) on delete set null,
  expires_at timestamptz,
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);

create index moderation_actions_target_idx
  on public.moderation_actions (target_user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------------

create function private.before_report_insert()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.reporter_id := coalesce((select auth.uid()), new.reporter_id);
  new.status := 'pending';
  new.resolved_by := null;
  new.resolved_at := null;
  new.resolution_note := null;
  new.created_at := now();
  return new;
end;
$$;

create trigger reports_before_insert
  before insert on public.reports
  for each row execute function private.before_report_insert();

create function private.before_report_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.status is distinct from old.status and new.status <> 'pending' then
    new.resolved_by := (select auth.uid());
    new.resolved_at := now();
  end if;
  return new;
end;
$$;

create trigger reports_before_update
  before update on public.reports
  for each row execute function private.before_report_update();

create function private.before_role_request_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.status <> 'pending' then
    raise exception 'Request already reviewed' using errcode = 'P0001';
  end if;
  new.user_id := old.user_id;
  new.requested_role := old.requested_role;
  new.reviewed_by := (select auth.uid());
  new.reviewed_at := now();
  return new;
end;
$$;

create trigger role_requests_before_update
  before update on public.role_requests
  for each row execute function private.before_role_request_update();

-- Approval grants the role (runs as the approving admin, so the
-- prevent_role_change guard allows it).
create function private.after_role_request_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'approved' and old.status = 'pending' then
    update public.profiles set role = new.requested_role where id = new.user_id;
  end if;
  return new;
end;
$$;

create trigger role_requests_after_update
  after update on public.role_requests
  for each row execute function private.after_role_request_update();

-- Suspensions/bans/reactivations update the account status.
create function private.after_moderation_action()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set status = case new.action
    when 'suspension' then 'suspended'::public.account_status
    when 'ban' then 'banned'::public.account_status
    when 'reactivation' then 'active'::public.account_status
    else status
  end
  where id = new.target_user_id and new.action <> 'warning';
  return new;
end;
$$;

create function private.before_moderation_action()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.created_by := coalesce((select auth.uid()), new.created_by);
  new.created_at := now();
  return new;
end;
$$;

create trigger moderation_actions_before_insert
  before insert on public.moderation_actions
  for each row execute function private.before_moderation_action();

create trigger moderation_actions_after_insert
  after insert on public.moderation_actions
  for each row execute function private.after_moderation_action();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.reports enable row level security;
alter table public.role_requests enable row level security;
alter table public.moderation_actions enable row level security;

create policy "reports: reporter or admin reads"
  on public.reports for select to authenticated
  using (reporter_id = (select auth.uid()) or private.is_admin());

create policy "reports: users report"
  on public.reports for insert to authenticated
  with check (reporter_id = (select auth.uid()));

create policy "reports: admin resolves"
  on public.reports for update to authenticated
  using (private.is_admin())
  with check (private.is_admin());

revoke delete on public.reports from authenticated;

create policy "role_requests: requester or admin reads"
  on public.role_requests for select to authenticated
  using (user_id = (select auth.uid()) or private.is_admin());

create policy "role_requests: users request"
  on public.role_requests for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and status = 'pending'
    and private.current_user_role() = 'user'
  );

create policy "role_requests: admin reviews"
  on public.role_requests for update to authenticated
  using (private.is_admin())
  with check (private.is_admin() and status in ('approved', 'rejected'));

revoke delete on public.role_requests from authenticated;
revoke update on public.role_requests from authenticated;
grant update (status) on public.role_requests to authenticated;

create policy "moderation_actions: admin reads"
  on public.moderation_actions for select to authenticated
  using (private.is_admin());

create policy "moderation_actions: admin acts"
  on public.moderation_actions for insert to authenticated
  with check (private.is_admin());

revoke update, delete on public.moderation_actions from authenticated;
