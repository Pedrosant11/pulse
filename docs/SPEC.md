# SPEC — App de match para festas eletrônicas

> Nome provisório: **Pulse** (trocar depois em `lib/app/constants.dart` e nos arquivos de plataforma).
> Este documento é a fonte da verdade do projeto. Leia inteiro antes de começar e siga as fases na ordem.

---

## 1. Visão geral

Aplicativo mobile (Android e iOS) estilo Tinder, focado em festas e festivais de música eletrônica. O usuário marca os eventos em que vai e, na tela de descoberta, vê pessoas que marcaram **os mesmos eventos**.

O app tem dois **modos** de descoberta, na mesma aba:

- **Date**: casual, encontro ou relacionamento.
- **Crew**: fazer amizade e montar grupos para ninguém ir sozinho à festa.

O usuário escolhe em quais modos quer aparecer (um ou os dois). Swipes e matches são separados por modo.

Público: maiores de 18 anos, Brasil, interface em português (pt-BR). Preparar a estrutura para i18n desde o início (arquivos ARB), mas só traduzir pt-BR por enquanto.

---

## 2. Stack

- **Flutter** (stable mais recente) + **Dart 3**, null safety, Material 3.
- **Estado**: `flutter_riverpod` + `riverpod_annotation` / `riverpod_generator`.
- **Navegação**: `go_router` (com redirect baseado no estado de auth e onboarding).
- **Modelos**: `freezed` + `json_serializable`.
- **Backend**: **Supabase** (`supabase_flutter`): Auth, Postgres, Storage, Realtime e Edge Functions.
- **Animações**: `flutter_animate`, `rive`, fragment shaders nativos do Flutter (GLSL em `shaders/`).
- **Imagens**: `image_picker`, `image_cropper`, `flutter_image_compress`, `cached_network_image`.
- **Fontes**: `google_fonts` (ou fontes empacotadas em `assets/fonts`).
- **Outros**: `intl`, `flutter_localizations`, `pinput` (campo de OTP), `haptic feedback` nativo.

Use as versões estáveis mais recentes de cada pacote (verifique no pub.dev). Não use three.js nem WebView para efeitos visuais.

Configuração sensível via `--dart-define-from-file=env.json` (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` — a chave `sb_publishable_...`). Criar `env.example.json` e adicionar `env.json` ao `.gitignore`. Nunca colocar a service role key no app.

---

## 3. Estrutura de pastas (feature-first)

```
lib/
  main.dart
  app/            # app.dart, router.dart, theme/, constants.dart
  core/           # supabase client, erros, extensions, utils, widgets compartilhados, shaders helpers
  features/
    auth/         # data/ domain/ presentation/
    onboarding/
    profile/
    events/
    discover/
    matches/
    chat/
    crews/
    safety/       # bloquear, denunciar
    admin/        # fila de aprovação, denúncias, pedidos de papel
    settings/
  l10n/
shaders/          # *.frag
assets/
  rive/
  images/
  fonts/
supabase/
  migrations/     # SQL versionado
  functions/      # edge functions (Deno/TypeScript)
  seed.sql
test/
```

Cada feature com camadas `data` (repositórios, chamadas Supabase), `domain` (modelos freezed) e `presentation` (telas, widgets, providers).

---

## 4. Papéis de usuário

| Papel | O que pode fazer |
|---|---|
| `user` | Perfil, swipe, chat, crews, marcar presença em eventos, **sugerir** eventos (ficam pendentes). |
| `curator` | Tudo do user + cadastrar eventos já aprovados + aprovar/rejeitar sugestões. |
| `producer` | Tudo do user + cadastrar os **próprios** eventos, que recebem o selo "Oficial". |
| `admin` | Tudo + moderar denúncias, aprovar pedidos de curador/produtor, remover eventos e usuários. |

- O usuário pode pedir para virar curador ou produtor pela tela de configurações (tabela `role_requests`), e um admin aprova.
- O papel `admin` é definido manualmente via SQL.
- O usuário **nunca** pode alterar o próprio `role` (garantir por RLS e trigger).

---

## 5. Cadastro e autenticação

### 5.1 Fluxo de cadastro (multi-step, com barra de progresso animada)

1. **Dados da conta**: nome, sobrenome, e-mail, senha (mín. 8 caracteres, com indicador de força), data de nascimento.
   - Bloquear menores de 18 anos já nesta etapa, com mensagem clara.
2. **Celular**: número com DDI (padrão +55) e máscara. Obrigatório e **único por conta** (constraint no banco), mas **sem código de verificação** (decisão de lançamento, 2026-10-10).
3. **Termos**: aceite obrigatório dos Termos de Uso e da Política de Privacidade, e consentimento LGPD (gravar data/hora do aceite e versão dos termos).
4. Confirmação de e-mail (link do Supabase) pode acontecer em paralelo; bloquear funcionalidades sociais até o e-mail estar confirmado.

Implementação: `signUp` com e-mail e senha; o celular é salvo direto em `user_private.phone` (E.164, único). Um número só pode estar vinculado a uma conta.

### 5.2 Login e segurança

- Login com e-mail e senha.
- **2FA por telefone** (MFA do Supabase, fator phone): **só na fase de lançamento**, porque depende do provedor pago. Deixar o fluxo de login preparado para uma etapa extra de código, mas desligado por padrão.
- Recuperação de senha por e-mail.
- Logout e "sair de todos os dispositivos".
- **Excluir conta** pelo app (obrigatório nas lojas): Edge Function com service role que apaga o usuário do Auth, as fotos do Storage e os dados (cascade).
- Fase posterior (não fazer agora): login com Google e Apple.

### 5.3 Verificação de telefone

Não há verificação por código no lançamento: só o e-mail é confirmado. O modo de teste (código fixo) e a RPC `verify_phone_mock` foram removidos (migration `20261018120000_phone_without_code.sql`). Se no futuro a verificação voltar, usar o OTP de telefone do Supabase (Twilio), com nova migration.

### 5.4 Dados privados vs públicos

Nunca exibir para outros usuários: sobrenome, e-mail, telefone, data de nascimento exata, localização precisa. Outros usuários veem apenas primeiro nome, idade calculada e cidade.

### 5.5 LGPD e documentos legais

- **Documentos** em `assets/legal/` (fonte única, em Markdown): Termos de Uso, Política de Privacidade, Diretrizes da Comunidade e Como excluir a conta. O app mostra os documentos embutidos (funciona offline), em `/legal/<slug>`, acessível em qualquer estado da sessão. O site público (GitHub Pages) é gerado a partir dos mesmos arquivos com `dart run tool/build_site.dart` em `site/`; um teste falha se o site estiver desatualizado.
- **Aceite**: no cadastro, cada caixa tem o link "Ler". A versão aceita fica em `profiles.terms_version` (`AppConstants.termsVersion`, hoje `2026-10-04`). Mudou a versão, todo mundo aceita de novo.
- **Dado sensível**: orientação sexual só é salva com consentimento específico (`profiles.sensitive_data_consent_at`, com o relógio do servidor). Remover a orientação revoga o consentimento. Regra no banco.
- **Direitos do titular**: "Baixar meus dados" em Configurações (RPC `export_my_data()` + links temporários das fotos, compartilhado como JSON), editar perfil (correção), excluir conta (eliminação).
- **Marcadores a preencher antes de publicar**: `[NOME DO CONTROLADOR]`, `[CPF OU CNPJ]`, `[NÚMERO DO DOCUMENTO]`, `[ENDEREÇO]`, `[E-MAIL DE CONTATO]`, `[E-MAIL DE PRIVACIDADE]`, `[NOME DO ENCARREGADO…]`, `[DATA DE PUBLICAÇÃO]`, `[PRAZO DE BACKUP]`.

---

## 6. Perfil

### 6.1 Campos

- **Fotos**: mínimo 2, máximo 6. Reordenáveis por arrastar, com a primeira sendo a principal. Recorte 4:5, compressão para no máximo 1080px de largura antes do upload.
- **Básico**: primeiro nome (vindo do cadastro), idade (calculada), cidade/estado (escolha da lista ou sugestão pelo GPS; salvar só a cidade e coordenadas arredondadas para ~1 km).
- **Área de atuação** (texto curto) e **descrição/bio** (máx. 500 caracteres).
- **Sobre mim** (todos opcionais): altura (cm), idiomas (multi-seleção), signo, bebida (não/socialmente/sim), fumo (não/socialmente/sim), pets.
- **Gênero** (lista inclusiva + "prefiro não dizer") e **orientação** (opcional, com opção de exibir ou não no perfil).
- **Música**: gêneros favoritos (techno, house, tech house, melodic techno, psytrance, trance, drum & bass, dubstep, afro house, minimal, hard techno, disco/nu-disco, EDM, outros) e DJs favoritos (tags livres, máx. 10).
- **Modos ativos**: Date e/ou Crew (pelo menos um).
- **Preferências do Date**: o que busca (casual, encontro, relacionamento, ainda descobrindo), "mostrar para mim" (gêneros), faixa etária.
- **Preferências do Crew**: mostrar todos ou só pessoas do mesmo gênero (importante para quem quer crew só de mulheres, por exemplo).
- **Raio de distância** (vale para Date, Crew e eventos): padrão 50 km, ajustável até 100 km no plano grátis. A distância é calculada a partir das coordenadas aproximadas do perfil e da cidade do evento.

Não criar nenhum campo relacionado a uso de drogas.

### 6.2 Onboarding de perfil

Após o cadastro, fluxo em etapas: fotos → básico → sobre mim → música → modos e preferências → primeiro evento (convite para marcar presença em algum evento já cadastrado). Salvar progresso a cada etapa. O usuário só aparece no feed quando `onboarding_completed = true` e tem pelo menos 2 fotos.

### 6.3 Tela de perfil

Visualização do próprio perfil exatamente como os outros veem (preview), botão editar, selo de verificado, lista de próximos eventos marcados.

### 6.4 Selos de identificação

Mostram quem a pessoa é na cena (diferente do selo de verificado, que é sobre identidade; ver Fase 11).

- **Catálogo**: **Equipe Pulse**, **DJ** e **Figura pública** (tabela `profile_badges`), mais **Produtor**, que vem automaticamente do papel `producer`. Cada selo pode ter um **título** definido pelo admin (ex.: Equipe Pulse · "CEO", DJ · "Residente D-Edge"). Uma pessoa pode ter vários.
- **Quem concede**: só admins (RLS). Usuários pedem DJ ou Figura pública em Configurações (tabela `badge_requests`, com justificativa e links); Equipe Pulse nunca pode ser pedido. Aprovar o pedido concede o selo (trigger).
- **Painel admin → Selos**: pedidos pendentes e busca de pessoas pelo nome para dar, editar o título ou tirar selos. Admins também gerenciam pelo perfil de qualquer pessoa.
- **Onde aparece**: card do Descobrir (até 2), perfil, cabeçalho do chat, membros da crew e "Criado por" do evento. Escondido junto com o perfil (bloqueio, conta inativa), via RPC `get_user_badges`.

---

## 7. Eventos

### 7.1 Campos

Nome, descrição, imagem de capa, nome do local, endereço, cidade, estado, data/hora de início, data/hora de término, gêneros, line-up (lista de nomes), link de ingresso (opcional), classificação etária, status, criador, se é oficial.

Status: `pending`, `approved`, `rejected`, `cancelled`.

### 7.2 Regras

- Usuário comum cria com `status = pending`. Curador, produtor e admin criam com `approved` (forçar via trigger, não confiar no app).
- Evento criado por produtor recebe `is_official = true`.
- **Anti-duplicação**: antes de salvar, chamar uma RPC que usa `pg_trgm` para buscar eventos parecidos (mesmo dia, mesma cidade, nome similar) e mostrar "Esse evento já existe?" com a opção de marcar presença no existente.
- Edição: criador do evento, curadores e admin.

### 7.3 Telas

- **Lista de eventos**: abas "Próximos" e "Meus eventos". "Próximos" mostra por padrão os eventos **dentro do raio do usuário**. Filtro por data e gênero musical. **Busca por nome em todo o Brasil é grátis** (para achar, por exemplo, um festival em outra cidade). Navegar pela lista de **outra cidade** é o **Passaporte** (pago, ver seção 15). Cards grandes com capa, data em destaque e contador de "X pessoas vão".
- **Marcar presença e ver quem vai é grátis em qualquer cidade.**
- **Detalhe**: capa com efeito parallax, informações, line-up, botão grande "Eu vou" (com animação) e link de ingresso. Seções "Quem vai" (avatares desfocados para quem não deu match, com contagem por modo) e "Crews deste evento".
- **Criar/sugerir evento**: formulário com validação, seletor de data/hora, upload de capa.
- **Fila de aprovação** (curador/admin): aprovar, rejeitar com motivo, editar antes de aprovar.

Eventos encerrados saem do feed de descoberta, mas os matches e chats continuam.

### 7.4 Mapa de eventos

- **Local exato**: ao criar/editar, o criador busca o endereço com número ou o nome do lugar (Photon, geocoder do OpenStreetMap: só Brasil, completado com a cidade escolhida; acha muitas casas pelo nome, mas não todas) ou o **CEP** (ViaCEP, traz o nome da rua) e ajusta o pin tocando no mapa; o toque preenche o endereço do ponto se o campo estiver vazio. Endereço e coordenada ficam em `event_venues` (separado de `events`, que guarda o centro da cidade usado no filtro de raio).
- **Local secreto (opcional)**: o criador escolhe revelar o endereço 6, 12, 24 ou 48 h antes do início (`events.location_reveal_hours`). Até lá, a RLS esconde a linha de `event_venues` (criador e moderadores sempre veem) e o mapa mostra só a região: o ponto arredondado a ~1 km com um círculo de 1,5 km. A coordenada exata nunca sai do banco antes da hora.
- **Aba Eventos → Próximos**: alternar Lista/Mapa. O mapa usa os mesmos filtros e raio da lista, tema escuro, pins neon (lima para oficiais), agrupamento quando há muitos eventos próximos e, ao tocar num pin, o card do evento.
- **Detalhe do evento**: mini-mapa com o pin e botão "Como chegar" (abre o Google Maps). Com local secreto, mostra "O endereço aparece em {data}".
- **Provedores (todos grátis, sem chave, uso comercial liberado)**: mapa com tiles vetoriais do **OpenFreeMap** (estilo `dark`, via `flutter_map` + `vector_map_tiles`), busca no **Photon** público (komoot) e CEP no **ViaCEP**. Se o mapa base não carregar (ex.: offline), os pins continuam e aparece um aviso. Atribuição "OpenFreeMap © OpenMapTiles © OpenStreetMap" sempre visível. Ao crescer: hospedar o Photon (mesma API, trocar `photonHost`) e, se precisar de busca melhor por nome de casa, avaliar Google Places ou Mapbox.

---

## 8. Descoberta (swipe)

### 8.1 Regras do feed

RPC `get_discover_feed(p_mode text, p_limit int)` que retorna perfis que:

- marcaram pelo menos um **evento futuro aprovado** em comum com o usuário (em qualquer distância: o evento já define o lugar, então quem vai ao mesmo festival em outra cidade aparece);
- têm o `p_mode` entre os modos ativos e onboarding completo;
- não são o próprio usuário, não foram swipados por ele naquele modo e não têm bloqueio em nenhuma direção;
- no Date: respeitam as preferências de gênero e faixa etária **dos dois lados**;
- no Crew: respeitam o filtro "só mesmo gênero" dos dois lados.

Ordenação: quantidade de eventos em comum (desc), depois o evento em comum mais próximo, depois atividade recente. Retornar junto a lista de eventos em comum de cada perfil.

**Fallback**: se não houver ninguém, retornar perfis **dentro do raio do usuário** com gêneros musicais em comum (mais próximos primeiro), marcados com `is_fallback = true`, e a UI mostra um aviso "Você já viu todo mundo dos seus eventos por enquanto. Que tal essas pessoas perto de você com o mesmo gosto musical?"; nesses cards o chip do evento dá lugar a "Vocês curtem: [gêneros em comum]". Se o usuário não marcou nenhum evento, mostrar um estado vazio que leva para a aba Eventos.

### 8.2 UI

- Seletor de modo no topo (Date / Crew) com transição animada; a paleta de cor de destaque muda levemente por modo (Date: magenta, Crew: ciano).
- Card com fotos (toque nas laterais troca de foto, indicadores no topo), nome, idade, cidade e distância. O conteúdo muda por modo:
  - **Date**: chip **"Vocês vão: [evento]"** (+N), o que a pessoa busca e um trecho da bio.
  - **Crew**: o evento é o protagonista — faixa **"Procurando crew para: [evento]"** (+N) no topo do card — e afinidade musical (gêneros e DJs favoritos). Na Fase 7 o card também indica se a pessoa vai sozinha ou já tem crew naquele evento.
- Arrastar o card para cima ou tocar abre o perfil completo.
- Swipe com física própria (GestureDetector + AnimationController): rotação proporcional ao arraste, carimbo aparecendo com opacidade progressiva. Textos dos carimbos: Date = "CURTI" / "PASSO"; Crew = "BORA" / "PASSO".
- Botões de passar, desfazer (só o último swipe) e curtir. Haptic feedback no like e no match.
- Pré-carregar as imagens dos próximos 3 cards.

### 8.3 Match

- Like mútuo no mesmo modo gera um registro em `matches` via **trigger no banco** (nunca no app).
- Tela de match em tela cheia: shader de explosão neon + animação Rive, fotos dos dois, nome do evento em comum, botões "Mandar mensagem" e "Continuar".
- Cria automaticamente a conversa 1:1.

---

## 9. Chat

### 9.1 1:1

- Lista de conversas com abas Date / Crew / Grupos. Novos matches aparecem numa faixa horizontal no topo.
- Mensagens de texto em tempo real (Supabase Realtime), com status de enviado/lido e indicador "digitando" (via Presence/Broadcast).
- Sugestão de quebra-gelo baseada no evento em comum.
- Menu da conversa: ver perfil, desfazer match, bloquear, denunciar.
- Paginação das mensagens (carregar 30 por vez).

Fora do MVP: envio de fotos, áudio e GIFs.

### 9.2 Crews (grupos)

- Crew é sempre ligada a **um evento**. Máximo de 8 membros.
- Qualquer usuário que vai ao evento pode criar uma crew (nome, descrição curta, só mesmo gênero sim/não, aberta ou só convite).
- O dono pode convidar pessoas com quem tem match no modo Crew e que vão ao mesmo evento.
- Crews abertas aparecem no detalhe do evento com botão "Pedir pra entrar"; o dono aprova ou recusa.
- Cada crew tem um chat em grupo (mesma infraestrutura do 1:1).
- Membros podem sair; o dono pode remover membros e transferir a posse.

---

## 10. Segurança e moderação (obrigatório para as lojas)

- **Bloquear**: remove o match, esconde em qualquer lugar (feed, eventos, crews) nas duas direções.
- **Denunciar** usuário, mensagem ou evento, com motivos pré-definidos e campo opcional.
- Painel admin dentro do app (visível só para admin): denúncias pendentes, pedidos de papel, eventos pendentes; ações de advertir, suspender e banir (`profiles.status`).
- Rate limit simples no banco: máximo de swipes e mensagens por minuto (função + trigger).
- Tela de dicas de segurança em festas (link no perfil e no primeiro match).

---

## 11. Banco de dados (Supabase / Postgres)

Criar em `supabase/migrations/` com **RLS ativado em todas as tabelas**. Ativar a extensão `pg_trgm`.

### Tabelas

- `profiles`: `id` (pk, fk `auth.users` on delete cascade), `first_name`, `last_name`, `birth_date` (check ≥ 18 anos), `gender`, `orientation`, `show_orientation`, `city`, `state`, `lat`, `lng` (arredondados), `occupation`, `bio`, `height_cm`, `languages text[]`, `zodiac`, `drinks`, `smokes`, `music_genres text[]`, `favorite_djs text[]`, `modes text[]`, `date_looking_for`, `date_show_me text[]`, `date_age_min`, `date_age_max`, `crew_same_gender_only bool`, `role` (default `user`), `status` (`active`, `suspended`, `banned`), `is_verified`, `onboarding_completed`, `terms_accepted_at`, `terms_version`, `last_active_at`, `created_at`, `updated_at`.
- View `public_profiles`: expõe só os campos públicos + `age` calculada. Os demais usuários consultam apenas a view.
- `user_private`: `user_id` (pk), `phone` (unique), `phone_verified_at`. Só o próprio usuário lê; escrita do campo verificado apenas via RPC (seção 5.3).
- `profile_photos`: `id`, `user_id`, `storage_path`, `position` (0–5), `created_at`. Unique `(user_id, position)`; trigger impedindo mais de 6.
- `events`: campos da seção 7.1 + `created_by`, `approved_by`, `rejection_reason`, timestamps.
- `event_attendance`: `user_id`, `event_id`, `created_at`, pk composta.
- `swipes`: `swiper_id`, `swiped_id`, `mode`, `direction` (`like`/`pass`), `created_at`; pk `(swiper_id, swiped_id, mode)`.
- `matches`: `id`, `user_a`, `user_b` (check `user_a < user_b`), `mode`, `created_at`, `unmatched_at`; unique `(user_a, user_b, mode)`.
- `conversations`: `id`, `type` (`direct`/`crew`), `match_id`, `crew_id`, `last_message_at`.
- `conversation_members`: `conversation_id`, `user_id`, `last_read_at`, `joined_at`.
- `messages`: `id`, `conversation_id`, `sender_id`, `content` (máx. 2000), `created_at`, `deleted_at`.
- `crews`: `id`, `event_id`, `owner_id`, `name`, `description`, `max_members` (default 8, máx. 8), `is_open`, `same_gender_only`, `conversation_id`, `created_at`.
- `crew_members`: `crew_id`, `user_id`, `role` (`owner`/`member`), `joined_at`.
- `crew_join_requests`: `id`, `crew_id`, `user_id`, `status`, `created_at`.
- `blocks`: `blocker_id`, `blocked_id`, `created_at`.
- `reports`: `id`, `reporter_id`, `target_type` (`user`/`message`/`event`), `target_id`, `reason`, `details`, `status`, `resolved_by`, `created_at`.
- `role_requests`: `id`, `user_id`, `requested_role`, `justification`, `links`, `status`, `reviewed_by`, `created_at`.

### Funções e triggers

- `handle_new_user`: cria a linha em `profiles` ao criar usuário no Auth.
- `prevent_role_change`: impede que o próprio usuário altere `role`, `status` e `is_verified`.
- `set_event_status_on_insert`: define `pending`/`approved` e `is_official` conforme o papel.
- `create_match_on_mutual_like`: cria match + conversa direct + membros.
- `get_discover_feed(mode, limit)`: seção 8.1 (`security definer`, com `search_path` fixo).
- `find_similar_events(title, starts_at, city)`: anti-duplicação.
- `is_blocked(a, b)`: helper usado nas políticas.
- Rate limits de swipe e mensagem.

### Storage

- Bucket `profile-photos` (caminho `{user_id}/{uuid}.jpg`): o dono escreve e apaga; usuários autenticados leem.
- Bucket `event-covers`: escrita pelo criador do evento; leitura pública.

### Seed

`supabase/seed.sql` com ~10 eventos fictícios em São Paulo e Rio de Janeiro, e ~30 perfis fictícios marcando presença neles (fotos placeholder), para testar o feed.

---

## 12. Design system

### Direção visual

Escuro, neon, com cara de pista de dança à noite. Moderno e limpo, sem poluição. Inspirações: flyers de techno, luz de laser, fumaça.

### Cores (definir como `ThemeExtension`)

- Fundo: `#0A0A0F`; superfície: `#14141C`; superfície elevada: `#1E1E2A`.
- Magenta (Date / ação principal): `#FF2BD6`.
- Ciano (Crew): `#00E5FF`.
- Violeta (gradientes): `#7B2CFF`.
- Lima ácido (destaques pontuais, badges): `#C6FF00`.
- Texto: `#F5F5F7` / secundário `#9A9AB0`.
- Erro: `#FF4D6D`; sucesso: `#2BFF88`.

Gradiente principal: violeta → magenta. Gradiente do Crew: violeta → ciano.

### Tipografia

- Títulos: **Unbounded** (ou Space Grotesk) em caixa alta nos destaques.
- Corpo: **Inter**.

### Logo

- Marca: anel neon (violeta → magenta) com uma linha de batimento (pulso) dentro, desenhada em código (`PulseLogo` / `PulseMark`, `lib/core/widgets/pulse_logo.dart`), mais o wordmark "PULSE" com o gradiente principal. No splash, a marca "bate" em loop (estática com redução de movimento).
- Aparece no splash e nas telas de entrada (login, cadastro, esqueci a senha, confirmação de e-mail, nova senha).
- Ícone do app e splash nativo (Android/iOS) gerados a partir da mesma marca: `flutter test tool/brand/render_brand_test.dart`, depois `dart run flutter_launcher_icons` e `dart run flutter_native_splash:create`. Para adotar uma arte oficial, troque o desenho em `PulseMark` (ou as imagens em `assets/brand/`) e rode os comandos.

### Componentes

Cards com glassmorphism sutil (blur + borda 1px com gradiente), botões com glow suave no estado ativo, chips de gênero musical, bottom navigation flutuante com 4 itens (Descobrir, Eventos, Chats, Perfil) e indicador animado.

### Animações

- **Shaders** em `shaders/`:
  - `neon_background.frag`: gradiente vivo e lento tipo fumaça com luz, usado no splash, login e onboarding.
  - `match_burst.frag`: explosão de luz na tela de match.
  - `glitch.frag`: efeito glitch rápido em transições pontuais (ex.: troca de modo).
- **Rive**: animação do match e do botão "Eu vou". Se não houver arquivo `.riv` disponível, criar um placeholder e deixar documentado onde trocar.
- **flutter_animate**: entrada de listas em cascata, transições entre etapas, microinterações nos botões.
- Shimmer nos estados de carregamento, Hero animation da foto do card para o perfil completo.
- Respeitar `MediaQuery.disableAnimations` (reduzir ou desligar shaders e animações pesadas).
- Manter 60fps: evitar rebuilds desnecessários, usar `RepaintBoundary` nos shaders.

### Estados

Toda tela precisa de estados de carregando, vazio (com ilustração ou animação e chamada para ação) e erro (com botão de tentar de novo).

---

## 13. Qualidade

- `flutter analyze` sem warnings; usar `very_good_analysis` ou `flutter_lints`.
- Testes unitários para repositórios e lógica de providers; testes das RPCs principais (feed, match) via SQL ou integração com Supabase local.
- Rodar Supabase local (`supabase start`) durante o desenvolvimento.
- Tratamento de erros centralizado, com mensagens amigáveis em português.
- Acessibilidade: `Semantics` nos botões de swipe, contraste adequado, tamanhos de fonte dinâmicos.

---

## 14. Fases de implementação

**Trabalhe uma fase por vez. Ao final de cada fase: rode `flutter analyze` e os testes, faça um resumo do que foi feito, liste o que eu preciso configurar manualmente (ex.: chaves, painel do Supabase) e pare esperando minha confirmação.** Se algo nesta spec estiver ambíguo ou parecer uma má decisão técnica, pergunte antes de seguir.

0. **Setup**: projeto Flutter, estrutura de pastas, dependências, tema e design system, go_router com telas placeholder, inicialização do Supabase, env, lints, l10n.
1. **Banco**: migrations, RLS, storage, funções, triggers e seed. Testar o feed e o match com dados do seed.
2. **Auth**: cadastro multi-step, verificação de telefone com o serviço mock (seção 5.3), termos, login, recuperação de senha, logout.
3. **Perfil**: onboarding em etapas, upload e reordenação de fotos, edição, preview.
4. **Eventos**: lista, filtros, detalhe, "Eu vou", criar/sugerir com anti-duplicação, fila de aprovação, pedidos de papel.
5. **Descoberta**: seletor de modo, cards com swipe, feed via RPC, fallback, desfazer, tela de match.
6. **Chat 1:1**: lista, conversa em tempo real, lido, digitando, desfazer match.
7. **Crews**: criar, convidar, pedidos de entrada, chat em grupo. No card do Crew, indicar "vai sozinho(a)" ou "já tem crew de N" naquele evento. A tela de match do Crew tem como ação principal **"Montar crew para [evento]"** (cria a crew já convidando a pessoa), com "Mandar mensagem" como secundária.
8. **Segurança**: bloquear, denunciar, painel admin, rate limit, excluir conta (Edge Function).
9. **Polimento**: shaders, Rive, Hero animations, estados vazios, revisão de performance e acessibilidade.
10. **Lançamento** (decidido em 2026-10-10, Android primeiro):
    - **Verificação de celular sem código**: só o e-mail é confirmado. O celular continua obrigatório e único por conta (constraint no banco), mas sem OTP; remover a etapa de código e a RPC mock. Twilio/2FA ficam para depois.
    - **Login com Google e Apple** (Supabase `signInWithIdToken`), pedindo no app os dados que faltarem (nascimento 18+, celular, termos).
    - **Notificações push** (feito): FCM só como entrega; tokens em `push_tokens` no Supabase. Gatilhos do banco (match, mensagem, convite e pedido de crew, aceite) chamam a Edge Function `send-push` via pg_net, com URL e segredo no Vault. Texto genérico, sem nomes nem conteúdo. Canais Android: matches, messages, crews. Ver `docs/PUSH.md`.
    - **Feito**: registros de acesso por 6 meses (`private.access_logs`, `log_access()`), e-mails do Auth em português (`supabase/templates/`, guia em `docs/EMAILS.md`).
    - **Infra e lojas**: primeiro commit e repositório privado no GitHub; chave de assinatura Android (upload key) fora do git; plano Pro do Supabase; domínio próprio no Resend; colar os modelos de e-mail no painel; Site URL do Auth; teste fechado do Google Play (12 testadores, 14 dias); iOS depois (Mac ou build na nuvem + conta Apple).
    - **Documentos legais**: preencher os marcadores (seção 5.5), revisão por advogado, publicar o site (GitHub Pages) e cadastrar as URLs nas lojas.
    - **Recomendado**: relatório de falhas (Sentry ou Crashlytics), checar disponibilidade do nome "Pulse" (lojas e INPI), eventos reais cadastrados e quem modera as denúncias.
11. **Depois do MVP** (não fazer agora): verificação por selfie (selfie na hora com um gesto sorteado, revisada manualmente pela moderação; o selo cai se a pessoa trocar as fotos), fotos no chat, monetização (seção 15).

---

## 15. Monetização (depois do MVP)

Modelo freemium, no estilo do Tinder. O plano grátis cobre a sua região; quem paga ganha alcance e conveniências.

| Recurso | Grátis | Pago (assinatura e/ou créditos) |
|---|---|---|
| Raio de distância | até 100 km | — |
| Marcar presença em eventos de qualquer cidade e ver quem vai | ✅ | ✅ |
| Buscar evento por nome no Brasil todo | ✅ | ✅ |
| **Passaporte**: navegar por eventos e pessoas de outra cidade | — | ✅ |
| Likes por dia | limitado (ex.: 50/dia) | ilimitado |
| **Super like** | — | ✅ (créditos) |
| **Voltar** o último swipe (curtiu ou passou sem querer) | — | ✅ |
| **Ver quem te curtiu** | — | ✅ |

Regras:

- Compras dentro do app **obrigatoriamente pelo sistema das lojas** (In-App Purchase da Apple e Google Play Billing), recomendado via RevenueCat. Não usar checkout próprio, Stripe ou Pix para recursos digitais.
- O direito de uso (plano ativo, créditos) fica no **banco**, atualizado pelo webhook da loja/RevenueCat numa Edge Function; as regras (limite de likes, passaporte, voltar, ver quem curtiu) são checadas em RLS/RPCs, nunca só no app.
- Até essa fase existir: likes sem limite, "voltar" disponível para todos (como na seção 8.2), e Passaporte, super like e "ver quem te curtiu" não aparecem.
