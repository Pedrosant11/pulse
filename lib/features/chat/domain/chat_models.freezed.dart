// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationSummary {

 String get id; ConversationType get type; DateTime get createdAt; AppMode? get mode; String? get matchId; String? get otherUserId; String? get otherFirstName; String? get otherPhotoPath; String? get lastMessage; String? get lastMessageSenderId; DateTime? get lastMessageAt; MessageKind get lastMessageKind; int get unreadCount; String? get crewId; String? get crewName; String? get eventName; int? get memberCount;
/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSummaryCopyWith<ConversationSummary> get copyWith => _$ConversationSummaryCopyWithImpl<ConversationSummary>(this as ConversationSummary, _$identity);

  /// Serializes this ConversationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.otherUserId, _this.otherUserId) || other.otherUserId == _this.otherUserId)&&(identical(other.otherFirstName, _this.otherFirstName) || other.otherFirstName == _this.otherFirstName)&&(identical(other.otherPhotoPath, _this.otherPhotoPath) || other.otherPhotoPath == _this.otherPhotoPath)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.lastMessageSenderId, _this.lastMessageSenderId) || other.lastMessageSenderId == _this.lastMessageSenderId)&&(identical(other.lastMessageAt, _this.lastMessageAt) || other.lastMessageAt == _this.lastMessageAt)&&(identical(other.lastMessageKind, _this.lastMessageKind) || other.lastMessageKind == _this.lastMessageKind)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount)&&(identical(other.crewId, _this.crewId) || other.crewId == _this.crewId)&&(identical(other.crewName, _this.crewName) || other.crewName == _this.crewName)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationSummary;
  return Object.hash(runtimeType,_this.id,_this.type,_this.createdAt,_this.mode,_this.matchId,_this.otherUserId,_this.otherFirstName,_this.otherPhotoPath,_this.lastMessage,_this.lastMessageSenderId,_this.lastMessageAt,_this.lastMessageKind,_this.unreadCount,_this.crewId,_this.crewName,_this.eventName,_this.memberCount);
}

@override
String toString() {
  final _this = this as ConversationSummary;
  return 'ConversationSummary(id: ${_this.id}, type: ${_this.type}, createdAt: ${_this.createdAt}, mode: ${_this.mode}, matchId: ${_this.matchId}, otherUserId: ${_this.otherUserId}, otherFirstName: ${_this.otherFirstName}, otherPhotoPath: ${_this.otherPhotoPath}, lastMessage: ${_this.lastMessage}, lastMessageSenderId: ${_this.lastMessageSenderId}, lastMessageAt: ${_this.lastMessageAt}, lastMessageKind: ${_this.lastMessageKind}, unreadCount: ${_this.unreadCount}, crewId: ${_this.crewId}, crewName: ${_this.crewName}, eventName: ${_this.eventName}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $ConversationSummaryCopyWith<$Res>  {
  factory $ConversationSummaryCopyWith(ConversationSummary value, $Res Function(ConversationSummary) _then) = _$ConversationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, ConversationType type, DateTime createdAt, AppMode? mode, String? matchId, String? otherUserId, String? otherFirstName, String? otherPhotoPath, String? lastMessage, String? lastMessageSenderId, DateTime? lastMessageAt, MessageKind lastMessageKind, int unreadCount, String? crewId, String? crewName, String? eventName, int? memberCount
});




}
/// @nodoc
class _$ConversationSummaryCopyWithImpl<$Res>
    implements $ConversationSummaryCopyWith<$Res> {
  _$ConversationSummaryCopyWithImpl(this._self, this._then);

  final ConversationSummary _self;
  final $Res Function(ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? createdAt = null,Object? mode = freezed,Object? matchId = freezed,Object? otherUserId = freezed,Object? otherFirstName = freezed,Object? otherPhotoPath = freezed,Object? lastMessage = freezed,Object? lastMessageSenderId = freezed,Object? lastMessageAt = freezed,Object? lastMessageKind = null,Object? unreadCount = null,Object? crewId = freezed,Object? crewName = freezed,Object? eventName = freezed,Object? memberCount = freezed,}) {
  return _then(ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode?,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherFirstName: freezed == otherFirstName ? _self.otherFirstName : otherFirstName // ignore: cast_nullable_to_non_nullable
as String?,otherPhotoPath: freezed == otherPhotoPath ? _self.otherPhotoPath : otherPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageSenderId: freezed == lastMessageSenderId ? _self.lastMessageSenderId : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessageKind: null == lastMessageKind ? _self.lastMessageKind : lastMessageKind // ignore: cast_nullable_to_non_nullable
as MessageKind,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,crewId: freezed == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String?,crewName: freezed == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String?,eventName: freezed == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String?,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationSummary].
extension ConversationSummaryPatterns on ConversationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ConversationType type,  DateTime createdAt,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  String? lastMessage,  String? lastMessageSenderId,  DateTime? lastMessageAt,  MessageKind lastMessageKind,  int unreadCount,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.type,_that.createdAt,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.lastMessage,_that.lastMessageSenderId,_that.lastMessageAt,_that.lastMessageKind,_that.unreadCount,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ConversationType type,  DateTime createdAt,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  String? lastMessage,  String? lastMessageSenderId,  DateTime? lastMessageAt,  MessageKind lastMessageKind,  int unreadCount,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary():
return $default(_that.id,_that.type,_that.createdAt,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.lastMessage,_that.lastMessageSenderId,_that.lastMessageAt,_that.lastMessageKind,_that.unreadCount,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ConversationType type,  DateTime createdAt,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  String? lastMessage,  String? lastMessageSenderId,  DateTime? lastMessageAt,  MessageKind lastMessageKind,  int unreadCount,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.type,_that.createdAt,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.lastMessage,_that.lastMessageSenderId,_that.lastMessageAt,_that.lastMessageKind,_that.unreadCount,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationSummary extends ConversationSummary {
  const _ConversationSummary({required this.id, required this.type, required this.createdAt, this.mode, this.matchId, this.otherUserId, this.otherFirstName, this.otherPhotoPath, this.lastMessage, this.lastMessageSenderId, this.lastMessageAt, this.lastMessageKind = MessageKind.text, this.unreadCount = 0, this.crewId, this.crewName, this.eventName, this.memberCount}): super._();
  factory _ConversationSummary.fromJson(Map<String, dynamic> json) => _$ConversationSummaryFromJson(json);

@override final  String id;
@override final  ConversationType type;
@override final  DateTime createdAt;
@override final  AppMode? mode;
@override final  String? matchId;
@override final  String? otherUserId;
@override final  String? otherFirstName;
@override final  String? otherPhotoPath;
@override final  String? lastMessage;
@override final  String? lastMessageSenderId;
@override final  DateTime? lastMessageAt;
@override@JsonKey() final  MessageKind lastMessageKind;
@override@JsonKey() final  int unreadCount;
@override final  String? crewId;
@override final  String? crewName;
@override final  String? eventName;
@override final  int? memberCount;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSummaryCopyWith<_ConversationSummary> get copyWith => __$ConversationSummaryCopyWithImpl<_ConversationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.otherFirstName, otherFirstName) || other.otherFirstName == otherFirstName)&&(identical(other.otherPhotoPath, otherPhotoPath) || other.otherPhotoPath == otherPhotoPath)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageSenderId, lastMessageSenderId) || other.lastMessageSenderId == lastMessageSenderId)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessageKind, lastMessageKind) || other.lastMessageKind == lastMessageKind)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.crewId, crewId) || other.crewId == crewId)&&(identical(other.crewName, crewName) || other.crewName == crewName)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,createdAt,mode,matchId,otherUserId,otherFirstName,otherPhotoPath,lastMessage,lastMessageSenderId,lastMessageAt,lastMessageKind,unreadCount,crewId,crewName,eventName,memberCount);
}

@override
String toString() {
    return 'ConversationSummary(id: $id, type: $type, createdAt: $createdAt, mode: $mode, matchId: $matchId, otherUserId: $otherUserId, otherFirstName: $otherFirstName, otherPhotoPath: $otherPhotoPath, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, lastMessageAt: $lastMessageAt, lastMessageKind: $lastMessageKind, unreadCount: $unreadCount, crewId: $crewId, crewName: $crewName, eventName: $eventName, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$ConversationSummaryCopyWith<$Res> implements $ConversationSummaryCopyWith<$Res> {
  factory _$ConversationSummaryCopyWith(_ConversationSummary value, $Res Function(_ConversationSummary) _then) = __$ConversationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, ConversationType type, DateTime createdAt, AppMode? mode, String? matchId, String? otherUserId, String? otherFirstName, String? otherPhotoPath, String? lastMessage, String? lastMessageSenderId, DateTime? lastMessageAt, MessageKind lastMessageKind, int unreadCount, String? crewId, String? crewName, String? eventName, int? memberCount
});




}
/// @nodoc
class __$ConversationSummaryCopyWithImpl<$Res>
    implements _$ConversationSummaryCopyWith<$Res> {
  __$ConversationSummaryCopyWithImpl(this._self, this._then);

  final _ConversationSummary _self;
  final $Res Function(_ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? createdAt = null,Object? mode = freezed,Object? matchId = freezed,Object? otherUserId = freezed,Object? otherFirstName = freezed,Object? otherPhotoPath = freezed,Object? lastMessage = freezed,Object? lastMessageSenderId = freezed,Object? lastMessageAt = freezed,Object? lastMessageKind = null,Object? unreadCount = null,Object? crewId = freezed,Object? crewName = freezed,Object? eventName = freezed,Object? memberCount = freezed,}) {
  return _then(_ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode?,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherFirstName: freezed == otherFirstName ? _self.otherFirstName : otherFirstName // ignore: cast_nullable_to_non_nullable
as String?,otherPhotoPath: freezed == otherPhotoPath ? _self.otherPhotoPath : otherPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageSenderId: freezed == lastMessageSenderId ? _self.lastMessageSenderId : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessageKind: null == lastMessageKind ? _self.lastMessageKind : lastMessageKind // ignore: cast_nullable_to_non_nullable
as MessageKind,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,crewId: freezed == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String?,crewName: freezed == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String?,eventName: freezed == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String?,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ConversationHeader {

 String get id; ConversationType get type; AppMode? get mode; String? get matchId; String? get otherUserId; String? get otherFirstName; String? get otherPhotoPath; DateTime? get otherLastReadAt; List<CommonEvent> get commonEvents; String? get crewId; String? get crewName; String? get eventName; int? get memberCount;
/// Create a copy of ConversationHeader
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationHeaderCopyWith<ConversationHeader> get copyWith => _$ConversationHeaderCopyWithImpl<ConversationHeader>(this as ConversationHeader, _$identity);

  /// Serializes this ConversationHeader to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationHeader;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationHeader&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.otherUserId, _this.otherUserId) || other.otherUserId == _this.otherUserId)&&(identical(other.otherFirstName, _this.otherFirstName) || other.otherFirstName == _this.otherFirstName)&&(identical(other.otherPhotoPath, _this.otherPhotoPath) || other.otherPhotoPath == _this.otherPhotoPath)&&(identical(other.otherLastReadAt, _this.otherLastReadAt) || other.otherLastReadAt == _this.otherLastReadAt)&&const DeepCollectionEquality().equals(other.commonEvents, _this.commonEvents)&&(identical(other.crewId, _this.crewId) || other.crewId == _this.crewId)&&(identical(other.crewName, _this.crewName) || other.crewName == _this.crewName)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationHeader;
  return Object.hash(runtimeType,_this.id,_this.type,_this.mode,_this.matchId,_this.otherUserId,_this.otherFirstName,_this.otherPhotoPath,_this.otherLastReadAt,const DeepCollectionEquality().hash(_this.commonEvents),_this.crewId,_this.crewName,_this.eventName,_this.memberCount);
}

@override
String toString() {
  final _this = this as ConversationHeader;
  return 'ConversationHeader(id: ${_this.id}, type: ${_this.type}, mode: ${_this.mode}, matchId: ${_this.matchId}, otherUserId: ${_this.otherUserId}, otherFirstName: ${_this.otherFirstName}, otherPhotoPath: ${_this.otherPhotoPath}, otherLastReadAt: ${_this.otherLastReadAt}, commonEvents: ${_this.commonEvents}, crewId: ${_this.crewId}, crewName: ${_this.crewName}, eventName: ${_this.eventName}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $ConversationHeaderCopyWith<$Res>  {
  factory $ConversationHeaderCopyWith(ConversationHeader value, $Res Function(ConversationHeader) _then) = _$ConversationHeaderCopyWithImpl;
@useResult
$Res call({
 String id, ConversationType type, AppMode? mode, String? matchId, String? otherUserId, String? otherFirstName, String? otherPhotoPath, DateTime? otherLastReadAt, List<CommonEvent> commonEvents, String? crewId, String? crewName, String? eventName, int? memberCount
});




}
/// @nodoc
class _$ConversationHeaderCopyWithImpl<$Res>
    implements $ConversationHeaderCopyWith<$Res> {
  _$ConversationHeaderCopyWithImpl(this._self, this._then);

  final ConversationHeader _self;
  final $Res Function(ConversationHeader) _then;

/// Create a copy of ConversationHeader
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? mode = freezed,Object? matchId = freezed,Object? otherUserId = freezed,Object? otherFirstName = freezed,Object? otherPhotoPath = freezed,Object? otherLastReadAt = freezed,Object? commonEvents = null,Object? crewId = freezed,Object? crewName = freezed,Object? eventName = freezed,Object? memberCount = freezed,}) {
  return _then(ConversationHeader(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode?,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherFirstName: freezed == otherFirstName ? _self.otherFirstName : otherFirstName // ignore: cast_nullable_to_non_nullable
as String?,otherPhotoPath: freezed == otherPhotoPath ? _self.otherPhotoPath : otherPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,otherLastReadAt: freezed == otherLastReadAt ? _self.otherLastReadAt : otherLastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,commonEvents: null == commonEvents ? _self.commonEvents : commonEvents // ignore: cast_nullable_to_non_nullable
as List<CommonEvent>,crewId: freezed == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String?,crewName: freezed == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String?,eventName: freezed == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String?,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationHeader].
extension ConversationHeaderPatterns on ConversationHeader {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationHeader value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationHeader() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationHeader value)  $default,){
final _that = this;
switch (_that) {
case _ConversationHeader():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationHeader value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationHeader() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ConversationType type,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  DateTime? otherLastReadAt,  List<CommonEvent> commonEvents,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationHeader() when $default != null:
return $default(_that.id,_that.type,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.otherLastReadAt,_that.commonEvents,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ConversationType type,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  DateTime? otherLastReadAt,  List<CommonEvent> commonEvents,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)  $default,) {final _that = this;
switch (_that) {
case _ConversationHeader():
return $default(_that.id,_that.type,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.otherLastReadAt,_that.commonEvents,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ConversationType type,  AppMode? mode,  String? matchId,  String? otherUserId,  String? otherFirstName,  String? otherPhotoPath,  DateTime? otherLastReadAt,  List<CommonEvent> commonEvents,  String? crewId,  String? crewName,  String? eventName,  int? memberCount)?  $default,) {final _that = this;
switch (_that) {
case _ConversationHeader() when $default != null:
return $default(_that.id,_that.type,_that.mode,_that.matchId,_that.otherUserId,_that.otherFirstName,_that.otherPhotoPath,_that.otherLastReadAt,_that.commonEvents,_that.crewId,_that.crewName,_that.eventName,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationHeader extends ConversationHeader {
  const _ConversationHeader({required this.id, required this.type, this.mode, this.matchId, this.otherUserId, this.otherFirstName, this.otherPhotoPath, this.otherLastReadAt,  List<CommonEvent> commonEvents = const [], this.crewId, this.crewName, this.eventName, this.memberCount}): _commonEvents = commonEvents,super._();
  factory _ConversationHeader.fromJson(Map<String, dynamic> json) => _$ConversationHeaderFromJson(json);

@override final  String id;
@override final  ConversationType type;
@override final  AppMode? mode;
@override final  String? matchId;
@override final  String? otherUserId;
@override final  String? otherFirstName;
@override final  String? otherPhotoPath;
@override final  DateTime? otherLastReadAt;
 final  List<CommonEvent> _commonEvents;
@override@JsonKey() List<CommonEvent> get commonEvents {
  if (_commonEvents is EqualUnmodifiableListView) return _commonEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commonEvents);
}

@override final  String? crewId;
@override final  String? crewName;
@override final  String? eventName;
@override final  int? memberCount;

/// Create a copy of ConversationHeader
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationHeaderCopyWith<_ConversationHeader> get copyWith => __$ConversationHeaderCopyWithImpl<_ConversationHeader>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationHeaderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationHeader&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.otherFirstName, otherFirstName) || other.otherFirstName == otherFirstName)&&(identical(other.otherPhotoPath, otherPhotoPath) || other.otherPhotoPath == otherPhotoPath)&&(identical(other.otherLastReadAt, otherLastReadAt) || other.otherLastReadAt == otherLastReadAt)&&const DeepCollectionEquality().equals(other.commonEvents, _commonEvents)&&(identical(other.crewId, crewId) || other.crewId == crewId)&&(identical(other.crewName, crewName) || other.crewName == crewName)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,mode,matchId,otherUserId,otherFirstName,otherPhotoPath,otherLastReadAt,const DeepCollectionEquality().hash(_commonEvents),crewId,crewName,eventName,memberCount);
}

@override
String toString() {
    return 'ConversationHeader(id: $id, type: $type, mode: $mode, matchId: $matchId, otherUserId: $otherUserId, otherFirstName: $otherFirstName, otherPhotoPath: $otherPhotoPath, otherLastReadAt: $otherLastReadAt, commonEvents: $commonEvents, crewId: $crewId, crewName: $crewName, eventName: $eventName, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$ConversationHeaderCopyWith<$Res> implements $ConversationHeaderCopyWith<$Res> {
  factory _$ConversationHeaderCopyWith(_ConversationHeader value, $Res Function(_ConversationHeader) _then) = __$ConversationHeaderCopyWithImpl;
@override @useResult
$Res call({
 String id, ConversationType type, AppMode? mode, String? matchId, String? otherUserId, String? otherFirstName, String? otherPhotoPath, DateTime? otherLastReadAt, List<CommonEvent> commonEvents, String? crewId, String? crewName, String? eventName, int? memberCount
});




}
/// @nodoc
class __$ConversationHeaderCopyWithImpl<$Res>
    implements _$ConversationHeaderCopyWith<$Res> {
  __$ConversationHeaderCopyWithImpl(this._self, this._then);

  final _ConversationHeader _self;
  final $Res Function(_ConversationHeader) _then;

/// Create a copy of ConversationHeader
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? mode = freezed,Object? matchId = freezed,Object? otherUserId = freezed,Object? otherFirstName = freezed,Object? otherPhotoPath = freezed,Object? otherLastReadAt = freezed,Object? commonEvents = null,Object? crewId = freezed,Object? crewName = freezed,Object? eventName = freezed,Object? memberCount = freezed,}) {
  return _then(_ConversationHeader(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ConversationType,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode?,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherFirstName: freezed == otherFirstName ? _self.otherFirstName : otherFirstName // ignore: cast_nullable_to_non_nullable
as String?,otherPhotoPath: freezed == otherPhotoPath ? _self.otherPhotoPath : otherPhotoPath // ignore: cast_nullable_to_non_nullable
as String?,otherLastReadAt: freezed == otherLastReadAt ? _self.otherLastReadAt : otherLastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,commonEvents: null == commonEvents ? _self._commonEvents : commonEvents // ignore: cast_nullable_to_non_nullable
as List<CommonEvent>,crewId: freezed == crewId ? _self.crewId : crewId // ignore: cast_nullable_to_non_nullable
as String?,crewName: freezed == crewName ? _self.crewName : crewName // ignore: cast_nullable_to_non_nullable
as String?,eventName: freezed == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String?,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get conversationId; String get senderId; String get content; DateTime get createdAt; DateTime? get deletedAt; MessageKind get kind;/// `chat-media` path of a photo or voice message.
 String? get mediaPath; int? get mediaDurationMs;/// Crew poll shown by this message (kind poll).
 String? get pollId;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.senderId, _this.senderId) || other.senderId == _this.senderId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.mediaPath, _this.mediaPath) || other.mediaPath == _this.mediaPath)&&(identical(other.mediaDurationMs, _this.mediaDurationMs) || other.mediaDurationMs == _this.mediaDurationMs)&&(identical(other.pollId, _this.pollId) || other.pollId == _this.pollId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.id,_this.conversationId,_this.senderId,_this.content,_this.createdAt,_this.deletedAt,_this.kind,_this.mediaPath,_this.mediaDurationMs,_this.pollId);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(id: ${_this.id}, conversationId: ${_this.conversationId}, senderId: ${_this.senderId}, content: ${_this.content}, createdAt: ${_this.createdAt}, deletedAt: ${_this.deletedAt}, kind: ${_this.kind}, mediaPath: ${_this.mediaPath}, mediaDurationMs: ${_this.mediaDurationMs}, pollId: ${_this.pollId})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String conversationId, String senderId, String content, DateTime createdAt, DateTime? deletedAt, MessageKind kind, String? mediaPath, int? mediaDurationMs, String? pollId
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? content = null,Object? createdAt = null,Object? deletedAt = freezed,Object? kind = null,Object? mediaPath = freezed,Object? mediaDurationMs = freezed,Object? pollId = freezed,}) {
  return _then(ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,mediaPath: freezed == mediaPath ? _self.mediaPath : mediaPath // ignore: cast_nullable_to_non_nullable
as String?,mediaDurationMs: freezed == mediaDurationMs ? _self.mediaDurationMs : mediaDurationMs // ignore: cast_nullable_to_non_nullable
as int?,pollId: freezed == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String content,  DateTime createdAt,  DateTime? deletedAt,  MessageKind kind,  String? mediaPath,  int? mediaDurationMs,  String? pollId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.createdAt,_that.deletedAt,_that.kind,_that.mediaPath,_that.mediaDurationMs,_that.pollId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String conversationId,  String senderId,  String content,  DateTime createdAt,  DateTime? deletedAt,  MessageKind kind,  String? mediaPath,  int? mediaDurationMs,  String? pollId)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.createdAt,_that.deletedAt,_that.kind,_that.mediaPath,_that.mediaDurationMs,_that.pollId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String conversationId,  String senderId,  String content,  DateTime createdAt,  DateTime? deletedAt,  MessageKind kind,  String? mediaPath,  int? mediaDurationMs,  String? pollId)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderId,_that.content,_that.createdAt,_that.deletedAt,_that.kind,_that.mediaPath,_that.mediaDurationMs,_that.pollId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.conversationId, required this.senderId, required this.content, required this.createdAt, this.deletedAt, this.kind = MessageKind.text, this.mediaPath, this.mediaDurationMs, this.pollId});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String conversationId;
@override final  String senderId;
@override final  String content;
@override final  DateTime createdAt;
@override final  DateTime? deletedAt;
@override@JsonKey() final  MessageKind kind;
/// `chat-media` path of a photo or voice message.
@override final  String? mediaPath;
@override final  int? mediaDurationMs;
/// Crew poll shown by this message (kind poll).
@override final  String? pollId;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mediaPath, mediaPath) || other.mediaPath == mediaPath)&&(identical(other.mediaDurationMs, mediaDurationMs) || other.mediaDurationMs == mediaDurationMs)&&(identical(other.pollId, pollId) || other.pollId == pollId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,conversationId,senderId,content,createdAt,deletedAt,kind,mediaPath,mediaDurationMs,pollId);
}

@override
String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, createdAt: $createdAt, deletedAt: $deletedAt, kind: $kind, mediaPath: $mediaPath, mediaDurationMs: $mediaDurationMs, pollId: $pollId)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String conversationId, String senderId, String content, DateTime createdAt, DateTime? deletedAt, MessageKind kind, String? mediaPath, int? mediaDurationMs, String? pollId
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderId = null,Object? content = null,Object? createdAt = null,Object? deletedAt = freezed,Object? kind = null,Object? mediaPath = freezed,Object? mediaDurationMs = freezed,Object? pollId = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,mediaPath: freezed == mediaPath ? _self.mediaPath : mediaPath // ignore: cast_nullable_to_non_nullable
as String?,mediaDurationMs: freezed == mediaDurationMs ? _self.mediaDurationMs : mediaDurationMs // ignore: cast_nullable_to_non_nullable
as int?,pollId: freezed == pollId ? _self.pollId : pollId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ConversationMember {

 String get userId; String? get firstName; String? get photoPath;
/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationMemberCopyWith<ConversationMember> get copyWith => _$ConversationMemberCopyWithImpl<ConversationMember>(this as ConversationMember, _$identity);

  /// Serializes this ConversationMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationMember&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationMember;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.photoPath);
}

@override
String toString() {
  final _this = this as ConversationMember;
  return 'ConversationMember(userId: ${_this.userId}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $ConversationMemberCopyWith<$Res>  {
  factory $ConversationMemberCopyWith(ConversationMember value, $Res Function(ConversationMember) _then) = _$ConversationMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String? firstName, String? photoPath
});




}
/// @nodoc
class _$ConversationMemberCopyWithImpl<$Res>
    implements $ConversationMemberCopyWith<$Res> {
  _$ConversationMemberCopyWithImpl(this._self, this._then);

  final ConversationMember _self;
  final $Res Function(ConversationMember) _then;

/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(ConversationMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationMember].
extension ConversationMemberPatterns on ConversationMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationMember value)  $default,){
final _that = this;
switch (_that) {
case _ConversationMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationMember value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationMember() when $default != null:
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
case _ConversationMember() when $default != null:
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
case _ConversationMember():
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
case _ConversationMember() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationMember implements ConversationMember {
  const _ConversationMember({required this.userId, this.firstName, this.photoPath});
  factory _ConversationMember.fromJson(Map<String, dynamic> json) => _$ConversationMemberFromJson(json);

@override final  String userId;
@override final  String? firstName;
@override final  String? photoPath;

/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationMemberCopyWith<_ConversationMember> get copyWith => __$ConversationMemberCopyWithImpl<_ConversationMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,photoPath);
}

@override
String toString() {
    return 'ConversationMember(userId: $userId, firstName: $firstName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$ConversationMemberCopyWith<$Res> implements $ConversationMemberCopyWith<$Res> {
  factory _$ConversationMemberCopyWith(_ConversationMember value, $Res Function(_ConversationMember) _then) = __$ConversationMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? firstName, String? photoPath
});




}
/// @nodoc
class __$ConversationMemberCopyWithImpl<$Res>
    implements _$ConversationMemberCopyWith<$Res> {
  __$ConversationMemberCopyWithImpl(this._self, this._then);

  final _ConversationMember _self;
  final $Res Function(_ConversationMember) _then;

/// Create a copy of ConversationMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,}) {
  return _then(_ConversationMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PendingMessage {

 String get localId; String get content; DateTime get createdAt; bool get failed; MessageKind get kind;/// The photo or recording being sent (shown while uploading).
 Uint8List? get bytes; int? get durationMs;/// Set once uploaded, so a retry only sends the message.
 String? get mediaPath;
/// Create a copy of PendingMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingMessageCopyWith<PendingMessage> get copyWith => _$PendingMessageCopyWithImpl<PendingMessage>(this as PendingMessage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PendingMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingMessage&&(identical(other.localId, _this.localId) || other.localId == _this.localId)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&const DeepCollectionEquality().equals(other.bytes, _this.bytes)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.mediaPath, _this.mediaPath) || other.mediaPath == _this.mediaPath));
}


@override
int get hashCode {
  final _this = this as PendingMessage;
  return Object.hash(runtimeType,_this.localId,_this.content,_this.createdAt,_this.failed,_this.kind,const DeepCollectionEquality().hash(_this.bytes),_this.durationMs,_this.mediaPath);
}

@override
String toString() {
  final _this = this as PendingMessage;
  return 'PendingMessage(localId: ${_this.localId}, content: ${_this.content}, createdAt: ${_this.createdAt}, failed: ${_this.failed}, kind: ${_this.kind}, bytes: ${_this.bytes}, durationMs: ${_this.durationMs}, mediaPath: ${_this.mediaPath})';
}


}

/// @nodoc
abstract mixin class $PendingMessageCopyWith<$Res>  {
  factory $PendingMessageCopyWith(PendingMessage value, $Res Function(PendingMessage) _then) = _$PendingMessageCopyWithImpl;
@useResult
$Res call({
 String localId, String content, DateTime createdAt, bool failed, MessageKind kind, Uint8List? bytes, int? durationMs, String? mediaPath
});




}
/// @nodoc
class _$PendingMessageCopyWithImpl<$Res>
    implements $PendingMessageCopyWith<$Res> {
  _$PendingMessageCopyWithImpl(this._self, this._then);

  final PendingMessage _self;
  final $Res Function(PendingMessage) _then;

/// Create a copy of PendingMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localId = null,Object? content = null,Object? createdAt = null,Object? failed = null,Object? kind = null,Object? bytes = freezed,Object? durationMs = freezed,Object? mediaPath = freezed,}) {
  return _then(PendingMessage(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,mediaPath: freezed == mediaPath ? _self.mediaPath : mediaPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingMessage].
extension PendingMessagePatterns on PendingMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingMessage value)  $default,){
final _that = this;
switch (_that) {
case _PendingMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingMessage value)?  $default,){
final _that = this;
switch (_that) {
case _PendingMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String localId,  String content,  DateTime createdAt,  bool failed,  MessageKind kind,  Uint8List? bytes,  int? durationMs,  String? mediaPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingMessage() when $default != null:
return $default(_that.localId,_that.content,_that.createdAt,_that.failed,_that.kind,_that.bytes,_that.durationMs,_that.mediaPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String localId,  String content,  DateTime createdAt,  bool failed,  MessageKind kind,  Uint8List? bytes,  int? durationMs,  String? mediaPath)  $default,) {final _that = this;
switch (_that) {
case _PendingMessage():
return $default(_that.localId,_that.content,_that.createdAt,_that.failed,_that.kind,_that.bytes,_that.durationMs,_that.mediaPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String localId,  String content,  DateTime createdAt,  bool failed,  MessageKind kind,  Uint8List? bytes,  int? durationMs,  String? mediaPath)?  $default,) {final _that = this;
switch (_that) {
case _PendingMessage() when $default != null:
return $default(_that.localId,_that.content,_that.createdAt,_that.failed,_that.kind,_that.bytes,_that.durationMs,_that.mediaPath);case _:
  return null;

}
}

}

/// @nodoc


class _PendingMessage implements PendingMessage {
  const _PendingMessage({required this.localId, required this.content, required this.createdAt, this.failed = false, this.kind = MessageKind.text, this.bytes, this.durationMs, this.mediaPath});
  

@override final  String localId;
@override final  String content;
@override final  DateTime createdAt;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  MessageKind kind;
/// The photo or recording being sent (shown while uploading).
@override final  Uint8List? bytes;
@override final  int? durationMs;
/// Set once uploaded, so a retry only sends the message.
@override final  String? mediaPath;

/// Create a copy of PendingMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingMessageCopyWith<_PendingMessage> get copyWith => __$PendingMessageCopyWithImpl<_PendingMessage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingMessage&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.kind, kind) || other.kind == kind)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.mediaPath, mediaPath) || other.mediaPath == mediaPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,localId,content,createdAt,failed,kind,const DeepCollectionEquality().hash(bytes),durationMs,mediaPath);
}

@override
String toString() {
    return 'PendingMessage(localId: $localId, content: $content, createdAt: $createdAt, failed: $failed, kind: $kind, bytes: $bytes, durationMs: $durationMs, mediaPath: $mediaPath)';
}


}

/// @nodoc
abstract mixin class _$PendingMessageCopyWith<$Res> implements $PendingMessageCopyWith<$Res> {
  factory _$PendingMessageCopyWith(_PendingMessage value, $Res Function(_PendingMessage) _then) = __$PendingMessageCopyWithImpl;
@override @useResult
$Res call({
 String localId, String content, DateTime createdAt, bool failed, MessageKind kind, Uint8List? bytes, int? durationMs, String? mediaPath
});




}
/// @nodoc
class __$PendingMessageCopyWithImpl<$Res>
    implements _$PendingMessageCopyWith<$Res> {
  __$PendingMessageCopyWithImpl(this._self, this._then);

  final _PendingMessage _self;
  final $Res Function(_PendingMessage) _then;

/// Create a copy of PendingMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localId = null,Object? content = null,Object? createdAt = null,Object? failed = null,Object? kind = null,Object? bytes = freezed,Object? durationMs = freezed,Object? mediaPath = freezed,}) {
  return _then(_PendingMessage(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MessageKind,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,mediaPath: freezed == mediaPath ? _self.mediaPath : mediaPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ConversationState {

/// Newest first (the list is reversed on screen).
 List<ChatMessage> get messages; bool get hasMore; bool get loadingMore; bool get otherTyping;/// Who is typing (group chats show the name).
 String? get typingUserId; DateTime? get otherLastReadAt; List<PendingMessage> get pending;
/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationStateCopyWith<ConversationState> get copyWith => _$ConversationStateCopyWithImpl<ConversationState>(this as ConversationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ConversationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationState&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore)&&(identical(other.otherTyping, _this.otherTyping) || other.otherTyping == _this.otherTyping)&&(identical(other.typingUserId, _this.typingUserId) || other.typingUserId == _this.typingUserId)&&(identical(other.otherLastReadAt, _this.otherLastReadAt) || other.otherLastReadAt == _this.otherLastReadAt)&&const DeepCollectionEquality().equals(other.pending, _this.pending));
}


@override
int get hashCode {
  final _this = this as ConversationState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.messages),_this.hasMore,_this.loadingMore,_this.otherTyping,_this.typingUserId,_this.otherLastReadAt,const DeepCollectionEquality().hash(_this.pending));
}

@override
String toString() {
  final _this = this as ConversationState;
  return 'ConversationState(messages: ${_this.messages}, hasMore: ${_this.hasMore}, loadingMore: ${_this.loadingMore}, otherTyping: ${_this.otherTyping}, typingUserId: ${_this.typingUserId}, otherLastReadAt: ${_this.otherLastReadAt}, pending: ${_this.pending})';
}


}

/// @nodoc
abstract mixin class $ConversationStateCopyWith<$Res>  {
  factory $ConversationStateCopyWith(ConversationState value, $Res Function(ConversationState) _then) = _$ConversationStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, bool hasMore, bool loadingMore, bool otherTyping, String? typingUserId, DateTime? otherLastReadAt, List<PendingMessage> pending
});




}
/// @nodoc
class _$ConversationStateCopyWithImpl<$Res>
    implements $ConversationStateCopyWith<$Res> {
  _$ConversationStateCopyWithImpl(this._self, this._then);

  final ConversationState _self;
  final $Res Function(ConversationState) _then;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? hasMore = null,Object? loadingMore = null,Object? otherTyping = null,Object? typingUserId = freezed,Object? otherLastReadAt = freezed,Object? pending = null,}) {
  return _then(ConversationState(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,otherTyping: null == otherTyping ? _self.otherTyping : otherTyping // ignore: cast_nullable_to_non_nullable
as bool,typingUserId: freezed == typingUserId ? _self.typingUserId : typingUserId // ignore: cast_nullable_to_non_nullable
as String?,otherLastReadAt: freezed == otherLastReadAt ? _self.otherLastReadAt : otherLastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as List<PendingMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationState].
extension ConversationStatePatterns on ConversationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationState value)  $default,){
final _that = this;
switch (_that) {
case _ConversationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationState value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool hasMore,  bool loadingMore,  bool otherTyping,  String? typingUserId,  DateTime? otherLastReadAt,  List<PendingMessage> pending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationState() when $default != null:
return $default(_that.messages,_that.hasMore,_that.loadingMore,_that.otherTyping,_that.typingUserId,_that.otherLastReadAt,_that.pending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool hasMore,  bool loadingMore,  bool otherTyping,  String? typingUserId,  DateTime? otherLastReadAt,  List<PendingMessage> pending)  $default,) {final _that = this;
switch (_that) {
case _ConversationState():
return $default(_that.messages,_that.hasMore,_that.loadingMore,_that.otherTyping,_that.typingUserId,_that.otherLastReadAt,_that.pending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> messages,  bool hasMore,  bool loadingMore,  bool otherTyping,  String? typingUserId,  DateTime? otherLastReadAt,  List<PendingMessage> pending)?  $default,) {final _that = this;
switch (_that) {
case _ConversationState() when $default != null:
return $default(_that.messages,_that.hasMore,_that.loadingMore,_that.otherTyping,_that.typingUserId,_that.otherLastReadAt,_that.pending);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationState implements ConversationState {
  const _ConversationState({required  List<ChatMessage> messages, this.hasMore = true, this.loadingMore = false, this.otherTyping = false, this.typingUserId, this.otherLastReadAt,  List<PendingMessage> pending = const []}): _messages = messages,_pending = pending;
  

/// Newest first (the list is reversed on screen).
 final  List<ChatMessage> _messages;
/// Newest first (the list is reversed on screen).
@override List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;
@override@JsonKey() final  bool otherTyping;
/// Who is typing (group chats show the name).
@override final  String? typingUserId;
@override final  DateTime? otherLastReadAt;
 final  List<PendingMessage> _pending;
@override@JsonKey() List<PendingMessage> get pending {
  if (_pending is EqualUnmodifiableListView) return _pending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pending);
}


/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationStateCopyWith<_ConversationState> get copyWith => __$ConversationStateCopyWithImpl<_ConversationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationState&&const DeepCollectionEquality().equals(other.messages, _messages)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.otherTyping, otherTyping) || other.otherTyping == otherTyping)&&(identical(other.typingUserId, typingUserId) || other.typingUserId == typingUserId)&&(identical(other.otherLastReadAt, otherLastReadAt) || other.otherLastReadAt == otherLastReadAt)&&const DeepCollectionEquality().equals(other.pending, _pending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),hasMore,loadingMore,otherTyping,typingUserId,otherLastReadAt,const DeepCollectionEquality().hash(_pending));
}

@override
String toString() {
    return 'ConversationState(messages: $messages, hasMore: $hasMore, loadingMore: $loadingMore, otherTyping: $otherTyping, typingUserId: $typingUserId, otherLastReadAt: $otherLastReadAt, pending: $pending)';
}


}

/// @nodoc
abstract mixin class _$ConversationStateCopyWith<$Res> implements $ConversationStateCopyWith<$Res> {
  factory _$ConversationStateCopyWith(_ConversationState value, $Res Function(_ConversationState) _then) = __$ConversationStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, bool hasMore, bool loadingMore, bool otherTyping, String? typingUserId, DateTime? otherLastReadAt, List<PendingMessage> pending
});




}
/// @nodoc
class __$ConversationStateCopyWithImpl<$Res>
    implements _$ConversationStateCopyWith<$Res> {
  __$ConversationStateCopyWithImpl(this._self, this._then);

  final _ConversationState _self;
  final $Res Function(_ConversationState) _then;

/// Create a copy of ConversationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? hasMore = null,Object? loadingMore = null,Object? otherTyping = null,Object? typingUserId = freezed,Object? otherLastReadAt = freezed,Object? pending = null,}) {
  return _then(_ConversationState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,otherTyping: null == otherTyping ? _self.otherTyping : otherTyping // ignore: cast_nullable_to_non_nullable
as bool,typingUserId: freezed == typingUserId ? _self.typingUserId : typingUserId // ignore: cast_nullable_to_non_nullable
as String?,otherLastReadAt: freezed == otherLastReadAt ? _self.otherLastReadAt : otherLastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pending: null == pending ? _self._pending : pending // ignore: cast_nullable_to_non_nullable
as List<PendingMessage>,
  ));
}


}

// dart format on
