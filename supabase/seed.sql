-- Local development seed (SPEC 11). Applied by `supabase db reset`.
-- NEVER run against production (`supabase db push` skips it by default).
--
-- Every seed user can log in with password `pulse1234`:
--   seed01@pulse.test  admin
--   seed02@pulse.test  curator
--   seed03@pulse.test  producer
--   seed04..seed30     regular users (01–15 São Paulo, 16–30 Rio)
-- Photos come from supabase/seed/profile-photos and event covers from
-- supabase/seed/event-covers (uploaded by the CLI, see seed/CREDITS.md).
--
-- IDs are deterministic:
--   users  00000000-0000-4000-a000-0000000000NN
--   events 00000000-0000-4000-b000-0000000000NN

-- ---------------------------------------------------------------------------
-- Users (the on_auth_user_created trigger creates profiles/user_private)
-- ---------------------------------------------------------------------------

create temp table seed_people (
  n int primary key,
  first_name text,
  last_name text,
  gender public.gender,
  birth_date date,
  modes public.app_mode[],
  date_show_me public.gender[],
  date_looking_for public.date_intent,
  crew_same_gender_only boolean,
  music_genres public.music_genre[],
  favorite_djs text[],
  occupation text,
  bio text
);

insert into seed_people values
  ( 1, 'Ana',      'Ribeiro',    'woman',          '1994-03-12', '{date,crew}', '{man}',          'dating',       false, '{techno,melodic_techno}',       '{"Charlotte de Witte","Amelie Lens"}', 'Designer',          'Sempre na grade do Galpão 23.'),
  ( 2, 'Bruno',    'Carvalho',   'man',            '1992-07-04', '{date,crew}', '{woman}',        'relationship', false, '{house,tech_house}',            '{"Fisher","Chris Lake"}',               'Engenheiro',        'Curador de festa boa.'),
  ( 3, 'Carla',    'Mendes',     'woman',          '1990-11-23', '{crew}',      '{}',             null,           true,  '{techno,hard_techno}',          '{"I Hate Models"}',                     'Produtora',         'Produzo a Ritual.'),
  ( 4, 'Diego',    'Souza',      'man',            '1997-01-30', '{date}',      '{woman}',        'casual',       false, '{psytrance,trance}',            '{"Vini Vici","Astrix"}',                'Fotógrafo',         'Psy até o sol nascer.'),
  ( 5, 'Elisa',    'Moraes',     'woman',          '1999-05-17', '{date,crew}', '{man,non_binary}','figuring_out', false, '{house,afro_house}',            '{"Black Coffee","Keinemusik"}',         'Estudante',         'Afro house é vida.'),
  ( 6, 'Felipe',   'Araújo',     'man',            '1995-09-09', '{date,crew}', '{woman}',        'dating',       false, '{techno,minimal}',              '{"Richie Hawtin"}',                     'Dev',               'Minimal e café.'),
  ( 7, 'Gabi',     'Lima',       'non_binary',     '1998-12-01', '{date,crew}', '{}',             'casual',       false, '{techno,melodic_techno,house}', '{"Anyma","Tale Of Us"}',               'Ilustradore',       'Melodic no talo.'),
  ( 8, 'Hugo',     'Pereira',    'man',            '1993-04-22', '{crew}',      '{}',             null,           false, '{drum_and_bass,dubstep}',       '{"Sub Focus"}',                         'Barista',           'Procurando crew pro festival.'),
  ( 9, 'Isabela',  'Costa',      'woman',          '1996-08-14', '{date}',      '{man}',          'relationship', false, '{techno,house}',                '{"Peggy Gou"}',                         'Advogada',          'Dança primeiro, conversa depois.'),
  (10, 'João',     'Martins',    'man',            '1991-02-27', '{date,crew}', '{woman,man}',    'dating',       false, '{tech_house,house}',            '{"John Summit"}',                       'Publicitário',      'Tech house e boas risadas.'),
  (11, 'Larissa',  'Rocha',      'woman',          '2000-06-05', '{crew}',      '{}',             null,           true,  '{techno,melodic_techno}',       '{"ARTBAT"}',                            'Estudante',         'Crew só de mina, bora?'),
  (12, 'Marcos',   'Teixeira',   'man',            '1989-10-19', '{date}',      '{woman}',        'casual',       false, '{techno,hard_techno}',          '{"Sara Landry"}',                       'Arquiteto',         'Hard techno de domingo.'),
  (13, 'Natália',  'Barbosa',    'woman',          '1997-03-03', '{date,crew}', '{man,woman}',    'figuring_out', false, '{disco_nu_disco,house}',        '{"Purple Disco Machine"}',              'Jornalista',        'Disco ball enthusiast.'),
  (14, 'Otávio',   'Gomes',      'man',            '1994-07-28', '{date,crew}', '{woman}',        'dating',       false, '{techno,minimal,house}',        '{"Ricardo Villalobos"}',                'Chef',              'Afters e risoto.'),
  (15, 'Paula',    'Freitas',    'woman',          '1995-11-11', '{date}',      '{man}',          'relationship', false, '{melodic_techno,trance}',       '{"Massano"}',                           'Médica',            'Plantão e pista.'),
  (16, 'Rafael',   'Dias',       'man',            '1993-01-08', '{date,crew}', '{woman}',        'dating',       false, '{house,tech_house}',            '{"Vintage Culture"}',                   'Surfista',          'Do mar pra pista.'),
  (17, 'Sofia',    'Nunes',      'woman',          '1998-04-16', '{date,crew}', '{man}',          'casual',       false, '{techno,house}',                '{"Solomun"}',                           'Modelo',            'Carioca da gema.'),
  (18, 'Thiago',   'Castro',     'man',            '1990-09-25', '{crew}',      '{}',             null,           false, '{psytrance}',                   '{"Infected Mushroom"}',                 'Professor',         'Montando crew pro Universo Paralello.'),
  (19, 'Úrsula',   'Pinto',      'woman',          '1996-12-30', '{date,crew}', '{woman}',        'relationship', false, '{afro_house,house}',            '{"&ME","Rampa"}',                       'Bióloga',           'Pôr do sol + afro house.'),
  (20, 'Victor',   'Alves',      'man',            '1997-06-12', '{date}',      '{woman}',        'casual',       false, '{edm,tech_house}',              '{"Alok"}',                              'Personal trainer',  'Treino e festa.'),
  (21, 'Wendy',    'Cardoso',    'woman',          '1999-02-19', '{date,crew}', '{man,non_binary}','dating',      false, '{techno,melodic_techno}',       '{"Adriatique"}',                        'Designer de moda',  'Look pronto, bora?'),
  (22, 'Xavier',   'Ramos',      'man',            '1988-08-08', '{date,crew}', '{woman,man}',    'figuring_out', false, '{minimal,techno}',              '{"Seth Troxler"}',                      'Músico',            'Toco sintetizador.'),
  (23, 'Yasmin',   'Correia',    'woman',          '2001-10-10', '{crew}',      '{}',             null,           true,  '{house,disco_nu_disco}',        '{"Honey Dijon"}',                       'Estudante',         'Primeira vez em festival!'),
  (24, 'Zeca',     'Monteiro',   'man',            '1992-05-05', '{date,crew}', '{woman}',        'dating',       false, '{drum_and_bass,techno}',        '{"Andy C"}',                            'Engenheiro de som', 'DnB é amor.'),
  (25, 'Bia',      'Lopes',      'woman',          '1995-01-21', '{date,crew}', '{man}',          'relationship', false, '{techno,house}',                '{"Nina Kraviz"}',                       'Psicóloga',         'Conversa boa no fumódromo.'),
  (26, 'Caio',     'Vieira',     'man',            '1996-03-14', '{date}',      '{woman}',        'casual',       false, '{house,afro_house}',            '{"Keinemusik"}',                        'Garçom',            'Sorriso fácil.'),
  (27, 'Duda',     'Farias',     'non_binary',     '1999-07-07', '{date,crew}', '{}',             'figuring_out', false, '{techno,hard_techno}',          '{"Reinier Zonneveld"}',                 'Tatuadore',         'Techno e tinta.'),
  (28, 'Enzo',     'Batista',    'man',            '1998-11-29', '{date,crew}', '{woman}',        'dating',       false, '{melodic_techno,trance}',       '{"Argy"}',                              'Analista',          'Melodic e pôr do sol.'),
  (29, 'Fernanda', 'Melo',       'woman',          '1993-09-03', '{date,crew}', '{man}',          'relationship', false, '{techno,minimal}',              '{"Ellen Allien"}',                      'Professora',        'Minimal de quinta.'),
  (30, 'Gael',     'Santana',    'prefer_not_say', '2000-04-01', '{crew}',      '{}',             null,           false, '{house,edm}',                   '{"Calvin Harris"}',                     'Estudante',         'Só quero dançar.');

create temp table seed_users as
select
  sp.*,
  format('00000000-0000-4000-a000-%s', lpad(sp.n::text, 12, '0'))::uuid as id,
  format('seed%s@pulse.test', lpad(sp.n::text, 2, '0')) as email,
  case when sp.n <= 15 then 'São Paulo' else 'Rio de Janeiro' end as city,
  case when sp.n <= 15 then 'SP' else 'RJ' end as state,
  case when sp.n <= 15 then -23.55 else -22.91 end as lat,
  case when sp.n <= 15 then -46.63 else -43.17 end as lng
from seed_people sp;

insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at,
  confirmation_token, recovery_token, email_change, email_change_token_new,
  email_change_token_current, phone_change, phone_change_token, reauthentication_token
)
select
  '00000000-0000-0000-0000-000000000000', u.id, 'authenticated', 'authenticated',
  u.email, extensions.crypt('pulse1234', extensions.gen_salt('bf')),
  now(), '{"provider": "email", "providers": ["email"]}'::jsonb,
  jsonb_build_object(
    'first_name', u.first_name,
    'last_name', u.last_name,
    'birth_date', u.birth_date
  ),
  now(), now(), '', '', '', '', '', '', '', ''
from seed_users u;

insert into auth.identities (
  id, user_id, provider_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
)
select
  gen_random_uuid(), u.id, u.id::text,
  jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
  'email', now(), now(), now()
from seed_users u;

-- Photos first: completing the onboarding requires 2+ photos.
insert into public.profile_photos (user_id, storage_path, position)
select u.id, format('%s/%s.jpg', u.id, pos), pos
from seed_users u
cross join generate_series(0, 1) as pos;

update public.profiles p
set
  gender = u.gender,
  city = u.city,
  state = u.state,
  lat = u.lat,
  lng = u.lng,
  occupation = u.occupation,
  bio = u.bio,
  languages = '{pt}',
  music_genres = u.music_genres,
  favorite_djs = u.favorite_djs,
  modes = u.modes,
  date_looking_for = u.date_looking_for,
  date_show_me = u.date_show_me,
  date_age_min = 18,
  date_age_max = 45,
  crew_same_gender_only = u.crew_same_gender_only,
  role = case u.n when 1 then 'admin' when 2 then 'curator' when 3 then 'producer' else 'user' end::public.user_role,
  is_verified = u.n % 4 = 0,
  terms_version = '2026-10-04',
  onboarding_completed = true,
  last_active_at = now() - make_interval(mins => u.n * 7)
from seed_users u
where p.id = u.id;

-- Identification badges (SPEC 6.4). Carla (3) shows "Produtor" from her
-- role; user 7 has a pending DJ request for the admin panel.
insert into public.profile_badges (user_id, badge, title) values
  ('00000000-0000-4000-a000-000000000001', 'team', 'CEO'),
  ('00000000-0000-4000-a000-000000000006', 'dj', 'Residente Galpão 23'),
  ('00000000-0000-4000-a000-000000000010', 'public_figure', null);

insert into public.badge_requests (user_id, badge, justification, links) values
  ('00000000-0000-4000-a000-000000000007', 'dj',
   'Toco techno há 5 anos em festas de SP, com sets no SoundCloud.',
   '{"https://soundcloud.com/exemplo"}');

update public.user_private up
set phone = format('+55119%s', lpad((90000000 + u.n)::text, 8, '0'))
from seed_users u
where up.user_id = u.id;


-- ---------------------------------------------------------------------------
-- Events (dates relative to today, at 23:00 São Paulo time)
-- ---------------------------------------------------------------------------

create temp table seed_events (
  n int primary key,
  name text,
  venue_name text,
  address text,
  city text,
  state text,
  days_from_now int,
  hours int,
  genres public.music_genre[],
  lineup text[],
  status public.event_status,
  creator int,
  is_official boolean
);

insert into seed_events values
  ( 1, 'Ritual',                  'Galpão 23',            'Rua Brigadeiro Galvão, 230 - Barra Funda', 'São Paulo', 'SP',  5, 8, '{techno,hard_techno}',          '{"Charlotte de Witte","Sara Landry"}',     'approved', 3, true),
  ( 2, 'Sunday Groove',           'Clube Aurora',         'Rua Guaicurus, 1200 - Lapa',  'São Paulo',      'SP', 12, 10, '{house,tech_house}',           '{"Fisher","Chris Lake"}',                  'approved', 2, false),
  ( 3, 'Subsolo',                 'Galpão na Mooca',      'Rua da Mooca, 1000',          'São Paulo',      'SP',  8, 12, '{techno,minimal}',             '{"Richie Hawtin","Ellen Allien"}',         'approved', 2, false),
  ( 4, 'Horizonte',               'Rooftop Centro',       'Av. Ipiranga, 344',           'São Paulo',      'SP', 19, 6, '{melodic_techno,trance}',       '{"Anyma","Argy"}',                         'approved', 2, false),
  ( 5, 'Raízes',                  'Casa Vermelha',        'Rua Augusta, 2203',           'São Paulo',      'SP', 26, 7, '{afro_house,house}',            '{"Black Coffee","&ME"}',                   'approved', 2, false),
  ( 6, 'Globo de Ouro',           'Salão Glitter',        'Rua Augusta, 657',            'São Paulo',      'SP', 33, 6, '{disco_nu_disco,house}',        '{"Purple Disco Machine"}',                 'approved', 2, false),
  -- Real party (D-EDGE Rio, 06/11), with the promoter's coupon.
  ( 7, 'Beltran na D-EDGE Rio',   'D-EDGE Rio',           'Av. Rodrigues Alves, 293 - Saúde', 'Rio de Janeiro', 'RJ', greatest(1, date '2026-11-06' - current_date), 7, '{tech_house}', '{"Beltran"}',               'approved', 2, true),
  ( 8, 'BOMA',                    'Edifício Touring',     'Praça Mauá - Centro',         'Rio de Janeiro', 'RJ', 13, 8, '{melodic_techno,tech_house}',   '{"ARTBAT","CamelPhat"}',                   'approved', 2, false),
  ( 9, 'Privilege Búzios',        'Privilege',            'Orla Bardot - Centro',        'Armação dos Búzios', 'RJ', 20, 7, '{edm,house}',                '{"Alok","Vintage Culture"}',               'approved', 2, false),
  (10, 'Bass Cave',               'Porão Botafogo',       'Rua Voluntários da Pátria, 400','Rio de Janeiro', 'RJ', 27, 7, '{drum_and_bass,dubstep}',     '{"Andy C","Sub Focus"}',                   'approved', 2, false),
  -- Moderation queue example (suggested by a regular user).
  (11, 'Festa Secreta do Centro', 'Local a confirmar',    null,                          'São Paulo',      'SP', 15, 8, '{techno}',                      '{}',                                       'pending',  5, false),
  -- Already over: must not appear in the discovery feed.
  (12, 'Ritual · Edição 11',      'Galpão 23',            'Rua Brigadeiro Galvão, 230 - Barra Funda', 'São Paulo', 'SP', -10, 8, '{techno}',             '{"Amelie Lens"}',                          'approved', 2, false);

insert into public.events (
  id, name, description, venue_name, city, state, lat, lng,
  starts_at, ends_at, genres, lineup, status, is_official,
  created_by, approved_by, location_reveal_hours
)
select
  format('00000000-0000-4000-b000-%s', lpad(e.n::text, 12, '0'))::uuid,
  e.name,
  format('%s · %s. Line-up completo, pista até o sol nascer. Proibido para menores de 18.', e.name, e.venue_name),
  e.venue_name, e.city, e.state,
  case when e.state = 'SP' then -23.53 when e.city = 'Armação dos Búzios' then -22.75 else -22.91 end,
  case when e.state = 'SP' then -46.64 when e.city = 'Armação dos Búzios' then -41.89 else -43.20 end,
  ((current_date + e.days_from_now)::timestamp + interval '23 hours') at time zone 'America/Sao_Paulo',
  ((current_date + e.days_from_now)::timestamp + interval '23 hours' + make_interval(hours => e.hours)) at time zone 'America/Sao_Paulo',
  e.genres, e.lineup, e.status, e.is_official,
  format('00000000-0000-4000-a000-%s', lpad(e.creator::text, 12, '0'))::uuid,
  case when e.status = 'approved'
    then format('00000000-0000-4000-a000-%s', lpad(e.creator::text, 12, '0'))::uuid
  end
,
  -- Subsolo keeps its galpão secret until 24 h before (SPEC 7.4).
  case when e.n = 3 then 24 end
from seed_events e;

-- Covers (supabase/seed/event-covers); the pending suggestion has none.
update public.events
set cover_path = id || '.jpg'
where id::text like '00000000-0000-4000-b000-%' and status = 'approved';

-- Venues (approximate real coordinates of each place).
insert into public.event_venues (event_id, address, lat, lng)
select
  format('00000000-0000-4000-b000-%s', lpad(e.n::text, 12, '0'))::uuid,
  e.address, v.lat, v.lng
from seed_events e
join (values
  ( 1, -23.5262, -46.6658),
  ( 2, -23.5268, -46.6747),
  ( 3, -23.5584, -46.5967),
  ( 4, -23.5452, -46.6430),
  ( 5, -23.5617, -46.6650),
  ( 6, -23.5527, -46.6512),
  ( 7, -22.8963, -43.1858),
  ( 8, -22.8958, -43.1797),
  ( 9, -22.7568, -41.8863),
  (10, -22.9658, -43.1868),
  (12, -23.5262, -46.6658)
) as v (n, lat, lng) on v.n = e.n;

-- ---------------------------------------------------------------------------
-- Attendance: overlapping groups so the feed has plenty of matches.
--   São Paulo (1–15): event 1 or 2 (mixing genders), plus one of 3–6, plus
--   the past event.
--   Rio (16–30): event 7 or 8, plus event 9 or 10.
-- Expectations used by supabase/tests (e.g. Ana's Date feed = Diego, Marcos).
-- ---------------------------------------------------------------------------

with picks as (
  select u.id as user_id, ev as event_n
  from seed_users u
  cross join lateral (
    values
      (case when u.n <= 15 then 1 + ((u.n / 2) % 2) else 7 + ((u.n / 2) % 2) end),
      (case when u.n <= 15 then 3 + (u.n % 4) else 9 + (u.n % 2) end),
      (case when u.n <= 15 then 12 end)
  ) as v(ev)
  where ev is not null
)
insert into public.event_attendance (user_id, event_id)
select
  user_id,
  format('00000000-0000-4000-b000-%s', lpad(event_n::text, 12, '0'))::uuid
from picks
on conflict do nothing;

-- Plans (monetization): Elisa (5) has Pulse Black with some packs, Felipe
-- (6) has Pulse+. Granted by "admin", so no store is needed locally.
insert into public.subscriptions (user_id, tier, source) values
  ('00000000-0000-4000-a000-000000000005', 'black', 'admin'),
  ('00000000-0000-4000-a000-000000000006', 'plus', 'admin');
insert into public.wallets (user_id, superlikes, boosts) values
  ('00000000-0000-4000-a000-000000000005', 3, 1);

-- Pending likes for "who liked you" (Crew likes need a party in common:
-- Hugo and Elisa share one): Elisa (Black) sees who they are, Ana
-- (free) only how many.
insert into public.swipes (swiper_id, swiped_id, mode, direction, is_super) values
  ('00000000-0000-4000-a000-000000000002', '00000000-0000-4000-a000-000000000005', 'date', 'like', false),
  ('00000000-0000-4000-a000-000000000024', '00000000-0000-4000-a000-000000000005', 'date', 'like', false),
  ('00000000-0000-4000-a000-000000000008', '00000000-0000-4000-a000-000000000005', 'crew', 'like', false),
  ('00000000-0000-4000-a000-000000000027', '00000000-0000-4000-a000-000000000005', 'date', 'like', true),
  ('00000000-0000-4000-a000-000000000002', '00000000-0000-4000-a000-000000000001', 'date', 'like', false),
  ('00000000-0000-4000-a000-000000000004', '00000000-0000-4000-a000-000000000001', 'date', 'like', false);

-- Ticket links with a promoter coupon (tickets migration), for testing the
-- coupon row and the tap count. Event 7 is the real D-EDGE Rio party.
update public.events
set ticket_url = 'https://ingressos.exemplo.com.br/ritual?ref=pulse',
    ticket_coupon = 'PULSE10'
where id = '00000000-0000-4000-b000-000000000001';
update public.events
set ticket_url = 'https://ingresse.com/d-edge-rio-3-anos',
    ticket_coupon = 'SANT'
where id = '00000000-0000-4000-b000-000000000007';
update public.events
set description = 'A D-EDGE Rio comemora 3 anos com Beltran na cabine. Proibido para menores de 18.'
where id = '00000000-0000-4000-b000-000000000007';

-- Profile prompts (a few profiles answer, so the cards show them).
insert into public.profile_prompts (user_id, position, prompt, answer) values
  ('00000000-0000-4000-a000-000000000001', 0, 'dream_set', 'Charlotte de Witte no nascer do sol, sem hora pra acabar.'),
  ('00000000-0000-4000-a000-000000000001', 1, 'on_the_floor', 'A que não sai da frente da caixa.'),
  ('00000000-0000-4000-a000-000000000002', 0, 'after_party', 'Pão de queijo na padaria às 7h.'),
  ('00000000-0000-4000-a000-000000000004', 0, 'best_party', 'Warung em Itajaí, chovendo, todo mundo dançando.'),
  ('00000000-0000-4000-a000-000000000004', 1, 'green_flag', 'Dividir água sem eu pedir.'),
  ('00000000-0000-4000-a000-000000000006', 0, 'crew_role', 'Leva o carregador portátil e lembra onde estacionou.'),
  ('00000000-0000-4000-a000-000000000010', 0, 'match_if', 'Topa sair de uma festa pra outra.'),
  ('00000000-0000-4000-a000-000000000012', 0, 'track_on_repeat', 'Innerbloom, versão de 9 minutos.'),
  ('00000000-0000-4000-a000-000000000014', 0, 'festival_must', 'Protetor solar, leque e a minha crew.');
