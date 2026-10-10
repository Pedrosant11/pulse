-- Foundation: schemas, extensions, enum types, private config and helpers.
--
-- Conventions for every migration in this project:
--   * RLS is enabled on every table in `public`.
--   * Helpers used by policies/triggers live in the `private` schema, which is
--     NOT exposed by the Data API. Only deliberate RPCs live in `public`.
--   * SECURITY DEFINER functions always pin `search_path = ''` and use fully
--     qualified names.
--   * Business rules (roles, event status, matches, permissions) are enforced
--     here, never trusted to the app.

create schema if not exists private;
grant usage on schema private to authenticated, service_role;

create extension if not exists pg_trgm with schema extensions;
create extension if not exists unaccent with schema extensions;

-- ---------------------------------------------------------------------------
-- Enum types (values are the strings the app stores/sends)
-- ---------------------------------------------------------------------------

create type public.user_role as enum ('user', 'curator', 'producer', 'admin');
create type public.account_status as enum ('active', 'suspended', 'banned');
create type public.app_mode as enum ('date', 'crew');

-- Kept short on purpose: matching filters ("show me") operate on these.
-- The UI can describe each option inclusively (e.g. "Mulher (cis ou trans)").
create type public.gender as enum (
  'woman', 'man', 'non_binary', 'other', 'prefer_not_say'
);

create type public.orientation as enum (
  'straight', 'gay', 'lesbian', 'bisexual', 'pansexual', 'asexual',
  'queer', 'questioning', 'other'
);

create type public.date_intent as enum (
  'casual', 'dating', 'relationship', 'figuring_out'
);

create type public.habit_frequency as enum ('no', 'socially', 'yes');

create type public.zodiac_sign as enum (
  'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo',
  'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'
);

create type public.music_genre as enum (
  'techno', 'house', 'tech_house', 'melodic_techno', 'psytrance', 'trance',
  'drum_and_bass', 'dubstep', 'afro_house', 'minimal', 'hard_techno',
  'disco_nu_disco', 'edm', 'other'
);

create type public.event_status as enum (
  'pending', 'approved', 'rejected', 'cancelled'
);

create type public.swipe_direction as enum ('like', 'pass');
create type public.conversation_type as enum ('direct', 'crew');
create type public.crew_member_role as enum ('owner', 'member');

create type public.request_status as enum (
  'pending', 'approved', 'rejected', 'cancelled'
);

create type public.report_target as enum ('user', 'message', 'event');

create type public.report_reason as enum (
  'fake_profile', 'harassment', 'inappropriate_content', 'spam',
  'underage', 'safety_concern', 'scam', 'other'
);

create type public.report_status as enum ('pending', 'resolved', 'dismissed');

create type public.moderation_action_type as enum (
  'warning', 'suspension', 'ban', 'reactivation'
);

-- ---------------------------------------------------------------------------
-- Private configuration (not reachable through the API)
-- ---------------------------------------------------------------------------

create table private.app_settings (
  key text primary key,
  value text not null
);

-- `phone_verification_mode`: 'mock' while developing (SPEC 5.3). The launch
-- migration (Phase 10) switches it to 'twilio' and drops the mock RPC.
insert into private.app_settings (key, value) values
  ('phone_verification_mode', 'mock');

revoke all on private.app_settings from public, anon, authenticated;

create function private.setting(p_key text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select value from private.app_settings where key = p_key;
$$;

-- ---------------------------------------------------------------------------
-- Generic helpers
-- ---------------------------------------------------------------------------

create function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- Raised by rate-limit triggers. SQLSTATE P0429 is mapped by the app to a
-- friendly "slow down" message.
create function private.raise_rate_limited(p_what text)
returns void
language plpgsql
set search_path = ''
as $$
begin
  raise exception 'Rate limit exceeded for %', p_what
    using errcode = 'P0429';
end;
$$;

-- The app requires a session: nothing in `public` is readable by `anon`.
alter default privileges in schema public revoke all on tables from anon;
alter default privileges in schema public revoke all on sequences from anon;
alter default privileges in schema public revoke execute on functions from anon, public;
