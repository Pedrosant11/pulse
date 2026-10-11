import 'package:pulse/app/routes.dart';

/// Screen to open when a notification is tapped, from its `route` data.
/// Only the inbox, a conversation, a crew, the verification screen or the
/// plans are accepted, so a malformed message can't send the user anywhere
/// else.
/// Falls back to the inbox.
String routeFromPushData(Map<String, dynamic> data) {
  final route = data['route'];
  if (route is! String) return AppRoutes.chats;
  final segments = Uri.tryParse(route)?.pathSegments ?? const <String>[];
  final isId = segments.length == 2 && _uuid.hasMatch(segments[1]);
  return switch (segments) {
    ['chats'] => AppRoutes.chats,
    ['chats', final id] when isId => AppRoutes.conversation(id),
    ['crews', final id] when isId => AppRoutes.crew(id),
    ['settings', 'verification'] => AppRoutes.verification,
    ['plans'] => AppRoutes.plans,
    _ => AppRoutes.chats,
  };
}

final _uuid = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
);
