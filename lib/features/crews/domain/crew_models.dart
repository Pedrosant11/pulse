import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_models.freezed.dart';
part 'crew_models.g.dart';

/// The user's relation to a crew (`private.crew_status`).
@JsonEnum()
enum CrewRelation { owner, member, requested, invited }

/// Mirrors the database enum `crew_member_role`.
enum CrewRole { owner, member }

/// Mirrors the database enum `crew_request_kind`.
enum CrewRequestKind { request, invite }

/// Row of `list_event_crews()`.
@freezed
abstract class CrewSummary with _$CrewSummary {
  const factory({
    required String id,
    required String name,
    required int maxMembers,
    required int memberCount,
    String? description,
    @Default(true) bool isOpen,
    @Default(false) bool sameGenderOnly,
    String? ownerFirstName,
    @Default([]) List<String> memberPhotos,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    CrewRelation? myStatus,
  }) = _CrewSummary;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$CrewSummaryFromJson(json);

  bool get isFull => memberCount >= maxMembers;
}

/// Row of `get_crew()`. [conversationId] is only set for members.
@freezed
abstract class CrewDetail with _$CrewDetail {
  const factory({
    required String id,
    required String name,
    required int maxMembers,
    required int memberCount,
    required String ownerId,
    required String eventId,
    required String eventName,
    required DateTime eventStartsAt,
    String? description,
    @Default(true) bool isOpen,
    @Default(false) bool sameGenderOnly,
    String? conversationId,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    CrewRelation? myStatus,

    /// The user's pending request/invite for this crew.
    String? myRequestId,

    /// Where the crew meets at the party (members only).
    String? meetingPoint,
  }) = _CrewDetail;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$CrewDetailFromJson(json);

  bool get isFull => memberCount >= maxMembers;
  bool get isMember =>
      myStatus == CrewRelation.owner || myStatus == CrewRelation.member;
}

@freezed
abstract class CrewMember with _$CrewMember {
  const factory({
    required String userId,
    required CrewRole role,
    required DateTime joinedAt,
    String? firstName,
    String? photoPath,
  }) = _CrewMember;

  factory fromJson(Map<String, dynamic> json) => _$CrewMemberFromJson(json);
}

/// Pending request or invite (owner view, `get_crew_pending()`).
@freezed
abstract class CrewPending with _$CrewPending {
  const factory({
    required String requestId,
    required String userId,
    required CrewRequestKind kind,
    required DateTime createdAt,
    String? firstName,
    String? photoPath,
  }) = _CrewPending;

  factory fromJson(Map<String, dynamic> json) => _$CrewPendingFromJson(json);
}

@freezed
abstract class CrewInviteCandidate with _$CrewInviteCandidate {
  const factory({
    required String userId,
    String? firstName,
    String? photoPath,
  }) = _CrewInviteCandidate;

  factory fromJson(Map<String, dynamic> json) =>
      _$CrewInviteCandidateFromJson(json);
}

/// Invite received by the user (`list_my_crew_invites()`).
@freezed
abstract class MyCrewInvite with _$MyCrewInvite {
  const factory({
    required String requestId,
    required String crewId,
    required String crewName,
    required String eventName,
    required DateTime eventStartsAt,
    required int memberCount,
    String? invitedByName,
  }) = _MyCrewInvite;

  factory fromJson(Map<String, dynamic> json) => _$MyCrewInviteFromJson(json);
}
