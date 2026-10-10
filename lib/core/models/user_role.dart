/// Mirrors the database enum `user_role` (SPEC 4). Permissions are always
/// enforced by the database; the app only uses this to show/hide UI.
enum UserRole {
  user,
  curator,
  producer,
  admin;

  /// Creates events already approved (SPEC 7.2).
  bool get createsApprovedEvents => this != UserRole.user;

  /// Sees the approval queue.
  bool get isModerator => this == UserRole.curator || this == UserRole.admin;

  bool get isAdmin => this == UserRole.admin;
}
