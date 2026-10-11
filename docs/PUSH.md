# Notificações push

O Firebase (FCM) só entrega as notificações. Os tokens dos aparelhos e as regras de envio ficam no Supabase.

```
evento no banco (match, mensagem, crew)
  → gatilho → private.send_push()            (filtra ativos, bloqueios, rajadas)
  → pg_net → Edge Function send-push          (segredo compartilhado)
  → FCM HTTP v1 → aparelho                    (texto genérico, sem nomes)
```

| Tipo | Quem recebe | Canal Android | Abre |
|---|---|---|---|
| `match` | quem curtiu primeiro | matches | Conversas |
| `message` / `crew_message` | os outros membros (menos bloqueados; uma vez por rajada de 30 s) | messages | a conversa |
| `crew_invite` | o convidado | crews | Conversas (convites) |
| `crew_request` | o dono da crew | crews | a crew |
| `crew_request_accepted` / `crew_invite_accepted` | quem pediu / quem convidou | crews | a crew |
| `verification_approved` / `verification_rejected` | quem pediu a verificação | account | a tela de verificação |
| `trial_started` | quem deu o primeiro match e ganhou 3 dias de Black | account | Planos |

Os textos ficam em `supabase/functions/send-push/index.ts`, porque o celular os mostra com o app fechado.

## Configurar na nuvem (uma vez)

1. Aplicar a migration `20261019120000_push_notifications.sql` (`supabase db push`).
2. Publicar a função: `supabase functions deploy send-push`.
3. Segredos da função (o arquivo da conta de serviço **nunca** entra no git):
   ```sh
   supabase secrets set PUSH_WEBHOOK_SECRET=<segredo aleatório>
   supabase secrets set FCM_SERVICE_ACCOUNT="$(cat caminho/da/conta-de-servico.json)"
   ```
   A conta de serviço vem de Firebase → Configurações do projeto → Contas de serviço → Gerar nova chave privada.
4. No SQL Editor do painel, criar os dois segredos no Vault (o mesmo segredo do passo 3):
   ```sql
   select vault.create_secret('https://<ref>.supabase.co/functions/v1/send-push', 'push_function_url');
   select vault.create_secret('<segredo aleatório>', 'push_webhook_secret');
   ```
   Sem eles, o banco simplesmente não envia nada. É assim no ambiente local, nos testes e no seed.

Para trocar o segredo: `vault.update_secret(...)` e `supabase secrets set` com o mesmo valor.

## No app

- Android: `android/app/google-services.json` (pode ir para o git; não é segredo). Os canais são criados em `MainActivity.kt` e o ícone fica em `res/drawable/ic_notification.xml`.
- iOS (depois): `GoogleService-Info.plist`, chave APNs enviada ao Firebase e a capability Push Notifications no Xcode. Até lá o app roda sem notificações no iOS.
- O pedido de permissão aparece ao entrar no app. O token é salvo por `register_push_token` e removido ao sair da conta (ou de todos os aparelhos).
