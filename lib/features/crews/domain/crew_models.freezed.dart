// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crew_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CrewSummary {

 String get id; String get name; int get maxMembers; int get memberCount; String? get description; bool get isOpen; bool get sameGenderOnly; String? get ownerFirstName; List<String> get memberPhotos;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? get myStatus;
/// Create a copy of CrewSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewSummaryCopyWith<CrewSummary> get copyWith => _$CrewSummaryCopyWithImpl<CrewSummary>(this as CrewSummary, _$identity);

  /// Serializes this CrewSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CrewSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.maxMembers, _this.maxMembers) || other.maxMembers == _this.maxMembers)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isOpen, _this.isOpen) || other.isOpen == _this.isOpen)&&(identical(other.sameGenderOnly, _this.sameGenderOnly) || other.sameGenderOnly == _this.sameGenderOnly)&&(identical(other.ownerFirstName, _this.ownerFirstName) || other.ownerFirstName == _this.ownerFirstName)&&const DeepCollectionEquality().equals(other.memberPhotos, _this.memberPhotos)&&(identical(other.myStatus, _this.myStatus) || other.myStatus == _this.myStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CrewSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.maxMembers,_this.memberCount,_this.description,_this.isOpen,_this.sameGenderOnly,_this.ownerFirstName,const DeepCollectionEquality().hash(_this.memberPhotos),_this.myStatus);
}

@override
String toString() {
  final _this = this as CrewSummary;
  return 'CrewSummary(id: ${_this.id}, name: ${_this.name}, maxMembers: ${_this.maxMembers}, memberCount: ${_this.memberCount}, description: ${_this.description}, isOpen: ${_this.isOpen}, sameGenderOnly: ${_this.sameGenderOnly}, ownerFirstName: ${_this.ownerFirstName}, memberPhotos: ${_this.memberPhotos}, myStatus: ${_this.myStatus})';
}


}

/// @nodoc
abstract mixin class $CrewSummaryCopyWith<$Res>  {
  factory $CrewSummaryCopyWith(CrewSummary value, $Res Function(CrewSummary) _then) = _$CrewSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, int maxMembers, int memberCount, String? description, bool isOpen, bool sameGenderOnly, String? ownerFirstName, List<String> memberPhotos,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? myStatus
});




}
/// @nodoc
class _$CrewSummaryCopyWithImpl<$Res>
    implements $CrewSummaryCopyWith<$Res> {
  _$CrewSummaryCopyWithImpl(this._self, this._then);

  final CrewSummary _self;
  final $Res Function(CrewSummary) _then;

/// Create a copy of CrewSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? maxMembers = null,Object? memberCount = null,Object? description = freezed,Object? isOpen = null,Object? sameGenderOnly = null,Object? ownerFirstName = freezed,Object? memberPhotos = null,Object? myStatus = freezed,}) {
  return _then(CrewSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,sameGenderOnly: null == sameGenderOnly ? _self.sameGenderOnly : sameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,ownerFirstName: freezed == ownerFirstName ? _self.ownerFirstName : ownerFirstName // ignore: cast_nullable_to_non_nullable
as String?,memberPhotos: null == memberPhotos ? _self.memberPhotos : memberPhotos // ignore: cast_nullable_to_non_nullable
as List<String>,myStatus: freezed == myStatus ? _self.myStatus : myStatus // ignore: cast_nullable_to_non_nullable
as CrewRelation?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewSummary].
extension CrewSummaryPatterns on CrewSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewSummary value)  $default,){
final _that = this;
switch (_that) {
case _CrewSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CrewSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int maxMembers,  int memberCount,  String? description,  bool isOpen,  bool sameGenderOnly,  String? ownerFirstName,  List<String> memberPhotos, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewSummary() when $default != null:
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.description,_that.isOpen,_that.sameGenderOnly,_that.ownerFirstName,_that.memberPhotos,_that.myStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int maxMembers,  int memberCount,  String? description,  bool isOpen,  bool sameGenderOnly,  String? ownerFirstName,  List<String> memberPhotos, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus)  $default,) {final _that = this;
switch (_that) {
case _CrewSummary():
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.description,_that.isOpen,_that.sameGenderOnly,_that.ownerFirstName,_that.memberPhotos,_that.myStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int maxMembers,  int memberCount,  String? description,  bool isOpen,  bool sameGenderOnly,  String? ownerFirstName,  List<String> memberPhotos, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus)?  $default,) {final _that = this;
switch (_that) {
case _CrewSummary() when $default != null:
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.description,_that.isOpen,_that.sameGenderOnly,_that.ownerFirstName,_that.memberPhotos,_that.myStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewSummary extends CrewSummary {
  const _CrewSummary({required this.id, required this.name, required this.maxMembers, required this.memberCount, this.description, this.isOpen = true, this.sameGenderOnly = false, this.ownerFirstName,  List<String> memberPhotos = const [], @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.myStatus}): _memberPhotos = memberPhotos,super._();
  factory _CrewSummary.fromJson(Map<String, dynamic> json) => _$CrewSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  int maxMembers;
@override final  int memberCount;
@override final  String? description;
@override@JsonKey() final  bool isOpen;
@override@JsonKey() final  bool sameGenderOnly;
@override final  String? ownerFirstName;
 final  List<String> _memberPhotos;
@override@JsonKey() List<String> get memberPhotos {
  if (_memberPhotos is EqualUnmodifiableListView) return _memberPhotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberPhotos);
}

@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  CrewRelation? myStatus;

/// Create a copy of CrewSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewSummaryCopyWith<_CrewSummary> get copyWith => __$CrewSummaryCopyWithImpl<_CrewSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.description, description) || other.description == description)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.sameGenderOnly, sameGenderOnly) || other.sameGenderOnly == sameGenderOnly)&&(identical(other.ownerFirstName, ownerFirstName) || other.ownerFirstName == ownerFirstName)&&const DeepCollectionEquality().equals(other.memberPhotos, _memberPhotos)&&(identical(other.myStatus, myStatus) || other.myStatus == myStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,maxMembers,memberCount,description,isOpen,sameGenderOnly,ownerFirstName,const DeepCollectionEquality().hash(_memberPhotos),myStatus);
}

@override
String toString() {
    return 'CrewSummary(id: $id, name: $name, maxMembers: $maxMembers, memberCount: $memberCount, description: $description, isOpen: $isOpen, sameGenderOnly: $sameGenderOnly, ownerFirstName: $ownerFirstName, memberPhotos: $memberPhotos, myStatus: $myStatus)';
}


}

/// @nodoc
abstract mixin class _$CrewSummaryCopyWith<$Res> implements $CrewSummaryCopyWith<$Res> {
  factory _$CrewSummaryCopyWith(_CrewSummary value, $Res Function(_CrewSummary) _then) = __$CrewSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int maxMembers, int memberCount, String? description, bool isOpen, bool sameGenderOnly, String? ownerFirstName, List<String> memberPhotos,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? myStatus
});




}
/// @nodoc
class __$CrewSummaryCopyWithImpl<$Res>
    implements _$CrewSummaryCopyWith<$Res> {
  __$CrewSummaryCopyWithImpl(this._self, this._then);

  final _CrewSummary _self;
  final $Res Function(_CrewSummary) _then;

/// Create a copy of CrewSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? maxMembers = null,Object? memberCount = null,Object? description = freezed,Object? isOpen = null,Object? sameGenderOnly = null,Object? ownerFirstName = freezed,Object? memberPhotos = null,Object? myStatus = freezed,}) {
  return _then(_CrewSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,sameGenderOnly: null == sameGenderOnly ? _self.sameGenderOnly : sameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,ownerFirstName: freezed == ownerFirstName ? _self.ownerFirstName : ownerFirstName // ignore: cast_nullable_to_non_nullable
as String?,memberPhotos: null == memberPhotos ? _self._memberPhotos : memberPhotos // ignore: cast_nullable_to_non_nullable
as List<String>,myStatus: freezed == myStatus ? _self.myStatus : myStatus // ignore: cast_nullable_to_non_nullable
as CrewRelation?,
  ));
}


}


/// @nodoc
mixin _$CrewDetail {

 String get id; String get name; int get maxMembers; int get memberCount; String get ownerId; String get eventId; String get eventName; DateTime get eventStartsAt; String? get description; bool get isOpen; bool get sameGenderOnly; String? get conversationId;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? get myStatus;/// The user's pending request/invite for this crew.
 String? get myRequestId;
/// Create a copy of CrewDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewDetailCopyWith<CrewDetail> get copyWith => _$CrewDetailCopyWithImpl<CrewDetail>(this as CrewDetail, _$identity);

  /// Serializes this CrewDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CrewDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.maxMembers, _this.maxMembers) || other.maxMembers == _this.maxMembers)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.eventStartsAt, _this.eventStartsAt) || other.eventStartsAt == _this.eventStartsAt)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isOpen, _this.isOpen) || other.isOpen == _this.isOpen)&&(identical(other.sameGenderOnly, _this.sameGenderOnly) || other.sameGenderOnly == _this.sameGenderOnly)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.myStatus, _this.myStatus) || other.myStatus == _this.myStatus)&&(identical(other.myRequestId, _this.myRequestId) || other.myRequestId == _this.myRequestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CrewDetail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.maxMembers,_this.memberCount,_this.ownerId,_this.eventId,_this.eventName,_this.eventStartsAt,_this.description,_this.isOpen,_this.sameGenderOnly,_this.conversationId,_this.myStatus,_this.myRequestId);
}

@override
String toString() {
  final _this = this as CrewDetail;
  return 'CrewDetail(id: ${_this.id}, name: ${_this.name}, maxMembers: ${_this.maxMembers}, memberCount: ${_this.memberCount}, ownerId: ${_this.ownerId}, eventId: ${_this.eventId}, eventName: ${_this.eventName}, eventStartsAt: ${_this.eventStartsAt}, description: ${_this.description}, isOpen: ${_this.isOpen}, sameGenderOnly: ${_this.sameGenderOnly}, conversationId: ${_this.conversationId}, myStatus: ${_this.myStatus}, myRequestId: ${_this.myRequestId})';
}


}

/// @nodoc
abstract mixin class $CrewDetailCopyWith<$Res>  {
  factory $CrewDetailCopyWith(CrewDetail value, $Res Function(CrewDetail) _then) = _$CrewDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, int maxMembers, int memberCount, String ownerId, String eventId, String eventName, DateTime eventStartsAt, String? description, bool isOpen, bool sameGenderOnly, String? conversationId,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? myStatus, String? myRequestId
});




}
/// @nodoc
class _$CrewDetailCopyWithImpl<$Res>
    implements $CrewDetailCopyWith<$Res> {
  _$CrewDetailCopyWithImpl(this._self, this._then);

  final CrewDetail _self;
  final $Res Function(CrewDetail) _then;

/// Create a copy of CrewDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? maxMembers = null,Object? memberCount = null,Object? ownerId = null,Object? eventId = null,Object? eventName = null,Object? eventStartsAt = null,Object? description = freezed,Object? isOpen = null,Object? sameGenderOnly = null,Object? conversationId = freezed,Object? myStatus = freezed,Object? myRequestId = freezed,}) {
  return _then(CrewDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,sameGenderOnly: null == sameGenderOnly ? _self.sameGenderOnly : sameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,myStatus: freezed == myStatus ? _self.myStatus : myStatus // ignore: cast_nullable_to_non_nullable
as CrewRelation?,myRequestId: freezed == myRequestId ? _self.myRequestId : myRequestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewDetail].
extension CrewDetailPatterns on CrewDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewDetail value)  $default,){
final _that = this;
switch (_that) {
case _CrewDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewDetail value)?  $default,){
final _that = this;
switch (_that) {
case _CrewDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int maxMembers,  int memberCount,  String ownerId,  String eventId,  String eventName,  DateTime eventStartsAt,  String? description,  bool isOpen,  bool sameGenderOnly,  String? conversationId, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus,  String? myRequestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewDetail() when $default != null:
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.ownerId,_that.eventId,_that.eventName,_that.eventStartsAt,_that.description,_that.isOpen,_that.sameGenderOnly,_that.conversationId,_that.myStatus,_that.myRequestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int maxMembers,  int memberCount,  String ownerId,  String eventId,  String eventName,  DateTime eventStartsAt,  String? description,  bool isOpen,  bool sameGenderOnly,  String? conversationId, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus,  String? myRequestId)  $default,) {final _that = this;
switch (_that) {
case _CrewDetail():
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.ownerId,_that.eventId,_that.eventName,_that.eventStartsAt,_that.description,_that.isOpen,_that.sameGenderOnly,_that.conversationId,_that.myStatus,_that.myRequestId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int maxMembers,  int memberCount,  String ownerId,  String eventId,  String eventName,  DateTime eventStartsAt,  String? description,  bool isOpen,  bool sameGenderOnly,  String? conversationId, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CrewRelation? myStatus,  String? myRequestId)?  $default,) {final _that = this;
switch (_that) {
case _CrewDetail() when $default != null:
return $default(_that.id,_that.name,_that.maxMembers,_that.memberCount,_that.ownerId,_that.eventId,_that.eventName,_that.eventStartsAt,_that.description,_that.isOpen,_that.sameGenderOnly,_that.conversationId,_that.myStatus,_that.myRequestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewDetail extends CrewDetail {
  const _CrewDetail({required this.id, required this.name, required this.maxMembers, required this.memberCount, required this.ownerId, required this.eventId, required this.eventName, required this.eventStartsAt, this.description, this.isOpen = true, this.sameGenderOnly = false, this.conversationId, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.myStatus, this.myRequestId}): super._();
  factory _CrewDetail.fromJson(Map<String, dynamic> json) => _$CrewDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  int maxMembers;
@override final  int memberCount;
@override final  String ownerId;
@override final  String eventId;
@override final  String eventName;
@override final  DateTime eventStartsAt;
@override final  String? description;
@override@JsonKey() final  bool isOpen;
@override@JsonKey() final  bool sameGenderOnly;
@override final  String? conversationId;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  CrewRelation? myStatus;
/// The user's pending request/invite for this crew.
@override final  String? myRequestId;

/// Create a copy of CrewDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewDetailCopyWith<_CrewDetail> get copyWith => __$CrewDetailCopyWithImpl<_CrewDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.eventStartsAt, eventStartsAt) || other.eventStartsAt == eventStartsAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.sameGenderOnly, sameGenderOnly) || other.sameGenderOnly == sameGenderOnly)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.myStatus, myStatus) || other.myStatus == myStatus)&&(identical(other.myRequestId, myRequestId) || other.myRequestId == myRequestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,maxMembers,memberCount,ownerId,eventId,eventName,eventStartsAt,description,isOpen,sameGenderOnly,conversationId,myStatus,myRequestId);
}

@override
String toString() {
    return 'CrewDetail(id: $id, name: $name, maxMembers: $maxMembers, memberCount: $memberCount, ownerId: $ownerId, eventId: $eventId, eventName: $eventName, eventStartsAt: $eventStartsAt, description: $description, isOpen: $isOpen, sameGenderOnly: $sameGenderOnly, conversationId: $conversationId, myStatus: $myStatus, myRequestId: $myRequestId)';
}


}

/// @nodoc
abstract mixin class _$CrewDetailCopyWith<$Res> implements $CrewDetailCopyWith<$Res> {
  factory _$CrewDetailCopyWith(_CrewDetail value, $Res Function(_CrewDetail) _then) = __$CrewDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int maxMembers, int memberCount, String ownerId, String eventId, String eventName, DateTime eventStartsAt, String? description, bool isOpen, bool sameGenderOnly, String? conversationId,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CrewRelation? myStatus, String? myRequestId
});




}
/// @nodoc
class __$CrewDetailCopyWithImpl<$Res>
    implements _$CrewDetailCopyWith<$Res> {
  __$CrewDetailCopyWithImpl(this._self, this._then);

  final _CrewDetail _self;
  final $Res Function(_CrewDetail) _then;

/// Create a copy of CrewDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? maxMembers = null,Object? memberCount = null,Object? ownerId = null,Object? eventId = null,Object? eventName = null,Object? eventStartsAt = null,Object? description = freezed,Object? isOpen = null,Object? sameGenderOnly = null,Object? conversationId = freezed,Object? myStatus = freezed,Object? myRequestId = freezed,}) {
  return _then(_CrewDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,sameGenderOnly: null == sameGenderOnly ? _self.sameGenderOnly : sameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,myStatus: freezed == myStatus ? _self.myStatus : myStatus // ignore: cast_nullable_to_non_nullable
as CrewRelation?,myRequestId: freezed == myRequestId ? _self.myRequestId : myRequestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrewMember {

 String get userId; CrewRole get role; DateTime get joinedAt; String? get firstName; String? get photoPath;
/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewMemberCopyWith<CrewMember> get copyWith => _$CrewMemberCopyWithImpl<CrewMember>(this as CrewMember, _$identity);

  /// Serializes this CrewMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CrewMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewMember&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CrewMember;
  return Object.hash(runtimeType,_this.userId,_this.role,_this.joinedAt,_this.firstName,_this.photoPath);
}

@override
String toString() {
  final _this = this as CrewMember;
  return 'CrewMember(userId: ${_this.userId}, role: ${_this.role}, joinedAt: ${_this.joinedAt}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $CrewMemberCopyWith<$Res>  {
  factory $CrewMemberCopyWith(CrewMember value, $Res Function(CrewMember) _then) = _$CrewMemberCopyWithImpl;
@useResult
$Res call({
 String userId, CrewRole role, DateTime joinedAt, String? firstName, String? photoPath
});




}
/// @nodoc
class _$CrewMemberCopyWithImpl<$Res>
    implements $CrewMemberCopyWith<$Res> {
  _$CrewMemberCopyWithImpl(this._self, this._then);

  final CrewMember _self;
  final $Res Function(CrewMember) _then;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? joinedAt = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(CrewMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewMember].
extension CrewMemberPatterns on CrewMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewMember value)  $default,){
final _that = this;
switch (_that) {
case _CrewMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewMember value)?  $default,){
final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  CrewRole role,  DateTime joinedAt,  String? firstName,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAt,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  CrewRole role,  DateTime joinedAt,  String? firstName,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _CrewMember():
return $default(_that.userId,_that.role,_that.joinedAt,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  CrewRole role,  DateTime joinedAt,  String? firstName,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _CrewMember() when $default != null:
return $default(_that.userId,_that.role,_that.joinedAt,_that.firstName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewMember implements CrewMember {
  const _CrewMember({required this.userId, required this.role, required this.joinedAt, this.firstName, this.photoPath});
  factory _CrewMember.fromJson(Map<String, dynamic> json) => _$CrewMemberFromJson(json);

@override final  String userId;
@override final  CrewRole role;
@override final  DateTime joinedAt;
@override final  String? firstName;
@override final  String? photoPath;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewMemberCopyWith<_CrewMember> get copyWith => __$CrewMemberCopyWithImpl<_CrewMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,role,joinedAt,firstName,photoPath);
}

@override
String toString() {
    return 'CrewMember(userId: $userId, role: $role, joinedAt: $joinedAt, firstName: $firstName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$CrewMemberCopyWith<$Res> implements $CrewMemberCopyWith<$Res> {
  factory _$CrewMemberCopyWith(_CrewMember value, $Res Function(_CrewMember) _then) = __$CrewMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, CrewRole role, DateTime joinedAt, String? firstName, String? photoPath
});




}
/// @nodoc
class __$CrewMemberCopyWithImpl<$Res>
    implements _$CrewMemberCopyWith<$Res> {
  __$CrewMemberCopyWithImpl(this._self, this._then);

  final _CrewMember _self;
  final $Res Function(_CrewMember) _then;

/// Create a copy of CrewMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? joinedAt = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(_CrewMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as CrewRole,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrewPending {

 String get requestId; String get userId; CrewRequestKind get kind; DateTime get createdAt; String? get firstName; String? get photoPath;
/// Create a copy of CrewPending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewPendingCopyWith<CrewPending> get copyWith => _$CrewPendingCopyWithImpl<CrewPending>(this as CrewPending, _$identity);

  /// Serializes this CrewPending to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CrewPending;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewPending&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CrewPending;
  return Object.hash(runtimeType,_this.requestId,_this.userId,_this.kind,_this.createdAt,_this.firstName,_this.photoPath);
}

@override
String toString() {
  final _this = this as CrewPending;
  return 'CrewPending(requestId: ${_this.requestId}, userId: ${_this.userId}, kind: ${_this.kind}, createdAt: ${_this.createdAt}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $CrewPendingCopyWith<$Res>  {
  factory $CrewPendingCopyWith(CrewPending value, $Res Function(CrewPending) _then) = _$CrewPendingCopyWithImpl;
@useResult
$Res call({
 String requestId, String userId, CrewRequestKind kind, DateTime createdAt, String? firstName, String? photoPath
});




}
/// @nodoc
class _$CrewPendingCopyWithImpl<$Res>
    implements $CrewPendingCopyWith<$Res> {
  _$CrewPendingCopyWithImpl(this._self, this._then);

  final CrewPending _self;
  final $Res Function(CrewPending) _then;

/// Create a copy of CrewPending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? userId = null,Object? kind = null,Object? createdAt = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(CrewPending(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CrewRequestKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewPending].
extension CrewPendingPatterns on CrewPending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewPending value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewPending() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewPending value)  $default,){
final _that = this;
switch (_that) {
case _CrewPending():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewPending value)?  $default,){
final _that = this;
switch (_that) {
case _CrewPending() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String userId,  CrewRequestKind kind,  DateTime createdAt,  String? firstName,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewPending() when $default != null:
return $default(_that.requestId,_that.userId,_that.kind,_that.createdAt,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String userId,  CrewRequestKind kind,  DateTime createdAt,  String? firstName,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _CrewPending():
return $default(_that.requestId,_that.userId,_that.kind,_that.createdAt,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String userId,  CrewRequestKind kind,  DateTime createdAt,  String? firstName,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _CrewPending() when $default != null:
return $default(_that.requestId,_that.userId,_that.kind,_that.createdAt,_that.firstName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewPending implements CrewPending {
  const _CrewPending({required this.requestId, required this.userId, required this.kind, required this.createdAt, this.firstName, this.photoPath});
  factory _CrewPending.fromJson(Map<String, dynamic> json) => _$CrewPendingFromJson(json);

@override final  String requestId;
@override final  String userId;
@override final  CrewRequestKind kind;
@override final  DateTime createdAt;
@override final  String? firstName;
@override final  String? photoPath;

/// Create a copy of CrewPending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewPendingCopyWith<_CrewPending> get copyWith => __$CrewPendingCopyWithImpl<_CrewPending>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewPendingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewPending&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,userId,kind,createdAt,firstName,photoPath);
}

@override
String toString() {
    return 'CrewPending(requestId: $requestId, userId: $userId, kind: $kind, createdAt: $createdAt, firstName: $firstName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$CrewPendingCopyWith<$Res> implements $CrewPendingCopyWith<$Res> {
  factory _$CrewPendingCopyWith(_CrewPending value, $Res Function(_CrewPending) _then) = __$CrewPendingCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String userId, CrewRequestKind kind, DateTime createdAt, String? firstName, String? photoPath
});




}
/// @nodoc
class __$CrewPendingCopyWithImpl<$Res>
    implements _$CrewPendingCopyWith<$Res> {
  __$CrewPendingCopyWithImpl(this._self, this._then);

  final _CrewPending _self;
  final $Res Function(_CrewPending) _then;

/// Create a copy of CrewPending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? userId = null,Object? kind = null,Object? createdAt = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(_CrewPending(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CrewRequestKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CrewInviteCandidate {

 String get userId; String? get firstName; String? get photoPath;
/// Create a copy of CrewInviteCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrewInviteCandidateCopyWith<CrewInviteCandidate> get copyWith => _$CrewInviteCandidateCopyWithImpl<CrewInviteCandidate>(this as CrewInviteCandidate, _$identity);

  /// Serializes this CrewInviteCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CrewInviteCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrewInviteCandidate&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CrewInviteCandidate;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.photoPath);
}

@override
String toString() {
  final _this = this as CrewInviteCandidate;
  return 'CrewInviteCandidate(userId: ${_this.userId}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $CrewInviteCandidateCopyWith<$Res>  {
  factory $CrewInviteCandidateCopyWith(CrewInviteCandidate value, $Res Function(CrewInviteCandidate) _then) = _$CrewInviteCandidateCopyWithImpl;
@useResult
$Res call({
 String userId, String? firstName, String? photoPath
});




}
/// @nodoc
class _$CrewInviteCandidateCopyWithImpl<$Res>
    implements $CrewInviteCandidateCopyWith<$Res> {
  _$CrewInviteCandidateCopyWithImpl(this._self, this._then);

  final CrewInviteCandidate _self;
  final $Res Function(CrewInviteCandidate) _then;

/// Create a copy of CrewInviteCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(CrewInviteCandidate(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CrewInviteCandidate].
extension CrewInviteCandidatePatterns on CrewInviteCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrewInviteCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrewInviteCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrewInviteCandidate value)  $default,){
final _that = this;
switch (_that) {
case _CrewInviteCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrewInviteCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _CrewInviteCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? firstName,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrewInviteCandidate() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? firstName,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _CrewInviteCandidate():
return $default(_that.userId,_that.firstName,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? firstName,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _CrewInviteCandidate() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CrewInviteCandidate implements CrewInviteCandidate {
  const _CrewInviteCandidate({required this.userId, this.firstName, this.photoPath});
  factory _CrewInviteCandidate.fromJson(Map<String, dynamic> json) => _$CrewInviteCandidateFromJson(json);

@override final  String userId;
@override final  String? firstName;
@override final  String? photoPath;

/// Create a copy of CrewInviteCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrewInviteCandidateCopyWith<_CrewInviteCandidate> get copyWith => __$CrewInviteCandidateCopyWithImpl<_CrewInviteCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CrewInviteCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrewInviteCandidate&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,photoPath);
}

@override
String toString() {
    return 'CrewInviteCandidate(userId: $userId, firstName: $firstName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$CrewInviteCandidateCopyWith<$Res> implements $CrewInviteCandidateCopyWith<$Res> {
  factory _$CrewInviteCandidateCopyWith(_CrewInviteCandidate value, $Res Function(_CrewInviteCandidate) _then) = __$CrewInviteCandidateCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? firstName, String? photoPath
});




}
/// @nodoc
class __$CrewInviteCandidateCopyWithImpl<$Res>
    implements _$CrewInviteCandidateCopyWith<$Res> {
  __$CrewInviteCandidateCopyWithImpl(this._self, this._then);

  final _CrewInviteCandidate _self;
  final $Res Function(_CrewInviteCandidate) _then;

/// Create a copy of CrewInviteCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(_CrewInviteCandidate(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MyCrewInvite {

 String get requestId; String get crewId; String get crewName; String get eventName; DateTime get eventStartsAt; int get memberCount; String? get invitedByName;
/// Create a copy of MyCrewInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyCrewInviteCopyWith<MyCrewInvite> get copyWith => _$MyCrewInviteCopyWithImpl<MyCrewInvite>(this as MyCrewInvite, _$identity);

  /// Serializes this MyCrewInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyCrewInvite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyCrewInvite&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.crewId, _this.crewId) || other.crewId == _this.crewId)&&(identical(other.crewName, _this.crewName) || other.crewName == _this.crewName)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.eventStartsAt, _this.eventStartsAt) || other.eventStartsAt == _this.eventStartsAt)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.invitedByName, _this.invitedByName) || other.invitedByName == _this.invitedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyCrewInvite;
  return Object.hash(runtimeType,_this.requestId,_this.crewId,_this.crewName,_this.eventName,_this.eventStartsAt,_this.memberCount,_this.invitedByName);
}

@override
String toString() {
  final _this = this as MyCrewInvite;
  return 'MyCrewInvite(requestId: ${_this.requestId}, crewId: ${_this.crewId}, crewName: ${_this.crewName}, eventName: ${_this.eventName}, eventStartsAt: ${_this.eventStartsAt}, memberCount: ${_this.memberCount}, invitedByName: ${_this.invitedByName})';
}


}

/// @nodoc
abstract mixin class $MyCrewInviteCopyWith<$Res>  {
  factory $MyCrewInviteCopyWith(MyCrewInvite value, $Res Function(MyCrewInvite) _then) = _$MyCrewInviteCopyWithImpl;
@useResult
$Res call({
 String requestId, String crewId, String crewName, String eventName, DateTime eventStartsAt, int memberCount, String? invitedByName
});




}
/// @nodoc
class _$MyCrewInviteCopyWithImpl<$Res>
    implements $MyCrewInviteCopyWith<$Res> {
  _$MyCrewInviteCopyWithImpl(this._self, this._then);

  final MyCrewInvite _self;
  final $Res Function(MyCrewInvite) _then;

/// Create a copy of MyCrewInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? crewId = null,Object? crewName = null,Object? eventName = null,Object? eventStartsAt = null,Object? memberCount = null,Object? invitedByName = freezed,}) {
  return _then(MyCrewInvite(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,crewId: null == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String,crewName: null == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,invitedByName: freezed == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyCrewInvite].
extension MyCrewInvitePatterns on MyCrewInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyCrewInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyCrewInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyCrewInvite value)  $default,){
final _that = this;
switch (_that) {
case _MyCrewInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyCrewInvite value)?  $default,){
final _that = this;
switch (_that) {
case _MyCrewInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requestId,  String crewId,  String crewName,  String eventName,  DateTime eventStartsAt,  int memberCount,  String? invitedByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyCrewInvite() when $default != null:
return $default(_that.requestId,_that.crewId,_that.crewName,_that.eventName,_that.eventStartsAt,_that.memberCount,_that.invitedByName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requestId,  String crewId,  String crewName,  String eventName,  DateTime eventStartsAt,  int memberCount,  String? invitedByName)  $default,) {final _that = this;
switch (_that) {
case _MyCrewInvite():
return $default(_that.requestId,_that.crewId,_that.crewName,_that.eventName,_that.eventStartsAt,_that.memberCount,_that.invitedByName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requestId,  String crewId,  String crewName,  String eventName,  DateTime eventStartsAt,  int memberCount,  String? invitedByName)?  $default,) {final _that = this;
switch (_that) {
case _MyCrewInvite() when $default != null:
return $default(_that.requestId,_that.crewId,_that.crewName,_that.eventName,_that.eventStartsAt,_that.memberCount,_that.invitedByName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyCrewInvite implements MyCrewInvite {
  const _MyCrewInvite({required this.requestId, required this.crewId, required this.crewName, required this.eventName, required this.eventStartsAt, required this.memberCount, this.invitedByName});
  factory _MyCrewInvite.fromJson(Map<String, dynamic> json) => _$MyCrewInviteFromJson(json);

@override final  String requestId;
@override final  String crewId;
@override final  String crewName;
@override final  String eventName;
@override final  DateTime eventStartsAt;
@override final  int memberCount;
@override final  String? invitedByName;

/// Create a copy of MyCrewInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyCrewInviteCopyWith<_MyCrewInvite> get copyWith => __$MyCrewInviteCopyWithImpl<_MyCrewInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyCrewInviteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyCrewInvite&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.crewId, crewId) || other.crewId == crewId)&&(identical(other.crewName, crewName) || other.crewName == crewName)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.eventStartsAt, eventStartsAt) || other.eventStartsAt == eventStartsAt)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.invitedByName, invitedByName) || other.invitedByName == invitedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,crewId,crewName,eventName,eventStartsAt,memberCount,invitedByName);
}

@override
String toString() {
    return 'MyCrewInvite(requestId: $requestId, crewId: $crewId, crewName: $crewName, eventName: $eventName, eventStartsAt: $eventStartsAt, memberCount: $memberCount, invitedByName: $invitedByName)';
}


}

/// @nodoc
abstract mixin class _$MyCrewInviteCopyWith<$Res> implements $MyCrewInviteCopyWith<$Res> {
  factory _$MyCrewInviteCopyWith(_MyCrewInvite value, $Res Function(_MyCrewInvite) _then) = __$MyCrewInviteCopyWithImpl;
@override @useResult
$Res call({
 String requestId, String crewId, String crewName, String eventName, DateTime eventStartsAt, int memberCount, String? invitedByName
});




}
/// @nodoc
class __$MyCrewInviteCopyWithImpl<$Res>
    implements _$MyCrewInviteCopyWith<$Res> {
  __$MyCrewInviteCopyWithImpl(this._self, this._then);

  final _MyCrewInvite _self;
  final $Res Function(_MyCrewInvite) _then;

/// Create a copy of MyCrewInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? crewId = null,Object? crewName = null,Object? eventName = null,Object? eventStartsAt = null,Object? memberCount = null,Object? invitedByName = freezed,}) {
  return _then(_MyCrewInvite(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,crewId: null == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String,crewName: null == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,invitedByName: freezed == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
