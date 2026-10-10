-- LGPD (Política de Privacidade, SPEC 5.4):
-- 1. Sexual orientation is sensitive data (art. 11): it needs a specific
--    consent, recorded with the server clock, and removing the orientation
--    withdraws it.
-- 2. Access and portability (art. 18): export_my_data() returns everything
--    the app holds about the signed-in user.

alter table public.profiles
  add column sensitive_data_consent_at timestamptz;

comment on column public.profiles.sensitive_data_consent_at is
  'When the user consented to the processing of their sexual orientation '
  '(LGPD art. 11). Null when no orientation is stored.';

-- Accounts created before this rule accepted the terms that covered it.
update public.profiles
set sensitive_data_consent_at = coalesce(terms_accepted_at, now())
where orientation is not null;

alter table public.profiles
  add constraint profiles_orientation_needs_consent
    check (orientation is null or sensitive_data_consent_at is not null);

-- The app sends any timestamp to say "I consent"; the database stores its
-- own clock. Without consent an orientation is refused.
create function private.guard_sensitive_consent()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.orientation is null then
    new.sensitive_data_consent_at := null;
    new.show_orientation := false;
    return new;
  end if;

  if tg_op = 'UPDATE' and old.sensitive_data_consent_at is not null then
    new.sensitive_data_consent_at := old.sensitive_data_consent_at;
    return new;
  end if;

  if new.sensitive_data_consent_at is null then
    raise exception 'Sexual orientation needs consent'
      using errcode = '22023', hint = 'sensitive_consent';
  end if;
  new.sensitive_data_consent_at := now();
  return new;
end;
$$;

create trigger profiles_guard_sensitive_consent
  before insert or update of orientation, sensitive_data_consent_at
  on public.profiles
  for each row execute function private.guard_sensitive_consent();

-- ---------------------------------------------------------------------------
-- "Baixar meus dados": the user's own data. Other people appear only as
-- what the user already sees (first name), never their private data.
-- ---------------------------------------------------------------------------

create function public.export_my_data()
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

  return jsonb_build_object(
    'exported_at', now(),
    'account', (
      select jsonb_build_object(
        'email', u.email,
        'created_at', u.created_at,
        'email_confirmed_at', u.email_confirmed_at,
        'last_sign_in_at', u.last_sign_in_at
      )
      from auth.users u where u.id = v_uid
    ),
    'profile', (select to_jsonb(p) from public.profiles p where p.id = v_uid),
    'phone', (
      select jsonb_build_object(
        'phone', up.phone,
        'verified_at', up.phone_verified_at
      )
      from public.user_private up where up.user_id = v_uid
    ),
    'photos', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'storage_path', ph.storage_path,
          'position', ph.position,
          'created_at', ph.created_at
        ) order by ph.position
      )
      from public.profile_photos ph where ph.user_id = v_uid
    ), '[]'::jsonb),
    'events_going', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'event', e.name, 'starts_at', e.starts_at, 'marked_at', a.created_at
        ) order by e.starts_at
      )
      from public.event_attendance a
      join public.events e on e.id = a.event_id
      where a.user_id = v_uid
    ), '[]'::jsonb),
    'events_created', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'name', e.name, 'status', e.status, 'starts_at', e.starts_at,
          'venue_name', e.venue_name, 'address', v.address,
          'city', e.city, 'state', e.state, 'created_at', e.created_at
        ) order by e.created_at
      )
      from public.events e
      left join public.event_venues v on v.event_id = e.id
      where e.created_by = v_uid
    ), '[]'::jsonb),
    'swipes', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'mode', s.mode, 'direction', s.direction, 'created_at', s.created_at
        ) order by s.created_at
      )
      from public.swipes s where s.swiper_id = v_uid
    ), '[]'::jsonb),
    'matches', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'with', other.first_name,
          'mode', m.mode,
          'created_at', m.created_at,
          'unmatched_at', m.unmatched_at
        ) order by m.created_at
      )
      from public.matches m
      left join public.profiles other
        on other.id = case when m.user_a = v_uid then m.user_b else m.user_a end
      where v_uid in (m.user_a, m.user_b)
    ), '[]'::jsonb),
    'messages_sent', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'conversation_id', msg.conversation_id,
          'content', msg.content,
          'sent_at', msg.created_at
        ) order by msg.created_at
      )
      from public.messages msg
      where msg.sender_id = v_uid and msg.deleted_at is null
    ), '[]'::jsonb),
    'crews', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'crew', c.name, 'event', e.name, 'role', cm.role,
          'joined_at', cm.joined_at
        ) order by cm.joined_at
      )
      from public.crew_members cm
      join public.crews c on c.id = cm.crew_id
      join public.events e on e.id = c.event_id
      where cm.user_id = v_uid
    ), '[]'::jsonb),
    'blocked', coalesce((
      select jsonb_agg(
        jsonb_build_object('first_name', p.first_name, 'blocked_at', b.created_at)
        order by b.created_at
      )
      from public.blocks b
      join public.profiles p on p.id = b.blocked_id
      where b.blocker_id = v_uid
    ), '[]'::jsonb),
    'reports_made', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'target_type', r.target_type, 'reason', r.reason,
          'details', r.details, 'status', r.status, 'created_at', r.created_at
        ) order by r.created_at
      )
      from public.reports r where r.reporter_id = v_uid
    ), '[]'::jsonb),
    'moderation_actions', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'action', ma.action, 'reason', ma.reason,
          'expires_at', ma.expires_at, 'created_at', ma.created_at
        ) order by ma.created_at
      )
      from public.moderation_actions ma where ma.target_user_id = v_uid
    ), '[]'::jsonb),
    'badges', coalesce((
      select jsonb_agg(
        jsonb_build_object('badge', pb.badge, 'title', pb.title,
                           'granted_at', pb.created_at)
      )
      from public.profile_badges pb where pb.user_id = v_uid
    ), '[]'::jsonb),
    'role_requests', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'role', rr.requested_role, 'status', rr.status,
          'justification', rr.justification, 'created_at', rr.created_at
        ) order by rr.created_at
      )
      from public.role_requests rr where rr.user_id = v_uid
    ), '[]'::jsonb),
    'badge_requests', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'badge', br.badge, 'status', br.status,
          'justification', br.justification, 'created_at', br.created_at
        ) order by br.created_at
      )
      from public.badge_requests br where br.user_id = v_uid
    ), '[]'::jsonb)
  );
end;
$$;

revoke execute on function public.export_my_data() from public, anon;
grant execute on function public.export_my_data() to authenticated;
