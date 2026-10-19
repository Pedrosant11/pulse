// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'featured.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeaturedPrice {

 int get days; int get priceCents; String get storeProductId;
/// Create a copy of FeaturedPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturedPriceCopyWith<FeaturedPrice> get copyWith => _$FeaturedPriceCopyWithImpl<FeaturedPrice>(this as FeaturedPrice, _$identity);

  /// Serializes this FeaturedPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeaturedPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturedPrice&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.priceCents, _this.priceCents) || other.priceCents == _this.priceCents)&&(identical(other.storeProductId, _this.storeProductId) || other.storeProductId == _this.storeProductId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeaturedPrice;
  return Object.hash(runtimeType,_this.days,_this.priceCents,_this.storeProductId);
}

@override
String toString() {
  final _this = this as FeaturedPrice;
  return 'FeaturedPrice(days: ${_this.days}, priceCents: ${_this.priceCents}, storeProductId: ${_this.storeProductId})';
}


}

/// @nodoc
abstract mixin class $FeaturedPriceCopyWith<$Res>  {
  factory $FeaturedPriceCopyWith(FeaturedPrice value, $Res Function(FeaturedPrice) _then) = _$FeaturedPriceCopyWithImpl;
@useResult
$Res call({
 int days, int priceCents, String storeProductId
});




}
/// @nodoc
class _$FeaturedPriceCopyWithImpl<$Res>
    implements $FeaturedPriceCopyWith<$Res> {
  _$FeaturedPriceCopyWithImpl(this._self, this._then);

  final FeaturedPrice _self;
  final $Res Function(FeaturedPrice) _then;

/// Create a copy of FeaturedPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? priceCents = null,Object? storeProductId = null,}) {
  return _then(FeaturedPrice(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,storeProductId: null == storeProductId ? _self.storeProductId : storeProductId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturedPrice].
extension FeaturedPricePatterns on FeaturedPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturedPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturedPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturedPrice value)  $default,){
final _that = this;
switch (_that) {
case _FeaturedPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturedPrice value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturedPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int days,  int priceCents,  String storeProductId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturedPrice() when $default != null:
return $default(_that.days,_that.priceCents,_that.storeProductId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int days,  int priceCents,  String storeProductId)  $default,) {final _that = this;
switch (_that) {
case _FeaturedPrice():
return $default(_that.days,_that.priceCents,_that.storeProductId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int days,  int priceCents,  String storeProductId)?  $default,) {final _that = this;
switch (_that) {
case _FeaturedPrice() when $default != null:
return $default(_that.days,_that.priceCents,_that.storeProductId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeaturedPrice extends FeaturedPrice {
  const _FeaturedPrice({required this.days, required this.priceCents, required this.storeProductId}): super._();
  factory _FeaturedPrice.fromJson(Map<String, dynamic> json) => _$FeaturedPriceFromJson(json);

@override final  int days;
@override final  int priceCents;
@override final  String storeProductId;

/// Create a copy of FeaturedPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturedPriceCopyWith<_FeaturedPrice> get copyWith => __$FeaturedPriceCopyWithImpl<_FeaturedPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeaturedPriceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturedPrice&&(identical(other.days, days) || other.days == days)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.storeProductId, storeProductId) || other.storeProductId == storeProductId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,days,priceCents,storeProductId);
}

@override
String toString() {
    return 'FeaturedPrice(days: $days, priceCents: $priceCents, storeProductId: $storeProductId)';
}


}

/// @nodoc
abstract mixin class _$FeaturedPriceCopyWith<$Res> implements $FeaturedPriceCopyWith<$Res> {
  factory _$FeaturedPriceCopyWith(_FeaturedPrice value, $Res Function(_FeaturedPrice) _then) = __$FeaturedPriceCopyWithImpl;
@override @useResult
$Res call({
 int days, int priceCents, String storeProductId
});




}
/// @nodoc
class __$FeaturedPriceCopyWithImpl<$Res>
    implements _$FeaturedPriceCopyWith<$Res> {
  __$FeaturedPriceCopyWithImpl(this._self, this._then);

  final _FeaturedPrice _self;
  final $Res Function(_FeaturedPrice) _then;

/// Create a copy of FeaturedPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? priceCents = null,Object? storeProductId = null,}) {
  return _then(_FeaturedPrice(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,storeProductId: null == storeProductId ? _self.storeProductId : storeProductId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FeaturedRequest {

 String get id; String get eventId; int get days; int get priceCents; FeaturedMethod get method; DateTime get createdAt;
/// Create a copy of FeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeaturedRequestCopyWith<FeaturedRequest> get copyWith => _$FeaturedRequestCopyWithImpl<FeaturedRequest>(this as FeaturedRequest, _$identity);

  /// Serializes this FeaturedRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeaturedRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeaturedRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.priceCents, _this.priceCents) || other.priceCents == _this.priceCents)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeaturedRequest;
  return Object.hash(runtimeType,_this.id,_this.eventId,_this.days,_this.priceCents,_this.method,_this.createdAt);
}

@override
String toString() {
  final _this = this as FeaturedRequest;
  return 'FeaturedRequest(id: ${_this.id}, eventId: ${_this.eventId}, days: ${_this.days}, priceCents: ${_this.priceCents}, method: ${_this.method}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $FeaturedRequestCopyWith<$Res>  {
  factory $FeaturedRequestCopyWith(FeaturedRequest value, $Res Function(FeaturedRequest) _then) = _$FeaturedRequestCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, int days, int priceCents, FeaturedMethod method, DateTime createdAt
});




}
/// @nodoc
class _$FeaturedRequestCopyWithImpl<$Res>
    implements $FeaturedRequestCopyWith<$Res> {
  _$FeaturedRequestCopyWithImpl(this._self, this._then);

  final FeaturedRequest _self;
  final $Res Function(FeaturedRequest) _then;

/// Create a copy of FeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? days = null,Object? priceCents = null,Object? method = null,Object? createdAt = null,}) {
  return _then(FeaturedRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as FeaturedMethod,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FeaturedRequest].
extension FeaturedRequestPatterns on FeaturedRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeaturedRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeaturedRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeaturedRequest value)  $default,){
final _that = this;
switch (_that) {
case _FeaturedRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeaturedRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FeaturedRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  int days,  int priceCents,  FeaturedMethod method,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeaturedRequest() when $default != null:
return $default(_that.id,_that.eventId,_that.days,_that.priceCents,_that.method,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  int days,  int priceCents,  FeaturedMethod method,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FeaturedRequest():
return $default(_that.id,_that.eventId,_that.days,_that.priceCents,_that.method,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  int days,  int priceCents,  FeaturedMethod method,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FeaturedRequest() when $default != null:
return $default(_that.id,_that.eventId,_that.days,_that.priceCents,_that.method,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeaturedRequest implements FeaturedRequest {
  const _FeaturedRequest({required this.id, required this.eventId, required this.days, required this.priceCents, required this.method, required this.createdAt});
  factory _FeaturedRequest.fromJson(Map<String, dynamic> json) => _$FeaturedRequestFromJson(json);

@override final  String id;
@override final  String eventId;
@override final  int days;
@override final  int priceCents;
@override final  FeaturedMethod method;
@override final  DateTime createdAt;

/// Create a copy of FeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeaturedRequestCopyWith<_FeaturedRequest> get copyWith => __$FeaturedRequestCopyWithImpl<_FeaturedRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeaturedRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeaturedRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.days, days) || other.days == days)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.method, method) || other.method == method)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,eventId,days,priceCents,method,createdAt);
}

@override
String toString() {
    return 'FeaturedRequest(id: $id, eventId: $eventId, days: $days, priceCents: $priceCents, method: $method, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FeaturedRequestCopyWith<$Res> implements $FeaturedRequestCopyWith<$Res> {
  factory _$FeaturedRequestCopyWith(_FeaturedRequest value, $Res Function(_FeaturedRequest) _then) = __$FeaturedRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, int days, int priceCents, FeaturedMethod method, DateTime createdAt
});




}
/// @nodoc
class __$FeaturedRequestCopyWithImpl<$Res>
    implements _$FeaturedRequestCopyWith<$Res> {
  __$FeaturedRequestCopyWithImpl(this._self, this._then);

  final _FeaturedRequest _self;
  final $Res Function(_FeaturedRequest) _then;

/// Create a copy of FeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? days = null,Object? priceCents = null,Object? method = null,Object? createdAt = null,}) {
  return _then(_FeaturedRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as FeaturedMethod,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AdminFeaturedRequest {

 String get id; String get eventId; String get eventName; DateTime get eventStartsAt; String get city; int get days; int get priceCents; DateTime get createdAt; String? get requesterName;
/// Create a copy of AdminFeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminFeaturedRequestCopyWith<AdminFeaturedRequest> get copyWith => _$AdminFeaturedRequestCopyWithImpl<AdminFeaturedRequest>(this as AdminFeaturedRequest, _$identity);

  /// Serializes this AdminFeaturedRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminFeaturedRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminFeaturedRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.eventName, _this.eventName) || other.eventName == _this.eventName)&&(identical(other.eventStartsAt, _this.eventStartsAt) || other.eventStartsAt == _this.eventStartsAt)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.priceCents, _this.priceCents) || other.priceCents == _this.priceCents)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.requesterName, _this.requesterName) || other.requesterName == _this.requesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminFeaturedRequest;
  return Object.hash(runtimeType,_this.id,_this.eventId,_this.eventName,_this.eventStartsAt,_this.city,_this.days,_this.priceCents,_this.createdAt,_this.requesterName);
}

@override
String toString() {
  final _this = this as AdminFeaturedRequest;
  return 'AdminFeaturedRequest(id: ${_this.id}, eventId: ${_this.eventId}, eventName: ${_this.eventName}, eventStartsAt: ${_this.eventStartsAt}, city: ${_this.city}, days: ${_this.days}, priceCents: ${_this.priceCents}, createdAt: ${_this.createdAt}, requesterName: ${_this.requesterName})';
}


}

/// @nodoc
abstract mixin class $AdminFeaturedRequestCopyWith<$Res>  {
  factory $AdminFeaturedRequestCopyWith(AdminFeaturedRequest value, $Res Function(AdminFeaturedRequest) _then) = _$AdminFeaturedRequestCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String eventName, DateTime eventStartsAt, String city, int days, int priceCents, DateTime createdAt, String? requesterName
});




}
/// @nodoc
class _$AdminFeaturedRequestCopyWithImpl<$Res>
    implements $AdminFeaturedRequestCopyWith<$Res> {
  _$AdminFeaturedRequestCopyWithImpl(this._self, this._then);

  final AdminFeaturedRequest _self;
  final $Res Function(AdminFeaturedRequest) _then;

/// Create a copy of AdminFeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? eventName = null,Object? eventStartsAt = null,Object? city = null,Object? days = null,Object? priceCents = null,Object? createdAt = null,Object? requesterName = freezed,}) {
  return _then(AdminFeaturedRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminFeaturedRequest].
extension AdminFeaturedRequestPatterns on AdminFeaturedRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminFeaturedRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminFeaturedRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminFeaturedRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdminFeaturedRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminFeaturedRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdminFeaturedRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String eventName,  DateTime eventStartsAt,  String city,  int days,  int priceCents,  DateTime createdAt,  String? requesterName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminFeaturedRequest() when $default != null:
return $default(_that.id,_that.eventId,_that.eventName,_that.eventStartsAt,_that.city,_that.days,_that.priceCents,_that.createdAt,_that.requesterName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String eventName,  DateTime eventStartsAt,  String city,  int days,  int priceCents,  DateTime createdAt,  String? requesterName)  $default,) {final _that = this;
switch (_that) {
case _AdminFeaturedRequest():
return $default(_that.id,_that.eventId,_that.eventName,_that.eventStartsAt,_that.city,_that.days,_that.priceCents,_that.createdAt,_that.requesterName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String eventName,  DateTime eventStartsAt,  String city,  int days,  int priceCents,  DateTime createdAt,  String? requesterName)?  $default,) {final _that = this;
switch (_that) {
case _AdminFeaturedRequest() when $default != null:
return $default(_that.id,_that.eventId,_that.eventName,_that.eventStartsAt,_that.city,_that.days,_that.priceCents,_that.createdAt,_that.requesterName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminFeaturedRequest implements AdminFeaturedRequest {
  const _AdminFeaturedRequest({required this.id, required this.eventId, required this.eventName, required this.eventStartsAt, required this.city, required this.days, required this.priceCents, required this.createdAt, this.requesterName});
  factory _AdminFeaturedRequest.fromJson(Map<String, dynamic> json) => _$AdminFeaturedRequestFromJson(json);

@override final  String id;
@override final  String eventId;
@override final  String eventName;
@override final  DateTime eventStartsAt;
@override final  String city;
@override final  int days;
@override final  int priceCents;
@override final  DateTime createdAt;
@override final  String? requesterName;

/// Create a copy of AdminFeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminFeaturedRequestCopyWith<_AdminFeaturedRequest> get copyWith => __$AdminFeaturedRequestCopyWithImpl<_AdminFeaturedRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminFeaturedRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminFeaturedRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventName, eventName) || other.eventName == eventName)&&(identical(other.eventStartsAt, eventStartsAt) || other.eventStartsAt == eventStartsAt)&&(identical(other.city, city) || other.city == city)&&(identical(other.days, days) || other.days == days)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requesterName, requesterName) || other.requesterName == requesterName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,eventId,eventName,eventStartsAt,city,days,priceCents,createdAt,requesterName);
}

@override
String toString() {
    return 'AdminFeaturedRequest(id: $id, eventId: $eventId, eventName: $eventName, eventStartsAt: $eventStartsAt, city: $city, days: $days, priceCents: $priceCents, createdAt: $createdAt, requesterName: $requesterName)';
}


}

/// @nodoc
abstract mixin class _$AdminFeaturedRequestCopyWith<$Res> implements $AdminFeaturedRequestCopyWith<$Res> {
  factory _$AdminFeaturedRequestCopyWith(_AdminFeaturedRequest value, $Res Function(_AdminFeaturedRequest) _then) = __$AdminFeaturedRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String eventName, DateTime eventStartsAt, String city, int days, int priceCents, DateTime createdAt, String? requesterName
});




}
/// @nodoc
class __$AdminFeaturedRequestCopyWithImpl<$Res>
    implements _$AdminFeaturedRequestCopyWith<$Res> {
  __$AdminFeaturedRequestCopyWithImpl(this._self, this._then);

  final _AdminFeaturedRequest _self;
  final $Res Function(_AdminFeaturedRequest) _then;

/// Create a copy of AdminFeaturedRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? eventName = null,Object? eventStartsAt = null,Object? city = null,Object? days = null,Object? priceCents = null,Object? createdAt = null,Object? requesterName = freezed,}) {
  return _then(_AdminFeaturedRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventName: null == eventName ? _self.eventName : eventName // ignore: cast_nullable_to_non_nullable
as String,eventStartsAt: null == eventStartsAt ? _self.eventStartsAt : eventStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requesterName: freezed == requesterName ? _self.requesterName : requesterName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
