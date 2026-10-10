# E-mails do Pulse (Supabase Auth)

Os modelos em português ficam em `supabase/templates/` e são gerados por:

```
dart run tool/email_templates.dart
```

O Supabase local já usa esses arquivos (`supabase/config.toml`). No projeto da nuvem, eles precisam ser colados no painel.

## Como aplicar na nuvem

Supabase → projeto **PulseApp** → **Authentication → Emails**.

Em **Templates**, para cada modelo: cole o **Subject** da tabela, abra o arquivo, copie todo o conteúdo para **Body** e salve.

| Modelo no painel | Subject | Arquivo |
|---|---|---|
| Confirm signup | Confirme seu e-mail no Pulse | `confirmation.html` |
| Reset password | Redefina sua senha do Pulse | `recovery.html` |
| Change email address | Confirme seu novo e-mail no Pulse | `email_change.html` |
| Magic link | Seu link de acesso ao Pulse | `magic_link.html` |
| Invite user | Você foi convidado(a) para o Pulse | `invite.html` |
| Reauthentication | Seu código de confirmação do Pulse | `reauthentication.html` |

Em **Security notifications**, ative e preencha:

| Aviso | Subject | Arquivo |
|---|---|---|
| Password changed | Sua senha do Pulse foi alterada | `password_changed_notification.html` |
| Email address changed | O e-mail da sua conta Pulse foi alterado | `email_changed_notification.html` |

## Antes do lançamento

- Domínio próprio verificado no Resend (SPF, DKIM e DMARC) e remetente `nao-responda@<domínio>`. Sem isso, os e-mails tendem a cair no spam.
- Em **Authentication → URL Configuration**, o **Site URL** deve apontar para o site público (GitHub Pages), e `com.pulseapp.pulse://login-callback` deve continuar em **Redirect URLs**.
- Depois de mudar um modelo no projeto, rode o script de novo e repita a colagem só dos arquivos alterados.
