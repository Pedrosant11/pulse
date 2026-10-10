-- When a suggestion is approved, its creator is marked as going ("Eu vou").
-- Attendance is only allowed on approved events, so suggestions can't do it
-- at creation time.

create function private.attend_on_approval()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status = 'approved'
     and old.status is distinct from 'approved'
     and new.created_by is not null
     and new.ends_at > now() then
    insert into public.event_attendance (user_id, event_id)
    values (new.created_by, new.id)
    on conflict do nothing;
  end if;
  return new;
end;
$$;

create trigger events_attend_on_approval
  after update of status on public.events
  for each row execute function private.attend_on_approval();
