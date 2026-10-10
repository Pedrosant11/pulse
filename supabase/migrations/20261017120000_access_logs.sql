-- Registros de acesso (Marco Civil da Internet, art. 15; Política de
-- Privacidade, item 6): date/time of each use of the app and the IP it
-- came from, kept for 6 months and then deleted.
--
-- Private table: no client reads it. Rows survive account deletion
-- (no FK) because the law requires keeping them for the full period.

create table private.access_logs (
  id bigint generated always as identity primary key,
  user_id uuid not null,
  ip inet,
  user_agent text,
  created_at timestamptz not null default now()
);

create index access_logs_user_idx on private.access_logs (user_id, created_at desc);
create index access_logs_created_idx on private.access_logs (created_at);

-- Called by the app when it opens or comes back to the foreground. The IP
-- is read from the request (gateway headers), never sent by the app.
-- At most one row per user every 10 minutes.
create function public.log_access()
returns void
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_headers json := nullif(current_setting('request.headers', true), '')::json;
  v_ip text;
begin
  if v_uid is null then
    raise exception 'Not authenticated' using errcode = '42501';
  end if;

  if exists (
    select 1 from private.access_logs
    where user_id = v_uid and created_at > now() - interval '10 minutes'
  ) then
    return;
  end if;

  v_ip := coalesce(
    v_headers ->> 'cf-connecting-ip',
    v_headers ->> 'x-real-ip',
    btrim(split_part(v_headers ->> 'x-forwarded-for', ',', 1))
  );

  insert into private.access_logs (user_id, ip, user_agent)
  values (
    v_uid,
    case when v_ip ~ '^[0-9a-fA-F:.]+$' then v_ip::inet end,
    left(v_headers ->> 'user-agent', 300)
  );
end;
$$;

revoke execute on function public.log_access() from public, anon;
grant execute on function public.log_access() to authenticated;

-- Six months, then gone (LGPD: no longer than needed).
create function private.purge_access_logs()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  delete from private.access_logs where created_at < now() - interval '6 months';
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

revoke execute on function private.purge_access_logs() from public, anon, authenticated;

select cron.schedule(
  'purge-access-logs',
  '17 3 * * *',
  'select private.purge_access_logs()'
);
