// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_requests_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleRequest {

 String get id; String get userId; UserRole get requestedRole; String get justification; RequestStatus get status; DateTime get createdAt; List<String> get links;/// Filled for admins: who is asking (name and "City, UF").
 String? get requesterName; String? get requesterPlace;
/// Create a copy of RoleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleRequestCopyWith<RoleRequest> get copyWith => _$RoleRequestCopyWithImpl<RoleRequest>(this as RoleRequest, _$identity);

  /// Serializes this RoleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoleRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.requestedRole, _this.requestedRole) || other.requestedRole == _this.requestedRole)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.links, _this.links)&&(identical(other.requesterName, _this.requesterName) || other.requesterName == _this.requesterName)&&(identical(other.requesterPlace, _this.requesterPlace) || other.requesterPlace == _this.requesterPlace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoleRequest;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.requestedRole,_this.justification,_this.status,_this.createdAt,const DeepCollectionEquality().hash(_this.links),_this.requesterName,_this.requesterPlace);
}

@override
String toString() {
  final _this = this as RoleRequest;
  return 'RoleRequest(id: ${_this.id}, userId: ${_this.userId}, requestedRole: ${_this.requestedRole}, justification: ${_this.justification}, status: ${_this.status}, createdAt: ${_this.createdAt}, links: ${_this.links}, requesterName: ${_this.requesterName}, requesterPlace: ${_this.requesterPlace})';
}


}

/// @nodoc
abstract mixin class $RoleRequestCopyWith<$Res>  {
  factory $RoleRequestCopyWith(RoleRequest value, $Res Function(RoleRequest) _then) = _$RoleRequestCopyWithImpl;
@useResult
$Res call({
 String id, String userId, UserRole requestedRole, String justification, RequestStatus status, DateTime createdAt, List<String> links, String? requesterName, String? requesterPlace
});




}
/// @nodoc
class _$RoleRequestCopyWithImpl<$Res>
    implements $RoleRequestCopyWith<$Res> {
  _$RoleRequestCopyWithImpl(this._self, this._then);

  final RoleRequest _self;
  final $Res Function(RoleRequest) _then;

/// Create a copy of RoleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? requestedRole = null,Object? justification = null,Object? status = null,Object? createdAt = null,Object? links = null,Object? requesterName = freezed,Object? requesterPlace = freezed,}) {
  return _then(RoleRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as UserRole,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<String>,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,requesterPlace: freezed == requesterPlace ? _self.requesterPlace : requesterPlace // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleRequest].
extension RoleRequestPatterns on RoleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleRequest value)  $default,){
final _that = this;
switch (_that) {
case _RoleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RoleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  UserRole requestedRole,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName,  String? requesterPlace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleRequest() when $default != null:
return $default(_that.id,_that.userId,_that.requestedRole,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName,_that.requesterPlace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  UserRole requestedRole,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName,  String? requesterPlace)  $default,) {final _that = this;
switch (_that) {
case _RoleRequest():
return $default(_that.id,_that.userId,_that.requestedRole,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName,_that.requesterPlace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  UserRole requestedRole,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName,  String? requesterPlace)?  $default,) {final _that = this;
switch (_that) {
case _RoleRequest() when $default != null:
return $default(_that.id,_that.userId,_that.requestedRole,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName,_that.requesterPlace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleRequest implements RoleRequest {
  const _RoleRequest({required this.id, required this.userId, required this.requestedRole, required this.justification, required this.status, required this.createdAt,  List<String> links = const [], this.requesterName, this.requesterPlace}): _links = links;
  factory _RoleRequest.fromJson(Map<String, dynamic> json) => _$RoleRequestFromJson(json);

@override final  String id;
@override final  String userId;
@override final  UserRole requestedRole;
@override final  String justification;
@override final  RequestStatus status;
@override final  DateTime createdAt;
 final  List<String> _links;
@override@JsonKey() List<String> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

/// Filled for admins: who is asking (name and "City, UF").
@override final  String? requesterName;
@override final  String? requesterPlace;

/// Create a copy of RoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleRequestCopyWith<_RoleRequest> get copyWith => __$RoleRequestCopyWithImpl<_RoleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.requestedRole, requestedRole) || other.requestedRole == requestedRole)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.links, _links)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName)&&(identical(other.requesterPlace, requesterPlace) || other.requesterPlace == requesterPlace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,requestedRole,justification,status,createdAt,const DeepCollectionEquality().hash(_links),requesterName,requesterPlace);
}

@override
String toString() {
    return 'RoleRequest(id: $id, userId: $userId, requestedRole: $requestedRole, justification: $justification, status: $status, createdAt: $createdAt, links: $links, requesterName: $requesterName, requesterPlace: $requesterPlace)';
}


}

/// @nodoc
abstract mixin class _$RoleRequestCopyWith<$Res> implements $RoleRequestCopyWith<$Res> {
  factory _$RoleRequestCopyWith(_RoleRequest value, $Res Function(_RoleRequest) _then) = __$RoleRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, UserRole requestedRole, String justification, RequestStatus status, DateTime createdAt, List<String> links, String? requesterName, String? requesterPlace
});




}
/// @nodoc
class __$RoleRequestCopyWithImpl<$Res>
    implements _$RoleRequestCopyWith<$Res> {
  __$RoleRequestCopyWithImpl(this._self, this._then);

  final _RoleRequest _self;
  final $Res Function(_RoleRequest) _then;

/// Create a copy of RoleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? requestedRole = null,Object? justification = null,Object? status = null,Object? createdAt = null,Object? links = null,Object? requesterName = freezed,Object? requesterPlace = freezed,}) {
  return _then(_RoleRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,requestedRole: null == requestedRole ? _self.requestedRole : requestedRole // ignore: cast_nullable_to_non_nullable
as UserRole,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<String>,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,requesterPlace: freezed == requesterPlace ? _self.requesterPlace : requesterPlace // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
