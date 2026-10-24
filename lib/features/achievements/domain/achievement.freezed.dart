// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Achievement {

 AchievementKey get key; int get progress; int get goal; bool get unlocked;
/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AchievementCopyWith<Achievement> get copyWith => _$AchievementCopyWithImpl<Achievement>(this as Achievement, _$identity);

  /// Serializes this Achievement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Achievement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Achievement&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.unlocked, _this.unlocked) || other.unlocked == _this.unlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Achievement;
  return Object.hash(runtimeType,_this.key,_this.progress,_this.goal,_this.unlocked);
}

@override
String toString() {
  final _this = this as Achievement;
  return 'Achievement(key: ${_this.key}, progress: ${_this.progress}, goal: ${_this.goal}, unlocked: ${_this.unlocked})';
}


}

/// @nodoc
abstract mixin class $AchievementCopyWith<$Res>  {
  factory $AchievementCopyWith(Achievement value, $Res Function(Achievement) _then) = _$AchievementCopyWithImpl;
@useResult
$Res call({
 AchievementKey key, int progress, int goal, bool unlocked
});




}
/// @nodoc
class _$AchievementCopyWithImpl<$Res>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._self, this._then);

  final Achievement _self;
  final $Res Function(Achievement) _then;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? progress = null,Object? goal = null,Object? unlocked = null,}) {
  return _then(Achievement(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as AchievementKey,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Achievement].
extension AchievementPatterns on Achievement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Achievement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Achievement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Achievement value)  $default,){
final _that = this;
switch (_that) {
case _Achievement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Achievement value)?  $default,){
final _that = this;
switch (_that) {
case _Achievement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AchievementKey key,  int progress,  int goal,  bool unlocked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Achievement() when $default != null:
return $default(_that.key,_that.progress,_that.goal,_that.unlocked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AchievementKey key,  int progress,  int goal,  bool unlocked)  $default,) {final _that = this;
switch (_that) {
case _Achievement():
return $default(_that.key,_that.progress,_that.goal,_that.unlocked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AchievementKey key,  int progress,  int goal,  bool unlocked)?  $default,) {final _that = this;
switch (_that) {
case _Achievement() when $default != null:
return $default(_that.key,_that.progress,_that.goal,_that.unlocked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Achievement implements Achievement {
  const _Achievement({required this.key, required this.progress, required this.goal, required this.unlocked});
  factory _Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);

@override final  AchievementKey key;
@override final  int progress;
@override final  int goal;
@override final  bool unlocked;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AchievementCopyWith<_Achievement> get copyWith => __$AchievementCopyWithImpl<_Achievement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AchievementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Achievement&&(identical(other.key, key) || other.key == key)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.unlocked, unlocked) || other.unlocked == unlocked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,progress,goal,unlocked);
}

@override
String toString() {
    return 'Achievement(key: $key, progress: $progress, goal: $goal, unlocked: $unlocked)';
}


}

/// @nodoc
abstract mixin class _$AchievementCopyWith<$Res> implements $AchievementCopyWith<$Res> {
  factory _$AchievementCopyWith(_Achievement value, $Res Function(_Achievement) _then) = __$AchievementCopyWithImpl;
@override @useResult
$Res call({
 AchievementKey key, int progress, int goal, bool unlocked
});




}
/// @nodoc
class __$AchievementCopyWithImpl<$Res>
    implements _$AchievementCopyWith<$Res> {
  __$AchievementCopyWithImpl(this._self, this._then);

  final _Achievement _self;
  final $Res Function(_Achievement) _then;

/// Create a copy of Achievement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? progress = null,Object? goal = null,Object? unlocked = null,}) {
  return _then(_Achievement(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as AchievementKey,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,unlocked: null == unlocked ? _self.unlocked : unlocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Passport {

 int get parties; int get venues; int get cities; int get genres;/// The whole history (Pulse Black).
 bool get full; List<EventSummary> get entries;
/// Create a copy of Passport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassportCopyWith<Passport> get copyWith => _$PassportCopyWithImpl<Passport>(this as Passport, _$identity);

  /// Serializes this Passport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Passport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Passport&&(identical(other.parties, _this.parties) || other.parties == _this.parties)&&(identical(other.venues, _this.venues) || other.venues == _this.venues)&&(identical(other.cities, _this.cities) || other.cities == _this.cities)&&(identical(other.genres, _this.genres) || other.genres == _this.genres)&&(identical(other.full, _this.full) || other.full == _this.full)&&const DeepCollectionEquality().equals(other.entries, _this.entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Passport;
  return Object.hash(runtimeType,_this.parties,_this.venues,_this.cities,_this.genres,_this.full,const DeepCollectionEquality().hash(_this.entries));
}

@override
String toString() {
  final _this = this as Passport;
  return 'Passport(parties: ${_this.parties}, venues: ${_this.venues}, cities: ${_this.cities}, genres: ${_this.genres}, full: ${_this.full}, entries: ${_this.entries})';
}


}

/// @nodoc
abstract mixin class $PassportCopyWith<$Res>  {
  factory $PassportCopyWith(Passport value, $Res Function(Passport) _then) = _$PassportCopyWithImpl;
@useResult
$Res call({
 int parties, int venues, int cities, int genres, bool full, List<EventSummary> entries
});




}
/// @nodoc
class _$PassportCopyWithImpl<$Res>
    implements $PassportCopyWith<$Res> {
  _$PassportCopyWithImpl(this._self, this._then);

  final Passport _self;
  final $Res Function(Passport) _then;

/// Create a copy of Passport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parties = null,Object? venues = null,Object? cities = null,Object? genres = null,Object? full = null,Object? entries = null,}) {
  return _then(Passport(
parties: null == parties ? _self.parties : parties // ignore: cast_nullable_to_non_nullable
as int,venues: null == venues ? _self.venues : venues // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as int,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [Passport].
extension PassportPatterns on Passport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Passport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Passport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Passport value)  $default,){
final _that = this;
switch (_that) {
case _Passport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Passport value)?  $default,){
final _that = this;
switch (_that) {
case _Passport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int parties,  int venues,  int cities,  int genres,  bool full,  List<EventSummary> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Passport() when $default != null:
return $default(_that.parties,_that.venues,_that.cities,_that.genres,_that.full,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int parties,  int venues,  int cities,  int genres,  bool full,  List<EventSummary> entries)  $default,) {final _that = this;
switch (_that) {
case _Passport():
return $default(_that.parties,_that.venues,_that.cities,_that.genres,_that.full,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int parties,  int venues,  int cities,  int genres,  bool full,  List<EventSummary> entries)?  $default,) {final _that = this;
switch (_that) {
case _Passport() when $default != null:
return $default(_that.parties,_that.venues,_that.cities,_that.genres,_that.full,_that.entries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Passport implements Passport {
  const _Passport({this.parties = 0, this.venues = 0, this.cities = 0, this.genres = 0, this.full = false,  List<EventSummary> entries = const []}): _entries = entries;
  factory _Passport.fromJson(Map<String, dynamic> json) => _$PassportFromJson(json);

@override@JsonKey() final  int parties;
@override@JsonKey() final  int venues;
@override@JsonKey() final  int cities;
@override@JsonKey() final  int genres;
/// The whole history (Pulse Black).
@override@JsonKey() final  bool full;
 final  List<EventSummary> _entries;
@override@JsonKey() List<EventSummary> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of Passport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PassportCopyWith<_Passport> get copyWith => __$PassportCopyWithImpl<_Passport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PassportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Passport&&(identical(other.parties, parties) || other.parties == parties)&&(identical(other.venues, venues) || other.venues == venues)&&(identical(other.cities, cities) || other.cities == cities)&&(identical(other.genres, genres) || other.genres == genres)&&(identical(other.full, full) || other.full == full)&&const DeepCollectionEquality().equals(other.entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,parties,venues,cities,genres,full,const DeepCollectionEquality().hash(_entries));
}

@override
String toString() {
    return 'Passport(parties: $parties, venues: $venues, cities: $cities, genres: $genres, full: $full, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$PassportCopyWith<$Res> implements $PassportCopyWith<$Res> {
  factory _$PassportCopyWith(_Passport value, $Res Function(_Passport) _then) = __$PassportCopyWithImpl;
@override @useResult
$Res call({
 int parties, int venues, int cities, int genres, bool full, List<EventSummary> entries
});




}
/// @nodoc
class __$PassportCopyWithImpl<$Res>
    implements _$PassportCopyWith<$Res> {
  __$PassportCopyWithImpl(this._self, this._then);

  final _Passport _self;
  final $Res Function(_Passport) _then;

/// Create a copy of Passport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parties = null,Object? venues = null,Object? cities = null,Object? genres = null,Object? full = null,Object? entries = null,}) {
  return _then(_Passport(
parties: null == parties ? _self.parties : parties // ignore: cast_nullable_to_non_nullable
as int,venues: null == venues ? _self.venues : venues // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as int,full: null == full ? _self.full : full // ignore: cast_nullable_to_non_nullable
as bool,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,
  ));
}


}

// dart format on
