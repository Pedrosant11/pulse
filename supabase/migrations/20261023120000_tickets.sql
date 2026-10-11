-- Tickets (launch plan): the event's ticket link can be an affiliate link
-- and carry a coupon (e.g. a promoter code), and "Comprar ingresso" taps
-- are counted so producers can see what the app brings them.

alter table public.events
  add column ticket_coupon text
    check (ticket_coupon is null or char_length(btrim(ticket_coupon)) between 2 and 30);

comment on column public.events.ticket_coupon is
  'Discount/affiliate code shown next to the ticket link (copy button).';

-- One row per tap (deduplicated per person, event and hour). After 90 days
-- only the count remains: the user id is dropped.
create table public.ticket_clicks (
  id bigint generated always as identity primary key,
  event_id uuid not null references public.events (id) on delete cascade,
  user_id uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);

create index ticket_clicks_event_idx on public.ticket_clicks (event_id, created_at desc);
create index ticket_clicks_user_idx on public.ticket_clicks (user_id, event_id, created_at desc);

alter table public.ticket_clicks enable row level security;
revoke all on public.ticket_clicks from anon, authenticated;

create function public.log_ticket_click(p_event_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    return;
  end if;
  if not exists (
    select 1 from public.events
    where id = p_event_id and status = 'approved' and ticket_url is not null
  ) then
    return;
  end if;
  if exists (
    select 1 from public.ticket_clicks
    where user_id = v_uid and event_id = p_event_id
      and created_at > now() - interval '1 hour'
  ) then
    return;
  end if;
  insert into public.ticket_clicks (event_id, user_id) values (p_event_id, v_uid);
end;
$$;

-- How many people tapped the ticket button (creator and moderators).
create function public.get_ticket_click_count(p_event_id uuid)
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::int
  from public.ticket_clicks c
  join public.events e on e.id = c.event_id
  where c.event_id = p_event_id
    and (e.created_by = (select auth.uid()) or private.is_moderator());
$$;

revoke execute on function public.log_ticket_click(uuid) from public, anon;
grant execute on function public.log_ticket_click(uuid) to authenticated;
revoke execute on function public.get_ticket_click_count(uuid) from public, anon;
grant execute on function public.get_ticket_click_count(uuid) to authenticated;

create function private.anonymize_ticket_clicks()
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count int;
begin
  update public.ticket_clicks set user_id = null
  where user_id is not null and created_at < now() - interval '90 days';
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

select cron.schedule(
  'anonymize-ticket-clicks',
  '45 3 * * *',
  'select private.anonymize_ticket_clicks()'
);
