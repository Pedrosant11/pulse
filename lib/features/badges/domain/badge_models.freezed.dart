// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBadge {

 ProfileBadgeType get badge; String? get title;
/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserBadgeCopyWith<UserBadge> get copyWith => _$UserBadgeCopyWithImpl<UserBadge>(this as UserBadge, _$identity);

  /// Serializes this UserBadge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserBadge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserBadge&&(identical(other.badge, _this.badge) || other.badge == _this.badge)&&(identical(other.title, _this.title) || other.title == _this.title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserBadge;
  return Object.hash(runtimeType,_this.badge,_this.title);
}

@override
String toString() {
  final _this = this as UserBadge;
  return 'UserBadge(badge: ${_this.badge}, title: ${_this.title})';
}


}

/// @nodoc
abstract mixin class $UserBadgeCopyWith<$Res>  {
  factory $UserBadgeCopyWith(UserBadge value, $Res Function(UserBadge) _then) = _$UserBadgeCopyWithImpl;
@useResult
$Res call({
 ProfileBadgeType badge, String? title
});




}
/// @nodoc
class _$UserBadgeCopyWithImpl<$Res>
    implements $UserBadgeCopyWith<$Res> {
  _$UserBadgeCopyWithImpl(this._self, this._then);

  final UserBadge _self;
  final $Res Function(UserBadge) _then;

/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? badge = null,Object? title = freezed,}) {
  return _then(UserBadge(
badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as ProfileBadgeType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserBadge].
extension UserBadgePatterns on UserBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserBadge value)  $default,){
final _that = this;
switch (_that) {
case _UserBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserBadge value)?  $default,){
final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileBadgeType badge,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
return $default(_that.badge,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileBadgeType badge,  String? title)  $default,) {final _that = this;
switch (_that) {
case _UserBadge():
return $default(_that.badge,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileBadgeType badge,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _UserBadge() when $default != null:
return $default(_that.badge,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserBadge implements UserBadge {
  const _UserBadge({required this.badge, this.title});
  factory _UserBadge.fromJson(Map<String, dynamic> json) => _$UserBadgeFromJson(json);

@override final  ProfileBadgeType badge;
@override final  String? title;

/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserBadgeCopyWith<_UserBadge> get copyWith => __$UserBadgeCopyWithImpl<_UserBadge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserBadgeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserBadge&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,badge,title);
}

@override
String toString() {
    return 'UserBadge(badge: $badge, title: $title)';
}


}

/// @nodoc
abstract mixin class _$UserBadgeCopyWith<$Res> implements $UserBadgeCopyWith<$Res> {
  factory _$UserBadgeCopyWith(_UserBadge value, $Res Function(_UserBadge) _then) = __$UserBadgeCopyWithImpl;
@override @useResult
$Res call({
 ProfileBadgeType badge, String? title
});




}
/// @nodoc
class __$UserBadgeCopyWithImpl<$Res>
    implements _$UserBadgeCopyWith<$Res> {
  __$UserBadgeCopyWithImpl(this._self, this._then);

  final _UserBadge _self;
  final $Res Function(_UserBadge) _then;

/// Create a copy of UserBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? badge = null,Object? title = freezed,}) {
  return _then(_UserBadge(
badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as ProfileBadgeType,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BadgeRequest {

 String get id; String get userId; ProfileBadgeType get badge; String get justification; RequestStatus get status; DateTime get createdAt; List<String> get links;/// Filled for admins (requester's name).
 String? get requesterName;
/// Create a copy of BadgeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeRequestCopyWith<BadgeRequest> get copyWith => _$BadgeRequestCopyWithImpl<BadgeRequest>(this as BadgeRequest, _$identity);

  /// Serializes this BadgeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BadgeRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.badge, _this.badge) || other.badge == _this.badge)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.links, _this.links)&&(identical(other.requesterName, _this.requesterName) || other.requesterName == _this.requesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BadgeRequest;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.badge,_this.justification,_this.status,_this.createdAt,const DeepCollectionEquality().hash(_this.links),_this.requesterName);
}

@override
String toString() {
  final _this = this as BadgeRequest;
  return 'BadgeRequest(id: ${_this.id}, userId: ${_this.userId}, badge: ${_this.badge}, justification: ${_this.justification}, status: ${_this.status}, createdAt: ${_this.createdAt}, links: ${_this.links}, requesterName: ${_this.requesterName})';
}


}

/// @nodoc
abstract mixin class $BadgeRequestCopyWith<$Res>  {
  factory $BadgeRequestCopyWith(BadgeRequest value, $Res Function(BadgeRequest) _then) = _$BadgeRequestCopyWithImpl;
@useResult
$Res call({
 String id, String userId, ProfileBadgeType badge, String justification, RequestStatus status, DateTime createdAt, List<String> links, String? requesterName
});




}
/// @nodoc
class _$BadgeRequestCopyWithImpl<$Res>
    implements $BadgeRequestCopyWith<$Res> {
  _$BadgeRequestCopyWithImpl(this._self, this._then);

  final BadgeRequest _self;
  final $Res Function(BadgeRequest) _then;

/// Create a copy of BadgeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? badge = null,Object? justification = null,Object? status = null,Object? createdAt = null,Object? links = null,Object? requesterName = freezed,}) {
  return _then(BadgeRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as ProfileBadgeType,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<String>,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeRequest].
extension BadgeRequestPatterns on BadgeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeRequest value)  $default,){
final _that = this;
switch (_that) {
case _BadgeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  ProfileBadgeType badge,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.badge,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  ProfileBadgeType badge,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName)  $default,) {final _that = this;
switch (_that) {
case _BadgeRequest():
return $default(_that.id,_that.userId,_that.badge,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  ProfileBadgeType badge,  String justification,  RequestStatus status,  DateTime createdAt,  List<String> links,  String? requesterName)?  $default,) {final _that = this;
switch (_that) {
case _BadgeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.badge,_that.justification,_that.status,_that.createdAt,_that.links,_that.requesterName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeRequest implements BadgeRequest {
  const _BadgeRequest({required this.id, required this.userId, required this.badge, required this.justification, required this.status, required this.createdAt,  List<String> links = const [], this.requesterName}): _links = links;
  factory _BadgeRequest.fromJson(Map<String, dynamic> json) => _$BadgeRequestFromJson(json);

@override final  String id;
@override final  String userId;
@override final  ProfileBadgeType badge;
@override final  String justification;
@override final  RequestStatus status;
@override final  DateTime createdAt;
 final  List<String> _links;
@override@JsonKey() List<String> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

/// Filled for admins (requester's name).
@override final  String? requesterName;

/// Create a copy of BadgeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeRequestCopyWith<_BadgeRequest> get copyWith => __$BadgeRequestCopyWithImpl<_BadgeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.links, _links)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,badge,justification,status,createdAt,const DeepCollectionEquality().hash(_links),requesterName);
}

@override
String toString() {
    return 'BadgeRequest(id: $id, userId: $userId, badge: $badge, justification: $justification, status: $status, createdAt: $createdAt, links: $links, requesterName: $requesterName)';
}


}

/// @nodoc
abstract mixin class _$BadgeRequestCopyWith<$Res> implements $BadgeRequestCopyWith<$Res> {
  factory _$BadgeRequestCopyWith(_BadgeRequest value, $Res Function(_BadgeRequest) _then) = __$BadgeRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, ProfileBadgeType badge, String justification, RequestStatus status, DateTime createdAt, List<String> links, String? requesterName
});




}
/// @nodoc
class __$BadgeRequestCopyWithImpl<$Res>
    implements _$BadgeRequestCopyWith<$Res> {
  __$BadgeRequestCopyWithImpl(this._self, this._then);

  final _BadgeRequest _self;
  final $Res Function(_BadgeRequest) _then;

/// Create a copy of BadgeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? badge = null,Object? justification = null,Object? status = null,Object? createdAt = null,Object? links = null,Object? requesterName = freezed,}) {
  return _then(_BadgeRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,badge: null == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as ProfileBadgeType,justification: null == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<String>,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdminUserResult {

 String get userId; String get firstName; String? get lastName; String? get city; String? get state; String? get photoPath;
/// Create a copy of AdminUserResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserResultCopyWith<AdminUserResult> get copyWith => _$AdminUserResultCopyWithImpl<AdminUserResult>(this as AdminUserResult, _$identity);

  /// Serializes this AdminUserResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUserResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserResult&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUserResult;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.lastName,_this.city,_this.state,_this.photoPath);
}

@override
String toString() {
  final _this = this as AdminUserResult;
  return 'AdminUserResult(userId: ${_this.userId}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, city: ${_this.city}, state: ${_this.state}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $AdminUserResultCopyWith<$Res>  {
  factory $AdminUserResultCopyWith(AdminUserResult value, $Res Function(AdminUserResult) _then) = _$AdminUserResultCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, String? lastName, String? city, String? state, String? photoPath
});




}
/// @nodoc
class _$AdminUserResultCopyWithImpl<$Res>
    implements $AdminUserResultCopyWith<$Res> {
  _$AdminUserResultCopyWithImpl(this._self, this._then);

  final AdminUserResult _self;
  final $Res Function(AdminUserResult) _then;

/// Create a copy of AdminUserResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? lastName = freezed,Object? city = freezed,Object? state = freezed,Object? photoPath = freezed,}) {
  return _then(AdminUserResult(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserResult].
extension AdminUserResultPatterns on AdminUserResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserResult value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserResult value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  String? lastName,  String? city,  String? state,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserResult() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.city,_that.state,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  String? lastName,  String? city,  String? state,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _AdminUserResult():
return $default(_that.userId,_that.firstName,_that.lastName,_that.city,_that.state,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  String? lastName,  String? city,  String? state,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserResult() when $default != null:
return $default(_that.userId,_that.firstName,_that.lastName,_that.city,_that.state,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserResult extends AdminUserResult {
  const _AdminUserResult({required this.userId, required this.firstName, this.lastName, this.city, this.state, this.photoPath}): super._();
  factory _AdminUserResult.fromJson(Map<String, dynamic> json) => _$AdminUserResultFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  String? lastName;
@override final  String? city;
@override final  String? state;
@override final  String? photoPath;

/// Create a copy of AdminUserResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserResultCopyWith<_AdminUserResult> get copyWith => __$AdminUserResultCopyWithImpl<_AdminUserResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserResult&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,lastName,city,state,photoPath);
}

@override
String toString() {
    return 'AdminUserResult(userId: $userId, firstName: $firstName, lastName: $lastName, city: $city, state: $state, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$AdminUserResultCopyWith<$Res> implements $AdminUserResultCopyWith<$Res> {
  factory _$AdminUserResultCopyWith(_AdminUserResult value, $Res Function(_AdminUserResult) _then) = __$AdminUserResultCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, String? lastName, String? city, String? state, String? photoPath
});




}
/// @nodoc
class __$AdminUserResultCopyWithImpl<$Res>
    implements _$AdminUserResultCopyWith<$Res> {
  __$AdminUserResultCopyWithImpl(this._self, this._then);

  final _AdminUserResult _self;
  final $Res Function(_AdminUserResult) _then;

/// Create a copy of AdminUserResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? lastName = freezed,Object? city = freezed,Object? state = freezed,Object? photoPath = freezed,}) {
  return _then(_AdminUserResult(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
