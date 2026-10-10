// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminReport {

 String get id; ReportTarget get targetType; String get targetId; ReportReason get reason; DateTime get createdAt; Map<String, dynamic> get snapshot; String? get details; String? get reporterId; String? get reporterFirstName; String? get reportedUserId; String? get reportedFirstName; String? get reportedPhotoPath; AccountStatus? get reportedStatus; int get reportsAgainstUser; int get previousActions;
/// Create a copy of AdminReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminReportCopyWith<AdminReport> get copyWith => _$AdminReportCopyWithImpl<AdminReport>(this as AdminReport, _$identity);

  /// Serializes this AdminReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminReport&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.targetType, _this.targetType) || other.targetType == _this.targetType)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.snapshot, _this.snapshot)&&(identical(other.details, _this.details) || other.details == _this.details)&&(identical(other.reporterId, _this.reporterId) || other.reporterId == _this.reporterId)&&(identical(other.reporterFirstName, _this.reporterFirstName) || other.reporterFirstName == _this.reporterFirstName)&&(identical(other.reportedUserId, _this.reportedUserId) || other.reportedUserId == _this.reportedUserId)&&(identical(other.reportedFirstName, _this.reportedFirstName) || other.reportedFirstName == _this.reportedFirstName)&&(identical(other.reportedPhotoPath, _this.reportedPhotoPath) || other.reportedPhotoPath == _this.reportedPhotoPath)&&(identical(other.reportedStatus, _this.reportedStatus) || other.reportedStatus == _this.reportedStatus)&&(identical(other.reportsAgainstUser, _this.reportsAgainstUser) || other.reportsAgainstUser == _this.reportsAgainstUser)&&(identical(other.previousActions, _this.previousActions) || other.previousActions == _this.previousActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminReport;
  return Object.hash(runtimeType,_this.id,_this.targetType,_this.targetId,_this.reason,_this.createdAt,const DeepCollectionEquality().hash(_this.snapshot),_this.details,_this.reporterId,_this.reporterFirstName,_this.reportedUserId,_this.reportedFirstName,_this.reportedPhotoPath,_this.reportedStatus,_this.reportsAgainstUser,_this.previousActions);
}

@override
String toString() {
  final _this = this as AdminReport;
  return 'AdminReport(id: ${_this.id}, targetType: ${_this.targetType}, targetId: ${_this.targetId}, reason: ${_this.reason}, createdAt: ${_this.createdAt}, snapshot: ${_this.snapshot}, details: ${_this.details}, reporterId: ${_this.reporterId}, reporterFirstName: ${_this.reporterFirstName}, reportedUserId: ${_this.reportedUserId}, reportedFirstName: ${_this.reportedFirstName}, reportedPhotoPath: ${_this.reportedPhotoPath}, reportedStatus: ${_this.reportedStatus}, reportsAgainstUser: ${_this.reportsAgainstUser}, previousActions: ${_this.previousActions})';
}


}

/// @nodoc
abstract mixin class $AdminReportCopyWith<$Res>  {
  factory $AdminReportCopyWith(AdminReport value, $Res Function(AdminReport) _then) = _$AdminReportCopyWithImpl;
@useResult
$Res call({
 String id, ReportTarget targetType, String targetId, ReportReason reason, DateTime createdAt, Map<String, dynamic> snapshot, String? details, String? reporterId, String? reporterFirstName, String? reportedUserId, String? reportedFirstName, String? reportedPhotoPath, AccountStatus? reportedStatus, int reportsAgainstUser, int previousActions
});




}
/// @nodoc
class _$AdminReportCopyWithImpl<$Res>
    implements $AdminReportCopyWith<$Res> {
  _$AdminReportCopyWithImpl(this._self, this._then);

  final AdminReport _self;
  final $Res Function(AdminReport) _then;

/// Create a copy of AdminReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? targetType = null,Object? targetId = null,Object? reason = null,Object? createdAt = null,Object? snapshot = null,Object? details = freezed,Object? reporterId = freezed,Object? reporterFirstName = freezed,Object? reportedUserId = freezed,Object? reportedFirstName = freezed,Object? reportedPhotoPath = freezed,Object? reportedStatus = freezed,Object? reportsAgainstUser = null,Object? previousActions = null,}) {
  return _then(AdminReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ReportTarget,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,reporterId: freezed == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String?,reporterFirstName: freezed == reporterFirstName ? _self.reporterFirstName : reporterFirstName // ignore: cast_nullable_to_non_nullable
as String?,reportedUserId: freezed == reportedUserId ? _self.reportedUserId : reportedUserId // ignore: cast_nullable_to_non_nullable
as String?,reportedFirstName: freezed == reportedFirstName ? _self.reportedFirstName : reportedFirstName // ignore: cast_nullable_to_non_nullable
as String?,reportedPhotoPath: freezed == reportedPhotoPath ? _self.reportedPhotoPath : reportedPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,reportedStatus: freezed == reportedStatus ? _self.reportedStatus : reportedStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus?,reportsAgainstUser: null == reportsAgainstUser ? _self.reportsAgainstUser : reportsAgainstUser // ignore: cast_nullable_to_non_nullable
as int,previousActions: null == previousActions ? _self.previousActions : previousActions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminReport].
extension AdminReportPatterns on AdminReport {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminReport() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminReport value)  $default,){
final _that = this;
switch (_that) {
case _AdminReport():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminReport value)?  $default,){
final _that = this;
switch (_that) {
case _AdminReport() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ReportTarget targetType,  String targetId,  ReportReason reason,  DateTime createdAt,  Map<String, dynamic> snapshot,  String? details,  String? reporterId,  String? reporterFirstName,  String? reportedUserId,  String? reportedFirstName,  String? reportedPhotoPath,  AccountStatus? reportedStatus,  int reportsAgainstUser,  int previousActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminReport() when $default != null:
return $default(_that.id,_that.targetType,_that.targetId,_that.reason,_that.createdAt,_that.snapshot,_that.details,_that.reporterId,_that.reporterFirstName,_that.reportedUserId,_that.reportedFirstName,_that.reportedPhotoPath,_that.reportedStatus,_that.reportsAgainstUser,_that.previousActions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ReportTarget targetType,  String targetId,  ReportReason reason,  DateTime createdAt,  Map<String, dynamic> snapshot,  String? details,  String? reporterId,  String? reporterFirstName,  String? reportedUserId,  String? reportedFirstName,  String? reportedPhotoPath,  AccountStatus? reportedStatus,  int reportsAgainstUser,  int previousActions)  $default,) {final _that = this;
switch (_that) {
case _AdminReport():
return $default(_that.id,_that.targetType,_that.targetId,_that.reason,_that.createdAt,_that.snapshot,_that.details,_that.reporterId,_that.reporterFirstName,_that.reportedUserId,_that.reportedFirstName,_that.reportedPhotoPath,_that.reportedStatus,_that.reportsAgainstUser,_that.previousActions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ReportTarget targetType,  String targetId,  ReportReason reason,  DateTime createdAt,  Map<String, dynamic> snapshot,  String? details,  String? reporterId,  String? reporterFirstName,  String? reportedUserId,  String? reportedFirstName,  String? reportedPhotoPath,  AccountStatus? reportedStatus,  int reportsAgainstUser,  int previousActions)?  $default,) {final _that = this;
switch (_that) {
case _AdminReport() when $default != null:
return $default(_that.id,_that.targetType,_that.targetId,_that.reason,_that.createdAt,_that.snapshot,_that.details,_that.reporterId,_that.reporterFirstName,_that.reportedUserId,_that.reportedFirstName,_that.reportedPhotoPath,_that.reportedStatus,_that.reportsAgainstUser,_that.previousActions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminReport extends AdminReport {
  const _AdminReport({required this.id, required this.targetType, required this.targetId, required this.reason, required this.createdAt,  Map<String, dynamic> snapshot = const <String, dynamic>{}, this.details, this.reporterId, this.reporterFirstName, this.reportedUserId, this.reportedFirstName, this.reportedPhotoPath, this.reportedStatus, this.reportsAgainstUser = 0, this.previousActions = 0}): _snapshot = snapshot,super._();
  factory _AdminReport.fromJson(Map<String, dynamic> json) => _$AdminReportFromJson(json);

@override final  String id;
@override final  ReportTarget targetType;
@override final  String targetId;
@override final  ReportReason reason;
@override final  DateTime createdAt;
 final  Map<String, dynamic> _snapshot;
@override@JsonKey() Map<String, dynamic> get snapshot {
  if (_snapshot is EqualUnmodifiableMapView) return _snapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_snapshot);
}

@override final  String? details;
@override final  String? reporterId;
@override final  String? reporterFirstName;
@override final  String? reportedUserId;
@override final  String? reportedFirstName;
@override final  String? reportedPhotoPath;
@override final  AccountStatus? reportedStatus;
@override@JsonKey() final  int reportsAgainstUser;
@override@JsonKey() final  int previousActions;

/// Create a copy of AdminReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminReportCopyWith<_AdminReport> get copyWith => __$AdminReportCopyWithImpl<_AdminReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminReport&&(identical(other.id, id) || other.id == id)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.snapshot, _snapshot)&&(identical(other.details, details) || other.details == details)&&(identical(other.reporterId, reporterId) || other.reporterId == reporterId)&&(identical(other.reporterFirstName, reporterFirstName) || other.reporterFirstName == reporterFirstName)&&(identical(other.reportedUserId, reportedUserId) || other.reportedUserId == reportedUserId)&&(identical(other.reportedFirstName, reportedFirstName) || other.reportedFirstName == reportedFirstName)&&(identical(other.reportedPhotoPath, reportedPhotoPath) || other.reportedPhotoPath == reportedPhotoPath)&&(identical(other.reportedStatus, reportedStatus) || other.reportedStatus == reportedStatus)&&(identical(other.reportsAgainstUser, reportsAgainstUser) || other.reportsAgainstUser == reportsAgainstUser)&&(identical(other.previousActions, previousActions) || other.previousActions == previousActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,targetType,targetId,reason,createdAt,const DeepCollectionEquality().hash(_snapshot),details,reporterId,reporterFirstName,reportedUserId,reportedFirstName,reportedPhotoPath,reportedStatus,reportsAgainstUser,previousActions);
}

@override
String toString() {
    return 'AdminReport(id: $id, targetType: $targetType, targetId: $targetId, reason: $reason, createdAt: $createdAt, snapshot: $snapshot, details: $details, reporterId: $reporterId, reporterFirstName: $reporterFirstName, reportedUserId: $reportedUserId, reportedFirstName: $reportedFirstName, reportedPhotoPath: $reportedPhotoPath, reportedStatus: $reportedStatus, reportsAgainstUser: $reportsAgainstUser, previousActions: $previousActions)';
}


}

/// @nodoc
abstract mixin class _$AdminReportCopyWith<$Res> implements $AdminReportCopyWith<$Res> {
  factory _$AdminReportCopyWith(_AdminReport value, $Res Function(_AdminReport) _then) = __$AdminReportCopyWithImpl;
@override @useResult
$Res call({
 String id, ReportTarget targetType, String targetId, ReportReason reason, DateTime createdAt, Map<String, dynamic> snapshot, String? details, String? reporterId, String? reporterFirstName, String? reportedUserId, String? reportedFirstName, String? reportedPhotoPath, AccountStatus? reportedStatus, int reportsAgainstUser, int previousActions
});




}
/// @nodoc
class __$AdminReportCopyWithImpl<$Res>
    implements _$AdminReportCopyWith<$Res> {
  __$AdminReportCopyWithImpl(this._self, this._then);

  final _AdminReport _self;
  final $Res Function(_AdminReport) _then;

/// Create a copy of AdminReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? targetType = null,Object? targetId = null,Object? reason = null,Object? createdAt = null,Object? snapshot = null,Object? details = freezed,Object? reporterId = freezed,Object? reporterFirstName = freezed,Object? reportedUserId = freezed,Object? reportedFirstName = freezed,Object? reportedPhotoPath = freezed,Object? reportedStatus = freezed,Object? reportsAgainstUser = null,Object? previousActions = null,}) {
  return _then(_AdminReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ReportTarget,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReportReason,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,snapshot: null == snapshot ? _self._snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,reporterId: freezed == reporterId ? _self.reporterId : reporterId // ignore: cast_nullable_to_non_nullable
as String?,reporterFirstName: freezed == reporterFirstName ? _self.reporterFirstName : reporterFirstName // ignore: cast_nullable_to_non_nullable
as String?,reportedUserId: freezed == reportedUserId ? _self.reportedUserId : reportedUserId // ignore: cast_nullable_to_non_nullable
as String?,reportedFirstName: freezed == reportedFirstName ? _self.reportedFirstName : reportedFirstName // ignore: cast_nullable_to_non_nullable
as String?,reportedPhotoPath: freezed == reportedPhotoPath ? _self.reportedPhotoPath : reportedPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,reportedStatus: freezed == reportedStatus ? _self.reportedStatus : reportedStatus // ignore: cast_nullable_to_non_nullable
as AccountStatus?,reportsAgainstUser: null == reportsAgainstUser ? _self.reportsAgainstUser : reportsAgainstUser // ignore: cast_nullable_to_non_nullable
as int,previousActions: null == previousActions ? _self.previousActions : previousActions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RestrictedUser {

 String get userId; String get firstName; AccountStatus get status; String? get photoPath; String? get reason; DateTime? get expiresAt; DateTime? get actedAt;
/// Create a copy of RestrictedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestrictedUserCopyWith<RestrictedUser> get copyWith => _$RestrictedUserCopyWithImpl<RestrictedUser>(this as RestrictedUser, _$identity);

  /// Serializes this RestrictedUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RestrictedUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestrictedUser&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.actedAt, _this.actedAt) || other.actedAt == _this.actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RestrictedUser;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.status,_this.photoPath,_this.reason,_this.expiresAt,_this.actedAt);
}

@override
String toString() {
  final _this = this as RestrictedUser;
  return 'RestrictedUser(userId: ${_this.userId}, firstName: ${_this.firstName}, status: ${_this.status}, photoPath: ${_this.photoPath}, reason: ${_this.reason}, expiresAt: ${_this.expiresAt}, actedAt: ${_this.actedAt})';
}


}

/// @nodoc
abstract mixin class $RestrictedUserCopyWith<$Res>  {
  factory $RestrictedUserCopyWith(RestrictedUser value, $Res Function(RestrictedUser) _then) = _$RestrictedUserCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, AccountStatus status, String? photoPath, String? reason, DateTime? expiresAt, DateTime? actedAt
});




}
/// @nodoc
class _$RestrictedUserCopyWithImpl<$Res>
    implements $RestrictedUserCopyWith<$Res> {
  _$RestrictedUserCopyWithImpl(this._self, this._then);

  final RestrictedUser _self;
  final $Res Function(RestrictedUser) _then;

/// Create a copy of RestrictedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? status = null,Object? photoPath = freezed,Object? reason = freezed,Object? expiresAt = freezed,Object? actedAt = freezed,}) {
  return _then(RestrictedUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestrictedUser].
extension RestrictedUserPatterns on RestrictedUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestrictedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestrictedUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestrictedUser value)  $default,){
final _that = this;
switch (_that) {
case _RestrictedUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestrictedUser value)?  $default,){
final _that = this;
switch (_that) {
case _RestrictedUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  AccountStatus status,  String? photoPath,  String? reason,  DateTime? expiresAt,  DateTime? actedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestrictedUser() when $default != null:
return $default(_that.userId,_that.firstName,_that.status,_that.photoPath,_that.reason,_that.expiresAt,_that.actedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  AccountStatus status,  String? photoPath,  String? reason,  DateTime? expiresAt,  DateTime? actedAt)  $default,) {final _that = this;
switch (_that) {
case _RestrictedUser():
return $default(_that.userId,_that.firstName,_that.status,_that.photoPath,_that.reason,_that.expiresAt,_that.actedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  AccountStatus status,  String? photoPath,  String? reason,  DateTime? expiresAt,  DateTime? actedAt)?  $default,) {final _that = this;
switch (_that) {
case _RestrictedUser() when $default != null:
return $default(_that.userId,_that.firstName,_that.status,_that.photoPath,_that.reason,_that.expiresAt,_that.actedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestrictedUser implements RestrictedUser {
  const _RestrictedUser({required this.userId, required this.firstName, required this.status, this.photoPath, this.reason, this.expiresAt, this.actedAt});
  factory _RestrictedUser.fromJson(Map<String, dynamic> json) => _$RestrictedUserFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  AccountStatus status;
@override final  String? photoPath;
@override final  String? reason;
@override final  DateTime? expiresAt;
@override final  DateTime? actedAt;

/// Create a copy of RestrictedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestrictedUserCopyWith<_RestrictedUser> get copyWith => __$RestrictedUserCopyWithImpl<_RestrictedUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestrictedUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestrictedUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.status, status) || other.status == status)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.actedAt, actedAt) || other.actedAt == actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,status,photoPath,reason,expiresAt,actedAt);
}

@override
String toString() {
    return 'RestrictedUser(userId: $userId, firstName: $firstName, status: $status, photoPath: $photoPath, reason: $reason, expiresAt: $expiresAt, actedAt: $actedAt)';
}


}

/// @nodoc
abstract mixin class _$RestrictedUserCopyWith<$Res> implements $RestrictedUserCopyWith<$Res> {
  factory _$RestrictedUserCopyWith(_RestrictedUser value, $Res Function(_RestrictedUser) _then) = __$RestrictedUserCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, AccountStatus status, String? photoPath, String? reason, DateTime? expiresAt, DateTime? actedAt
});




}
/// @nodoc
class __$RestrictedUserCopyWithImpl<$Res>
    implements _$RestrictedUserCopyWith<$Res> {
  __$RestrictedUserCopyWithImpl(this._self, this._then);

  final _RestrictedUser _self;
  final $Res Function(_RestrictedUser) _then;

/// Create a copy of RestrictedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? status = null,Object? photoPath = freezed,Object? reason = freezed,Object? expiresAt = freezed,Object? actedAt = freezed,}) {
  return _then(_RestrictedUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
