# Pulse

App de match para festas e festivais de música eletrônica (modos **Date** e **Crew**). Flutter + Supabase.

A especificação completa está em [docs/SPEC.md](docs/SPEC.md); convenções em [CLAUDE.md](CLAUDE.md).

## Requisitos

- Flutter stable (3.47+) / Dart 3.13+
- Android SDK (via Android Studio). Build iOS exige macOS + Xcode.

## Configuração

1. Copie `env.example.json` para `env.json` e preencha com os dados do projeto Supabase
   (Project Settings → API Keys): `SUPABASE_URL` e a **publishable key** (`sb_publishable_...`).
   Nunca use a secret/service role key no app.
2. Instale as dependências e gere o código:

   ```sh
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Rode:

   ```sh
   flutter run --dart-define-from-file=env.json
   ```

   No VS Code, a configuração "Pulse (debug)" em `.vscode/launch.json` já passa o `env.json`.

## Banco (Supabase local)

Requer Docker Desktop (com WSL2) e o Supabase CLI.

```sh
supabase start        # sobe Postgres, Auth, Storage, Realtime e Studio (http://127.0.0.1:54323)
supabase db reset     # recria o banco: migrations + seed.sql + fotos do seed
supabase test db      # testes pgTAP em supabase/tests/database
```

O seed cria 30 usuários (`seed01@pulse.test` … `seed30@pulse.test`, senha `pulse1234`;
01 = admin, 02 = curador, 03 = produtor) e eventos em SP e RJ. Para usar o banco local no app,
crie um `env.local.json` (ignorado pelo git) com `SUPABASE_URL` = `http://10.0.2.2:54321`
(emulador Android) e a publishable key do `supabase status`, e rode
`flutter run --dart-define-from-file=env.local.json`. Localmente a confirmação de e-mail é
desligada; os e-mails enviados aparecem no Mailpit (http://127.0.0.1:54324).

Toda mudança de schema é uma **nova** migration (`supabase migration new <nome>`); nunca edite
uma migration já aplicada. Para aplicar no projeto da nuvem: `supabase link` e `supabase db push`
(o seed não é enviado).

## Qualidade

```sh
flutter analyze
flutter test
supabase test db
```

## Estrutura

```
lib/
  app/        # app, router, rotas, tema (design system), constantes
  core/       # config (env), supabase, erros, extensions, modelos e widgets compartilhados
  features/   # <feature>/{data,domain,presentation}
  l10n/       # ARB (pt-BR) + código gerado
supabase/     # migrations, edge functions, seed
shaders/      # fragment shaders (Fase 9)
assets/       # fonts (Unbounded, Inter — OFL), images, rive
```
