import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';

class ChatAvatar extends StatelessWidget {
  const new({required this.photoPath, this.size = 48, this.ring, super.key});

  final String? photoPath;
  final double size;

  /// Highlight ring (e.g. new match in the mode's color).
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    final ring = this.ring;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring == null ? 0 : 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ring == null ? null : Border.all(color: ring, width: 2),
        boxShadow: ring == null
            ? null
            : [BoxShadow(color: ring.withValues(alpha: 0.5), blurRadius: 10)],
      ),
      child: ClipOval(
        child: path == null
            ? ColoredBox(
                color: context.colors.surfaceElevated,
                child: Icon(Icons.person, color: context.colors.textSecondary),
              )
            : ProfilePhotoImage(path, decodeWidth: size),
      ),
    );
  }
}

/// "14:32", "Ontem" or "12/10" depending on how old [time] is.
String formatChatTime(
  BuildContext context,
  DateTime time, {
  required String yesterday,
}) {
  final local = time.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final material = MaterialLocalizations.of(context);
  if (day == today) {
    return material.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: true,
    );
  }
  if (day == today.subtract(const Duration(days: 1))) return yesterday;
  return material.formatCompactDate(local).substring(0, 5);
}
