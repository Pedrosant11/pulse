import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/admin/presentation/widgets/role_requests_list.dart';

/// Curator and producer requests (the list from the app's admin panel).
class RoleRequestsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.background,
    appBar: AppBar(title: Text(context.l10n.adminRoleRequests.toUpperCase())),
    body: ListView(
      padding: EdgeInsets.all(context.spacing.md),
      children: const [RoleRequestsList()],
    ),
  );
}
