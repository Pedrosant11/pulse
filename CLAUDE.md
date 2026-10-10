# CLAUDE.md

Projeto: app Flutter de match para festas eletrônicas (modos Date e Crew), backend Supabase.

A especificação completa está em `docs/SPEC.md`. Leia antes de qualquer tarefa e siga as fases da seção 14 na ordem.

## Convenções

- Código, nomes de arquivos, classes e variáveis em inglês; textos da interface em pt-BR via arquivos ARB (nunca strings fixas nas telas).
- Arquitetura feature-first (`lib/features/<feature>/{data,domain,presentation}`).
- Riverpod com code generation; modelos com freezed. Rodar `dart run build_runner build --delete-conflicting-outputs` após alterar modelos ou providers.
- Toda regra de negócio sensível (papéis, status de evento, criação de match, permissões) fica no banco: RLS, triggers e RPCs. Nunca confiar no app para isso.
- Toda mudança de banco é uma nova migration em `supabase/migrations/`; nunca editar migrations já aplicadas.
- Nunca commitar `env.json` nem usar a service role key no app.
- Cores, fontes e espaçamentos sempre pelo tema (`ThemeExtension`), nunca valores soltos nas telas.

## Fluxo de trabalho

- Uma fase por vez. Ao terminar: `flutter analyze`, testes, resumo do que foi feito, lista do que preciso configurar manualmente, e parar para eu confirmar.
- Se algo na spec estiver ambíguo ou for uma má decisão técnica, pergunte antes de implementar.
