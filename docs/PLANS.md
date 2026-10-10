# Planos e compras

| | Grátis | Pulse+ | Pulse Black |
|---|---|---|---|
| Likes por dia | 50 | ilimitados | ilimitados |
| Voltar o último swipe | — | ✅ | ✅ |
| Modo viagem | — | ✅ | ✅ |
| Superlikes por semana | 1 | 5 | 5 |
| Quem curtiu você | só a quantidade | só a quantidade | ✅ |
| Boost (30 min no topo) | — | — | 1 por mês |
| Modo discreto | — | — | ✅ |

Avulsos (saldo na carteira): `pulse_superlikes_5`, `pulse_superlikes_15`, `pulse_boost_1` e `pulse_boosts_5`.

Os números (50 likes, superlikes, boosts, 30 min) ficam em `private.app_settings`. Dá para ajustar sem migration:

```sql
update private.app_settings set value = '30' where key = 'free_daily_likes';
```

## Como funciona

```
app → loja (Google Play / App Store) → RevenueCat
RevenueCat → Edge Function revenuecat-webhook → public.apply_store_event()
app ← get_my_entitlements() (o banco decide tudo)
```

- O app entra no RevenueCat com o **id do usuário do Supabase**, que chega no webhook como `app_user_id`.
- Assinaturas: o plano vem das *entitlements* `plus` e `black`. Black vale mais que Plus.
- Cancelar só desliga a renovação; o plano vale até `expires_at`. `EXPIRATION` remove o plano.
- Avulsos (`NON_RENEWING_PURCHASE`): somam na carteira conforme `private.store_products`.
- Cada evento é aplicado uma vez só (`private.store_events`, guardado por 5 anos).
- O admin pode liberar um plano (30 dias) ou pacotes na ficha da pessoa, em Painel → Selos → buscar pessoa. No seed local, a Elisa (5) tem Black e o Felipe (6) tem Plus.

## Configurar (quando a conta do Play Console existir)

1. **Play Console → Monetizar**:
   - Assinaturas `pulse_plus_monthly` e `pulse_black_monthly` (plano base mensal).
   - Produtos únicos com os 4 ids de avulsos.
   - Preço sugerido: Pulse+ R$ 24,90, Black R$ 44,90, 5 superlikes R$ 14,90, 15 superlikes R$ 34,90, 1 boost R$ 12,90, 5 boosts R$ 44,90.
2. **RevenueCat** (app.revenuecat.com):
   - Criar o projeto e o app Android `com.pulseapp.pulse`.
   - Ligar ao Play com a conta de serviço do Google Cloud.
   - Importar os produtos.
   - Criar as entitlements `plus` (com os dois planos) e `black` (só o Black).
3. **Webhook** no RevenueCat:
   - URL: `https://<ref>.supabase.co/functions/v1/revenuecat-webhook`.
   - Authorization header: um segredo aleatório.
   - Guardar o mesmo valor no Supabase: `supabase secrets set REVENUECAT_WEBHOOK_SECRET=<segredo>`.
4. **App**: no `env.json`, preencher `REVENUECAT_GOOGLE_KEY` com a chave pública do SDK (começa com `goog_`). Sem ela, a tela de planos mostra "Em breve".
5. **Testar**: subir o app no teste interno do Play e adicionar o seu e-mail como *testador de licença*. As compras de teste não são cobradas.

O iOS vem depois: os mesmos ids no App Store Connect e `REVENUECAT_APPLE_KEY`.

## Regras das lojas

- Benefício digital usado dentro do app só pode ser vendido pela loja. Não pode haver link para pagamento externo.
- A tela de planos mostra o preço da loja, a renovação automática, como cancelar e os links para Termos e Privacidade.
- O destaque de evento para produtores (fase futura) é serviço de divulgação e pode ser cobrado por fora (Pix).
