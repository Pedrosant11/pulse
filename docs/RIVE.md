# Animações Rive

Arquivos `.riv` opcionais (SPEC seção 12). Enquanto um arquivo não existir aqui, o app
mostra a animação de reserva feita em Flutter, então dá para adicionar ou trocar
os arquivos sem mexer no código.

| Arquivo      | Onde aparece                                        | Reserva atual                     |
|--------------|-----------------------------------------------------|-----------------------------------|
| `match.riv`  | Tela de match, por cima do brilho (`match_burst`)   | Nada extra (shader + fotos)       |
| `attend.riv` | Ícone do botão "Eu vou" depois de confirmar presença | Ícone de check com "pop" animado |

Como preparar no editor do Rive (rive.app):

- Use o artboard padrão e uma state machine padrão que toque sozinha ao abrir
  (o app não dispara inputs).
- Fundo transparente. `match.riv` ocupa a tela toda (`Fit.contain`);
  `attend.riv` é desenhado em 24×24.
- Exporte para a versão de runtime atual e salve aqui com o nome exato da tabela.

Coloque os arquivos em `assets/rive/`. Os nomes ficam em `RiveAssets` (`lib/core/widgets/rive_slot.dart`). A pasta
inteira já está registrada no `pubspec.yaml`. Com "reduzir movimento" ativo no
aparelho, a reserva é usada sempre.
