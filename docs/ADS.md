# Anúncios

## Como funciona

- **Onde:** um card a cada N eventos em "Próximos" e um card a cada N perfis no Descobrir (Date e Crew). Nunca no chat, na tela de match, nos perfis ou nas telas de segurança. Todo anúncio leva o selo "Patrocinado".
- **Anúncios próprios primeiro:** festas e parceiros que você vende direto. O admin cria em Painel → Anúncios ou no evento (⋮ → Anunciar evento). Eles se revezam nos espaços.
- **Google (AdMob) completa:** quando não há anúncio próprio para aquele espaço, entra um anúncio nativo do Google. Se o Google não tiver anúncio, o espaço some (no Descobrir, o deck segue).
- **Números:** visualizações e toques dos anúncios próprios, contados uma vez por pessoa por dia (`private.ad_stats`). Aparecem na lista de anúncios do admin, para mostrar ao anunciante.

Ajustes sem lançar versão nova (`private.app_settings`):

```sql
update private.app_settings set value = '0' where key = 'ads_for_paid';      -- quem paga não vê anúncio
update private.app_settings set value = '8' where key = 'ads_events_every';  -- 1 anúncio a cada 8 eventos
update private.app_settings set value = '25' where key = 'ads_discover_every';
update private.app_settings set value = '0' where key = 'ads_enabled';       -- desliga tudo
```

## Testar localmente com anúncios do Google

No `env.local.json` (não vai para o git):

```json
"ADMOB_NATIVE_ANDROID": "test",
"ADMOB_NATIVE_IOS": "test"
```

`test` usa os anúncios de teste do Google. Sem essas chaves, só aparecem os anúncios próprios.

## Configurar (quando for lançar)

1. **AdMob** (admob.google.com), no seu CPF ou na empresa:
   - Adicionar o app Android `com.pulseapp.pulse` (e o iOS depois).
   - Criar uma unidade de anúncio **Nativo avançado** por plataforma.
   - Em Bloquear controles, bloquear categorias sensíveis (apostas, namoro, conteúdo adulto) para combinar com o app.
2. **IDs no app:**
   - ID do app (tem `~`): no Android, `-PadmobAppId=ca-app-pub-...~...` no build ou trocar o padrão em `android/app/build.gradle.kts`; no iOS, `GADApplicationIdentifier` em `ios/Runner/Info.plist`. São públicos.
   - ID da unidade (tem `/`): `ADMOB_NATIVE_ANDROID` e `ADMOB_NATIVE_IOS` no `env.json`.
3. **app-ads.txt:** o AdMob exige o arquivo no site do domínio do app (`https://seudominio/app-ads.txt`) com a linha que ele mostra (`google.com, pub-..., DIRECT, f08c47fec0942fa0`). Colocar em `site/app-ads.txt` quando houver domínio.
4. **Google Play → Conteúdo do app:** marcar "O app contém anúncios" e, em Segurança dos dados, declarar o identificador de publicidade (coletado, compartilhado com o Google para publicidade).
5. **iOS (quando lançar):** a Apple exige o aviso de rastreamento (App Tracking Transparency) para anúncios personalizados. Sem ele, o Google mostra só anúncios não personalizados.
6. **Consentimento:** o app já usa o formulário de consentimento do Google (UMP). Ele só aparece onde a lei exige (ex.: Europa); configure a mensagem em AdMob → Privacidade e mensagens.

## Eventos em destaque (produtores)

Separado dos anúncios. O **produtor** destaca a própria festa na tela do evento ("Coloque sua festa no topo" → escolhe os dias):

| Dias | Preço | Por dia | Produto na loja |
|---|---|---|---|
| 3 | R$ 79 | R$ 26,33 | `pulse_featured_3` |
| 7 | R$ 149 | R$ 21,29 | `pulse_featured_7` |
| 14 | R$ 249 | R$ 17,79 | `pulse_featured_14` |
| 30 | R$ 449 | R$ 14,97 | `pulse_featured_30` |

- **Destacar agora:** compra pela loja (Google Play / App Store). O webhook do RevenueCat liga o destaque sozinho. Aparece quando as lojas estiverem configuradas.
- **Pedir pela equipe Pulse:** o pedido cai em Painel → Pedidos de destaque. Você combina o pagamento (Pix, pacotes) e toca em "Pago, ativar". O produtor recebe um push.
- O destaque começa quando o pagamento é confirmado e soma com o tempo que ainda falta.
- O admin também pode destacar direto pelo menu ⋮ do evento (cortesia, parceiros).
- Preços: `update public.featured_prices set price_cents = 9900 where days = 3;` (o preço na loja muda no Play Console / App Store Connect).
- O app não mostra link nem chave Pix: pelas regras das lojas, o pagamento por fora é combinado fora do app.

- O evento vai para o **topo de "Próximos"**, com o selo "Destaque" e um pin maior no mapa. Os anúncios continuam no meio da lista.
- Com vários destaques ao mesmo tempo, todos ficam no topo em **rodízio diário**: cada pessoa vê uma ordem diferente, que muda todo dia. Assim cada produtor fica em primeiro para uma parte do público.
- **Limite:** no máximo 5 destaques valendo ao mesmo tempo por região (50 km do evento, ou o mesmo estado). Ao tentar o sexto, o app avisa. Para mudar:

```sql
update private.app_settings set value = '8' where key = 'featured_max_per_region';
update private.app_settings set value = '80' where key = 'featured_region_km';
```
