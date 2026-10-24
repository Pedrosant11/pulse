// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventSummary {

 String get id; String get name; String get venueName; String get city; String get state; DateTime get startsAt; DateTime get endsAt; String? get coverPath; List<MusicGenre> get genres; bool get isOfficial;
/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventSummaryCopyWith<EventSummary> get copyWith => _$EventSummaryCopyWithImpl<EventSummary>(this as EventSummary, _$identity);

  /// Serializes this EventSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.isOfficial, _this.isOfficial) || other.isOfficial == _this.isOfficial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.venueName,_this.city,_this.state,_this.startsAt,_this.endsAt,_this.coverPath,const DeepCollectionEquality().hash(_this.genres),_this.isOfficial);
}

@override
String toString() {
  final _this = this as EventSummary;
  return 'EventSummary(id: ${_this.id}, name: ${_this.name}, venueName: ${_this.venueName}, city: ${_this.city}, state: ${_this.state}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, coverPath: ${_this.coverPath}, genres: ${_this.genres}, isOfficial: ${_this.isOfficial})';
}


}

/// @nodoc
abstract mixin class $EventSummaryCopyWith<$Res>  {
  factory $EventSummaryCopyWith(EventSummary value, $Res Function(EventSummary) _then) = _$EventSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, String? coverPath, List<MusicGenre> genres, bool isOfficial
});




}
/// @nodoc
class _$EventSummaryCopyWithImpl<$Res>
    implements $EventSummaryCopyWith<$Res> {
  _$EventSummaryCopyWithImpl(this._self, this._then);

  final EventSummary _self;
  final $Res Function(EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,}) {
  return _then(EventSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventSummary].
extension EventSummaryPatterns on EventSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventSummary value)  $default,){
final _that = this;
switch (_that) {
case _EventSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventSummary value)?  $default,){
final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial)  $default,) {final _that = this;
switch (_that) {
case _EventSummary():
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial)?  $default,) {final _that = this;
switch (_that) {
case _EventSummary() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventSummary implements EventSummary {
  const _EventSummary({required this.id, required this.name, required this.venueName, required this.city, required this.state, required this.startsAt, required this.endsAt, this.coverPath,  List<MusicGenre> genres = const [], this.isOfficial = false}): _genres = genres;
  factory _EventSummary.fromJson(Map<String, dynamic> json) => _$EventSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String venueName;
@override final  String city;
@override final  String state;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  String? coverPath;
 final  List<MusicGenre> _genres;
@override@JsonKey() List<MusicGenre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey() final  bool isOfficial;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventSummaryCopyWith<_EventSummary> get copyWith => __$EventSummaryCopyWithImpl<_EventSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,venueName,city,state,startsAt,endsAt,coverPath,const DeepCollectionEquality().hash(_genres),isOfficial);
}

@override
String toString() {
    return 'EventSummary(id: $id, name: $name, venueName: $venueName, city: $city, state: $state, startsAt: $startsAt, endsAt: $endsAt, coverPath: $coverPath, genres: $genres, isOfficial: $isOfficial)';
}


}

/// @nodoc
abstract mixin class _$EventSummaryCopyWith<$Res> implements $EventSummaryCopyWith<$Res> {
  factory _$EventSummaryCopyWith(_EventSummary value, $Res Function(_EventSummary) _then) = __$EventSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, String? coverPath, List<MusicGenre> genres, bool isOfficial
});




}
/// @nodoc
class __$EventSummaryCopyWithImpl<$Res>
    implements _$EventSummaryCopyWith<$Res> {
  __$EventSummaryCopyWithImpl(this._self, this._then);

  final _EventSummary _self;
  final $Res Function(_EventSummary) _then;

/// Create a copy of EventSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,}) {
  return _then(_EventSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EventListEntry {

 String get id; String get name; String get venueName; String get city; String get state; DateTime get startsAt; DateTime get endsAt; EventStatus get status; String? get coverPath; List<MusicGenre> get genres; bool get isOfficial; bool get isMine; bool get isGoing;/// Saved for later ("Salvar").
 bool get isSaved; int get goingCount; double? get distanceKm;/// Where to draw it on the map (SPEC 7.4): the venue when [pinExact],
/// otherwise an approximate area (secret location or no venue yet).
 double? get pinLat; double? get pinLng; bool get pinExact;/// Secret location: when the venue is revealed.
 DateTime? get locationRevealAt;/// Featured by an admin (paid by the producer): first in the list.
 bool get isFeatured;
/// Create a copy of EventListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventListEntryCopyWith<EventListEntry> get copyWith => _$EventListEntryCopyWithImpl<EventListEntry>(this as EventListEntry, _$identity);

  /// Serializes this EventListEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventListEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventListEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.isOfficial, _this.isOfficial) || other.isOfficial == _this.isOfficial)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.isGoing, _this.isGoing) || other.isGoing == _this.isGoing)&&(identical(other.isSaved, _this.isSaved) || other.isSaved == _this.isSaved)&&(identical(other.goingCount, _this.goingCount) || other.goingCount == _this.goingCount)&&(identical(other.distanceKm, _this.distanceKm) || other.distanceKm == _this.distanceKm)&&(identical(other.pinLat, _this.pinLat) || other.pinLat == _this.pinLat)&&(identical(other.pinLng, _this.pinLng) || other.pinLng == _this.pinLng)&&(identical(other.pinExact, _this.pinExact) || other.pinExact == _this.pinExact)&&(identical(other.locationRevealAt, _this.locationRevealAt) || other.locationRevealAt == _this.locationRevealAt)&&(identical(other.isFeatured, _this.isFeatured) || other.isFeatured == _this.isFeatured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventListEntry;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.venueName,_this.city,_this.state,_this.startsAt,_this.endsAt,_this.status,_this.coverPath,const DeepCollectionEquality().hash(_this.genres),_this.isOfficial,_this.isMine,_this.isGoing,_this.isSaved,_this.goingCount,_this.distanceKm,_this.pinLat,_this.pinLng,_this.pinExact,_this.locationRevealAt,_this.isFeatured]);
}

@override
String toString() {
  final _this = this as EventListEntry;
  return 'EventListEntry(id: ${_this.id}, name: ${_this.name}, venueName: ${_this.venueName}, city: ${_this.city}, state: ${_this.state}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, status: ${_this.status}, coverPath: ${_this.coverPath}, genres: ${_this.genres}, isOfficial: ${_this.isOfficial}, isMine: ${_this.isMine}, isGoing: ${_this.isGoing}, isSaved: ${_this.isSaved}, goingCount: ${_this.goingCount}, distanceKm: ${_this.distanceKm}, pinLat: ${_this.pinLat}, pinLng: ${_this.pinLng}, pinExact: ${_this.pinExact}, locationRevealAt: ${_this.locationRevealAt}, isFeatured: ${_this.isFeatured})';
}


}

/// @nodoc
abstract mixin class $EventListEntryCopyWith<$Res>  {
  factory $EventListEntryCopyWith(EventListEntry value, $Res Function(EventListEntry) _then) = _$EventListEntryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, EventStatus status, String? coverPath, List<MusicGenre> genres, bool isOfficial, bool isMine, bool isGoing, bool isSaved, int goingCount, double? distanceKm, double? pinLat, double? pinLng, bool pinExact, DateTime? locationRevealAt, bool isFeatured
});




}
/// @nodoc
class _$EventListEntryCopyWithImpl<$Res>
    implements $EventListEntryCopyWith<$Res> {
  _$EventListEntryCopyWithImpl(this._self, this._then);

  final EventListEntry _self;
  final $Res Function(EventListEntry) _then;

/// Create a copy of EventListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,Object? isMine = null,Object? isGoing = null,Object? isSaved = null,Object? goingCount = null,Object? distanceKm = freezed,Object? pinLat = freezed,Object? pinLng = freezed,Object? pinExact = null,Object? locationRevealAt = freezed,Object? isFeatured = null,}) {
  return _then(EventListEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,pinLat: freezed == pinLat ? _self.pinLat : pinLat // ignore: cast_nullable_to_non_nullable
as double?,pinLng: freezed == pinLng ? _self.pinLng : pinLng // ignore: cast_nullable_to_non_nullable
as double?,pinExact: null == pinExact ? _self.pinExact : pinExact // ignore: cast_nullable_to_non_nullable
as bool,locationRevealAt: freezed == locationRevealAt ? _self.locationRevealAt : locationRevealAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventListEntry].
extension EventListEntryPatterns on EventListEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventListEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventListEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventListEntry value)  $default,){
final _that = this;
switch (_that) {
case _EventListEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventListEntry value)?  $default,){
final _that = this;
switch (_that) {
case _EventListEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  bool isMine,  bool isGoing,  bool isSaved,  int goingCount,  double? distanceKm,  double? pinLat,  double? pinLng,  bool pinExact,  DateTime? locationRevealAt,  bool isFeatured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventListEntry() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.coverPath,_that.genres,_that.isOfficial,_that.isMine,_that.isGoing,_that.isSaved,_that.goingCount,_that.distanceKm,_that.pinLat,_that.pinLng,_that.pinExact,_that.locationRevealAt,_that.isFeatured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  bool isMine,  bool isGoing,  bool isSaved,  int goingCount,  double? distanceKm,  double? pinLat,  double? pinLng,  bool pinExact,  DateTime? locationRevealAt,  bool isFeatured)  $default,) {final _that = this;
switch (_that) {
case _EventListEntry():
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.coverPath,_that.genres,_that.isOfficial,_that.isMine,_that.isGoing,_that.isSaved,_that.goingCount,_that.distanceKm,_that.pinLat,_that.pinLng,_that.pinExact,_that.locationRevealAt,_that.isFeatured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  bool isMine,  bool isGoing,  bool isSaved,  int goingCount,  double? distanceKm,  double? pinLat,  double? pinLng,  bool pinExact,  DateTime? locationRevealAt,  bool isFeatured)?  $default,) {final _that = this;
switch (_that) {
case _EventListEntry() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.coverPath,_that.genres,_that.isOfficial,_that.isMine,_that.isGoing,_that.isSaved,_that.goingCount,_that.distanceKm,_that.pinLat,_that.pinLng,_that.pinExact,_that.locationRevealAt,_that.isFeatured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventListEntry implements EventListEntry {
  const _EventListEntry({required this.id, required this.name, required this.venueName, required this.city, required this.state, required this.startsAt, required this.endsAt, required this.status, this.coverPath,  List<MusicGenre> genres = const [], this.isOfficial = false, this.isMine = false, this.isGoing = false, this.isSaved = false, this.goingCount = 0, this.distanceKm, this.pinLat, this.pinLng, this.pinExact = false, this.locationRevealAt, this.isFeatured = false}): _genres = genres;
  factory _EventListEntry.fromJson(Map<String, dynamic> json) => _$EventListEntryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String venueName;
@override final  String city;
@override final  String state;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  EventStatus status;
@override final  String? coverPath;
 final  List<MusicGenre> _genres;
@override@JsonKey() List<MusicGenre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey() final  bool isOfficial;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  bool isGoing;
/// Saved for later ("Salvar").
@override@JsonKey() final  bool isSaved;
@override@JsonKey() final  int goingCount;
@override final  double? distanceKm;
/// Where to draw it on the map (SPEC 7.4): the venue when [pinExact],
/// otherwise an approximate area (secret location or no venue yet).
@override final  double? pinLat;
@override final  double? pinLng;
@override@JsonKey() final  bool pinExact;
/// Secret location: when the venue is revealed.
@override final  DateTime? locationRevealAt;
/// Featured by an admin (paid by the producer): first in the list.
@override@JsonKey() final  bool isFeatured;

/// Create a copy of EventListEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventListEntryCopyWith<_EventListEntry> get copyWith => __$EventListEntryCopyWithImpl<_EventListEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventListEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventListEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.isGoing, isGoing) || other.isGoing == isGoing)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.goingCount, goingCount) || other.goingCount == goingCount)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.pinLat, pinLat) || other.pinLat == pinLat)&&(identical(other.pinLng, pinLng) || other.pinLng == pinLng)&&(identical(other.pinExact, pinExact) || other.pinExact == pinExact)&&(identical(other.locationRevealAt, locationRevealAt) || other.locationRevealAt == locationRevealAt)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,venueName,city,state,startsAt,endsAt,status,coverPath,const DeepCollectionEquality().hash(_genres),isOfficial,isMine,isGoing,isSaved,goingCount,distanceKm,pinLat,pinLng,pinExact,locationRevealAt,isFeatured]);
}

@override
String toString() {
    return 'EventListEntry(id: $id, name: $name, venueName: $venueName, city: $city, state: $state, startsAt: $startsAt, endsAt: $endsAt, status: $status, coverPath: $coverPath, genres: $genres, isOfficial: $isOfficial, isMine: $isMine, isGoing: $isGoing, isSaved: $isSaved, goingCount: $goingCount, distanceKm: $distanceKm, pinLat: $pinLat, pinLng: $pinLng, pinExact: $pinExact, locationRevealAt: $locationRevealAt, isFeatured: $isFeatured)';
}


}

/// @nodoc
abstract mixin class _$EventListEntryCopyWith<$Res> implements $EventListEntryCopyWith<$Res> {
  factory _$EventListEntryCopyWith(_EventListEntry value, $Res Function(_EventListEntry) _then) = __$EventListEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, EventStatus status, String? coverPath, List<MusicGenre> genres, bool isOfficial, bool isMine, bool isGoing, bool isSaved, int goingCount, double? distanceKm, double? pinLat, double? pinLng, bool pinExact, DateTime? locationRevealAt, bool isFeatured
});




}
/// @nodoc
class __$EventListEntryCopyWithImpl<$Res>
    implements _$EventListEntryCopyWith<$Res> {
  __$EventListEntryCopyWithImpl(this._self, this._then);

  final _EventListEntry _self;
  final $Res Function(_EventListEntry) _then;

/// Create a copy of EventListEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,Object? isMine = null,Object? isGoing = null,Object? isSaved = null,Object? goingCount = null,Object? distanceKm = freezed,Object? pinLat = freezed,Object? pinLng = freezed,Object? pinExact = null,Object? locationRevealAt = freezed,Object? isFeatured = null,}) {
  return _then(_EventListEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,pinLat: freezed == pinLat ? _self.pinLat : pinLat // ignore: cast_nullable_to_non_nullable
as double?,pinLng: freezed == pinLng ? _self.pinLng : pinLng // ignore: cast_nullable_to_non_nullable
as double?,pinExact: null == pinExact ? _self.pinExact : pinExact // ignore: cast_nullable_to_non_nullable
as bool,locationRevealAt: freezed == locationRevealAt ? _self.locationRevealAt : locationRevealAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EventDetail {

 String get id; String get name; String get venueName; String get city; String get state; DateTime get startsAt; DateTime get endsAt; EventStatus get status; String? get description; String? get coverPath;/// City centroid (radius filter). The venue is in [EventVenue].
 double? get lat; double? get lng;/// Secret location: venue revealed this many hours before the start.
 int? get locationRevealHours; List<MusicGenre> get genres; List<String> get lineup; String? get ticketUrl;/// Affiliate/promoter code shown next to the ticket link.
 String? get ticketCoupon; int get minAge; bool get isOfficial; String? get createdBy; String? get rejectionReason;/// Featured until this moment (admins set it).
 DateTime? get featuredUntil;/// Its casa (venues migration), when linked.
 String? get venueId;
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailCopyWith<EventDetail> get copyWith => _$EventDetailCopyWithImpl<EventDetail>(this as EventDetail, _$identity);

  /// Serializes this EventDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.locationRevealHours, _this.locationRevealHours) || other.locationRevealHours == _this.locationRevealHours)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&const DeepCollectionEquality().equals(other.lineup, _this.lineup)&&(identical(other.ticketUrl, _this.ticketUrl) || other.ticketUrl == _this.ticketUrl)&&(identical(other.ticketCoupon, _this.ticketCoupon) || other.ticketCoupon == _this.ticketCoupon)&&(identical(other.minAge, _this.minAge) || other.minAge == _this.minAge)&&(identical(other.isOfficial, _this.isOfficial) || other.isOfficial == _this.isOfficial)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.rejectionReason, _this.rejectionReason) || other.rejectionReason == _this.rejectionReason)&&(identical(other.featuredUntil, _this.featuredUntil) || other.featuredUntil == _this.featuredUntil)&&(identical(other.venueId, _this.venueId) || other.venueId == _this.venueId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventDetail;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.venueName,_this.city,_this.state,_this.startsAt,_this.endsAt,_this.status,_this.description,_this.coverPath,_this.lat,_this.lng,_this.locationRevealHours,const DeepCollectionEquality().hash(_this.genres),const DeepCollectionEquality().hash(_this.lineup),_this.ticketUrl,_this.ticketCoupon,_this.minAge,_this.isOfficial,_this.createdBy,_this.rejectionReason,_this.featuredUntil,_this.venueId]);
}

@override
String toString() {
  final _this = this as EventDetail;
  return 'EventDetail(id: ${_this.id}, name: ${_this.name}, venueName: ${_this.venueName}, city: ${_this.city}, state: ${_this.state}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, status: ${_this.status}, description: ${_this.description}, coverPath: ${_this.coverPath}, lat: ${_this.lat}, lng: ${_this.lng}, locationRevealHours: ${_this.locationRevealHours}, genres: ${_this.genres}, lineup: ${_this.lineup}, ticketUrl: ${_this.ticketUrl}, ticketCoupon: ${_this.ticketCoupon}, minAge: ${_this.minAge}, isOfficial: ${_this.isOfficial}, createdBy: ${_this.createdBy}, rejectionReason: ${_this.rejectionReason}, featuredUntil: ${_this.featuredUntil}, venueId: ${_this.venueId})';
}


}

/// @nodoc
abstract mixin class $EventDetailCopyWith<$Res>  {
  factory $EventDetailCopyWith(EventDetail value, $Res Function(EventDetail) _then) = _$EventDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, EventStatus status, String? description, String? coverPath, double? lat, double? lng, int? locationRevealHours, List<MusicGenre> genres, List<String> lineup, String? ticketUrl, String? ticketCoupon, int minAge, bool isOfficial, String? createdBy, String? rejectionReason, DateTime? featuredUntil, String? venueId
});




}
/// @nodoc
class _$EventDetailCopyWithImpl<$Res>
    implements $EventDetailCopyWith<$Res> {
  _$EventDetailCopyWithImpl(this._self, this._then);

  final EventDetail _self;
  final $Res Function(EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? description = freezed,Object? coverPath = freezed,Object? lat = freezed,Object? lng = freezed,Object? locationRevealHours = freezed,Object? genres = null,Object? lineup = null,Object? ticketUrl = freezed,Object? ticketCoupon = freezed,Object? minAge = null,Object? isOfficial = null,Object? createdBy = freezed,Object? rejectionReason = freezed,Object? featuredUntil = freezed,Object? venueId = freezed,}) {
  return _then(EventDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,locationRevealHours: freezed == locationRevealHours ? _self.locationRevealHours : locationRevealHours // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,lineup: null == lineup ? _self.lineup : lineup // ignore: cast_nullable_to_non_nullable
as List<String>,ticketUrl: freezed == ticketUrl ? _self.ticketUrl : ticketUrl // ignore: cast_nullable_to_non_nullable
as String?,ticketCoupon: freezed == ticketCoupon ? _self.ticketCoupon : ticketCoupon // ignore: cast_nullable_to_non_nullable
as String?,minAge: null == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,featuredUntil: freezed == featuredUntil ? _self.featuredUntil : featuredUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,venueId: freezed == venueId ? _self.venueId : venueId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDetail].
extension EventDetailPatterns on EventDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetail value)  $default,){
final _that = this;
switch (_that) {
case _EventDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? description,  String? coverPath,  double? lat,  double? lng,  int? locationRevealHours,  List<MusicGenre> genres,  List<String> lineup,  String? ticketUrl,  String? ticketCoupon,  int minAge,  bool isOfficial,  String? createdBy,  String? rejectionReason,  DateTime? featuredUntil,  String? venueId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.description,_that.coverPath,_that.lat,_that.lng,_that.locationRevealHours,_that.genres,_that.lineup,_that.ticketUrl,_that.ticketCoupon,_that.minAge,_that.isOfficial,_that.createdBy,_that.rejectionReason,_that.featuredUntil,_that.venueId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? description,  String? coverPath,  double? lat,  double? lng,  int? locationRevealHours,  List<MusicGenre> genres,  List<String> lineup,  String? ticketUrl,  String? ticketCoupon,  int minAge,  bool isOfficial,  String? createdBy,  String? rejectionReason,  DateTime? featuredUntil,  String? venueId)  $default,) {final _that = this;
switch (_that) {
case _EventDetail():
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.description,_that.coverPath,_that.lat,_that.lng,_that.locationRevealHours,_that.genres,_that.lineup,_that.ticketUrl,_that.ticketCoupon,_that.minAge,_that.isOfficial,_that.createdBy,_that.rejectionReason,_that.featuredUntil,_that.venueId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  EventStatus status,  String? description,  String? coverPath,  double? lat,  double? lng,  int? locationRevealHours,  List<MusicGenre> genres,  List<String> lineup,  String? ticketUrl,  String? ticketCoupon,  int minAge,  bool isOfficial,  String? createdBy,  String? rejectionReason,  DateTime? featuredUntil,  String? venueId)?  $default,) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.status,_that.description,_that.coverPath,_that.lat,_that.lng,_that.locationRevealHours,_that.genres,_that.lineup,_that.ticketUrl,_that.ticketCoupon,_that.minAge,_that.isOfficial,_that.createdBy,_that.rejectionReason,_that.featuredUntil,_that.venueId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDetail implements EventDetail {
  const _EventDetail({required this.id, required this.name, required this.venueName, required this.city, required this.state, required this.startsAt, required this.endsAt, required this.status, this.description, this.coverPath, this.lat, this.lng, this.locationRevealHours,  List<MusicGenre> genres = const [],  List<String> lineup = const [], this.ticketUrl, this.ticketCoupon, this.minAge = 18, this.isOfficial = false, this.createdBy, this.rejectionReason, this.featuredUntil, this.venueId}): _genres = genres,_lineup = lineup;
  factory _EventDetail.fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String venueName;
@override final  String city;
@override final  String state;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  EventStatus status;
@override final  String? description;
@override final  String? coverPath;
/// City centroid (radius filter). The venue is in [EventVenue].
@override final  double? lat;
@override final  double? lng;
/// Secret location: venue revealed this many hours before the start.
@override final  int? locationRevealHours;
 final  List<MusicGenre> _genres;
@override@JsonKey() List<MusicGenre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _lineup;
@override@JsonKey() List<String> get lineup {
  if (_lineup is EqualUnmodifiableListView) return _lineup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineup);
}

@override final  String? ticketUrl;
/// Affiliate/promoter code shown next to the ticket link.
@override final  String? ticketCoupon;
@override@JsonKey() final  int minAge;
@override@JsonKey() final  bool isOfficial;
@override final  String? createdBy;
@override final  String? rejectionReason;
/// Featured until this moment (admins set it).
@override final  DateTime? featuredUntil;
/// Its casa (venues migration), when linked.
@override final  String? venueId;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailCopyWith<_EventDetail> get copyWith => __$EventDetailCopyWithImpl<_EventDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.locationRevealHours, locationRevealHours) || other.locationRevealHours == locationRevealHours)&&const DeepCollectionEquality().equals(other.genres, _genres)&&const DeepCollectionEquality().equals(other.lineup, _lineup)&&(identical(other.ticketUrl, ticketUrl) || other.ticketUrl == ticketUrl)&&(identical(other.ticketCoupon, ticketCoupon) || other.ticketCoupon == ticketCoupon)&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.featuredUntil, featuredUntil) || other.featuredUntil == featuredUntil)&&(identical(other.venueId, venueId) || other.venueId == venueId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,venueName,city,state,startsAt,endsAt,status,description,coverPath,lat,lng,locationRevealHours,const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_lineup),ticketUrl,ticketCoupon,minAge,isOfficial,createdBy,rejectionReason,featuredUntil,venueId]);
}

@override
String toString() {
    return 'EventDetail(id: $id, name: $name, venueName: $venueName, city: $city, state: $state, startsAt: $startsAt, endsAt: $endsAt, status: $status, description: $description, coverPath: $coverPath, lat: $lat, lng: $lng, locationRevealHours: $locationRevealHours, genres: $genres, lineup: $lineup, ticketUrl: $ticketUrl, ticketCoupon: $ticketCoupon, minAge: $minAge, isOfficial: $isOfficial, createdBy: $createdBy, rejectionReason: $rejectionReason, featuredUntil: $featuredUntil, venueId: $venueId)';
}


}

/// @nodoc
abstract mixin class _$EventDetailCopyWith<$Res> implements $EventDetailCopyWith<$Res> {
  factory _$EventDetailCopyWith(_EventDetail value, $Res Function(_EventDetail) _then) = __$EventDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, EventStatus status, String? description, String? coverPath, double? lat, double? lng, int? locationRevealHours, List<MusicGenre> genres, List<String> lineup, String? ticketUrl, String? ticketCoupon, int minAge, bool isOfficial, String? createdBy, String? rejectionReason, DateTime? featuredUntil, String? venueId
});




}
/// @nodoc
class __$EventDetailCopyWithImpl<$Res>
    implements _$EventDetailCopyWith<$Res> {
  __$EventDetailCopyWithImpl(this._self, this._then);

  final _EventDetail _self;
  final $Res Function(_EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? description = freezed,Object? coverPath = freezed,Object? lat = freezed,Object? lng = freezed,Object? locationRevealHours = freezed,Object? genres = null,Object? lineup = null,Object? ticketUrl = freezed,Object? ticketCoupon = freezed,Object? minAge = null,Object? isOfficial = null,Object? createdBy = freezed,Object? rejectionReason = freezed,Object? featuredUntil = freezed,Object? venueId = freezed,}) {
  return _then(_EventDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,locationRevealHours: freezed == locationRevealHours ? _self.locationRevealHours : locationRevealHours // ignore: cast_nullable_to_non_nullable
as int?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,lineup: null == lineup ? _self._lineup : lineup // ignore: cast_nullable_to_non_nullable
as List<String>,ticketUrl: freezed == ticketUrl ? _self.ticketUrl : ticketUrl // ignore: cast_nullable_to_non_nullable
as String?,ticketCoupon: freezed == ticketCoupon ? _self.ticketCoupon : ticketCoupon // ignore: cast_nullable_to_non_nullable
as String?,minAge: null == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,featuredUntil: freezed == featuredUntil ? _self.featuredUntil : featuredUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,venueId: freezed == venueId ? _self.venueId : venueId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EventVenue {

 String get eventId; String? get address; double? get lat; double? get lng;
/// Create a copy of EventVenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventVenueCopyWith<EventVenue> get copyWith => _$EventVenueCopyWithImpl<EventVenue>(this as EventVenue, _$identity);

  /// Serializes this EventVenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventVenue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventVenue&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventVenue;
  return Object.hash(runtimeType,_this.eventId,_this.address,_this.lat,_this.lng);
}

@override
String toString() {
  final _this = this as EventVenue;
  return 'EventVenue(eventId: ${_this.eventId}, address: ${_this.address}, lat: ${_this.lat}, lng: ${_this.lng})';
}


}

/// @nodoc
abstract mixin class $EventVenueCopyWith<$Res>  {
  factory $EventVenueCopyWith(EventVenue value, $Res Function(EventVenue) _then) = _$EventVenueCopyWithImpl;
@useResult
$Res call({
 String eventId, String? address, double? lat, double? lng
});




}
/// @nodoc
class _$EventVenueCopyWithImpl<$Res>
    implements $EventVenueCopyWith<$Res> {
  _$EventVenueCopyWithImpl(this._self, this._then);

  final EventVenue _self;
  final $Res Function(EventVenue) _then;

/// Create a copy of EventVenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(EventVenue(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventVenue].
extension EventVenuePatterns on EventVenue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventVenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventVenue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventVenue value)  $default,){
final _that = this;
switch (_that) {
case _EventVenue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventVenue value)?  $default,){
final _that = this;
switch (_that) {
case _EventVenue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String? address,  double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventVenue() when $default != null:
return $default(_that.eventId,_that.address,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String? address,  double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _EventVenue():
return $default(_that.eventId,_that.address,_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String? address,  double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _EventVenue() when $default != null:
return $default(_that.eventId,_that.address,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventVenue extends EventVenue {
  const _EventVenue({required this.eventId, this.address, this.lat, this.lng}): super._();
  factory _EventVenue.fromJson(Map<String, dynamic> json) => _$EventVenueFromJson(json);

@override final  String eventId;
@override final  String? address;
@override final  double? lat;
@override final  double? lng;

/// Create a copy of EventVenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventVenueCopyWith<_EventVenue> get copyWith => __$EventVenueCopyWithImpl<_EventVenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventVenueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventVenue&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,eventId,address,lat,lng);
}

@override
String toString() {
    return 'EventVenue(eventId: $eventId, address: $address, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$EventVenueCopyWith<$Res> implements $EventVenueCopyWith<$Res> {
  factory _$EventVenueCopyWith(_EventVenue value, $Res Function(_EventVenue) _then) = __$EventVenueCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String? address, double? lat, double? lng
});




}
/// @nodoc
class __$EventVenueCopyWithImpl<$Res>
    implements _$EventVenueCopyWith<$Res> {
  __$EventVenueCopyWithImpl(this._self, this._then);

  final _EventVenue _self;
  final $Res Function(_EventVenue) _then;

/// Create a copy of EventVenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_EventVenue(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$EventAttendee {

 String get userId; String? get firstName; String? get photoPath; List<AppMode> get modes; bool get isMatch;
/// Create a copy of EventAttendee
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventAttendeeCopyWith<EventAttendee> get copyWith => _$EventAttendeeCopyWithImpl<EventAttendee>(this as EventAttendee, _$identity);

  /// Serializes this EventAttendee to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventAttendee;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventAttendee&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.isMatch, _this.isMatch) || other.isMatch == _this.isMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventAttendee;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.photoPath,const DeepCollectionEquality().hash(_this.modes),_this.isMatch);
}

@override
String toString() {
  final _this = this as EventAttendee;
  return 'EventAttendee(userId: ${_this.userId}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath}, modes: ${_this.modes}, isMatch: ${_this.isMatch})';
}


}

/// @nodoc
abstract mixin class $EventAttendeeCopyWith<$Res>  {
  factory $EventAttendeeCopyWith(EventAttendee value, $Res Function(EventAttendee) _then) = _$EventAttendeeCopyWithImpl;
@useResult
$Res call({
 String userId, String? firstName, String? photoPath, List<AppMode> modes, bool isMatch
});




}
/// @nodoc
class _$EventAttendeeCopyWithImpl<$Res>
    implements $EventAttendeeCopyWith<$Res> {
  _$EventAttendeeCopyWithImpl(this._self, this._then);

  final EventAttendee _self;
  final $Res Function(EventAttendee) _then;

/// Create a copy of EventAttendee
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,Object? modes = null,Object? isMatch = null,}) {
  return _then(EventAttendee(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventAttendee].
extension EventAttendeePatterns on EventAttendee {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventAttendee value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventAttendee() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventAttendee value)  $default,){
final _that = this;
switch (_that) {
case _EventAttendee():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventAttendee value)?  $default,){
final _that = this;
switch (_that) {
case _EventAttendee() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? firstName,  String? photoPath,  List<AppMode> modes,  bool isMatch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventAttendee() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath,_that.modes,_that.isMatch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? firstName,  String? photoPath,  List<AppMode> modes,  bool isMatch)  $default,) {final _that = this;
switch (_that) {
case _EventAttendee():
return $default(_that.userId,_that.firstName,_that.photoPath,_that.modes,_that.isMatch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? firstName,  String? photoPath,  List<AppMode> modes,  bool isMatch)?  $default,) {final _that = this;
switch (_that) {
case _EventAttendee() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath,_that.modes,_that.isMatch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventAttendee implements EventAttendee {
  const _EventAttendee({required this.userId, this.firstName, this.photoPath,  List<AppMode> modes = const [], this.isMatch = false}): _modes = modes;
  factory _EventAttendee.fromJson(Map<String, dynamic> json) => _$EventAttendeeFromJson(json);

@override final  String userId;
@override final  String? firstName;
@override final  String? photoPath;
 final  List<AppMode> _modes;
@override@JsonKey() List<AppMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override@JsonKey() final  bool isMatch;

/// Create a copy of EventAttendee
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventAttendeeCopyWith<_EventAttendee> get copyWith => __$EventAttendeeCopyWithImpl<_EventAttendee>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventAttendeeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventAttendee&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.isMatch, isMatch) || other.isMatch == isMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,photoPath,const DeepCollectionEquality().hash(_modes),isMatch);
}

@override
String toString() {
    return 'EventAttendee(userId: $userId, firstName: $firstName, photoPath: $photoPath, modes: $modes, isMatch: $isMatch)';
}


}

/// @nodoc
abstract mixin class _$EventAttendeeCopyWith<$Res> implements $EventAttendeeCopyWith<$Res> {
  factory _$EventAttendeeCopyWith(_EventAttendee value, $Res Function(_EventAttendee) _then) = __$EventAttendeeCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? firstName, String? photoPath, List<AppMode> modes, bool isMatch
});




}
/// @nodoc
class __$EventAttendeeCopyWithImpl<$Res>
    implements _$EventAttendeeCopyWith<$Res> {
  __$EventAttendeeCopyWithImpl(this._self, this._then);

  final _EventAttendee _self;
  final $Res Function(_EventAttendee) _then;

/// Create a copy of EventAttendee
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = freezed,Object? photoPath = freezed,Object? modes = null,Object? isMatch = null,}) {
  return _then(_EventAttendee(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AttendeeCounts {

 int get total; int get dateCount; int get crewCount;
/// Create a copy of AttendeeCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendeeCountsCopyWith<AttendeeCounts> get copyWith => _$AttendeeCountsCopyWithImpl<AttendeeCounts>(this as AttendeeCounts, _$identity);

  /// Serializes this AttendeeCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendeeCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendeeCounts&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.dateCount, _this.dateCount) || other.dateCount == _this.dateCount)&&(identical(other.crewCount, _this.crewCount) || other.crewCount == _this.crewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendeeCounts;
  return Object.hash(runtimeType,_this.total,_this.dateCount,_this.crewCount);
}

@override
String toString() {
  final _this = this as AttendeeCounts;
  return 'AttendeeCounts(total: ${_this.total}, dateCount: ${_this.dateCount}, crewCount: ${_this.crewCount})';
}


}

/// @nodoc
abstract mixin class $AttendeeCountsCopyWith<$Res>  {
  factory $AttendeeCountsCopyWith(AttendeeCounts value, $Res Function(AttendeeCounts) _then) = _$AttendeeCountsCopyWithImpl;
@useResult
$Res call({
 int total, int dateCount, int crewCount
});




}
/// @nodoc
class _$AttendeeCountsCopyWithImpl<$Res>
    implements $AttendeeCountsCopyWith<$Res> {
  _$AttendeeCountsCopyWithImpl(this._self, this._then);

  final AttendeeCounts _self;
  final $Res Function(AttendeeCounts) _then;

/// Create a copy of AttendeeCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? dateCount = null,Object? crewCount = null,}) {
  return _then(AttendeeCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dateCount: null == dateCount ? _self.dateCount : dateCount // ignore: cast_nullable_to_non_nullable
as int,crewCount: null == crewCount ? _self.crewCount : crewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendeeCounts].
extension AttendeeCountsPatterns on AttendeeCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendeeCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendeeCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendeeCounts value)  $default,){
final _that = this;
switch (_that) {
case _AttendeeCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendeeCounts value)?  $default,){
final _that = this;
switch (_that) {
case _AttendeeCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int dateCount,  int crewCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendeeCounts() when $default != null:
return $default(_that.total,_that.dateCount,_that.crewCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int dateCount,  int crewCount)  $default,) {final _that = this;
switch (_that) {
case _AttendeeCounts():
return $default(_that.total,_that.dateCount,_that.crewCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int dateCount,  int crewCount)?  $default,) {final _that = this;
switch (_that) {
case _AttendeeCounts() when $default != null:
return $default(_that.total,_that.dateCount,_that.crewCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendeeCounts implements AttendeeCounts {
  const _AttendeeCounts({this.total = 0, this.dateCount = 0, this.crewCount = 0});
  factory _AttendeeCounts.fromJson(Map<String, dynamic> json) => _$AttendeeCountsFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int dateCount;
@override@JsonKey() final  int crewCount;

/// Create a copy of AttendeeCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendeeCountsCopyWith<_AttendeeCounts> get copyWith => __$AttendeeCountsCopyWithImpl<_AttendeeCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendeeCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendeeCounts&&(identical(other.total, total) || other.total == total)&&(identical(other.dateCount, dateCount) || other.dateCount == dateCount)&&(identical(other.crewCount, crewCount) || other.crewCount == crewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,dateCount,crewCount);
}

@override
String toString() {
    return 'AttendeeCounts(total: $total, dateCount: $dateCount, crewCount: $crewCount)';
}


}

/// @nodoc
abstract mixin class _$AttendeeCountsCopyWith<$Res> implements $AttendeeCountsCopyWith<$Res> {
  factory _$AttendeeCountsCopyWith(_AttendeeCounts value, $Res Function(_AttendeeCounts) _then) = __$AttendeeCountsCopyWithImpl;
@override @useResult
$Res call({
 int total, int dateCount, int crewCount
});




}
/// @nodoc
class __$AttendeeCountsCopyWithImpl<$Res>
    implements _$AttendeeCountsCopyWith<$Res> {
  __$AttendeeCountsCopyWithImpl(this._self, this._then);

  final _AttendeeCounts _self;
  final $Res Function(_AttendeeCounts) _then;

/// Create a copy of AttendeeCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? dateCount = null,Object? crewCount = null,}) {
  return _then(_AttendeeCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dateCount: null == dateCount ? _self.dateCount : dateCount // ignore: cast_nullable_to_non_nullable
as int,crewCount: null == crewCount ? _self.crewCount : crewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SimilarEvent {

 String get id; String get name; String get venueName; String get city; DateTime get startsAt; EventStatus get status;
/// Create a copy of SimilarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimilarEventCopyWith<SimilarEvent> get copyWith => _$SimilarEventCopyWithImpl<SimilarEvent>(this as SimilarEvent, _$identity);

  /// Serializes this SimilarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SimilarEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimilarEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SimilarEvent;
  return Object.hash(runtimeType,_this.id,_this.name,_this.venueName,_this.city,_this.startsAt,_this.status);
}

@override
String toString() {
  final _this = this as SimilarEvent;
  return 'SimilarEvent(id: ${_this.id}, name: ${_this.name}, venueName: ${_this.venueName}, city: ${_this.city}, startsAt: ${_this.startsAt}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $SimilarEventCopyWith<$Res>  {
  factory $SimilarEventCopyWith(SimilarEvent value, $Res Function(SimilarEvent) _then) = _$SimilarEventCopyWithImpl;
@useResult
$Res call({
 String id, String name, String venueName, String city, DateTime startsAt, EventStatus status
});




}
/// @nodoc
class _$SimilarEventCopyWithImpl<$Res>
    implements $SimilarEventCopyWith<$Res> {
  _$SimilarEventCopyWithImpl(this._self, this._then);

  final SimilarEvent _self;
  final $Res Function(SimilarEvent) _then;

/// Create a copy of SimilarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? startsAt = null,Object? status = null,}) {
  return _then(SimilarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SimilarEvent].
extension SimilarEventPatterns on SimilarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimilarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimilarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimilarEvent value)  $default,){
final _that = this;
switch (_that) {
case _SimilarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimilarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SimilarEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  DateTime startsAt,  EventStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimilarEvent() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.startsAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  DateTime startsAt,  EventStatus status)  $default,) {final _that = this;
switch (_that) {
case _SimilarEvent():
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.startsAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String venueName,  String city,  DateTime startsAt,  EventStatus status)?  $default,) {final _that = this;
switch (_that) {
case _SimilarEvent() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.startsAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SimilarEvent implements SimilarEvent {
  const _SimilarEvent({required this.id, required this.name, required this.venueName, required this.city, required this.startsAt, required this.status});
  factory _SimilarEvent.fromJson(Map<String, dynamic> json) => _$SimilarEventFromJson(json);

@override final  String id;
@override final  String name;
@override final  String venueName;
@override final  String city;
@override final  DateTime startsAt;
@override final  EventStatus status;

/// Create a copy of SimilarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimilarEventCopyWith<_SimilarEvent> get copyWith => __$SimilarEventCopyWithImpl<_SimilarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SimilarEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimilarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,venueName,city,startsAt,status);
}

@override
String toString() {
    return 'SimilarEvent(id: $id, name: $name, venueName: $venueName, city: $city, startsAt: $startsAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SimilarEventCopyWith<$Res> implements $SimilarEventCopyWith<$Res> {
  factory _$SimilarEventCopyWith(_SimilarEvent value, $Res Function(_SimilarEvent) _then) = __$SimilarEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String venueName, String city, DateTime startsAt, EventStatus status
});




}
/// @nodoc
class __$SimilarEventCopyWithImpl<$Res>
    implements _$SimilarEventCopyWith<$Res> {
  __$SimilarEventCopyWithImpl(this._self, this._then);

  final _SimilarEvent _self;
  final $Res Function(_SimilarEvent) _then;

/// Create a copy of SimilarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? startsAt = null,Object? status = null,}) {
  return _then(_SimilarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,
  ));
}


}


/// @nodoc
mixin _$EventCreator {

 String get userId; UserRole get role; DateTime get memberSince; String? get firstName; String? get photoPath; int get eventsCreated; int get eventsRejected; String? get email;
/// Create a copy of EventCreator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCreatorCopyWith<EventCreator> get copyWith => _$EventCreatorCopyWithImpl<EventCreator>(this as EventCreator, _$identity);

  /// Serializes this EventCreator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventCreator;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventCreator&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.memberSince, _this.memberSince) || other.memberSince == _this.memberSince)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.eventsCreated, _this.eventsCreated) || other.eventsCreated == _this.eventsCreated)&&(identical(other.eventsRejected, _this.eventsRejected) || other.eventsRejected == _this.eventsRejected)&&(identical(other.email, _this.email) || other.email == _this.email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventCreator;
  return Object.hash(runtimeType,_this.userId,_this.role,_this.memberSince,_this.firstName,_this.photoPath,_this.eventsCreated,_this.eventsRejected,_this.email);
}

@override
String toString() {
  final _this = this as EventCreator;
  return 'EventCreator(userId: ${_this.userId}, role: ${_this.role}, memberSince: ${_this.memberSince}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath}, eventsCreated: ${_this.eventsCreated}, eventsRejected: ${_this.eventsRejected}, email: ${_this.email})';
}


}

/// @nodoc
abstract mixin class $EventCreatorCopyWith<$Res>  {
  factory $EventCreatorCopyWith(EventCreator value, $Res Function(EventCreator) _then) = _$EventCreatorCopyWithImpl;
@useResult
$Res call({
 String userId, UserRole role, DateTime memberSince, String? firstName, String? photoPath, int eventsCreated, int eventsRejected, String? email
});




}
/// @nodoc
class _$EventCreatorCopyWithImpl<$Res>
    implements $EventCreatorCopyWith<$Res> {
  _$EventCreatorCopyWithImpl(this._self, this._then);

  final EventCreator _self;
  final $Res Function(EventCreator) _then;

/// Create a copy of EventCreator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? role = null,Object? memberSince = null,Object? firstName = freezed,Object? photoPath = freezed,Object? eventsCreated = null,Object? eventsRejected = null,Object? email = freezed,}) {
  return _then(EventCreator(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,eventsCreated: null == eventsCreated ? _self.eventsCreated : eventsCreated // ignore: cast_nullable_to_non_nullable
as int,eventsRejected: null == eventsRejected ? _self.eventsRejected : eventsRejected // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EventCreator].
extension EventCreatorPatterns on EventCreator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventCreator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventCreator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventCreator value)  $default,){
final _that = this;
switch (_that) {
case _EventCreator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventCreator value)?  $default,){
final _that = this;
switch (_that) {
case _EventCreator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  UserRole role,  DateTime memberSince,  String? firstName,  String? photoPath,  int eventsCreated,  int eventsRejected,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventCreator() when $default != null:
return $default(_that.userId,_that.role,_that.memberSince,_that.firstName,_that.photoPath,_that.eventsCreated,_that.eventsRejected,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  UserRole role,  DateTime memberSince,  String? firstName,  String? photoPath,  int eventsCreated,  int eventsRejected,  String? email)  $default,) {final _that = this;
switch (_that) {
case _EventCreator():
return $default(_that.userId,_that.role,_that.memberSince,_that.firstName,_that.photoPath,_that.eventsCreated,_that.eventsRejected,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  UserRole role,  DateTime memberSince,  String? firstName,  String? photoPath,  int eventsCreated,  int eventsRejected,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _EventCreator() when $default != null:
return $default(_that.userId,_that.role,_that.memberSince,_that.firstName,_that.photoPath,_that.eventsCreated,_that.eventsRejected,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventCreator implements EventCreator {
  const _EventCreator({required this.userId, required this.role, required this.memberSince, this.firstName, this.photoPath, this.eventsCreated = 0, this.eventsRejected = 0, this.email});
  factory _EventCreator.fromJson(Map<String, dynamic> json) => _$EventCreatorFromJson(json);

@override final  String userId;
@override final  UserRole role;
@override final  DateTime memberSince;
@override final  String? firstName;
@override final  String? photoPath;
@override@JsonKey() final  int eventsCreated;
@override@JsonKey() final  int eventsRejected;
@override final  String? email;

/// Create a copy of EventCreator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCreatorCopyWith<_EventCreator> get copyWith => __$EventCreatorCopyWithImpl<_EventCreator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventCreatorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventCreator&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.eventsCreated, eventsCreated) || other.eventsCreated == eventsCreated)&&(identical(other.eventsRejected, eventsRejected) || other.eventsRejected == eventsRejected)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,role,memberSince,firstName,photoPath,eventsCreated,eventsRejected,email);
}

@override
String toString() {
    return 'EventCreator(userId: $userId, role: $role, memberSince: $memberSince, firstName: $firstName, photoPath: $photoPath, eventsCreated: $eventsCreated, eventsRejected: $eventsRejected, email: $email)';
}


}

/// @nodoc
abstract mixin class _$EventCreatorCopyWith<$Res> implements $EventCreatorCopyWith<$Res> {
  factory _$EventCreatorCopyWith(_EventCreator value, $Res Function(_EventCreator) _then) = __$EventCreatorCopyWithImpl;
@override @useResult
$Res call({
 String userId, UserRole role, DateTime memberSince, String? firstName, String? photoPath, int eventsCreated, int eventsRejected, String? email
});




}
/// @nodoc
class __$EventCreatorCopyWithImpl<$Res>
    implements _$EventCreatorCopyWith<$Res> {
  __$EventCreatorCopyWithImpl(this._self, this._then);

  final _EventCreator _self;
  final $Res Function(_EventCreator) _then;

/// Create a copy of EventCreator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? role = null,Object? memberSince = null,Object? firstName = freezed,Object? photoPath = freezed,Object? eventsCreated = null,Object? eventsRejected = null,Object? email = freezed,}) {
  return _then(_EventCreator(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,memberSince: null == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,eventsCreated: null == eventsCreated ? _self.eventsCreated : eventsCreated // ignore: cast_nullable_to_non_nullable
as int,eventsRejected: null == eventsRejected ? _self.eventsRejected : eventsRejected // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$EventFilters {

 String get query; Set<MusicGenre> get genres; EventDateRange get dateRange;
/// Create a copy of EventFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFiltersCopyWith<EventFilters> get copyWith => _$EventFiltersCopyWithImpl<EventFilters>(this as EventFilters, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventFilters;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFilters&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.dateRange, _this.dateRange) || other.dateRange == _this.dateRange));
}


@override
int get hashCode {
  final _this = this as EventFilters;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.genres),_this.dateRange);
}

@override
String toString() {
  final _this = this as EventFilters;
  return 'EventFilters(query: ${_this.query}, genres: ${_this.genres}, dateRange: ${_this.dateRange})';
}


}

/// @nodoc
abstract mixin class $EventFiltersCopyWith<$Res>  {
  factory $EventFiltersCopyWith(EventFilters value, $Res Function(EventFilters) _then) = _$EventFiltersCopyWithImpl;
@useResult
$Res call({
 String query, Set<MusicGenre> genres, EventDateRange dateRange
});




}
/// @nodoc
class _$EventFiltersCopyWithImpl<$Res>
    implements $EventFiltersCopyWith<$Res> {
  _$EventFiltersCopyWithImpl(this._self, this._then);

  final EventFilters _self;
  final $Res Function(EventFilters) _then;

/// Create a copy of EventFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? genres = null,Object? dateRange = null,}) {
  return _then(EventFilters(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as Set<MusicGenre>,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as EventDateRange,
  ));
}

}


/// Adds pattern-matching-related methods to [EventFilters].
extension EventFiltersPatterns on EventFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventFilters value)  $default,){
final _that = this;
switch (_that) {
case _EventFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventFilters value)?  $default,){
final _that = this;
switch (_that) {
case _EventFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  Set<MusicGenre> genres,  EventDateRange dateRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventFilters() when $default != null:
return $default(_that.query,_that.genres,_that.dateRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  Set<MusicGenre> genres,  EventDateRange dateRange)  $default,) {final _that = this;
switch (_that) {
case _EventFilters():
return $default(_that.query,_that.genres,_that.dateRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  Set<MusicGenre> genres,  EventDateRange dateRange)?  $default,) {final _that = this;
switch (_that) {
case _EventFilters() when $default != null:
return $default(_that.query,_that.genres,_that.dateRange);case _:
  return null;

}
}

}

/// @nodoc


class _EventFilters implements EventFilters {
  const _EventFilters({this.query = '',  Set<MusicGenre> genres = const <MusicGenre>{}, this.dateRange = EventDateRange.any}): _genres = genres;
  

@override@JsonKey() final  String query;
 final  Set<MusicGenre> _genres;
@override@JsonKey() Set<MusicGenre> get genres {
  if (_genres is EqualUnmodifiableSetView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_genres);
}

@override@JsonKey() final  EventDateRange dateRange;

/// Create a copy of EventFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventFiltersCopyWith<_EventFilters> get copyWith => __$EventFiltersCopyWithImpl<_EventFilters>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventFilters&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_genres),dateRange);
}

@override
String toString() {
    return 'EventFilters(query: $query, genres: $genres, dateRange: $dateRange)';
}


}

/// @nodoc
abstract mixin class _$EventFiltersCopyWith<$Res> implements $EventFiltersCopyWith<$Res> {
  factory _$EventFiltersCopyWith(_EventFilters value, $Res Function(_EventFilters) _then) = __$EventFiltersCopyWithImpl;
@override @useResult
$Res call({
 String query, Set<MusicGenre> genres, EventDateRange dateRange
});




}
/// @nodoc
class __$EventFiltersCopyWithImpl<$Res>
    implements _$EventFiltersCopyWith<$Res> {
  __$EventFiltersCopyWithImpl(this._self, this._then);

  final _EventFilters _self;
  final $Res Function(_EventFilters) _then;

/// Create a copy of EventFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? genres = null,Object? dateRange = null,}) {
  return _then(_EventFilters(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as Set<MusicGenre>,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as EventDateRange,
  ));
}


}


/// @nodoc
mixin _$OnPerson {

 String get userId; String get firstName; String? get photoPath;
/// Create a copy of OnPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnPersonCopyWith<OnPerson> get copyWith => _$OnPersonCopyWithImpl<OnPerson>(this as OnPerson, _$identity);

  /// Serializes this OnPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnPerson;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnPerson&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnPerson;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.photoPath);
}

@override
String toString() {
  final _this = this as OnPerson;
  return 'OnPerson(userId: ${_this.userId}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $OnPersonCopyWith<$Res>  {
  factory $OnPersonCopyWith(OnPerson value, $Res Function(OnPerson) _then) = _$OnPersonCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, String? photoPath
});




}
/// @nodoc
class _$OnPersonCopyWithImpl<$Res>
    implements $OnPersonCopyWith<$Res> {
  _$OnPersonCopyWithImpl(this._self, this._then);

  final OnPerson _self;
  final $Res Function(OnPerson) _then;

/// Create a copy of OnPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? photoPath = freezed,}) {
  return _then(OnPerson(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnPerson].
extension OnPersonPatterns on OnPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnPerson value)  $default,){
final _that = this;
switch (_that) {
case _OnPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnPerson value)?  $default,){
final _that = this;
switch (_that) {
case _OnPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnPerson() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _OnPerson():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _OnPerson() when $default != null:
return $default(_that.userId,_that.firstName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnPerson implements OnPerson {
  const _OnPerson({required this.userId, required this.firstName, this.photoPath});
  factory _OnPerson.fromJson(Map<String, dynamic> json) => _$OnPersonFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  String? photoPath;

/// Create a copy of OnPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPersonCopyWith<_OnPerson> get copyWith => __$OnPersonCopyWithImpl<_OnPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnPersonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPerson&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,photoPath);
}

@override
String toString() {
    return 'OnPerson(userId: $userId, firstName: $firstName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$OnPersonCopyWith<$Res> implements $OnPersonCopyWith<$Res> {
  factory _$OnPersonCopyWith(_OnPerson value, $Res Function(_OnPerson) _then) = __$OnPersonCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, String? photoPath
});




}
/// @nodoc
class __$OnPersonCopyWithImpl<$Res>
    implements _$OnPersonCopyWith<$Res> {
  __$OnPersonCopyWithImpl(this._self, this._then);

  final _OnPerson _self;
  final $Res Function(_OnPerson) _then;

/// Create a copy of OnPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? photoPath = freezed,}) {
  return _then(_OnPerson(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SectionEvent {

 String get id; String get name; String get venueName; String get city; String get state; DateTime get startsAt; DateTime get endsAt; String? get coverPath; List<MusicGenre> get genres; bool get isOfficial; int get goingCount;
/// Create a copy of SectionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionEventCopyWith<SectionEvent> get copyWith => _$SectionEventCopyWithImpl<SectionEvent>(this as SectionEvent, _$identity);

  /// Serializes this SectionEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SectionEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venueName, _this.venueName) || other.venueName == _this.venueName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&const DeepCollectionEquality().equals(other.genres, _this.genres)&&(identical(other.isOfficial, _this.isOfficial) || other.isOfficial == _this.isOfficial)&&(identical(other.goingCount, _this.goingCount) || other.goingCount == _this.goingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SectionEvent;
  return Object.hash(runtimeType,_this.id,_this.name,_this.venueName,_this.city,_this.state,_this.startsAt,_this.endsAt,_this.coverPath,const DeepCollectionEquality().hash(_this.genres),_this.isOfficial,_this.goingCount);
}

@override
String toString() {
  final _this = this as SectionEvent;
  return 'SectionEvent(id: ${_this.id}, name: ${_this.name}, venueName: ${_this.venueName}, city: ${_this.city}, state: ${_this.state}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, coverPath: ${_this.coverPath}, genres: ${_this.genres}, isOfficial: ${_this.isOfficial}, goingCount: ${_this.goingCount})';
}


}

/// @nodoc
abstract mixin class $SectionEventCopyWith<$Res>  {
  factory $SectionEventCopyWith(SectionEvent value, $Res Function(SectionEvent) _then) = _$SectionEventCopyWithImpl;
@useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, String? coverPath, List<MusicGenre> genres, bool isOfficial, int goingCount
});




}
/// @nodoc
class _$SectionEventCopyWithImpl<$Res>
    implements $SectionEventCopyWith<$Res> {
  _$SectionEventCopyWithImpl(this._self, this._then);

  final SectionEvent _self;
  final $Res Function(SectionEvent) _then;

/// Create a copy of SectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,Object? goingCount = null,}) {
  return _then(SectionEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionEvent].
extension SectionEventPatterns on SectionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionEvent value)  $default,){
final _that = this;
switch (_that) {
case _SectionEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SectionEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  int goingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionEvent() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial,_that.goingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  int goingCount)  $default,) {final _that = this;
switch (_that) {
case _SectionEvent():
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial,_that.goingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String venueName,  String city,  String state,  DateTime startsAt,  DateTime endsAt,  String? coverPath,  List<MusicGenre> genres,  bool isOfficial,  int goingCount)?  $default,) {final _that = this;
switch (_that) {
case _SectionEvent() when $default != null:
return $default(_that.id,_that.name,_that.venueName,_that.city,_that.state,_that.startsAt,_that.endsAt,_that.coverPath,_that.genres,_that.isOfficial,_that.goingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionEvent implements SectionEvent {
  const _SectionEvent({required this.id, required this.name, required this.venueName, required this.city, required this.state, required this.startsAt, required this.endsAt, this.coverPath,  List<MusicGenre> genres = const [], this.isOfficial = false, this.goingCount = 0}): _genres = genres;
  factory _SectionEvent.fromJson(Map<String, dynamic> json) => _$SectionEventFromJson(json);

@override final  String id;
@override final  String name;
@override final  String venueName;
@override final  String city;
@override final  String state;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  String? coverPath;
 final  List<MusicGenre> _genres;
@override@JsonKey() List<MusicGenre> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey() final  bool isOfficial;
@override@JsonKey() final  int goingCount;

/// Create a copy of SectionEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionEventCopyWith<_SectionEvent> get copyWith => __$SectionEventCopyWithImpl<_SectionEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venueName, venueName) || other.venueName == venueName)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.genres, _genres)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.goingCount, goingCount) || other.goingCount == goingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,venueName,city,state,startsAt,endsAt,coverPath,const DeepCollectionEquality().hash(_genres),isOfficial,goingCount);
}

@override
String toString() {
    return 'SectionEvent(id: $id, name: $name, venueName: $venueName, city: $city, state: $state, startsAt: $startsAt, endsAt: $endsAt, coverPath: $coverPath, genres: $genres, isOfficial: $isOfficial, goingCount: $goingCount)';
}


}

/// @nodoc
abstract mixin class _$SectionEventCopyWith<$Res> implements $SectionEventCopyWith<$Res> {
  factory _$SectionEventCopyWith(_SectionEvent value, $Res Function(_SectionEvent) _then) = __$SectionEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String venueName, String city, String state, DateTime startsAt, DateTime endsAt, String? coverPath, List<MusicGenre> genres, bool isOfficial, int goingCount
});




}
/// @nodoc
class __$SectionEventCopyWithImpl<$Res>
    implements _$SectionEventCopyWith<$Res> {
  __$SectionEventCopyWithImpl(this._self, this._then);

  final _SectionEvent _self;
  final $Res Function(_SectionEvent) _then;

/// Create a copy of SectionEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? venueName = null,Object? city = null,Object? state = null,Object? startsAt = null,Object? endsAt = null,Object? coverPath = freezed,Object? genres = null,Object? isOfficial = null,Object? goingCount = null,}) {
  return _then(_SectionEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venueName: null == venueName ? _self.venueName : venueName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,goingCount: null == goingCount ? _self.goingCount : goingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$EventSections {

 List<SectionEvent> get trending; List<SectionEvent> get thisWeek; List<SectionEvent> get followedVenues;
/// Create a copy of EventSections
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventSectionsCopyWith<EventSections> get copyWith => _$EventSectionsCopyWithImpl<EventSections>(this as EventSections, _$identity);

  /// Serializes this EventSections to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventSections;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventSections&&const DeepCollectionEquality().equals(other.trending, _this.trending)&&const DeepCollectionEquality().equals(other.thisWeek, _this.thisWeek)&&const DeepCollectionEquality().equals(other.followedVenues, _this.followedVenues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventSections;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.trending),const DeepCollectionEquality().hash(_this.thisWeek),const DeepCollectionEquality().hash(_this.followedVenues));
}

@override
String toString() {
  final _this = this as EventSections;
  return 'EventSections(trending: ${_this.trending}, thisWeek: ${_this.thisWeek}, followedVenues: ${_this.followedVenues})';
}


}

/// @nodoc
abstract mixin class $EventSectionsCopyWith<$Res>  {
  factory $EventSectionsCopyWith(EventSections value, $Res Function(EventSections) _then) = _$EventSectionsCopyWithImpl;
@useResult
$Res call({
 List<SectionEvent> trending, List<SectionEvent> thisWeek, List<SectionEvent> followedVenues
});




}
/// @nodoc
class _$EventSectionsCopyWithImpl<$Res>
    implements $EventSectionsCopyWith<$Res> {
  _$EventSectionsCopyWithImpl(this._self, this._then);

  final EventSections _self;
  final $Res Function(EventSections) _then;

/// Create a copy of EventSections
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trending = null,Object? thisWeek = null,Object? followedVenues = null,}) {
  return _then(EventSections(
trending: null == trending ? _self.trending : trending // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,thisWeek: null == thisWeek ? _self.thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,followedVenues: null == followedVenues ? _self.followedVenues : followedVenues // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [EventSections].
extension EventSectionsPatterns on EventSections {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventSections value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventSections() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventSections value)  $default,){
final _that = this;
switch (_that) {
case _EventSections():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventSections value)?  $default,){
final _that = this;
switch (_that) {
case _EventSections() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SectionEvent> trending,  List<SectionEvent> thisWeek,  List<SectionEvent> followedVenues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventSections() when $default != null:
return $default(_that.trending,_that.thisWeek,_that.followedVenues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SectionEvent> trending,  List<SectionEvent> thisWeek,  List<SectionEvent> followedVenues)  $default,) {final _that = this;
switch (_that) {
case _EventSections():
return $default(_that.trending,_that.thisWeek,_that.followedVenues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SectionEvent> trending,  List<SectionEvent> thisWeek,  List<SectionEvent> followedVenues)?  $default,) {final _that = this;
switch (_that) {
case _EventSections() when $default != null:
return $default(_that.trending,_that.thisWeek,_that.followedVenues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventSections extends EventSections {
  const _EventSections({ List<SectionEvent> trending = const [],  List<SectionEvent> thisWeek = const [],  List<SectionEvent> followedVenues = const []}): _trending = trending,_thisWeek = thisWeek,_followedVenues = followedVenues,super._();
  factory _EventSections.fromJson(Map<String, dynamic> json) => _$EventSectionsFromJson(json);

 final  List<SectionEvent> _trending;
@override@JsonKey() List<SectionEvent> get trending {
  if (_trending is EqualUnmodifiableListView) return _trending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trending);
}

 final  List<SectionEvent> _thisWeek;
@override@JsonKey() List<SectionEvent> get thisWeek {
  if (_thisWeek is EqualUnmodifiableListView) return _thisWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thisWeek);
}

 final  List<SectionEvent> _followedVenues;
@override@JsonKey() List<SectionEvent> get followedVenues {
  if (_followedVenues is EqualUnmodifiableListView) return _followedVenues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followedVenues);
}


/// Create a copy of EventSections
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventSectionsCopyWith<_EventSections> get copyWith => __$EventSectionsCopyWithImpl<_EventSections>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventSectionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventSections&&const DeepCollectionEquality().equals(other.trending, _trending)&&const DeepCollectionEquality().equals(other.thisWeek, _thisWeek)&&const DeepCollectionEquality().equals(other.followedVenues, _followedVenues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_trending),const DeepCollectionEquality().hash(_thisWeek),const DeepCollectionEquality().hash(_followedVenues));
}

@override
String toString() {
    return 'EventSections(trending: $trending, thisWeek: $thisWeek, followedVenues: $followedVenues)';
}


}

/// @nodoc
abstract mixin class _$EventSectionsCopyWith<$Res> implements $EventSectionsCopyWith<$Res> {
  factory _$EventSectionsCopyWith(_EventSections value, $Res Function(_EventSections) _then) = __$EventSectionsCopyWithImpl;
@override @useResult
$Res call({
 List<SectionEvent> trending, List<SectionEvent> thisWeek, List<SectionEvent> followedVenues
});




}
/// @nodoc
class __$EventSectionsCopyWithImpl<$Res>
    implements _$EventSectionsCopyWith<$Res> {
  __$EventSectionsCopyWithImpl(this._self, this._then);

  final _EventSections _self;
  final $Res Function(_EventSections) _then;

/// Create a copy of EventSections
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trending = null,Object? thisWeek = null,Object? followedVenues = null,}) {
  return _then(_EventSections(
trending: null == trending ? _self._trending : trending // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,thisWeek: null == thisWeek ? _self._thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,followedVenues: null == followedVenues ? _self._followedVenues : followedVenues // ignore: cast_nullable_to_non_nullable
as List<SectionEvent>,
  ));
}


}

// dart format on
