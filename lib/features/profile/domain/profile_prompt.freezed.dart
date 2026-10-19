// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromptAnswer {

 ProfilePrompt get prompt; String get answer;
/// Create a copy of PromptAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromptAnswerCopyWith<PromptAnswer> get copyWith => _$PromptAnswerCopyWithImpl<PromptAnswer>(this as PromptAnswer, _$identity);

  /// Serializes this PromptAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PromptAnswer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromptAnswer&&(identical(other.prompt, _this.prompt) || other.prompt == _this.prompt)&&(identical(other.answer, _this.answer) || other.answer == _this.answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PromptAnswer;
  return Object.hash(runtimeType,_this.prompt,_this.answer);
}

@override
String toString() {
  final _this = this as PromptAnswer;
  return 'PromptAnswer(prompt: ${_this.prompt}, answer: ${_this.answer})';
}


}

/// @nodoc
abstract mixin class $PromptAnswerCopyWith<$Res>  {
  factory $PromptAnswerCopyWith(PromptAnswer value, $Res Function(PromptAnswer) _then) = _$PromptAnswerCopyWithImpl;
@useResult
$Res call({
 ProfilePrompt prompt, String answer
});




}
/// @nodoc
class _$PromptAnswerCopyWithImpl<$Res>
    implements $PromptAnswerCopyWith<$Res> {
  _$PromptAnswerCopyWithImpl(this._self, this._then);

  final PromptAnswer _self;
  final $Res Function(PromptAnswer) _then;

/// Create a copy of PromptAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompt = null,Object? answer = null,}) {
  return _then(PromptAnswer(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as ProfilePrompt,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromptAnswer].
extension PromptAnswerPatterns on PromptAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromptAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromptAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromptAnswer value)  $default,){
final _that = this;
switch (_that) {
case _PromptAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromptAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _PromptAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfilePrompt prompt,  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromptAnswer() when $default != null:
return $default(_that.prompt,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfilePrompt prompt,  String answer)  $default,) {final _that = this;
switch (_that) {
case _PromptAnswer():
return $default(_that.prompt,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfilePrompt prompt,  String answer)?  $default,) {final _that = this;
switch (_that) {
case _PromptAnswer() when $default != null:
return $default(_that.prompt,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromptAnswer implements PromptAnswer {
  const _PromptAnswer({required this.prompt, required this.answer});
  factory _PromptAnswer.fromJson(Map<String, dynamic> json) => _$PromptAnswerFromJson(json);

@override final  ProfilePrompt prompt;
@override final  String answer;

/// Create a copy of PromptAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromptAnswerCopyWith<_PromptAnswer> get copyWith => __$PromptAnswerCopyWithImpl<_PromptAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromptAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromptAnswer&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,prompt,answer);
}

@override
String toString() {
    return 'PromptAnswer(prompt: $prompt, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$PromptAnswerCopyWith<$Res> implements $PromptAnswerCopyWith<$Res> {
  factory _$PromptAnswerCopyWith(_PromptAnswer value, $Res Function(_PromptAnswer) _then) = __$PromptAnswerCopyWithImpl;
@override @useResult
$Res call({
 ProfilePrompt prompt, String answer
});




}
/// @nodoc
class __$PromptAnswerCopyWithImpl<$Res>
    implements _$PromptAnswerCopyWith<$Res> {
  __$PromptAnswerCopyWithImpl(this._self, this._then);

  final _PromptAnswer _self;
  final $Res Function(_PromptAnswer) _then;

/// Create a copy of PromptAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompt = null,Object? answer = null,}) {
  return _then(_PromptAnswer(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as ProfilePrompt,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
