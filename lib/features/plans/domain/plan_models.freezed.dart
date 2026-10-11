// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Entitlements {

 PlanTier? get tier; String? get source; DateTime? get expiresAt; bool get willRenew;/// null = unlimited.
 int? get likesLeftToday; int get freeSuperlikesLeft; int get superlikeBalance; int get freeBoostsLeft; int get boostBalance; DateTime? get boostEndsAt; String? get travelCity; String? get travelState; bool get incognito;
/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementsCopyWith<Entitlements> get copyWith => _$EntitlementsCopyWithImpl<Entitlements>(this as Entitlements, _$identity);

  /// Serializes this Entitlements to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Entitlements;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entitlements&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.willRenew, _this.willRenew) || other.willRenew == _this.willRenew)&&(identical(other.likesLeftToday, _this.likesLeftToday) || other.likesLeftToday == _this.likesLeftToday)&&(identical(other.freeSuperlikesLeft, _this.freeSuperlikesLeft) || other.freeSuperlikesLeft == _this.freeSuperlikesLeft)&&(identical(other.superlikeBalance, _this.superlikeBalance) || other.superlikeBalance == _this.superlikeBalance)&&(identical(other.freeBoostsLeft, _this.freeBoostsLeft) || other.freeBoostsLeft == _this.freeBoostsLeft)&&(identical(other.boostBalance, _this.boostBalance) || other.boostBalance == _this.boostBalance)&&(identical(other.boostEndsAt, _this.boostEndsAt) || other.boostEndsAt == _this.boostEndsAt)&&(identical(other.travelCity, _this.travelCity) || other.travelCity == _this.travelCity)&&(identical(other.travelState, _this.travelState) || other.travelState == _this.travelState)&&(identical(other.incognito, _this.incognito) || other.incognito == _this.incognito));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Entitlements;
  return Object.hash(runtimeType,_this.tier,_this.source,_this.expiresAt,_this.willRenew,_this.likesLeftToday,_this.freeSuperlikesLeft,_this.superlikeBalance,_this.freeBoostsLeft,_this.boostBalance,_this.boostEndsAt,_this.travelCity,_this.travelState,_this.incognito);
}

@override
String toString() {
  final _this = this as Entitlements;
  return 'Entitlements(tier: ${_this.tier}, source: ${_this.source}, expiresAt: ${_this.expiresAt}, willRenew: ${_this.willRenew}, likesLeftToday: ${_this.likesLeftToday}, freeSuperlikesLeft: ${_this.freeSuperlikesLeft}, superlikeBalance: ${_this.superlikeBalance}, freeBoostsLeft: ${_this.freeBoostsLeft}, boostBalance: ${_this.boostBalance}, boostEndsAt: ${_this.boostEndsAt}, travelCity: ${_this.travelCity}, travelState: ${_this.travelState}, incognito: ${_this.incognito})';
}


}

/// @nodoc
abstract mixin class $EntitlementsCopyWith<$Res>  {
  factory $EntitlementsCopyWith(Entitlements value, $Res Function(Entitlements) _then) = _$EntitlementsCopyWithImpl;
@useResult
$Res call({
 PlanTier? tier, String? source, DateTime? expiresAt, bool willRenew, int? likesLeftToday, int freeSuperlikesLeft, int superlikeBalance, int freeBoostsLeft, int boostBalance, DateTime? boostEndsAt, String? travelCity, String? travelState, bool incognito
});




}
/// @nodoc
class _$EntitlementsCopyWithImpl<$Res>
    implements $EntitlementsCopyWith<$Res> {
  _$EntitlementsCopyWithImpl(this._self, this._then);

  final Entitlements _self;
  final $Res Function(Entitlements) _then;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = freezed,Object? source = freezed,Object? expiresAt = freezed,Object? willRenew = null,Object? likesLeftToday = freezed,Object? freeSuperlikesLeft = null,Object? superlikeBalance = null,Object? freeBoostsLeft = null,Object? boostBalance = null,Object? boostEndsAt = freezed,Object? travelCity = freezed,Object? travelState = freezed,Object? incognito = null,}) {
  return _then(Entitlements(
tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PlanTier?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,willRenew: null == willRenew ? _self.willRenew : willRenew // ignore: cast_nullable_to_non_nullable
as bool,likesLeftToday: freezed == likesLeftToday ? _self.likesLeftToday : likesLeftToday // ignore: cast_nullable_to_non_nullable
as int?,freeSuperlikesLeft: null == freeSuperlikesLeft ? _self.freeSuperlikesLeft : freeSuperlikesLeft // ignore: cast_nullable_to_non_nullable
as int,superlikeBalance: null == superlikeBalance ? _self.superlikeBalance : superlikeBalance // ignore: cast_nullable_to_non_nullable
as int,freeBoostsLeft: null == freeBoostsLeft ? _self.freeBoostsLeft : freeBoostsLeft // ignore: cast_nullable_to_non_nullable
as int,boostBalance: null == boostBalance ? _self.boostBalance : boostBalance // ignore: cast_nullable_to_non_nullable
as int,boostEndsAt: freezed == boostEndsAt ? _self.boostEndsAt : boostEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,travelCity: freezed == travelCity ? _self.travelCity : travelCity // ignore: cast_nullable_to_non_nullable
as String?,travelState: freezed == travelState ? _self.travelState : travelState // ignore: cast_nullable_to_non_nullable
as String?,incognito: null == incognito ? _self.incognito : incognito // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Entitlements].
extension EntitlementsPatterns on Entitlements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entitlements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entitlements value)  $default,){
final _that = this;
switch (_that) {
case _Entitlements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entitlements value)?  $default,){
final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  bool willRenew,  int? likesLeftToday,  int freeSuperlikesLeft,  int superlikeBalance,  int freeBoostsLeft,  int boostBalance,  DateTime? boostEndsAt,  String? travelCity,  String? travelState,  bool incognito)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
return $default(_that.tier,_that.source,_that.expiresAt,_that.willRenew,_that.likesLeftToday,_that.freeSuperlikesLeft,_that.superlikeBalance,_that.freeBoostsLeft,_that.boostBalance,_that.boostEndsAt,_that.travelCity,_that.travelState,_that.incognito);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  bool willRenew,  int? likesLeftToday,  int freeSuperlikesLeft,  int superlikeBalance,  int freeBoostsLeft,  int boostBalance,  DateTime? boostEndsAt,  String? travelCity,  String? travelState,  bool incognito)  $default,) {final _that = this;
switch (_that) {
case _Entitlements():
return $default(_that.tier,_that.source,_that.expiresAt,_that.willRenew,_that.likesLeftToday,_that.freeSuperlikesLeft,_that.superlikeBalance,_that.freeBoostsLeft,_that.boostBalance,_that.boostEndsAt,_that.travelCity,_that.travelState,_that.incognito);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  bool willRenew,  int? likesLeftToday,  int freeSuperlikesLeft,  int superlikeBalance,  int freeBoostsLeft,  int boostBalance,  DateTime? boostEndsAt,  String? travelCity,  String? travelState,  bool incognito)?  $default,) {final _that = this;
switch (_that) {
case _Entitlements() when $default != null:
return $default(_that.tier,_that.source,_that.expiresAt,_that.willRenew,_that.likesLeftToday,_that.freeSuperlikesLeft,_that.superlikeBalance,_that.freeBoostsLeft,_that.boostBalance,_that.boostEndsAt,_that.travelCity,_that.travelState,_that.incognito);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Entitlements extends Entitlements {
  const _Entitlements({this.tier, this.source, this.expiresAt, this.willRenew = false, this.likesLeftToday, this.freeSuperlikesLeft = 0, this.superlikeBalance = 0, this.freeBoostsLeft = 0, this.boostBalance = 0, this.boostEndsAt, this.travelCity, this.travelState, this.incognito = false}): super._();
  factory _Entitlements.fromJson(Map<String, dynamic> json) => _$EntitlementsFromJson(json);

@override final  PlanTier? tier;
@override final  String? source;
@override final  DateTime? expiresAt;
@override@JsonKey() final  bool willRenew;
/// null = unlimited.
@override final  int? likesLeftToday;
@override@JsonKey() final  int freeSuperlikesLeft;
@override@JsonKey() final  int superlikeBalance;
@override@JsonKey() final  int freeBoostsLeft;
@override@JsonKey() final  int boostBalance;
@override final  DateTime? boostEndsAt;
@override final  String? travelCity;
@override final  String? travelState;
@override@JsonKey() final  bool incognito;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementsCopyWith<_Entitlements> get copyWith => __$EntitlementsCopyWithImpl<_Entitlements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entitlements&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.source, source) || other.source == source)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.willRenew, willRenew) || other.willRenew == willRenew)&&(identical(other.likesLeftToday, likesLeftToday) || other.likesLeftToday == likesLeftToday)&&(identical(other.freeSuperlikesLeft, freeSuperlikesLeft) || other.freeSuperlikesLeft == freeSuperlikesLeft)&&(identical(other.superlikeBalance, superlikeBalance) || other.superlikeBalance == superlikeBalance)&&(identical(other.freeBoostsLeft, freeBoostsLeft) || other.freeBoostsLeft == freeBoostsLeft)&&(identical(other.boostBalance, boostBalance) || other.boostBalance == boostBalance)&&(identical(other.boostEndsAt, boostEndsAt) || other.boostEndsAt == boostEndsAt)&&(identical(other.travelCity, travelCity) || other.travelCity == travelCity)&&(identical(other.travelState, travelState) || other.travelState == travelState)&&(identical(other.incognito, incognito) || other.incognito == incognito));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tier,source,expiresAt,willRenew,likesLeftToday,freeSuperlikesLeft,superlikeBalance,freeBoostsLeft,boostBalance,boostEndsAt,travelCity,travelState,incognito);
}

@override
String toString() {
    return 'Entitlements(tier: $tier, source: $source, expiresAt: $expiresAt, willRenew: $willRenew, likesLeftToday: $likesLeftToday, freeSuperlikesLeft: $freeSuperlikesLeft, superlikeBalance: $superlikeBalance, freeBoostsLeft: $freeBoostsLeft, boostBalance: $boostBalance, boostEndsAt: $boostEndsAt, travelCity: $travelCity, travelState: $travelState, incognito: $incognito)';
}


}

/// @nodoc
abstract mixin class _$EntitlementsCopyWith<$Res> implements $EntitlementsCopyWith<$Res> {
  factory _$EntitlementsCopyWith(_Entitlements value, $Res Function(_Entitlements) _then) = __$EntitlementsCopyWithImpl;
@override @useResult
$Res call({
 PlanTier? tier, String? source, DateTime? expiresAt, bool willRenew, int? likesLeftToday, int freeSuperlikesLeft, int superlikeBalance, int freeBoostsLeft, int boostBalance, DateTime? boostEndsAt, String? travelCity, String? travelState, bool incognito
});




}
/// @nodoc
class __$EntitlementsCopyWithImpl<$Res>
    implements _$EntitlementsCopyWith<$Res> {
  __$EntitlementsCopyWithImpl(this._self, this._then);

  final _Entitlements _self;
  final $Res Function(_Entitlements) _then;

/// Create a copy of Entitlements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = freezed,Object? source = freezed,Object? expiresAt = freezed,Object? willRenew = null,Object? likesLeftToday = freezed,Object? freeSuperlikesLeft = null,Object? superlikeBalance = null,Object? freeBoostsLeft = null,Object? boostBalance = null,Object? boostEndsAt = freezed,Object? travelCity = freezed,Object? travelState = freezed,Object? incognito = null,}) {
  return _then(_Entitlements(
tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PlanTier?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,willRenew: null == willRenew ? _self.willRenew : willRenew // ignore: cast_nullable_to_non_nullable
as bool,likesLeftToday: freezed == likesLeftToday ? _self.likesLeftToday : likesLeftToday // ignore: cast_nullable_to_non_nullable
as int?,freeSuperlikesLeft: null == freeSuperlikesLeft ? _self.freeSuperlikesLeft : freeSuperlikesLeft // ignore: cast_nullable_to_non_nullable
as int,superlikeBalance: null == superlikeBalance ? _self.superlikeBalance : superlikeBalance // ignore: cast_nullable_to_non_nullable
as int,freeBoostsLeft: null == freeBoostsLeft ? _self.freeBoostsLeft : freeBoostsLeft // ignore: cast_nullable_to_non_nullable
as int,boostBalance: null == boostBalance ? _self.boostBalance : boostBalance // ignore: cast_nullable_to_non_nullable
as int,boostEndsAt: freezed == boostEndsAt ? _self.boostEndsAt : boostEndsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,travelCity: freezed == travelCity ? _self.travelCity : travelCity // ignore: cast_nullable_to_non_nullable
as String?,travelState: freezed == travelState ? _self.travelState : travelState // ignore: cast_nullable_to_non_nullable
as String?,incognito: null == incognito ? _self.incognito : incognito // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LikedYou {

 String get userId; String get firstName; int get age; AppMode get mode; DateTime get likedAt; String? get city; String? get photoPath; bool get isSuper;
/// Create a copy of LikedYou
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikedYouCopyWith<LikedYou> get copyWith => _$LikedYouCopyWithImpl<LikedYou>(this as LikedYou, _$identity);

  /// Serializes this LikedYou to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LikedYou;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikedYou&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.likedAt, _this.likedAt) || other.likedAt == _this.likedAt)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.isSuper, _this.isSuper) || other.isSuper == _this.isSuper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LikedYou;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.age,_this.mode,_this.likedAt,_this.city,_this.photoPath,_this.isSuper);
}

@override
String toString() {
  final _this = this as LikedYou;
  return 'LikedYou(userId: ${_this.userId}, firstName: ${_this.firstName}, age: ${_this.age}, mode: ${_this.mode}, likedAt: ${_this.likedAt}, city: ${_this.city}, photoPath: ${_this.photoPath}, isSuper: ${_this.isSuper})';
}


}

/// @nodoc
abstract mixin class $LikedYouCopyWith<$Res>  {
  factory $LikedYouCopyWith(LikedYou value, $Res Function(LikedYou) _then) = _$LikedYouCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, int age, AppMode mode, DateTime likedAt, String? city, String? photoPath, bool isSuper
});




}
/// @nodoc
class _$LikedYouCopyWithImpl<$Res>
    implements $LikedYouCopyWith<$Res> {
  _$LikedYouCopyWithImpl(this._self, this._then);

  final LikedYou _self;
  final $Res Function(LikedYou) _then;

/// Create a copy of LikedYou
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? age = null,Object? mode = null,Object? likedAt = null,Object? city = freezed,Object? photoPath = freezed,Object? isSuper = null,}) {
  return _then(LikedYou(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode,likedAt: null == likedAt ? _self.likedAt : likedAt // ignore: cast_nullable_to_non_nullable
as DateTime,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,isSuper: null == isSuper ? _self.isSuper : isSuper // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LikedYou].
extension LikedYouPatterns on LikedYou {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikedYou value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikedYou() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikedYou value)  $default,){
final _that = this;
switch (_that) {
case _LikedYou():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikedYou value)?  $default,){
final _that = this;
switch (_that) {
case _LikedYou() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  int age,  AppMode mode,  DateTime likedAt,  String? city,  String? photoPath,  bool isSuper)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikedYou() when $default != null:
return $default(_that.userId,_that.firstName,_that.age,_that.mode,_that.likedAt,_that.city,_that.photoPath,_that.isSuper);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  int age,  AppMode mode,  DateTime likedAt,  String? city,  String? photoPath,  bool isSuper)  $default,) {final _that = this;
switch (_that) {
case _LikedYou():
return $default(_that.userId,_that.firstName,_that.age,_that.mode,_that.likedAt,_that.city,_that.photoPath,_that.isSuper);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  int age,  AppMode mode,  DateTime likedAt,  String? city,  String? photoPath,  bool isSuper)?  $default,) {final _that = this;
switch (_that) {
case _LikedYou() when $default != null:
return $default(_that.userId,_that.firstName,_that.age,_that.mode,_that.likedAt,_that.city,_that.photoPath,_that.isSuper);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikedYou implements LikedYou {
  const _LikedYou({required this.userId, required this.firstName, required this.age, required this.mode, required this.likedAt, this.city, this.photoPath, this.isSuper = false});
  factory _LikedYou.fromJson(Map<String, dynamic> json) => _$LikedYouFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  int age;
@override final  AppMode mode;
@override final  DateTime likedAt;
@override final  String? city;
@override final  String? photoPath;
@override@JsonKey() final  bool isSuper;

/// Create a copy of LikedYou
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikedYouCopyWith<_LikedYou> get copyWith => __$LikedYouCopyWithImpl<_LikedYou>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikedYouToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikedYou&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.age, age) || other.age == age)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.likedAt, likedAt) || other.likedAt == likedAt)&&(identical(other.city, city) || other.city == city)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.isSuper, isSuper) || other.isSuper == isSuper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,age,mode,likedAt,city,photoPath,isSuper);
}

@override
String toString() {
    return 'LikedYou(userId: $userId, firstName: $firstName, age: $age, mode: $mode, likedAt: $likedAt, city: $city, photoPath: $photoPath, isSuper: $isSuper)';
}


}

/// @nodoc
abstract mixin class _$LikedYouCopyWith<$Res> implements $LikedYouCopyWith<$Res> {
  factory _$LikedYouCopyWith(_LikedYou value, $Res Function(_LikedYou) _then) = __$LikedYouCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, int age, AppMode mode, DateTime likedAt, String? city, String? photoPath, bool isSuper
});




}
/// @nodoc
class __$LikedYouCopyWithImpl<$Res>
    implements _$LikedYouCopyWith<$Res> {
  __$LikedYouCopyWithImpl(this._self, this._then);

  final _LikedYou _self;
  final $Res Function(_LikedYou) _then;

/// Create a copy of LikedYou
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? age = null,Object? mode = null,Object? likedAt = null,Object? city = freezed,Object? photoPath = freezed,Object? isSuper = null,}) {
  return _then(_LikedYou(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AppMode,likedAt: null == likedAt ? _self.likedAt : likedAt // ignore: cast_nullable_to_non_nullable
as DateTime,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,isSuper: null == isSuper ? _self.isSuper : isSuper // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AdminPlan {

 PlanTier? get tier; String? get source; DateTime? get expiresAt; int get superlikeBalance; int get boostBalance;
/// Create a copy of AdminPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminPlanCopyWith<AdminPlan> get copyWith => _$AdminPlanCopyWithImpl<AdminPlan>(this as AdminPlan, _$identity);

  /// Serializes this AdminPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminPlan&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.superlikeBalance, _this.superlikeBalance) || other.superlikeBalance == _this.superlikeBalance)&&(identical(other.boostBalance, _this.boostBalance) || other.boostBalance == _this.boostBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminPlan;
  return Object.hash(runtimeType,_this.tier,_this.source,_this.expiresAt,_this.superlikeBalance,_this.boostBalance);
}

@override
String toString() {
  final _this = this as AdminPlan;
  return 'AdminPlan(tier: ${_this.tier}, source: ${_this.source}, expiresAt: ${_this.expiresAt}, superlikeBalance: ${_this.superlikeBalance}, boostBalance: ${_this.boostBalance})';
}


}

/// @nodoc
abstract mixin class $AdminPlanCopyWith<$Res>  {
  factory $AdminPlanCopyWith(AdminPlan value, $Res Function(AdminPlan) _then) = _$AdminPlanCopyWithImpl;
@useResult
$Res call({
 PlanTier? tier, String? source, DateTime? expiresAt, int superlikeBalance, int boostBalance
});




}
/// @nodoc
class _$AdminPlanCopyWithImpl<$Res>
    implements $AdminPlanCopyWith<$Res> {
  _$AdminPlanCopyWithImpl(this._self, this._then);

  final AdminPlan _self;
  final $Res Function(AdminPlan) _then;

/// Create a copy of AdminPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = freezed,Object? source = freezed,Object? expiresAt = freezed,Object? superlikeBalance = null,Object? boostBalance = null,}) {
  return _then(AdminPlan(
tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PlanTier?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,superlikeBalance: null == superlikeBalance ? _self.superlikeBalance : superlikeBalance // ignore: cast_nullable_to_non_nullable
as int,boostBalance: null == boostBalance ? _self.boostBalance : boostBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminPlan].
extension AdminPlanPatterns on AdminPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminPlan value)  $default,){
final _that = this;
switch (_that) {
case _AdminPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminPlan value)?  $default,){
final _that = this;
switch (_that) {
case _AdminPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  int superlikeBalance,  int boostBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminPlan() when $default != null:
return $default(_that.tier,_that.source,_that.expiresAt,_that.superlikeBalance,_that.boostBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  int superlikeBalance,  int boostBalance)  $default,) {final _that = this;
switch (_that) {
case _AdminPlan():
return $default(_that.tier,_that.source,_that.expiresAt,_that.superlikeBalance,_that.boostBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlanTier? tier,  String? source,  DateTime? expiresAt,  int superlikeBalance,  int boostBalance)?  $default,) {final _that = this;
switch (_that) {
case _AdminPlan() when $default != null:
return $default(_that.tier,_that.source,_that.expiresAt,_that.superlikeBalance,_that.boostBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminPlan implements AdminPlan {
  const _AdminPlan({this.tier, this.source, this.expiresAt, this.superlikeBalance = 0, this.boostBalance = 0});
  factory _AdminPlan.fromJson(Map<String, dynamic> json) => _$AdminPlanFromJson(json);

@override final  PlanTier? tier;
@override final  String? source;
@override final  DateTime? expiresAt;
@override@JsonKey() final  int superlikeBalance;
@override@JsonKey() final  int boostBalance;

/// Create a copy of AdminPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminPlanCopyWith<_AdminPlan> get copyWith => __$AdminPlanCopyWithImpl<_AdminPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminPlan&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.source, source) || other.source == source)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.superlikeBalance, superlikeBalance) || other.superlikeBalance == superlikeBalance)&&(identical(other.boostBalance, boostBalance) || other.boostBalance == boostBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tier,source,expiresAt,superlikeBalance,boostBalance);
}

@override
String toString() {
    return 'AdminPlan(tier: $tier, source: $source, expiresAt: $expiresAt, superlikeBalance: $superlikeBalance, boostBalance: $boostBalance)';
}


}

/// @nodoc
abstract mixin class _$AdminPlanCopyWith<$Res> implements $AdminPlanCopyWith<$Res> {
  factory _$AdminPlanCopyWith(_AdminPlan value, $Res Function(_AdminPlan) _then) = __$AdminPlanCopyWithImpl;
@override @useResult
$Res call({
 PlanTier? tier, String? source, DateTime? expiresAt, int superlikeBalance, int boostBalance
});




}
/// @nodoc
class __$AdminPlanCopyWithImpl<$Res>
    implements _$AdminPlanCopyWith<$Res> {
  __$AdminPlanCopyWithImpl(this._self, this._then);

  final _AdminPlan _self;
  final $Res Function(_AdminPlan) _then;

/// Create a copy of AdminPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = freezed,Object? source = freezed,Object? expiresAt = freezed,Object? superlikeBalance = null,Object? boostBalance = null,}) {
  return _then(_AdminPlan(
tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PlanTier?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,superlikeBalance: null == superlikeBalance ? _self.superlikeBalance : superlikeBalance // ignore: cast_nullable_to_non_nullable
as int,boostBalance: null == boostBalance ? _self.boostBalance : boostBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SameNightPerson {

 String get userId; String get firstName; int get age; String get eventName; String? get photoPath;
/// Create a copy of SameNightPerson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SameNightPersonCopyWith<SameNightPerson> get copyWith => _$SameNightPersonCopyWithImpl<SameNightPerson>(this as SameNightPerson, _$identity);

  /// Serializes this SameNightPerson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SameNightPerson;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SameNightPerson&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SameNightPerson;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.age,_this.eventName,_this.photoPath);
}

@override
String toString() {
  final _this = this as SameNightPerson;
  return 'SameNightPerson(userId: ${_this.userId}, firstName: ${_this.firstName}, age: ${_this.age}, eventName: ${_this.eventName}, photoPath: ${_this.photoPath})';
}


}

/// @nodoc
abstract mixin class $SameNightPersonCopyWith<$Res>  {
  factory $SameNightPersonCopyWith(SameNightPerson value, $Res Function(SameNightPerson) _then) = _$SameNightPersonCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, int age, String eventName, String? photoPath
});




}
/// @nodoc
class _$SameNightPersonCopyWithImpl<$Res>
    implements $SameNightPersonCopyWith<$Res> {
  _$SameNightPersonCopyWithImpl(this._self, this._then);

  final SameNightPerson _self;
  final $Res Function(SameNightPerson) _then;

/// Create a copy of SameNightPerson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? age = null,Object? eventName = null,Object? photoPath = freezed,}) {
  return _then(SameNightPerson(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SameNightPerson].
extension SameNightPersonPatterns on SameNightPerson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SameNightPerson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SameNightPerson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SameNightPerson value)  $default,){
final _that = this;
switch (_that) {
case _SameNightPerson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SameNightPerson value)?  $default,){
final _that = this;
switch (_that) {
case _SameNightPerson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  int age,  String eventName,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SameNightPerson() when $default != null:
return $default(_that.userId,_that.firstName,_that.age,_that.eventName,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  int age,  String eventName,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _SameNightPerson():
return $default(_that.userId,_that.firstName,_that.age,_that.eventName,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  int age,  String eventName,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _SameNightPerson() when $default != null:
return $default(_that.userId,_that.firstName,_that.age,_that.eventName,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SameNightPerson implements SameNightPerson {
  const _SameNightPerson({required this.userId, required this.firstName, required this.age, required this.eventName, this.photoPath});
  factory _SameNightPerson.fromJson(Map<String, dynamic> json) => _$SameNightPersonFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  int age;
@override final  String eventName;
@override final  String? photoPath;

/// Create a copy of SameNightPerson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SameNightPersonCopyWith<_SameNightPerson> get copyWith => __$SameNightPersonCopyWithImpl<_SameNightPerson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SameNightPersonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SameNightPerson&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.age, age) || other.age == age)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,age,eventName,photoPath);
}

@override
String toString() {
    return 'SameNightPerson(userId: $userId, firstName: $firstName, age: $age, eventName: $eventName, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$SameNightPersonCopyWith<$Res> implements $SameNightPersonCopyWith<$Res> {
  factory _$SameNightPersonCopyWith(_SameNightPerson value, $Res Function(_SameNightPerson) _then) = __$SameNightPersonCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, int age, String eventName, String? photoPath
});




}
/// @nodoc
class __$SameNightPersonCopyWithImpl<$Res>
    implements _$SameNightPersonCopyWith<$Res> {
  __$SameNightPersonCopyWithImpl(this._self, this._then);

  final _SameNightPerson _self;
  final $Res Function(_SameNightPerson) _then;

/// Create a copy of SameNightPerson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? age = null,Object? eventName = null,Object? photoPath = freezed,}) {
  return _then(_SameNightPerson(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
