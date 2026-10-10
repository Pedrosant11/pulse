import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';

/// Who sent a role or badge request, with a shortcut to their profile so
/// the admin can check before approving.
class RequesterHeader extends StatelessWidget {
  const new({
    required this.userId,
    required this.name,
    required this.trailing,
    this.place,
    super.key,
  });

  final String userId;
  final String? name;
  final String? place;

  /// What is being asked (role name, badge chip).
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (name?.isNotEmpty ?? false) ? name! : l10n.requesterUnknown,
                    style: context.textTheme.titleMedium,
                  ),
                  if (place case final place?)
                    Text(place, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            trailing,
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () => showUserProfile(context, userId),
            icon: const Icon(Icons.person_search_outlined, size: 18),
            label: Text(l10n.requesterViewProfile),
          ),
        ),
      ],
    );
  }
}
