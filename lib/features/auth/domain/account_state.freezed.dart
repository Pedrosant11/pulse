// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountState {

 String get userId;/// A phone number is saved (required, unique per account; no code).
 bool get hasPhone;/// Accepted the current terms version (AppConstants.termsVersion).
 bool get termsAccepted; bool get onboardingCompleted; AccountStatus get status;
/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountStateCopyWith<AccountState> get copyWith => _$AccountStateCopyWithImpl<AccountState>(this as AccountState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AccountState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.hasPhone, _this.hasPhone) || other.hasPhone == _this.hasPhone)&&(identical(other.termsAccepted, _this.termsAccepted) || other.termsAccepted == _this.termsAccepted)&&(identical(other.onboardingCompleted, _this.onboardingCompleted) || other.onboardingCompleted == _this.onboardingCompleted)&&(identical(other.status, _this.status) || other.status == _this.status));
}


@override
int get hashCode {
  final _this = this as AccountState;
  return Object.hash(runtimeType,_this.userId,_this.hasPhone,_this.termsAccepted,_this.onboardingCompleted,_this.status);
}

@override
String toString() {
  final _this = this as AccountState;
  return 'AccountState(userId: ${_this.userId}, hasPhone: ${_this.hasPhone}, termsAccepted: ${_this.termsAccepted}, onboardingCompleted: ${_this.onboardingCompleted}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $AccountStateCopyWith<$Res>  {
  factory $AccountStateCopyWith(AccountState value, $Res Function(AccountState) _then) = _$AccountStateCopyWithImpl;
@useResult
$Res call({
 String userId, bool hasPhone, bool termsAccepted, bool onboardingCompleted, AccountStatus status
});




}
/// @nodoc
class _$AccountStateCopyWithImpl<$Res>
    implements $AccountStateCopyWith<$Res> {
  _$AccountStateCopyWithImpl(this._self, this._then);

  final AccountState _self;
  final $Res Function(AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? hasPhone = null,Object? termsAccepted = null,Object? onboardingCompleted = null,Object? status = null,}) {
  return _then(AccountState(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,hasPhone: null == hasPhone ? _self.hasPhone : hasPhone // ignore: cast_nullable_to_non_nullable
as bool,termsAccepted: null == termsAccepted ? _self.termsAccepted : termsAccepted // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountState].
extension AccountStatePatterns on AccountState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountState value)  $default,){
final _that = this;
switch (_that) {
case _AccountState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool hasPhone,  bool termsAccepted,  bool onboardingCompleted,  AccountStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.userId,_that.hasPhone,_that.termsAccepted,_that.onboardingCompleted,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool hasPhone,  bool termsAccepted,  bool onboardingCompleted,  AccountStatus status)  $default,) {final _that = this;
switch (_that) {
case _AccountState():
return $default(_that.userId,_that.hasPhone,_that.termsAccepted,_that.onboardingCompleted,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool hasPhone,  bool termsAccepted,  bool onboardingCompleted,  AccountStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AccountState() when $default != null:
return $default(_that.userId,_that.hasPhone,_that.termsAccepted,_that.onboardingCompleted,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AccountState implements AccountState {
  const _AccountState({required this.userId, required this.hasPhone, required this.termsAccepted, required this.onboardingCompleted, required this.status});
  

@override final  String userId;
/// A phone number is saved (required, unique per account; no code).
@override final  bool hasPhone;
/// Accepted the current terms version (AppConstants.termsVersion).
@override final  bool termsAccepted;
@override final  bool onboardingCompleted;
@override final  AccountStatus status;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountStateCopyWith<_AccountState> get copyWith => __$AccountStateCopyWithImpl<_AccountState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.hasPhone, hasPhone) || other.hasPhone == hasPhone)&&(identical(other.termsAccepted, termsAccepted) || other.termsAccepted == termsAccepted)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,hasPhone,termsAccepted,onboardingCompleted,status);
}

@override
String toString() {
    return 'AccountState(userId: $userId, hasPhone: $hasPhone, termsAccepted: $termsAccepted, onboardingCompleted: $onboardingCompleted, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AccountStateCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory _$AccountStateCopyWith(_AccountState value, $Res Function(_AccountState) _then) = __$AccountStateCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool hasPhone, bool termsAccepted, bool onboardingCompleted, AccountStatus status
});




}
/// @nodoc
class __$AccountStateCopyWithImpl<$Res>
    implements _$AccountStateCopyWith<$Res> {
  __$AccountStateCopyWithImpl(this._self, this._then);

  final _AccountState _self;
  final $Res Function(_AccountState) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? hasPhone = null,Object? termsAccepted = null,Object? onboardingCompleted = null,Object? status = null,}) {
  return _then(_AccountState(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,hasPhone: null == hasPhone ? _self.hasPhone : hasPhone // ignore: cast_nullable_to_non_nullable
as bool,termsAccepted: null == termsAccepted ? _self.termsAccepted : termsAccepted // ignore: cast_nullable_to_non_nullable
as bool,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,
  ));
}


}

// dart format on
