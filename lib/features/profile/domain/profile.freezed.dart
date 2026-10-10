// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyProfile {

 String get id; String? get firstName; String? get lastName; DateTime? get birthDate; Gender? get gender; SexualOrientation? get orientation; bool get showOrientation; String? get city; String? get state; double? get lat; double? get lng; String? get occupation; String? get bio; int? get heightCm; List<String> get languages; ZodiacSign? get zodiac; HabitFrequency? get drinks; HabitFrequency? get smokes; List<Pet> get pets; List<MusicGenre> get musicGenres; List<String> get favoriteDjs; List<AppMode> get modes; DateIntent? get dateLookingFor; List<Gender> get dateShowMe; int get dateAgeMin; int get dateAgeMax; bool get crewSameGenderOnly; int get discoveryRadiusKm; UserRole get role; bool get isVerified; bool get onboardingCompleted; int get onboardingStep;
/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileCopyWith<MyProfile> get copyWith => _$MyProfileCopyWithImpl<MyProfile>(this as MyProfile, _$identity);

  /// Serializes this MyProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.orientation, _this.orientation) || other.orientation == _this.orientation)&&(identical(other.showOrientation, _this.showOrientation) || other.showOrientation == _this.showOrientation)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.occupation, _this.occupation) || other.occupation == _this.occupation)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&const DeepCollectionEquality().equals(other.languages, _this.languages)&&(identical(other.zodiac, _this.zodiac) || other.zodiac == _this.zodiac)&&(identical(other.drinks, _this.drinks) || other.drinks == _this.drinks)&&(identical(other.smokes, _this.smokes) || other.smokes == _this.smokes)&&const DeepCollectionEquality().equals(other.pets, _this.pets)&&const DeepCollectionEquality().equals(other.musicGenres, _this.musicGenres)&&const DeepCollectionEquality().equals(other.favoriteDjs, _this.favoriteDjs)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.dateLookingFor, _this.dateLookingFor) || other.dateLookingFor == _this.dateLookingFor)&&const DeepCollectionEquality().equals(other.dateShowMe, _this.dateShowMe)&&(identical(other.dateAgeMin, _this.dateAgeMin) || other.dateAgeMin == _this.dateAgeMin)&&(identical(other.dateAgeMax, _this.dateAgeMax) || other.dateAgeMax == _this.dateAgeMax)&&(identical(other.crewSameGenderOnly, _this.crewSameGenderOnly) || other.crewSameGenderOnly == _this.crewSameGenderOnly)&&(identical(other.discoveryRadiusKm, _this.discoveryRadiusKm) || other.discoveryRadiusKm == _this.discoveryRadiusKm)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.isVerified, _this.isVerified) || other.isVerified == _this.isVerified)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted)&&(identical(other.onboardingStep, _this.onboardingStep) || other.onboardingStep == _this.onboardingStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyProfile;
  return Object.hashAll([runtimeType,_this.id,_this.firstName,_this.lastName,_this.birthDate,_this.gender,_this.orientation,_this.showOrientation,_this.city,_this.state,_this.lat,_this.lng,_this.occupation,_this.bio,_this.heightCm,const DeepCollectionEquality().hash(_this.languages),_this.zodiac,_this.drinks,_this.smokes,const DeepCollectionEquality().hash(_this.pets),const DeepCollectionEquality().hash(_this.musicGenres),const DeepCollectionEquality().hash(_this.favoriteDjs),const DeepCollectionEquality().hash(_this.modes),_this.dateLookingFor,const DeepCollectionEquality().hash(_this.dateShowMe),_this.dateAgeMin,_this.dateAgeMax,_this.crewSameGenderOnly,_this.discoveryRadiusKm,_this.role,_this.isVerified,_this.onboardingCompleted,_this.onboardingStep]);
}

@override
String toString() {
  final _this = this as MyProfile;
  return 'MyProfile(id: ${_this.id}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, birthDate: ${_this.birthDate}, gender: ${_this.gender}, orientation: ${_this.orientation}, showOrientation: ${_this.showOrientation}, city: ${_this.city}, state: ${_this.state}, lat: ${_this.lat}, lng: ${_this.lng}, occupation: ${_this.occupation}, bio: ${_this.bio}, heightCm: ${_this.heightCm}, languages: ${_this.languages}, zodiac: ${_this.zodiac}, drinks: ${_this.drinks}, smokes: ${_this.smokes}, pets: ${_this.pets}, musicGenres: ${_this.musicGenres}, favoriteDjs: ${_this.favoriteDjs}, modes: ${_this.modes}, dateLookingFor: ${_this.dateLookingFor}, dateShowMe: ${_this.dateShowMe}, dateAgeMin: ${_this.dateAgeMin}, dateAgeMax: ${_this.dateAgeMax}, crewSameGenderOnly: ${_this.crewSameGenderOnly}, discoveryRadiusKm: ${_this.discoveryRadiusKm}, role: ${_this.role}, isVerified: ${_this.isVerified}, onboardingCompleted: ${_this.onboardingCompleted}, onboardingStep: ${_this.onboardingStep})';
}


}

/// @nodoc
abstract mixin class $MyProfileCopyWith<$Res>  {
  factory $MyProfileCopyWith(MyProfile value, $Res Function(MyProfile) _then) = _$MyProfileCopyWithImpl;
@useResult
$Res call({
 String id, String? firstName, String? lastName, DateTime? birthDate, Gender? gender, SexualOrientation? orientation, bool showOrientation, String? city, String? state, double? lat, double? lng, String? occupation, String? bio, int? heightCm, List<String> languages, ZodiacSign? zodiac, HabitFrequency? drinks, HabitFrequency? smokes, List<Pet> pets, List<MusicGenre> musicGenres, List<String> favoriteDjs, List<AppMode> modes, DateIntent? dateLookingFor, List<Gender> dateShowMe, int dateAgeMin, int dateAgeMax, bool crewSameGenderOnly, int discoveryRadiusKm, UserRole role, bool isVerified, bool onboardingCompleted, int onboardingStep
});




}
/// @nodoc
class _$MyProfileCopyWithImpl<$Res>
    implements $MyProfileCopyWith<$Res> {
  _$MyProfileCopyWithImpl(this._self, this._then);

  final MyProfile _self;
  final $Res Function(MyProfile) _then;

/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? orientation = freezed,Object? showOrientation = null,Object? city = freezed,Object? state = freezed,Object? lat = freezed,Object? lng = freezed,Object? occupation = freezed,Object? bio = freezed,Object? heightCm = freezed,Object? languages = null,Object? zodiac = freezed,Object? drinks = freezed,Object? smokes = freezed,Object? pets = null,Object? musicGenres = null,Object? favoriteDjs = null,Object? modes = null,Object? dateLookingFor = freezed,Object? dateShowMe = null,Object? dateAgeMin = null,Object? dateAgeMax = null,Object? crewSameGenderOnly = null,Object? discoveryRadiusKm = null,Object? role = null,Object? isVerified = null,Object? onboardingCompleted = null,Object? onboardingStep = null,}) {
  return _then(MyProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,orientation: freezed == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,showOrientation: null == showOrientation ? _self.showOrientation : showOrientation // ignore: cast_nullable_to_non_nullable
as bool,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as ZodiacSign?,drinks: freezed == drinks ? _self.drinks : drinks // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,pets: null == pets ? _self.pets : pets // ignore: cast_nullable_to_non_nullable
as List<Pet>,musicGenres: null == musicGenres ? _self.musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,favoriteDjs: null == favoriteDjs ? _self.favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,dateShowMe: null == dateShowMe ? _self.dateShowMe : dateShowMe // ignore: cast_nullable_to_non_nullable
as List<Gender>,dateAgeMin: null == dateAgeMin ? _self.dateAgeMin : dateAgeMin // ignore: cast_nullable_to_non_nullable
as int,dateAgeMax: null == dateAgeMax ? _self.dateAgeMax : dateAgeMax // ignore: cast_nullable_to_non_nullable
as int,crewSameGenderOnly: null == crewSameGenderOnly ? _self.crewSameGenderOnly : crewSameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,discoveryRadiusKm: null == discoveryRadiusKm ? _self.discoveryRadiusKm : discoveryRadiusKm // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,onboardingStep: null == onboardingStep ? _self.onboardingStep : onboardingStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyProfile].
extension MyProfilePatterns on MyProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfile value)  $default,){
final _that = this;
switch (_that) {
case _MyProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName,  DateTime? birthDate,  Gender? gender,  SexualOrientation? orientation,  bool showOrientation,  String? city,  String? state,  double? lat,  double? lng,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  List<Gender> dateShowMe,  int dateAgeMin,  int dateAgeMax,  bool crewSameGenderOnly,  int discoveryRadiusKm,  UserRole role,  bool isVerified,  bool onboardingCompleted,  int onboardingStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.orientation,_that.showOrientation,_that.city,_that.state,_that.lat,_that.lng,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.dateShowMe,_that.dateAgeMin,_that.dateAgeMax,_that.crewSameGenderOnly,_that.discoveryRadiusKm,_that.role,_that.isVerified,_that.onboardingCompleted,_that.onboardingStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName,  DateTime? birthDate,  Gender? gender,  SexualOrientation? orientation,  bool showOrientation,  String? city,  String? state,  double? lat,  double? lng,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  List<Gender> dateShowMe,  int dateAgeMin,  int dateAgeMax,  bool crewSameGenderOnly,  int discoveryRadiusKm,  UserRole role,  bool isVerified,  bool onboardingCompleted,  int onboardingStep)  $default,) {final _that = this;
switch (_that) {
case _MyProfile():
return $default(_that.id,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.orientation,_that.showOrientation,_that.city,_that.state,_that.lat,_that.lng,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.dateShowMe,_that.dateAgeMin,_that.dateAgeMax,_that.crewSameGenderOnly,_that.discoveryRadiusKm,_that.role,_that.isVerified,_that.onboardingCompleted,_that.onboardingStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? firstName,  String? lastName,  DateTime? birthDate,  Gender? gender,  SexualOrientation? orientation,  bool showOrientation,  String? city,  String? state,  double? lat,  double? lng,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  List<Gender> dateShowMe,  int dateAgeMin,  int dateAgeMax,  bool crewSameGenderOnly,  int discoveryRadiusKm,  UserRole role,  bool isVerified,  bool onboardingCompleted,  int onboardingStep)?  $default,) {final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.birthDate,_that.gender,_that.orientation,_that.showOrientation,_that.city,_that.state,_that.lat,_that.lng,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.dateShowMe,_that.dateAgeMin,_that.dateAgeMax,_that.crewSameGenderOnly,_that.discoveryRadiusKm,_that.role,_that.isVerified,_that.onboardingCompleted,_that.onboardingStep);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfile implements MyProfile {
  const _MyProfile({required this.id, this.firstName, this.lastName, this.birthDate, this.gender, this.orientation, this.showOrientation = false, this.city, this.state, this.lat, this.lng, this.occupation, this.bio, this.heightCm,  List<String> languages = const [], this.zodiac, this.drinks, this.smokes,  List<Pet> pets = const [],  List<MusicGenre> musicGenres = const [],  List<String> favoriteDjs = const [],  List<AppMode> modes = const [], this.dateLookingFor,  List<Gender> dateShowMe = const [], this.dateAgeMin = 18, this.dateAgeMax = 99, this.crewSameGenderOnly = false, this.discoveryRadiusKm = 50, this.role = UserRole.user, this.isVerified = false, this.onboardingCompleted = false, this.onboardingStep = 0}): _languages = languages,_pets = pets,_musicGenres = musicGenres,_favoriteDjs = favoriteDjs,_modes = modes,_dateShowMe = dateShowMe;
  factory _MyProfile.fromJson(Map<String, dynamic> json) => _$MyProfileFromJson(json);

@override final  String id;
@override final  String? firstName;
@override final  String? lastName;
@override final  DateTime? birthDate;
@override final  Gender? gender;
@override final  SexualOrientation? orientation;
@override@JsonKey() final  bool showOrientation;
@override final  String? city;
@override final  String? state;
@override final  double? lat;
@override final  double? lng;
@override final  String? occupation;
@override final  String? bio;
@override final  int? heightCm;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  ZodiacSign? zodiac;
@override final  HabitFrequency? drinks;
@override final  HabitFrequency? smokes;
 final  List<Pet> _pets;
@override@JsonKey() List<Pet> get pets {
  if (_pets is EqualUnmodifiableListView) return _pets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pets);
}

 final  List<MusicGenre> _musicGenres;
@override@JsonKey() List<MusicGenre> get musicGenres {
  if (_musicGenres is EqualUnmodifiableListView) return _musicGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_musicGenres);
}

 final  List<String> _favoriteDjs;
@override@JsonKey() List<String> get favoriteDjs {
  if (_favoriteDjs is EqualUnmodifiableListView) return _favoriteDjs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteDjs);
}

 final  List<AppMode> _modes;
@override@JsonKey() List<AppMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override final  DateIntent? dateLookingFor;
 final  List<Gender> _dateShowMe;
@override@JsonKey() List<Gender> get dateShowMe {
  if (_dateShowMe is EqualUnmodifiableListView) return _dateShowMe;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dateShowMe);
}

@override@JsonKey() final  int dateAgeMin;
@override@JsonKey() final  int dateAgeMax;
@override@JsonKey() final  bool crewSameGenderOnly;
@override@JsonKey() final  int discoveryRadiusKm;
@override@JsonKey() final  UserRole role;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool onboardingCompleted;
@override@JsonKey() final  int onboardingStep;

/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileCopyWith<_MyProfile> get copyWith => __$MyProfileCopyWithImpl<_MyProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.showOrientation, showOrientation) || other.showOrientation == showOrientation)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&const DeepCollectionEquality().equals(other.languages, _languages)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.drinks, drinks) || other.drinks == drinks)&&(identical(other.smokes, smokes) || other.smokes == smokes)&&const DeepCollectionEquality().equals(other.pets, _pets)&&const DeepCollectionEquality().equals(other.musicGenres, _musicGenres)&&const DeepCollectionEquality().equals(other.favoriteDjs, _favoriteDjs)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.dateLookingFor, dateLookingFor) || other.dateLookingFor == dateLookingFor)&&const DeepCollectionEquality().equals(other.dateShowMe, _dateShowMe)&&(identical(other.dateAgeMin, dateAgeMin) || other.dateAgeMin == dateAgeMin)&&(identical(other.dateAgeMax, dateAgeMax) || other.dateAgeMax == dateAgeMax)&&(identical(other.crewSameGenderOnly, crewSameGenderOnly) || other.crewSameGenderOnly == crewSameGenderOnly)&&(identical(other.discoveryRadiusKm, discoveryRadiusKm) || other.discoveryRadiusKm == discoveryRadiusKm)&&(identical(other.role, role) || other.role == role)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.onboardingStep, onboardingStep) || other.onboardingStep == onboardingStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,firstName,lastName,birthDate,gender,orientation,showOrientation,city,state,lat,lng,occupation,bio,heightCm,const DeepCollectionEquality().hash(_languages),zodiac,drinks,smokes,const DeepCollectionEquality().hash(_pets),const DeepCollectionEquality().hash(_musicGenres),const DeepCollectionEquality().hash(_favoriteDjs),const DeepCollectionEquality().hash(_modes),dateLookingFor,const DeepCollectionEquality().hash(_dateShowMe),dateAgeMin,dateAgeMax,crewSameGenderOnly,discoveryRadiusKm,role,isVerified,onboardingCompleted,onboardingStep]);
}

@override
String toString() {
    return 'MyProfile(id: $id, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, gender: $gender, orientation: $orientation, showOrientation: $showOrientation, city: $city, state: $state, lat: $lat, lng: $lng, occupation: $occupation, bio: $bio, heightCm: $heightCm, languages: $languages, zodiac: $zodiac, drinks: $drinks, smokes: $smokes, pets: $pets, musicGenres: $musicGenres, favoriteDjs: $favoriteDjs, modes: $modes, dateLookingFor: $dateLookingFor, dateShowMe: $dateShowMe, dateAgeMin: $dateAgeMin, dateAgeMax: $dateAgeMax, crewSameGenderOnly: $crewSameGenderOnly, discoveryRadiusKm: $discoveryRadiusKm, role: $role, isVerified: $isVerified, onboardingCompleted: $onboardingCompleted, onboardingStep: $onboardingStep)';
}


}

/// @nodoc
abstract mixin class _$MyProfileCopyWith<$Res> implements $MyProfileCopyWith<$Res> {
  factory _$MyProfileCopyWith(_MyProfile value, $Res Function(_MyProfile) _then) = __$MyProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? firstName, String? lastName, DateTime? birthDate, Gender? gender, SexualOrientation? orientation, bool showOrientation, String? city, String? state, double? lat, double? lng, String? occupation, String? bio, int? heightCm, List<String> languages, ZodiacSign? zodiac, HabitFrequency? drinks, HabitFrequency? smokes, List<Pet> pets, List<MusicGenre> musicGenres, List<String> favoriteDjs, List<AppMode> modes, DateIntent? dateLookingFor, List<Gender> dateShowMe, int dateAgeMin, int dateAgeMax, bool crewSameGenderOnly, int discoveryRadiusKm, UserRole role, bool isVerified, bool onboardingCompleted, int onboardingStep
});




}
/// @nodoc
class __$MyProfileCopyWithImpl<$Res>
    implements _$MyProfileCopyWith<$Res> {
  __$MyProfileCopyWithImpl(this._self, this._then);

  final _MyProfile _self;
  final $Res Function(_MyProfile) _then;

/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? orientation = freezed,Object? showOrientation = null,Object? city = freezed,Object? state = freezed,Object? lat = freezed,Object? lng = freezed,Object? occupation = freezed,Object? bio = freezed,Object? heightCm = freezed,Object? languages = null,Object? zodiac = freezed,Object? drinks = freezed,Object? smokes = freezed,Object? pets = null,Object? musicGenres = null,Object? favoriteDjs = null,Object? modes = null,Object? dateLookingFor = freezed,Object? dateShowMe = null,Object? dateAgeMin = null,Object? dateAgeMax = null,Object? crewSameGenderOnly = null,Object? discoveryRadiusKm = null,Object? role = null,Object? isVerified = null,Object? onboardingCompleted = null,Object? onboardingStep = null,}) {
  return _then(_MyProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,orientation: freezed == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,showOrientation: null == showOrientation ? _self.showOrientation : showOrientation // ignore: cast_nullable_to_non_nullable
as bool,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as ZodiacSign?,drinks: freezed == drinks ? _self.drinks : drinks // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,pets: null == pets ? _self._pets : pets // ignore: cast_nullable_to_non_nullable
as List<Pet>,musicGenres: null == musicGenres ? _self._musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,favoriteDjs: null == favoriteDjs ? _self._favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,dateShowMe: null == dateShowMe ? _self._dateShowMe : dateShowMe // ignore: cast_nullable_to_non_nullable
as List<Gender>,dateAgeMin: null == dateAgeMin ? _self.dateAgeMin : dateAgeMin // ignore: cast_nullable_to_non_nullable
as int,dateAgeMax: null == dateAgeMax ? _self.dateAgeMax : dateAgeMax // ignore: cast_nullable_to_non_nullable
as int,crewSameGenderOnly: null == crewSameGenderOnly ? _self.crewSameGenderOnly : crewSameGenderOnly // ignore: cast_nullable_to_non_nullable
as bool,discoveryRadiusKm: null == discoveryRadiusKm ? _self.discoveryRadiusKm : discoveryRadiusKm // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,onboardingStep: null == onboardingStep ? _self.onboardingStep : onboardingStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PublicProfile {

 String get id; String get firstName; int get age; Gender? get gender; SexualOrientation? get orientation; String? get city; String? get state; String? get occupation; String? get bio; int? get heightCm; List<String> get languages; ZodiacSign? get zodiac; HabitFrequency? get drinks; HabitFrequency? get smokes; List<Pet> get pets; List<MusicGenre> get musicGenres; List<String> get favoriteDjs; List<AppMode> get modes; DateIntent? get dateLookingFor; bool get isVerified;
/// Create a copy of PublicProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicProfileCopyWith<PublicProfile> get copyWith => _$PublicProfileCopyWithImpl<PublicProfile>(this as PublicProfile, _$identity);

  /// Serializes this PublicProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PublicProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.orientation, _this.orientation) || other.orientation == _this.orientation)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.occupation, _this.occupation) || other.occupation == _this.occupation)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&const DeepCollectionEquality().equals(other.languages, _this.languages)&&(identical(other.zodiac, _this.zodiac) || other.zodiac == _this.zodiac)&&(identical(other.drinks, _this.drinks) || other.drinks == _this.drinks)&&(identical(other.smokes, _this.smokes) || other.smokes == _this.smokes)&&const DeepCollectionEquality().equals(other.pets, _this.pets)&&const DeepCollectionEquality().equals(other.musicGenres, _this.musicGenres)&&const DeepCollectionEquality().equals(other.favoriteDjs, _this.favoriteDjs)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.dateLookingFor, _this.dateLookingFor) || other.dateLookingFor == _this.dateLookingFor)&&(identical(other.isVerified, _this.isVerified) || other.isVerified == _this.isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PublicProfile;
  return Object.hashAll([runtimeType,_this.id,_this.firstName,_this.age,_this.gender,_this.orientation,_this.city,_this.state,_this.occupation,_this.bio,_this.heightCm,const DeepCollectionEquality().hash(_this.languages),_this.zodiac,_this.drinks,_this.smokes,const DeepCollectionEquality().hash(_this.pets),const DeepCollectionEquality().hash(_this.musicGenres),const DeepCollectionEquality().hash(_this.favoriteDjs),const DeepCollectionEquality().hash(_this.modes),_this.dateLookingFor,_this.isVerified]);
}

@override
String toString() {
  final _this = this as PublicProfile;
  return 'PublicProfile(id: ${_this.id}, firstName: ${_this.firstName}, age: ${_this.age}, gender: ${_this.gender}, orientation: ${_this.orientation}, city: ${_this.city}, state: ${_this.state}, occupation: ${_this.occupation}, bio: ${_this.bio}, heightCm: ${_this.heightCm}, languages: ${_this.languages}, zodiac: ${_this.zodiac}, drinks: ${_this.drinks}, smokes: ${_this.smokes}, pets: ${_this.pets}, musicGenres: ${_this.musicGenres}, favoriteDjs: ${_this.favoriteDjs}, modes: ${_this.modes}, dateLookingFor: ${_this.dateLookingFor}, isVerified: ${_this.isVerified})';
}


}

/// @nodoc
abstract mixin class $PublicProfileCopyWith<$Res>  {
  factory $PublicProfileCopyWith(PublicProfile value, $Res Function(PublicProfile) _then) = _$PublicProfileCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, int age, Gender? gender, SexualOrientation? orientation, String? city, String? state, String? occupation, String? bio, int? heightCm, List<String> languages, ZodiacSign? zodiac, HabitFrequency? drinks, HabitFrequency? smokes, List<Pet> pets, List<MusicGenre> musicGenres, List<String> favoriteDjs, List<AppMode> modes, DateIntent? dateLookingFor, bool isVerified
});




}
/// @nodoc
class _$PublicProfileCopyWithImpl<$Res>
    implements $PublicProfileCopyWith<$Res> {
  _$PublicProfileCopyWithImpl(this._self, this._then);

  final PublicProfile _self;
  final $Res Function(PublicProfile) _then;

/// Create a copy of PublicProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? age = null,Object? gender = freezed,Object? orientation = freezed,Object? city = freezed,Object? state = freezed,Object? occupation = freezed,Object? bio = freezed,Object? heightCm = freezed,Object? languages = null,Object? zodiac = freezed,Object? drinks = freezed,Object? smokes = freezed,Object? pets = null,Object? musicGenres = null,Object? favoriteDjs = null,Object? modes = null,Object? dateLookingFor = freezed,Object? isVerified = null,}) {
  return _then(PublicProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,orientation: freezed == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as ZodiacSign?,drinks: freezed == drinks ? _self.drinks : drinks // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,pets: null == pets ? _self.pets : pets // ignore: cast_nullable_to_non_nullable
as List<Pet>,musicGenres: null == musicGenres ? _self.musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,favoriteDjs: null == favoriteDjs ? _self.favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicProfile].
extension PublicProfilePatterns on PublicProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicProfile value)  $default,){
final _that = this;
switch (_that) {
case _PublicProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PublicProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  int age,  Gender? gender,  SexualOrientation? orientation,  String? city,  String? state,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.age,_that.gender,_that.orientation,_that.city,_that.state,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  int age,  Gender? gender,  SexualOrientation? orientation,  String? city,  String? state,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _PublicProfile():
return $default(_that.id,_that.firstName,_that.age,_that.gender,_that.orientation,_that.city,_that.state,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  int age,  Gender? gender,  SexualOrientation? orientation,  String? city,  String? state,  String? occupation,  String? bio,  int? heightCm,  List<String> languages,  ZodiacSign? zodiac,  HabitFrequency? drinks,  HabitFrequency? smokes,  List<Pet> pets,  List<MusicGenre> musicGenres,  List<String> favoriteDjs,  List<AppMode> modes,  DateIntent? dateLookingFor,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _PublicProfile() when $default != null:
return $default(_that.id,_that.firstName,_that.age,_that.gender,_that.orientation,_that.city,_that.state,_that.occupation,_that.bio,_that.heightCm,_that.languages,_that.zodiac,_that.drinks,_that.smokes,_that.pets,_that.musicGenres,_that.favoriteDjs,_that.modes,_that.dateLookingFor,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicProfile implements PublicProfile {
  const _PublicProfile({required this.id, required this.firstName, required this.age, this.gender, this.orientation, this.city, this.state, this.occupation, this.bio, this.heightCm,  List<String> languages = const [], this.zodiac, this.drinks, this.smokes,  List<Pet> pets = const [],  List<MusicGenre> musicGenres = const [],  List<String> favoriteDjs = const [],  List<AppMode> modes = const [], this.dateLookingFor, this.isVerified = false}): _languages = languages,_pets = pets,_musicGenres = musicGenres,_favoriteDjs = favoriteDjs,_modes = modes;
  factory _PublicProfile.fromJson(Map<String, dynamic> json) => _$PublicProfileFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  int age;
@override final  Gender? gender;
@override final  SexualOrientation? orientation;
@override final  String? city;
@override final  String? state;
@override final  String? occupation;
@override final  String? bio;
@override final  int? heightCm;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  ZodiacSign? zodiac;
@override final  HabitFrequency? drinks;
@override final  HabitFrequency? smokes;
 final  List<Pet> _pets;
@override@JsonKey() List<Pet> get pets {
  if (_pets is EqualUnmodifiableListView) return _pets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pets);
}

 final  List<MusicGenre> _musicGenres;
@override@JsonKey() List<MusicGenre> get musicGenres {
  if (_musicGenres is EqualUnmodifiableListView) return _musicGenres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_musicGenres);
}

 final  List<String> _favoriteDjs;
@override@JsonKey() List<String> get favoriteDjs {
  if (_favoriteDjs is EqualUnmodifiableListView) return _favoriteDjs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteDjs);
}

 final  List<AppMode> _modes;
@override@JsonKey() List<AppMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override final  DateIntent? dateLookingFor;
@override@JsonKey() final  bool isVerified;

/// Create a copy of PublicProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicProfileCopyWith<_PublicProfile> get copyWith => __$PublicProfileCopyWithImpl<_PublicProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.orientation, orientation) || other.orientation == orientation)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&const DeepCollectionEquality().equals(other.languages, _languages)&&(identical(other.zodiac, zodiac) || other.zodiac == zodiac)&&(identical(other.drinks, drinks) || other.drinks == drinks)&&(identical(other.smokes, smokes) || other.smokes == smokes)&&const DeepCollectionEquality().equals(other.pets, _pets)&&const DeepCollectionEquality().equals(other.musicGenres, _musicGenres)&&const DeepCollectionEquality().equals(other.favoriteDjs, _favoriteDjs)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.dateLookingFor, dateLookingFor) || other.dateLookingFor == dateLookingFor)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,firstName,age,gender,orientation,city,state,occupation,bio,heightCm,const DeepCollectionEquality().hash(_languages),zodiac,drinks,smokes,const DeepCollectionEquality().hash(_pets),const DeepCollectionEquality().hash(_musicGenres),const DeepCollectionEquality().hash(_favoriteDjs),const DeepCollectionEquality().hash(_modes),dateLookingFor,isVerified]);
}

@override
String toString() {
    return 'PublicProfile(id: $id, firstName: $firstName, age: $age, gender: $gender, orientation: $orientation, city: $city, state: $state, occupation: $occupation, bio: $bio, heightCm: $heightCm, languages: $languages, zodiac: $zodiac, drinks: $drinks, smokes: $smokes, pets: $pets, musicGenres: $musicGenres, favoriteDjs: $favoriteDjs, modes: $modes, dateLookingFor: $dateLookingFor, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$PublicProfileCopyWith<$Res> implements $PublicProfileCopyWith<$Res> {
  factory _$PublicProfileCopyWith(_PublicProfile value, $Res Function(_PublicProfile) _then) = __$PublicProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, int age, Gender? gender, SexualOrientation? orientation, String? city, String? state, String? occupation, String? bio, int? heightCm, List<String> languages, ZodiacSign? zodiac, HabitFrequency? drinks, HabitFrequency? smokes, List<Pet> pets, List<MusicGenre> musicGenres, List<String> favoriteDjs, List<AppMode> modes, DateIntent? dateLookingFor, bool isVerified
});




}
/// @nodoc
class __$PublicProfileCopyWithImpl<$Res>
    implements _$PublicProfileCopyWith<$Res> {
  __$PublicProfileCopyWithImpl(this._self, this._then);

  final _PublicProfile _self;
  final $Res Function(_PublicProfile) _then;

/// Create a copy of PublicProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? age = null,Object? gender = freezed,Object? orientation = freezed,Object? city = freezed,Object? state = freezed,Object? occupation = freezed,Object? bio = freezed,Object? heightCm = freezed,Object? languages = null,Object? zodiac = freezed,Object? drinks = freezed,Object? smokes = freezed,Object? pets = null,Object? musicGenres = null,Object? favoriteDjs = null,Object? modes = null,Object? dateLookingFor = freezed,Object? isVerified = null,}) {
  return _then(_PublicProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,orientation: freezed == orientation ? _self.orientation : orientation // ignore: cast_nullable_to_non_nullable
as SexualOrientation?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,zodiac: freezed == zodiac ? _self.zodiac : zodiac // ignore: cast_nullable_to_non_nullable
as ZodiacSign?,drinks: freezed == drinks ? _self.drinks : drinks // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as HabitFrequency?,pets: null == pets ? _self._pets : pets // ignore: cast_nullable_to_non_nullable
as List<Pet>,musicGenres: null == musicGenres ? _self._musicGenres : musicGenres // ignore: cast_nullable_to_non_nullable
as List<MusicGenre>,favoriteDjs: null == favoriteDjs ? _self._favoriteDjs : favoriteDjs // ignore: cast_nullable_to_non_nullable
as List<String>,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<AppMode>,dateLookingFor: freezed == dateLookingFor ? _self.dateLookingFor : dateLookingFor // ignore: cast_nullable_to_non_nullable
as DateIntent?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProfilePhoto {

 String get id; String get userId; String get storagePath; int get position;
/// Create a copy of ProfilePhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilePhotoCopyWith<ProfilePhoto> get copyWith => _$ProfilePhotoCopyWithImpl<ProfilePhoto>(this as ProfilePhoto, _$identity);

  /// Serializes this ProfilePhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfilePhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilePhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.position, _this.position) || other.position == _this.position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfilePhoto;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.storagePath,_this.position);
}

@override
String toString() {
  final _this = this as ProfilePhoto;
  return 'ProfilePhoto(id: ${_this.id}, userId: ${_this.userId}, storagePath: ${_this.storagePath}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $ProfilePhotoCopyWith<$Res>  {
  factory $ProfilePhotoCopyWith(ProfilePhoto value, $Res Function(ProfilePhoto) _then) = _$ProfilePhotoCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String storagePath, int position
});




}
/// @nodoc
class _$ProfilePhotoCopyWithImpl<$Res>
    implements $ProfilePhotoCopyWith<$Res> {
  _$ProfilePhotoCopyWithImpl(this._self, this._then);

  final ProfilePhoto _self;
  final $Res Function(ProfilePhoto) _then;

/// Create a copy of ProfilePhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? storagePath = null,Object? position = null,}) {
  return _then(ProfilePhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilePhoto].
extension ProfilePhotoPatterns on ProfilePhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfilePhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfilePhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfilePhoto value)  $default,){
final _that = this;
switch (_that) {
case _ProfilePhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfilePhoto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfilePhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String storagePath,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfilePhoto() when $default != null:
return $default(_that.id,_that.userId,_that.storagePath,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String storagePath,  int position)  $default,) {final _that = this;
switch (_that) {
case _ProfilePhoto():
return $default(_that.id,_that.userId,_that.storagePath,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String storagePath,  int position)?  $default,) {final _that = this;
switch (_that) {
case _ProfilePhoto() when $default != null:
return $default(_that.id,_that.userId,_that.storagePath,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfilePhoto implements ProfilePhoto {
  const _ProfilePhoto({required this.id, required this.userId, required this.storagePath, required this.position});
  factory _ProfilePhoto.fromJson(Map<String, dynamic> json) => _$ProfilePhotoFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String storagePath;
@override final  int position;

/// Create a copy of ProfilePhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilePhotoCopyWith<_ProfilePhoto> get copyWith => __$ProfilePhotoCopyWithImpl<_ProfilePhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfilePhotoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfilePhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,storagePath,position);
}

@override
String toString() {
    return 'ProfilePhoto(id: $id, userId: $userId, storagePath: $storagePath, position: $position)';
}


}

/// @nodoc
abstract mixin class _$ProfilePhotoCopyWith<$Res> implements $ProfilePhotoCopyWith<$Res> {
  factory _$ProfilePhotoCopyWith(_ProfilePhoto value, $Res Function(_ProfilePhoto) _then) = __$ProfilePhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String storagePath, int position
});




}
/// @nodoc
class __$ProfilePhotoCopyWithImpl<$Res>
    implements _$ProfilePhotoCopyWith<$Res> {
  __$ProfilePhotoCopyWithImpl(this._self, this._then);

  final _ProfilePhoto _self;
  final $Res Function(_ProfilePhoto) _then;

/// Create a copy of ProfilePhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? storagePath = null,Object? position = null,}) {
  return _then(_ProfilePhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
