// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_requests_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleRequest _$RoleRequestFromJson(Map<String, dynamic> json) => _RoleRequest(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  requestedRole: $enumDecode(_$UserRoleEnumMap, json['requested_role']),
  justification: json['justification'] as String,
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  links:
      (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$RoleRequestToJson(_RoleRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'requested_role': _$UserRoleEnumMap[instance.requestedRole]!,
      'justification': instance.justification,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'links': instance.links,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.curator: 'curator',
  UserRole.producer: 'producer',
  UserRole.admin: 'admin',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.cancelled: 'cancelled',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roleRequestsRepository)
final roleRequestsRepositoryProvider = RoleRequestsRepositoryProvider._();

final class RoleRequestsRepositoryProvider
    extends
        $FunctionalProvider<
          RoleRequestsRepository,
          RoleRequestsRepository,
          RoleRequestsRepository
        >
    with $Provider<RoleRequestsRepository> {
  RoleRequestsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRequestsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRequestsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoleRequestsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoleRequestsRepository create(Ref ref) {
    return roleRequestsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleRequestsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleRequestsRepository>(value),
    );
  }
}

String _$roleRequestsRepositoryHash() =>
    r'87ae77468c0fd3382f8dd8c76cb4b951b7e61739';
