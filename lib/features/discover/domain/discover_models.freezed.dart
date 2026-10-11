// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommonEvent {

 String get id; String get name; DateTime get startsAt;
/// Create a copy of CommonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommonEventCopyWith<CommonEvent> get copyWith => _$CommonEventCopyWithImpl<CommonEvent>(this as CommonEvent, _$identity);

  /// Serializes this CommonEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommonEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommonEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommonEvent;
  return Object.hash(runtimeType,_this.id,_this.name,_this.startsAt);
}

@override
String toString() {
  final _this = this as CommonEvent;
  return 'CommonEvent(id: ${_this.id}, name: ${_this.name}, startsAt: ${_this.startsAt})';
}


}

/// @nodoc
abstract mixin class $CommonEventCopyWith<$Res>  {
  factory $CommonEventCopyWith(CommonEvent value, $Res Function(CommonEvent) _then) = _$CommonEventCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime startsAt
});




}
/// @nodoc
class _$CommonEventCopyWithImpl<$Res>
    implements $CommonEventCopyWith<$Res> {
  _$CommonEventCopyWithImpl(this._self, this._then);

  final CommonEvent _self;
  final $Res Function(CommonEvent) _then;

/// Create a copy of CommonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? startsAt = null,}) {
  return _then(CommonEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CommonEvent].
extension CommonEventPatterns on CommonEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommonEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommonEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommonEvent value)  $default,){
final _that = this;
switch (_that) {
case _CommonEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommonEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CommonEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime startsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommonEvent() when $default != null:
return $default(_that.id,_that.name,_that.startsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime startsAt)  $default,) {final _that = this;
switch (_that) {
case _CommonEvent():
return $default(_that.id,_that.name,_that.startsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime startsAt)?  $default,) {final _that = this;
switch (_that) {
case _CommonEvent() when $default != null:
return $default(_that.id,_that.name,_that.startsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommonEvent implements CommonEvent {
  const _CommonEvent({required this.id, required this.name, required this.startsAt});
  factory _CommonEvent.fromJson(Map<String, dynamic> json) => _$CommonEventFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime startsAt;

/// Create a copy of CommonEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommonEventCopyWith<_CommonEvent> get copyWith => __$CommonEventCopyWithImpl<_CommonEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommonEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommonEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,startsAt);
}

@override
String toString() {
    return 'CommonEvent(id: $id, name: $name, startsAt: $startsAt)';
}


}

/// @nodoc
abstract mixin class _$CommonEventCopyWith<$Res> implements $CommonEventCopyWith<$Res> {
  factory _$CommonEventCopyWith(_CommonEvent value, $Res Function(_CommonEvent) _then) = __$CommonEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime startsAt
});




}
/// @nodoc
class __$CommonEventCopyWithImpl<$Res>
    implements _$CommonEventCopyWith<$Res> {
  __$CommonEventCopyWithImpl(this._self, this._then);

  final _CommonEvent _self;
  final $Res Function(_CommonEvent) _then;

/// Create a copy of CommonEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? startsAt = null,}) {
  return _then(_CommonEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DiscoverCandidate {

 String get id; String get firstName; int get age; String? get city; String? get state; String? get occupation; String? get bio; Gender? get gender; bool get isVerified; List<MusicGenre> get musicGenres; List<String> get photoPaths; List<CommonEvent> get commonEvents; int get commonEventCount; bool get isFallback; double? get distanceKm; List<String> get favoriteDjs; DateIntent? get dateLookingFor;/// Crew mode: size of their crew for the first common event (null =
/// going solo).
 int? get crewSize;/// They superliked the viewer (plans).
 bool get superLikedMe;
/// Create a copy of DiscoverCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverCandidateCopyWith<DiscoverCandidate> get copyWith => _$DiscoverCandidateCopyWithImpl<DiscoverCandidate>(this as DiscoverCandidate, _$identity);

  /// Serializes this DiscoverCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiscoverCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverCandidate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.occupation, _this.occupation) || other.occupation == _this.occupation)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.isVerified, _this.isVerified) || other.isVerified == _this.isVerified)&&const DeepCollectionEquality().equals(other.musicGenres, _this.musicGenres)&&const DeepCollectionEquality().equals(other.photoPaths, _this.photoPaths)&&const DeepCollectionEquality().equals(other.commonEvents, _this.commonEvents)&&(identical(other.commonEventCount, _this.commonEventCount) || other.commonEventCount == _this.commonEventCount)&&(identical(other.isFallback, _this.isFallback) || other.isFallback == _this.isFallback)&&(identical(other.distanceKm, _this.distanceKm) || other.distanceKm == _this.distanceKm)&&const DeepCollectionEquality().equals(other.favoriteDjs, _this.favoriteDjs)&&(identical(other.dateLookingFor, _this.dateLookingFor) || other.dateLookingFor == _this.dateLookingFor)&&(identical(other.crewSize, _this.crewSize) || other.crewSize == _this.crewSize)&&(identical(other.superLikedMe, _this.superLikedMe) || other.superLikedMe == _this.superLikedMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiscoverCandidate;
  return Object.hashAll([runtimeType,_this.id,_this.firstName,_this.age,_this.city,_this.state,_this.occupation,_this.bio,_this.gender,_this.isVerified,const DeepCollectionEquality().hash(_this.musicGenres),const DeepCollectionEquality().hash(_this.photoPaths),const DeepCollectionEquality().hash(_this.commonEvents),_this.commonEventCount,_this.isFallback,_this.distanceKm,const DeepCollectionEquality().hash(_this.favoriteDjs),_this.dateLookingFor,_this.crewSize,_this.superLikedMe]);
}

@override
String toString() {
  final _this = this as DiscoverCandidate;
  return 'DiscoverCandidate(id: ${_this.id}, firstName: ${_this.firstName}, age: ${_this.age}, city: ${_this.city}, state: ${_this.state}, occupation: ${_this.occupation}, bio: ${_this.bio}, gender: ${_this.gender}, isVerified: ${_this.isVerified}, musicGenres: ${_this.musicGenres}, photoPaths: ${_this.photoPaths}, commonEvents: ${_this.commonEvents}, commonEventCount: ${_this.commonEventCount}, isFallback: ${_this.isFallback}, distanceKm: ${_this.distanceKm}, favoriteDjs: ${_this.favoriteDjs}, dateLookingFor: ${_this.dateLookingFor}, crewSize: ${_this.crewSize}, superLikedMe: ${_this.superLikedMe})';
}


}

/// @nodoc
abstract mixin class $DiscoverCandidateCopyWith<$Res>  {
  factory $DiscoverCandidateCopyWith(DiscoverCandidate value, $Res Function(DiscoverCandidate) _then) = _$DiscoverCandidateCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, int age, String? city, String? state, String? occupation, String? bio, Gender? gender, bool isVerified, List<MusicGenre> musicGenres, List<String> photoPaths, List<CommonEvent> commonEvents, int commonEventCount, bool isFallback, double? distanceKm, List<String> favoriteDjs, DateIntent? dateLookingFor, int? crewSize, bool superLikedMe
});




}
/// @nodoc
class _$DiscoverCandidateCopyWithImpl<$Res>
    implements $DiscoverCandidateCopyWith<$Res> {
  _$DiscoverCandidateCopyWithImpl(this._self, this._then);

  final DiscoverCandidate _self;
  final $Res Function(DiscoverCandidate) _then;

/// Create a copy of DiscoverCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? age = null,Object? city = freezed,Object? state = freezed,Object? occupation = freezed,Object? bio = freezed,Object? gender = freezed,Object? isVerified = null,Object? musicGenres = null,Object? photoPaths = null,Object? commonEvents = null,Object? commonEventCount = null,Object? isFallback = null,Object? distanceKm = freezed,Object? favoriteDjs = null,Object? dateLookingFor = freezed,Object? crewSize = freezed,Object? superLikedMe = null,}) {
  return _then(DiscoverCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,musicGenres: null == musicGenres ? _self.musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,commonEvents: null == commonEvents ? _self.commonEvents : commonEvents // ignore: cast_nullable_to_non_nullable
as List<CommonEvent>,commonEventCount: null == commonEventCount ? _self.commonEventCount : commonEventCount // ignore: cast_nullable_to_non_nullable
as int,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,favoriteDjs: null == favoriteDjs ? _self.favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,crewSize: freezed == crewSize ? _self.crewSize : crewSize // ignore: cast_nullable_to_non_nullable
as int?,superLikedMe: null == superLikedMe ? _self.superLikedMe : superLikedMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverCandidate].
extension DiscoverCandidatePatterns on DiscoverCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverCandidate value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  int age,  String? city,  String? state,  String? occupation,  String? bio,  Gender? gender,  bool isVerified,  List<MusicGenre> musicGenres,  List<String> photoPaths,  List<CommonEvent> commonEvents,  int commonEventCount,  bool isFallback,  double? distanceKm,  List<String> favoriteDjs,  DateIntent? dateLookingFor,  int? crewSize,  bool superLikedMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverCandidate() when $default != null:
return $default(_that.id,_that.firstName,_that.age,_that.city,_that.state,_that.occupation,_that.bio,_that.gender,_that.isVerified,_that.musicGenres,_that.photoPaths,_that.commonEvents,_that.commonEventCount,_that.isFallback,_that.distanceKm,_that.favoriteDjs,_that.dateLookingFor,_that.crewSize,_that.superLikedMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  int age,  String? city,  String? state,  String? occupation,  String? bio,  Gender? gender,  bool isVerified,  List<MusicGenre> musicGenres,  List<String> photoPaths,  List<CommonEvent> commonEvents,  int commonEventCount,  bool isFallback,  double? distanceKm,  List<String> favoriteDjs,  DateIntent? dateLookingFor,  int? crewSize,  bool superLikedMe)  $default,) {final _that = this;
switch (_that) {
case _DiscoverCandidate():
return $default(_that.id,_that.firstName,_that.age,_that.city,_that.state,_that.occupation,_that.bio,_that.gender,_that.isVerified,_that.musicGenres,_that.photoPaths,_that.commonEvents,_that.commonEventCount,_that.isFallback,_that.distanceKm,_that.favoriteDjs,_that.dateLookingFor,_that.crewSize,_that.superLikedMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  int age,  String? city,  String? state,  String? occupation,  String? bio,  Gender? gender,  bool isVerified,  List<MusicGenre> musicGenres,  List<String> photoPaths,  List<CommonEvent> commonEvents,  int commonEventCount,  bool isFallback,  double? distanceKm,  List<String> favoriteDjs,  DateIntent? dateLookingFor,  int? crewSize,  bool superLikedMe)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverCandidate() when $default != null:
return $default(_that.id,_that.firstName,_that.age,_that.city,_that.state,_that.occupation,_that.bio,_that.gender,_that.isVerified,_that.musicGenres,_that.photoPaths,_that.commonEvents,_that.commonEventCount,_that.isFallback,_that.distanceKm,_that.favoriteDjs,_that.dateLookingFor,_that.crewSize,_that.superLikedMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscoverCandidate extends DiscoverCandidate {
  const _DiscoverCandidate({required this.id, required this.firstName, required this.age, this.city, this.state, this.occupation, this.bio, this.gender, this.isVerified = false,  List<MusicGenre> musicGenres = const [],  List<String> photoPaths = const [],  List<CommonEvent> commonEvents = const [], this.commonEventCount = 0, this.isFallback = false, this.distanceKm,  List<String> favoriteDjs = const [], this.dateLookingFor, this.crewSize, this.superLikedMe = false}): _musicGenres = musicGenres,_photoPaths = photoPaths,_commonEvents = commonEvents,_favoriteDjs = favoriteDjs,super._();
  factory _DiscoverCandidate.fromJson(Map<String, dynamic> json) => _$DiscoverCandidateFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  int age;
@override final  String? city;
@override final  String? state;
@override final  String? occupation;
@override final  String? bio;
@override final  Gender? gender;
@override@JsonKey() final  bool isVerified;
 final  List<MusicGenre> _musicGenres;
@override@JsonKey() List<MusicGenre> get musicGenres {
  if (_musicGenres is EqualUnmodifiableListView) return _musicGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_musicGenres);
}

 final  List<String> _photoPaths;
@override@JsonKey() List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

 final  List<CommonEvent> _commonEvents;
@override@JsonKey() List<CommonEvent> get commonEvents {
  if (_commonEvents is EqualUnmodifiableListView) return _commonEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commonEvents);
}

@override@JsonKey() final  int commonEventCount;
@override@JsonKey() final  bool isFallback;
@override final  double? distanceKm;
 final  List<String> _favoriteDjs;
@override@JsonKey() List<String> get favoriteDjs {
  if (_favoriteDjs is EqualUnmodifiableListView) return _favoriteDjs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteDjs);
}

@override final  DateIntent? dateLookingFor;
/// Crew mode: size of their crew for the first common event (null =
/// going solo).
@override final  int? crewSize;
/// They superliked the viewer (plans).
@override@JsonKey() final  bool superLikedMe;

/// Create a copy of DiscoverCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverCandidateCopyWith<_DiscoverCandidate> get copyWith => __$DiscoverCandidateCopyWithImpl<_DiscoverCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscoverCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.age, age) || other.age == age)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.musicGenres, _musicGenres)&&const DeepCollectionEquality().equals(other.photoPaths, _photoPaths)&&const DeepCollectionEquality().equals(other.commonEvents, _commonEvents)&&(identical(other.commonEventCount, commonEventCount) || other.commonEventCount == commonEventCount)&&(identical(other.isFallback, isFallback) || other.isFallback == isFallback)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&const DeepCollectionEquality().equals(other.favoriteDjs, _favoriteDjs)&&(identical(other.dateLookingFor, dateLookingFor) || other.dateLookingFor == dateLookingFor)&&(identical(other.crewSize, crewSize) || other.crewSize == crewSize)&&(identical(other.superLikedMe, superLikedMe) || other.superLikedMe == superLikedMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,firstName,age,city,state,occupation,bio,gender,isVerified,const DeepCollectionEquality().hash(_musicGenres),const DeepCollectionEquality().hash(_photoPaths),const DeepCollectionEquality().hash(_commonEvents),commonEventCount,isFallback,distanceKm,const DeepCollectionEquality().hash(_favoriteDjs),dateLookingFor,crewSize,superLikedMe]);
}

@override
String toString() {
    return 'DiscoverCandidate(id: $id, firstName: $firstName, age: $age, city: $city, state: $state, occupation: $occupation, bio: $bio, gender: $gender, isVerified: $isVerified, musicGenres: $musicGenres, photoPaths: $photoPaths, commonEvents: $commonEvents, commonEventCount: $commonEventCount, isFallback: $isFallback, distanceKm: $distanceKm, favoriteDjs: $favoriteDjs, dateLookingFor: $dateLookingFor, crewSize: $crewSize, superLikedMe: $superLikedMe)';
}


}

/// @nodoc
abstract mixin class _$DiscoverCandidateCopyWith<$Res> implements $DiscoverCandidateCopyWith<$Res> {
  factory _$DiscoverCandidateCopyWith(_DiscoverCandidate value, $Res Function(_DiscoverCandidate) _then) = __$DiscoverCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, int age, String? city, String? state, String? occupation, String? bio, Gender? gender, bool isVerified, List<MusicGenre> musicGenres, List<String> photoPaths, List<CommonEvent> commonEvents, int commonEventCount, bool isFallback, double? distanceKm, List<String> favoriteDjs, DateIntent? dateLookingFor, int? crewSize, bool superLikedMe
});




}
/// @nodoc
class __$DiscoverCandidateCopyWithImpl<$Res>
    implements _$DiscoverCandidateCopyWith<$Res> {
  __$DiscoverCandidateCopyWithImpl(this._self, this._then);

  final _DiscoverCandidate _self;
  final $Res Function(_DiscoverCandidate) _then;

/// Create a copy of DiscoverCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? age = null,Object? city = freezed,Object? state = freezed,Object? occupation = freezed,Object? bio = freezed,Object? gender = freezed,Object? isVerified = null,Object? musicGenres = null,Object? photoPaths = null,Object? commonEvents = null,Object? commonEventCount = null,Object? isFallback = null,Object? distanceKm = freezed,Object? favoriteDjs = null,Object? dateLookingFor = freezed,Object? crewSize = freezed,Object? superLikedMe = null,}) {
  return _then(_DiscoverCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,musicGenres: null == musicGenres ? _self._musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,commonEvents: null == commonEvents ? _self._commonEvents : commonEvents // ignore: cast_nullable_to_non_nullable
as List<CommonEvent>,commonEventCount: null == commonEventCount ? _self.commonEventCount : commonEventCount // ignore: cast_nullable_to_non_nullable
as int,isFallback: null == isFallback ? _self.isFallback : isFallback // ignore: cast_nullable_to_non_nullable
as bool,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,favoriteDjs: null == favoriteDjs ? _self._favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,crewSize: freezed == crewSize ? _self.crewSize : crewSize // ignore: cast_nullable_to_non_nullable
as int?,superLikedMe: null == superLikedMe ? _self.superLikedMe : superLikedMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SwipeResult {

 bool get matched; String? get matchId; String? get conversationId;
/// Create a copy of SwipeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwipeResultCopyWith<SwipeResult> get copyWith => _$SwipeResultCopyWithImpl<SwipeResult>(this as SwipeResult, _$identity);

  /// Serializes this SwipeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SwipeResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwipeResult&&(identical(other.matched, _this.matched) || other.matched == _this.matched)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SwipeResult;
  return Object.hash(runtimeType,_this.matched,_this.matchId,_this.conversationId);
}

@override
String toString() {
  final _this = this as SwipeResult;
  return 'SwipeResult(matched: ${_this.matched}, matchId: ${_this.matchId}, conversationId: ${_this.conversationId})';
}


}

/// @nodoc
abstract mixin class $SwipeResultCopyWith<$Res>  {
  factory $SwipeResultCopyWith(SwipeResult value, $Res Function(SwipeResult) _then) = _$SwipeResultCopyWithImpl;
@useResult
$Res call({
 bool matched, String? matchId, String? conversationId
});




}
/// @nodoc
class _$SwipeResultCopyWithImpl<$Res>
    implements $SwipeResultCopyWith<$Res> {
  _$SwipeResultCopyWithImpl(this._self, this._then);

  final SwipeResult _self;
  final $Res Function(SwipeResult) _then;

/// Create a copy of SwipeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matched = null,Object? matchId = freezed,Object? conversationId = freezed,}) {
  return _then(SwipeResult(
matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SwipeResult].
extension SwipeResultPatterns on SwipeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwipeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwipeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwipeResult value)  $default,){
final _that = this;
switch (_that) {
case _SwipeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwipeResult value)?  $default,){
final _that = this;
switch (_that) {
case _SwipeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool matched,  String? matchId,  String? conversationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwipeResult() when $default != null:
return $default(_that.matched,_that.matchId,_that.conversationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool matched,  String? matchId,  String? conversationId)  $default,) {final _that = this;
switch (_that) {
case _SwipeResult():
return $default(_that.matched,_that.matchId,_that.conversationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool matched,  String? matchId,  String? conversationId)?  $default,) {final _that = this;
switch (_that) {
case _SwipeResult() when $default != null:
return $default(_that.matched,_that.matchId,_that.conversationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwipeResult implements SwipeResult {
  const _SwipeResult({required this.matched, this.matchId, this.conversationId});
  factory _SwipeResult.fromJson(Map<String, dynamic> json) => _$SwipeResultFromJson(json);

@override final  bool matched;
@override final  String? matchId;
@override final  String? conversationId;

/// Create a copy of SwipeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwipeResultCopyWith<_SwipeResult> get copyWith => __$SwipeResultCopyWithImpl<_SwipeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwipeResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwipeResult&&(identical(other.matched, matched) || other.matched == matched)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,matched,matchId,conversationId);
}

@override
String toString() {
    return 'SwipeResult(matched: $matched, matchId: $matchId, conversationId: $conversationId)';
}


}

/// @nodoc
abstract mixin class _$SwipeResultCopyWith<$Res> implements $SwipeResultCopyWith<$Res> {
  factory _$SwipeResultCopyWith(_SwipeResult value, $Res Function(_SwipeResult) _then) = __$SwipeResultCopyWithImpl;
@override @useResult
$Res call({
 bool matched, String? matchId, String? conversationId
});




}
/// @nodoc
class __$SwipeResultCopyWithImpl<$Res>
    implements _$SwipeResultCopyWith<$Res> {
  __$SwipeResultCopyWithImpl(this._self, this._then);

  final _SwipeResult _self;
  final $Res Function(_SwipeResult) _then;

/// Create a copy of SwipeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matched = null,Object? matchId = freezed,Object? conversationId = freezed,}) {
  return _then(_SwipeResult(
matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,matchId: freezed == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String?,conversationId: freezed == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DeckState {

 List<DiscoverCandidate> get cards; DiscoverCandidate? get lastSwiped;/// Last swipe/undo error, shown once by the screen.
 Object? get error;
/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckStateCopyWith<DeckState> get copyWith => _$DeckStateCopyWithImpl<DeckState>(this as DeckState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeckState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeckState&&const DeepCollectionEquality().equals(other.cards, _this.cards)&&(identical(other.lastSwiped, _this.lastSwiped) || other.lastSwiped == _this.lastSwiped)&&const DeepCollectionEquality().equals(other.error, _this.error));
}


@override
int get hashCode {
  final _this = this as DeckState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.cards),_this.lastSwiped,const DeepCollectionEquality().hash(_this.error));
}

@override
String toString() {
  final _this = this as DeckState;
  return 'DeckState(cards: ${_this.cards}, lastSwiped: ${_this.lastSwiped}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $DeckStateCopyWith<$Res>  {
  factory $DeckStateCopyWith(DeckState value, $Res Function(DeckState) _then) = _$DeckStateCopyWithImpl;
@useResult
$Res call({
 List<DiscoverCandidate> cards, DiscoverCandidate? lastSwiped, Object? error
});


$DiscoverCandidateCopyWith<$Res>? get lastSwiped;

}
/// @nodoc
class _$DeckStateCopyWithImpl<$Res>
    implements $DeckStateCopyWith<$Res> {
  _$DeckStateCopyWithImpl(this._self, this._then);

  final DeckState _self;
  final $Res Function(DeckState) _then;

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cards = null,Object? lastSwiped = freezed,Object? error = freezed,}) {
  return _then(DeckState(
cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<DiscoverCandidate>,lastSwiped: freezed == lastSwiped ? _self.lastSwiped : lastSwiped // ignore: cast_nullable_to_non_nullable
as DiscoverCandidate?,error: freezed == error ? _self.error : error ,
  ));
}
/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoverCandidateCopyWith<$Res>? get lastSwiped {
    if (_self.lastSwiped == null) {
    return null;
  }

  return $DiscoverCandidateCopyWith<$Res>(_self.lastSwiped!, (value) {
    return _then(_self.copyWith(lastSwiped: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeckState].
extension DeckStatePatterns on DeckState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeckState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeckState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeckState value)  $default,){
final _that = this;
switch (_that) {
case _DeckState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeckState value)?  $default,){
final _that = this;
switch (_that) {
case _DeckState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiscoverCandidate> cards,  DiscoverCandidate? lastSwiped,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeckState() when $default != null:
return $default(_that.cards,_that.lastSwiped,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiscoverCandidate> cards,  DiscoverCandidate? lastSwiped,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _DeckState():
return $default(_that.cards,_that.lastSwiped,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiscoverCandidate> cards,  DiscoverCandidate? lastSwiped,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _DeckState() when $default != null:
return $default(_that.cards,_that.lastSwiped,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DeckState extends DeckState {
  const _DeckState({required  List<DiscoverCandidate> cards, this.lastSwiped, this.error}): _cards = cards,super._();
  

 final  List<DiscoverCandidate> _cards;
@override List<DiscoverCandidate> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override final  DiscoverCandidate? lastSwiped;
/// Last swipe/undo error, shown once by the screen.
@override final  Object? error;

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckStateCopyWith<_DeckState> get copyWith => __$DeckStateCopyWithImpl<_DeckState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeckState&&const DeepCollectionEquality().equals(other.cards, _cards)&&(identical(other.lastSwiped, lastSwiped) || other.lastSwiped == lastSwiped)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_cards),lastSwiped,const DeepCollectionEquality().hash(error));
}

@override
String toString() {
    return 'DeckState(cards: $cards, lastSwiped: $lastSwiped, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DeckStateCopyWith<$Res> implements $DeckStateCopyWith<$Res> {
  factory _$DeckStateCopyWith(_DeckState value, $Res Function(_DeckState) _then) = __$DeckStateCopyWithImpl;
@override @useResult
$Res call({
 List<DiscoverCandidate> cards, DiscoverCandidate? lastSwiped, Object? error
});


@override $DiscoverCandidateCopyWith<$Res>? get lastSwiped;

}
/// @nodoc
class __$DeckStateCopyWithImpl<$Res>
    implements _$DeckStateCopyWith<$Res> {
  __$DeckStateCopyWithImpl(this._self, this._then);

  final _DeckState _self;
  final $Res Function(_DeckState) _then;

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cards = null,Object? lastSwiped = freezed,Object? error = freezed,}) {
  return _then(_DeckState(
cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<DiscoverCandidate>,lastSwiped: freezed == lastSwiped ? _self.lastSwiped : lastSwiped // ignore: cast_nullable_to_non_nullable
as DiscoverCandidate?,error: freezed == error ? _self.error : error ,
  ));
}

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoverCandidateCopyWith<$Res>? get lastSwiped {
    if (_self.lastSwiped == null) {
    return null;
  }

  return $DiscoverCandidateCopyWith<$Res>(_self.lastSwiped!, (value) {
    return _then(_self.copyWith(lastSwiped: value));
  });
}
}

// dart format on
