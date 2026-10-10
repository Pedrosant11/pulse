import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Friendly error line for a failed action (from the controllers' state).
class FormErrorText extends StatelessWidget {
  const new({required this.error, super.key});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    if (error == null) return const SizedBox.shrink();
    final colors = context.colors;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: context.spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, size: 18, color: colors.error),
            SizedBox(width: context.spacing.xs),
            Expanded(
              child: Text(
                friendlyErrorMessage(error, context.l10n),
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
