// Generates the Supabase Auth e-mail templates (pt-BR) in supabase/templates/.
//
//   dart run tool/email_templates.dart
//
// Local Supabase reads them through supabase/config.toml. For the cloud
// project, paste each file in Dashboard → Authentication → Emails, with the
// subject listed in `templates` below (see docs/EMAILS.md).
import 'dart:io';

/// Colors from PulseColors (the theme), inlined because e-mail clients
/// don't support stylesheets well.
const _bg = '#0A0A0F';
const _card = '#14141C';
const _border = '#2A2A38';
const _text = '#F5F5F7';
const _muted = '#9A9AB0';
const _magenta = '#FF2BD6';
const _violet = '#7B2CFF';
const _button = '#B421C9';

typedef EmailTemplate = ({
  String file,
  String subject,
  String title,
  String body,
  String? button,
  String? footnote,
});

/// Go templates use {{ .ConfirmationURL }}, {{ .Token }}, {{ .Email }}…
const List<EmailTemplate> templates = [
  (
    file: 'confirmation',
    subject: 'Confirme seu e-mail no Pulse',
    title: 'Falta pouco pra entrar na pista',
    body:
        'Confirme seu e-mail para ativar sua conta no Pulse e começar a '
        'encontrar sua galera nas festas.',
    button: 'Confirmar e-mail',
    footnote: 'Se você não criou uma conta no Pulse, ignore este e-mail.',
  ),
  (
    file: 'recovery',
    subject: 'Redefina sua senha do Pulse',
    title: 'Vamos criar uma senha nova',
    body:
        'Recebemos um pedido para redefinir a senha da sua conta. Toque no '
        'botão para escolher uma nova senha.',
    button: 'Redefinir senha',
    footnote:
        'Se não foi você, ignore este e-mail: sua senha continua a mesma.',
  ),
  (
    file: 'email_change',
    subject: 'Confirme seu novo e-mail no Pulse',
    title: 'Confirme o novo e-mail',
    body:
        'Você pediu para trocar o e-mail da sua conta de '
        '<strong>{{ .Email }}</strong> para '
        '<strong>{{ .NewEmail }}</strong>. Confirme para concluir.',
    button: 'Confirmar novo e-mail',
    footnote:
        'Se você não pediu essa troca, troque sua senha e fale com a gente.',
  ),
  (
    file: 'magic_link',
    subject: 'Seu link de acesso ao Pulse',
    title: 'Seu link de acesso',
    body: 'Toque no botão para entrar na sua conta do Pulse.',
    button: 'Entrar no Pulse',
    footnote: 'Se você não pediu este link, ignore este e-mail.',
  ),
  (
    file: 'invite',
    subject: 'Você foi convidado(a) para o Pulse',
    title: 'Bora pra pista?',
    body:
        'Você recebeu um convite para o Pulse, o app para conhecer quem vai '
        'às mesmas festas que você.',
    button: 'Aceitar convite',
    footnote: null,
  ),
  (
    file: 'reauthentication',
    subject: 'Seu código de confirmação do Pulse',
    title: 'Confirme que é você',
    body:
        'Use o código abaixo para confirmar a operação no app: '
        '<div style="margin:24px 0;font-size:32px;font-weight:800; '
        'letter-spacing:8px;color:$_text;">{{ .Token }}</div>',
    button: null,
    footnote: 'Se você não pediu este código, troque sua senha.',
  ),
  (
    file: 'password_changed_notification',
    subject: 'Sua senha do Pulse foi alterada',
    title: 'Senha alterada',
    body:
        'A senha da conta <strong>{{ .Email }}</strong> foi alterada agora '
        'há pouco.',
    button: null,
    footnote:
        'Se não foi você, redefina sua senha no app e fale com a gente '
        'imediatamente.',
  ),
  (
    file: 'email_changed_notification',
    subject: 'O e-mail da sua conta Pulse foi alterado',
    title: 'E-mail alterado',
    body:
        'O e-mail da sua conta foi trocado de '
        '<strong>{{ .OldEmail }}</strong> para '
        '<strong>{{ .Email }}</strong>.',
    button: null,
    footnote: 'Se não foi você, fale com a gente imediatamente.',
  ),
];

String render(EmailTemplate t) {
  final button = t.button == null
      ? ''
      : '''
          <tr><td style="padding:8px 0 24px;">
            <a href="{{ .ConfirmationURL }}" style="display:inline-block;background:$_button;background-image:linear-gradient(90deg,$_violet,$_magenta);color:#FFFFFF;text-decoration:none;font-weight:700;font-size:16px;padding:14px 28px;border-radius:999px;">${t.button}</a>
          </td></tr>
          <tr><td style="font-size:12px;color:$_muted;padding-bottom:16px;word-break:break-all;">
            Se o botão não funcionar, copie e cole este link no navegador do celular:<br>
            <a href="{{ .ConfirmationURL }}" style="color:$_magenta;">{{ .ConfirmationURL }}</a>
          </td></tr>''';
  final footnote = t.footnote == null
      ? ''
      : '''
          <tr><td style="font-size:13px;color:$_muted;border-top:1px solid $_border;padding-top:16px;">${t.footnote}</td></tr>''';

  return '''
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="dark">
<title>${t.subject}</title>
</head>
<body style="margin:0;padding:0;background:$_bg;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:$_bg;">
  <tr><td align="center" style="padding:32px 16px;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:520px;font-family:-apple-system,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
      <tr><td style="padding:0 0 24px;font-size:24px;font-weight:800;letter-spacing:6px;color:$_magenta;">PULSE</td></tr>
      <tr><td style="background:$_card;border:1px solid $_border;border-radius:20px;padding:32px 28px;">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
          <tr><td style="font-size:22px;font-weight:800;color:$_text;padding-bottom:12px;">${t.title}</td></tr>
          <tr><td style="font-size:16px;line-height:1.6;color:$_text;padding-bottom:20px;">${t.body}</td></tr>$button$footnote
        </table>
      </td></tr>
      <tr><td style="padding:20px 4px 0;font-size:12px;line-height:1.5;color:$_muted;">
        Você recebeu este e-mail porque tem (ou pediu) uma conta no Pulse. Não responda: esta caixa não é lida.
      </td></tr>
    </table>
  </td></tr>
</table>
</body>
</html>
''';
}

void main() {
  for (final t in templates) {
    File('supabase/templates/${t.file}.html')
      ..createSync(recursive: true)
      ..writeAsStringSync(render(t));
  }
  stdout.writeln('${templates.length} modelos em supabase/templates/.');
}
