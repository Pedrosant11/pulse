// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerificationRequest {

 String get id; VerificationPose get pose; RequestStatus get status; DateTime get createdAt; String? get rejectionReason;
/// Create a copy of VerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationRequestCopyWith<VerificationRequest> get copyWith => _$VerificationRequestCopyWithImpl<VerificationRequest>(this as VerificationRequest, _$identity);

  /// Serializes this VerificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VerificationRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.pose, _this.pose) || other.pose == _this.pose)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.rejectionReason, _this.rejectionReason) || other.rejectionReason == _this.rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VerificationRequest;
  return Object.hash(runtimeType,_this.id,_this.pose,_this.status,_this.createdAt,_this.rejectionReason);
}

@override
String toString() {
  final _this = this as VerificationRequest;
  return 'VerificationRequest(id: ${_this.id}, pose: ${_this.pose}, status: ${_this.status}, createdAt: ${_this.createdAt}, rejectionReason: ${_this.rejectionReason})';
}


}

/// @nodoc
abstract mixin class $VerificationRequestCopyWith<$Res>  {
  factory $VerificationRequestCopyWith(VerificationRequest value, $Res Function(VerificationRequest) _then) = _$VerificationRequestCopyWithImpl;
@useResult
$Res call({
 String id, VerificationPose pose, RequestStatus status, DateTime createdAt, String? rejectionReason
});




}
/// @nodoc
class _$VerificationRequestCopyWithImpl<$Res>
    implements $VerificationRequestCopyWith<$Res> {
  _$VerificationRequestCopyWithImpl(this._self, this._then);

  final VerificationRequest _self;
  final $Res Function(VerificationRequest) _then;

/// Create a copy of VerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pose = null,Object? status = null,Object? createdAt = null,Object? rejectionReason = freezed,}) {
  return _then(VerificationRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as VerificationPose,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerificationRequest].
extension VerificationRequestPatterns on VerificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _VerificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  VerificationPose pose,  RequestStatus status,  DateTime createdAt,  String? rejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationRequest() when $default != null:
return $default(_that.id,_that.pose,_that.status,_that.createdAt,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  VerificationPose pose,  RequestStatus status,  DateTime createdAt,  String? rejectionReason)  $default,) {final _that = this;
switch (_that) {
case _VerificationRequest():
return $default(_that.id,_that.pose,_that.status,_that.createdAt,_that.rejectionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  VerificationPose pose,  RequestStatus status,  DateTime createdAt,  String? rejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _VerificationRequest() when $default != null:
return $default(_that.id,_that.pose,_that.status,_that.createdAt,_that.rejectionReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationRequest implements VerificationRequest {
  const _VerificationRequest({required this.id, required this.pose, required this.status, required this.createdAt, this.rejectionReason});
  factory _VerificationRequest.fromJson(Map<String, dynamic> json) => _$VerificationRequestFromJson(json);

@override final  String id;
@override final  VerificationPose pose;
@override final  RequestStatus status;
@override final  DateTime createdAt;
@override final  String? rejectionReason;

/// Create a copy of VerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationRequestCopyWith<_VerificationRequest> get copyWith => __$VerificationRequestCopyWithImpl<_VerificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.pose, pose) || other.pose == pose)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,pose,status,createdAt,rejectionReason);
}

@override
String toString() {
    return 'VerificationRequest(id: $id, pose: $pose, status: $status, createdAt: $createdAt, rejectionReason: $rejectionReason)';
}


}

/// @nodoc
abstract mixin class _$VerificationRequestCopyWith<$Res> implements $VerificationRequestCopyWith<$Res> {
  factory _$VerificationRequestCopyWith(_VerificationRequest value, $Res Function(_VerificationRequest) _then) = __$VerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, VerificationPose pose, RequestStatus status, DateTime createdAt, String? rejectionReason
});




}
/// @nodoc
class __$VerificationRequestCopyWithImpl<$Res>
    implements _$VerificationRequestCopyWith<$Res> {
  __$VerificationRequestCopyWithImpl(this._self, this._then);

  final _VerificationRequest _self;
  final $Res Function(_VerificationRequest) _then;

/// Create a copy of VerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pose = null,Object? status = null,Object? createdAt = null,Object? rejectionReason = freezed,}) {
  return _then(_VerificationRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as VerificationPose,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PendingVerification {

 String get id; String get userId; String get firstName; int get age; VerificationPose get pose; DateTime get createdAt; String? get selfiePath; List<String> get photoPaths;
/// Create a copy of PendingVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingVerificationCopyWith<PendingVerification> get copyWith => _$PendingVerificationCopyWithImpl<PendingVerification>(this as PendingVerification, _$identity);

  /// Serializes this PendingVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PendingVerification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingVerification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.pose, _this.pose) || other.pose == _this.pose)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.selfiePath, _this.selfiePath) || other.selfiePath == _this.selfiePath)&&const DeepCollectionEquality().equals(other.photoPaths, _this.photoPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PendingVerification;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.firstName,_this.age,_this.pose,_this.createdAt,_this.selfiePath,const DeepCollectionEquality().hash(_this.photoPaths));
}

@override
String toString() {
  final _this = this as PendingVerification;
  return 'PendingVerification(id: ${_this.id}, userId: ${_this.userId}, firstName: ${_this.firstName}, age: ${_this.age}, pose: ${_this.pose}, createdAt: ${_this.createdAt}, selfiePath: ${_this.selfiePath}, photoPaths: ${_this.photoPaths})';
}


}

/// @nodoc
abstract mixin class $PendingVerificationCopyWith<$Res>  {
  factory $PendingVerificationCopyWith(PendingVerification value, $Res Function(PendingVerification) _then) = _$PendingVerificationCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String firstName, int age, VerificationPose pose, DateTime createdAt, String? selfiePath, List<String> photoPaths
});




}
/// @nodoc
class _$PendingVerificationCopyWithImpl<$Res>
    implements $PendingVerificationCopyWith<$Res> {
  _$PendingVerificationCopyWithImpl(this._self, this._then);

  final PendingVerification _self;
  final $Res Function(PendingVerification) _then;

/// Create a copy of PendingVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? firstName = null,Object? age = null,Object? pose = null,Object? createdAt = null,Object? selfiePath = freezed,Object? photoPaths = null,}) {
  return _then(PendingVerification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as VerificationPose,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingVerification].
extension PendingVerificationPatterns on PendingVerification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingVerification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingVerification value)  $default,){
final _that = this;
switch (_that) {
case _PendingVerification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingVerification value)?  $default,){
final _that = this;
switch (_that) {
case _PendingVerification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String firstName,  int age,  VerificationPose pose,  DateTime createdAt,  String? selfiePath,  List<String> photoPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingVerification() when $default != null:
return $default(_that.id,_that.userId,_that.firstName,_that.age,_that.pose,_that.createdAt,_that.selfiePath,_that.photoPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String firstName,  int age,  VerificationPose pose,  DateTime createdAt,  String? selfiePath,  List<String> photoPaths)  $default,) {final _that = this;
switch (_that) {
case _PendingVerification():
return $default(_that.id,_that.userId,_that.firstName,_that.age,_that.pose,_that.createdAt,_that.selfiePath,_that.photoPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String firstName,  int age,  VerificationPose pose,  DateTime createdAt,  String? selfiePath,  List<String> photoPaths)?  $default,) {final _that = this;
switch (_that) {
case _PendingVerification() when $default != null:
return $default(_that.id,_that.userId,_that.firstName,_that.age,_that.pose,_that.createdAt,_that.selfiePath,_that.photoPaths);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingVerification implements PendingVerification {
  const _PendingVerification({required this.id, required this.userId, required this.firstName, required this.age, required this.pose, required this.createdAt, this.selfiePath,  List<String> photoPaths = const []}): _photoPaths = photoPaths;
  factory _PendingVerification.fromJson(Map<String, dynamic> json) => _$PendingVerificationFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String firstName;
@override final  int age;
@override final  VerificationPose pose;
@override final  DateTime createdAt;
@override final  String? selfiePath;
 final  List<String> _photoPaths;
@override@JsonKey() List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}


/// Create a copy of PendingVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingVerificationCopyWith<_PendingVerification> get copyWith => __$PendingVerificationCopyWithImpl<_PendingVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.age, age) || other.age == age)&&(identical(other.pose, pose) || other.pose == pose)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.selfiePath, selfiePath) || other.selfiePath == selfiePath)&&const DeepCollectionEquality().equals(other.photoPaths, _photoPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,firstName,age,pose,createdAt,selfiePath,const DeepCollectionEquality().hash(_photoPaths));
}

@override
String toString() {
    return 'PendingVerification(id: $id, userId: $userId, firstName: $firstName, age: $age, pose: $pose, createdAt: $createdAt, selfiePath: $selfiePath, photoPaths: $photoPaths)';
}


}

/// @nodoc
abstract mixin class _$PendingVerificationCopyWith<$Res> implements $PendingVerificationCopyWith<$Res> {
  factory _$PendingVerificationCopyWith(_PendingVerification value, $Res Function(_PendingVerification) _then) = __$PendingVerificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String firstName, int age, VerificationPose pose, DateTime createdAt, String? selfiePath, List<String> photoPaths
});




}
/// @nodoc
class __$PendingVerificationCopyWithImpl<$Res>
    implements _$PendingVerificationCopyWith<$Res> {
  __$PendingVerificationCopyWithImpl(this._self, this._then);

  final _PendingVerification _self;
  final $Res Function(_PendingVerification) _then;

/// Create a copy of PendingVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? firstName = null,Object? age = null,Object? pose = null,Object? createdAt = null,Object? selfiePath = freezed,Object? photoPaths = null,}) {
  return _then(_PendingVerification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,pose: null == pose ? _self.pose : pose // ignore: cast_nullable_to_non_nullable
as VerificationPose,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
