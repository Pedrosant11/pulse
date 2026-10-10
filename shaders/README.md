# Shaders

Fragment shaders GLSL (SPEC seção 12), implementados na Fase 9:

- `neon_background.frag` — fumaça/luz lenta para splash, login e onboarding (substitui `NeonBackdrop`).
- `match_burst.frag` — explosão de luz na tela de match.
- `glitch.frag` — glitch rápido em transições pontuais.

Ao adicionar um arquivo, registre-o em `pubspec.yaml` (`flutter: shaders:`), envolva o widget em `RepaintBoundary` e respeite `context.reduceMotion`.
