-- Event moderation rules (Phase 4 feedback):
--   * only the creator or an admin can cancel an event;
--   * curators review pending events (approve/reject) and can edit any
--     event, but don't change the status of already reviewed ones;
--   * moderators can see who created an event (e-mail for admins only).

create or replace function private.guard_event_update()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_is_creator boolean;
begin
  if v_uid is null or private.is_admin() then
    return new;
  end if;

  new.created_by := old.created_by;
  new.is_official := old.is_official;
  new.created_at := old.created_at;
  v_is_creator := old.created_by = v_uid;

  if new.status is distinct from old.status then
    if new.status = 'cancelled' then
      if not v_is_creator then
        raise exception 'Only the creator or an admin can cancel an event'
          using errcode = '42501';
      end if;
    elsif private.is_moderator() then
      if old.status <> 'pending' or new.status not in ('approved', 'rejected') then
        raise exception 'Curators only review pending events'
          using errcode = '42501';
      end if;
      new.approved_by := case
        when new.status = 'approved' then v_uid
        else old.approved_by
      end;
    else
      raise exception 'Only curators can change the event status'
        using errcode = '42501';
    end if;
  end if;

  if private.is_moderator() then
    if new.status <> 'rejected' then
      new.rejection_reason := null;
    end if;
  else
    new.approved_by := old.approved_by;
    new.rejection_reason := old.rejection_reason;
  end if;
  return new;
end;
$$;

-- Who created an event, for moderators (contact and spam checks).
-- E-mail is personal data (SPEC 5.4): admins only.
create function public.get_event_creator(p_event_id uuid)
returns table (
  user_id uuid,
  first_name text,
  photo_path text,
  role public.user_role,
  member_since timestamptz,
  events_created int,
  events_rejected int,
  email text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not private.is_moderator() then
    raise exception 'Only curators and admins' using errcode = '42501';
  end if;

  return query
  select
    p.id,
    p.first_name,
    (select ph.storage_path from public.profile_photos ph
     where ph.user_id = p.id order by ph.position limit 1),
    p.role,
    p.created_at,
    (select count(*)::int from public.events e2 where e2.created_by = p.id),
    (select count(*)::int from public.events e2
     where e2.created_by = p.id and e2.status = 'rejected'),
    case when private.is_admin() then u.email::text end
  from public.events e
  join public.profiles p on p.id = e.created_by
  join auth.users u on u.id = p.id
  where e.id = p_event_id;
end;
$$;

revoke execute on function public.get_event_creator(uuid) from public, anon;
grant execute on function public.get_event_creator(uuid) to authenticated;
