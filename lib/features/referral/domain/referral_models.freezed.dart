// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferralInfo {

 String get code; int get invited; int get rewarded;/// True until the person has used a code or made a first match.
 bool get canRedeem; int get referrerSuperlikes; int get referrerBoosts; int get referredSuperlikes;
/// Create a copy of ReferralInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferralInfoCopyWith<ReferralInfo> get copyWith => _$ReferralInfoCopyWithImpl<ReferralInfo>(this as ReferralInfo, _$identity);

  /// Serializes this ReferralInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReferralInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferralInfo&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.invited, _this.invited) || other.invited == _this.invited)&&(identical(other.rewarded, _this.rewarded) || other.rewarded == _this.rewarded)&&(identical(other.canRedeem, _this.canRedeem) || other.canRedeem == _this.canRedeem)&&(identical(other.referrerSuperlikes, _this.referrerSuperlikes) || other.referrerSuperlikes == _this.referrerSuperlikes)&&(identical(other.referrerBoosts, _this.referrerBoosts) || other.referrerBoosts == _this.referrerBoosts)&&(identical(other.referredSuperlikes, _this.referredSuperlikes) || other.referredSuperlikes == _this.referredSuperlikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReferralInfo;
  return Object.hash(runtimeType,_this.code,_this.invited,_this.rewarded,_this.canRedeem,_this.referrerSuperlikes,_this.referrerBoosts,_this.referredSuperlikes);
}

@override
String toString() {
  final _this = this as ReferralInfo;
  return 'ReferralInfo(code: ${_this.code}, invited: ${_this.invited}, rewarded: ${_this.rewarded}, canRedeem: ${_this.canRedeem}, referrerSuperlikes: ${_this.referrerSuperlikes}, referrerBoosts: ${_this.referrerBoosts}, referredSuperlikes: ${_this.referredSuperlikes})';
}


}

/// @nodoc
abstract mixin class $ReferralInfoCopyWith<$Res>  {
  factory $ReferralInfoCopyWith(ReferralInfo value, $Res Function(ReferralInfo) _then) = _$ReferralInfoCopyWithImpl;
@useResult
$Res call({
 String code, int invited, int rewarded, bool canRedeem, int referrerSuperlikes, int referrerBoosts, int referredSuperlikes
});




}
/// @nodoc
class _$ReferralInfoCopyWithImpl<$Res>
    implements $ReferralInfoCopyWith<$Res> {
  _$ReferralInfoCopyWithImpl(this._self, this._then);

  final ReferralInfo _self;
  final $Res Function(ReferralInfo) _then;

/// Create a copy of ReferralInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? invited = null,Object? rewarded = null,Object? canRedeem = null,Object? referrerSuperlikes = null,Object? referrerBoosts = null,Object? referredSuperlikes = null,}) {
  return _then(ReferralInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invited: null == invited ? _self.invited : invited // ignore: cast_nullable_to_non_nullable
as int,rewarded: null == rewarded ? _self.rewarded : rewarded // ignore: cast_nullable_to_non_nullable
as int,canRedeem: null == canRedeem ? _self.canRedeem : canRedeem // ignore: cast_nullable_to_non_nullable
as bool,referrerSuperlikes: null == referrerSuperlikes ? _self.referrerSuperlikes : referrerSuperlikes // ignore: cast_nullable_to_non_nullable
as int,referrerBoosts: null == referrerBoosts ? _self.referrerBoosts : referrerBoosts // ignore: cast_nullable_to_non_nullable
as int,referredSuperlikes: null == referredSuperlikes ? _self.referredSuperlikes : referredSuperlikes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferralInfo].
extension ReferralInfoPatterns on ReferralInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferralInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferralInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferralInfo value)  $default,){
final _that = this;
switch (_that) {
case _ReferralInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferralInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ReferralInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  int invited,  int rewarded,  bool canRedeem,  int referrerSuperlikes,  int referrerBoosts,  int referredSuperlikes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferralInfo() when $default != null:
return $default(_that.code,_that.invited,_that.rewarded,_that.canRedeem,_that.referrerSuperlikes,_that.referrerBoosts,_that.referredSuperlikes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  int invited,  int rewarded,  bool canRedeem,  int referrerSuperlikes,  int referrerBoosts,  int referredSuperlikes)  $default,) {final _that = this;
switch (_that) {
case _ReferralInfo():
return $default(_that.code,_that.invited,_that.rewarded,_that.canRedeem,_that.referrerSuperlikes,_that.referrerBoosts,_that.referredSuperlikes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  int invited,  int rewarded,  bool canRedeem,  int referrerSuperlikes,  int referrerBoosts,  int referredSuperlikes)?  $default,) {final _that = this;
switch (_that) {
case _ReferralInfo() when $default != null:
return $default(_that.code,_that.invited,_that.rewarded,_that.canRedeem,_that.referrerSuperlikes,_that.referrerBoosts,_that.referredSuperlikes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferralInfo implements ReferralInfo {
  const _ReferralInfo({required this.code, this.invited = 0, this.rewarded = 0, this.canRedeem = false, this.referrerSuperlikes = 0, this.referrerBoosts = 0, this.referredSuperlikes = 0});
  factory _ReferralInfo.fromJson(Map<String, dynamic> json) => _$ReferralInfoFromJson(json);

@override final  String code;
@override@JsonKey() final  int invited;
@override@JsonKey() final  int rewarded;
/// True until the person has used a code or made a first match.
@override@JsonKey() final  bool canRedeem;
@override@JsonKey() final  int referrerSuperlikes;
@override@JsonKey() final  int referrerBoosts;
@override@JsonKey() final  int referredSuperlikes;

/// Create a copy of ReferralInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferralInfoCopyWith<_ReferralInfo> get copyWith => __$ReferralInfoCopyWithImpl<_ReferralInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferralInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferralInfo&&(identical(other.code, code) || other.code == code)&&(identical(other.invited, invited) || other.invited == invited)&&(identical(other.rewarded, rewarded) || other.rewarded == rewarded)&&(identical(other.canRedeem, canRedeem) || other.canRedeem == canRedeem)&&(identical(other.referrerSuperlikes, referrerSuperlikes) || other.referrerSuperlikes == referrerSuperlikes)&&(identical(other.referrerBoosts, referrerBoosts) || other.referrerBoosts == referrerBoosts)&&(identical(other.referredSuperlikes, referredSuperlikes) || other.referredSuperlikes == referredSuperlikes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,invited,rewarded,canRedeem,referrerSuperlikes,referrerBoosts,referredSuperlikes);
}

@override
String toString() {
    return 'ReferralInfo(code: $code, invited: $invited, rewarded: $rewarded, canRedeem: $canRedeem, referrerSuperlikes: $referrerSuperlikes, referrerBoosts: $referrerBoosts, referredSuperlikes: $referredSuperlikes)';
}


}

/// @nodoc
abstract mixin class _$ReferralInfoCopyWith<$Res> implements $ReferralInfoCopyWith<$Res> {
  factory _$ReferralInfoCopyWith(_ReferralInfo value, $Res Function(_ReferralInfo) _then) = __$ReferralInfoCopyWithImpl;
@override @useResult
$Res call({
 String code, int invited, int rewarded, bool canRedeem, int referrerSuperlikes, int referrerBoosts, int referredSuperlikes
});




}
/// @nodoc
class __$ReferralInfoCopyWithImpl<$Res>
    implements _$ReferralInfoCopyWith<$Res> {
  __$ReferralInfoCopyWithImpl(this._self, this._then);

  final _ReferralInfo _self;
  final $Res Function(_ReferralInfo) _then;

/// Create a copy of ReferralInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? invited = null,Object? rewarded = null,Object? canRedeem = null,Object? referrerSuperlikes = null,Object? referrerBoosts = null,Object? referredSuperlikes = null,}) {
  return _then(_ReferralInfo(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invited: null == invited ? _self.invited : invited // ignore: cast_nullable_to_non_nullable
as int,rewarded: null == rewarded ? _self.rewarded : rewarded // ignore: cast_nullable_to_non_nullable
as int,canRedeem: null == canRedeem ? _self.canRedeem : canRedeem // ignore: cast_nullable_to_non_nullable
as bool,referrerSuperlikes: null == referrerSuperlikes ? _self.referrerSuperlikes : referrerSuperlikes // ignore: cast_nullable_to_non_nullable
as int,referrerBoosts: null == referrerBoosts ? _self.referrerBoosts : referrerBoosts // ignore: cast_nullable_to_non_nullable
as int,referredSuperlikes: null == referredSuperlikes ? _self.referredSuperlikes : referredSuperlikes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
