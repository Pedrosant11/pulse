-- Crew meeting point (launch plan): any member writes where the crew
-- meets at the party; only members see it.


alter table public.crews
  add column meeting_point text check (char_length(meeting_point) <= 120);

create function public.set_crew_meeting_point(p_crew_id uuid, p_text text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not private.is_crew_member(p_crew_id) then
    raise exception 'Members only' using errcode = '42501';
  end if;
  update public.crews set meeting_point = nullif(btrim(p_text), '')
  where id = p_crew_id;
end;
$$;

revoke execute on function public.set_crew_meeting_point(uuid, text) from public, anon;
grant execute on function public.set_crew_meeting_point(uuid, text) to authenticated;

drop function public.get_crew(uuid);

create function public.get_crew(p_crew_id uuid)
returns table (
  id uuid,
  name text,
  description text,
  is_open boolean,
  same_gender_only boolean,
  max_members int,
  member_count int,
  owner_id uuid,
  event_id uuid,
  event_name text,
  event_starts_at timestamptz,
  conversation_id uuid,
  my_status text,
  my_request_id uuid,
  meeting_point text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    c.id, c.name, c.description, c.is_open, c.same_gender_only,
    c.max_members::int,
    (select count(*)::int from public.crew_members cm where cm.crew_id = c.id),
    c.owner_id,
    e.id, e.name, e.starts_at,
    -- The chat is only revealed to members.
    case when private.is_crew_member(c.id)
      then (select conv.id from public.conversations conv where conv.crew_id = c.id)
    end,
    private.crew_status(c.id),
    -- The user's pending request/invite (to cancel or answer it).
    (select r.id from public.crew_join_requests r
     where r.crew_id = c.id and r.user_id = (select auth.uid())
       and r.status = 'pending'
     limit 1),
    -- Members only.
    case when private.is_crew_member(c.id) then c.meeting_point end
  from public.crews c
  join public.events e on e.id = c.event_id
  where c.id = p_crew_id and private.can_see_crew(c);
$$;

revoke execute on function public.get_crew(uuid) from public, anon;
grant execute on function public.get_crew(uuid) to authenticated;
