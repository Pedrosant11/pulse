// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HouseAd {

 String get id; String get title; String? get body; String? get imagePath; String? get cta;/// A tap opens this party in the app...
 String? get eventId;/// ...or this website.
 String? get linkUrl; List<AdPlacement> get placements;
/// Create a copy of HouseAd
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseAdCopyWith<HouseAd> get copyWith => _$HouseAdCopyWithImpl<HouseAd>(this as HouseAd, _$identity);

  /// Serializes this HouseAd to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HouseAd;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseAd&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.cta, _this.cta) || other.cta == _this.cta)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.linkUrl, _this.linkUrl) || other.linkUrl == _this.linkUrl)&&const DeepCollectionEquality().equals(other.placements, _this.placements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HouseAd;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,_this.imagePath,_this.cta,_this.eventId,_this.linkUrl,const DeepCollectionEquality().hash(_this.placements));
}

@override
String toString() {
  final _this = this as HouseAd;
  return 'HouseAd(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, imagePath: ${_this.imagePath}, cta: ${_this.cta}, eventId: ${_this.eventId}, linkUrl: ${_this.linkUrl}, placements: ${_this.placements})';
}


}

/// @nodoc
abstract mixin class $HouseAdCopyWith<$Res>  {
  factory $HouseAdCopyWith(HouseAd value, $Res Function(HouseAd) _then) = _$HouseAdCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? body, String? imagePath, String? cta, String? eventId, String? linkUrl, List<AdPlacement> placements
});




}
/// @nodoc
class _$HouseAdCopyWithImpl<$Res>
    implements $HouseAdCopyWith<$Res> {
  _$HouseAdCopyWithImpl(this._self, this._then);

  final HouseAd _self;
  final $Res Function(HouseAd) _then;

/// Create a copy of HouseAd
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = freezed,Object? imagePath = freezed,Object? cta = freezed,Object? eventId = freezed,Object? linkUrl = freezed,Object? placements = null,}) {
  return _then(HouseAd(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,placements: null == placements ? _self.placements : placements // ignore: cast_nullable_to_non_nullable
as List<AdPlacement>,
  ));
}

}


/// Adds pattern-matching-related methods to [HouseAd].
extension HouseAdPatterns on HouseAd {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HouseAd value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HouseAd() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HouseAd value)  $default,){
final _that = this;
switch (_that) {
case _HouseAd():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HouseAd value)?  $default,){
final _that = this;
switch (_that) {
case _HouseAd() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HouseAd() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements)  $default,) {final _that = this;
switch (_that) {
case _HouseAd():
return $default(_that.id,_that.title,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements)?  $default,) {final _that = this;
switch (_that) {
case _HouseAd() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HouseAd implements HouseAd {
  const _HouseAd({required this.id, required this.title, this.body, this.imagePath, this.cta, this.eventId, this.linkUrl,  List<AdPlacement> placements = AdPlacement.values}): _placements = placements;
  factory _HouseAd.fromJson(Map<String, dynamic> json) => _$HouseAdFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? body;
@override final  String? imagePath;
@override final  String? cta;
/// A tap opens this party in the app...
@override final  String? eventId;
/// ...or this website.
@override final  String? linkUrl;
 final  List<AdPlacement> _placements;
@override@JsonKey() List<AdPlacement> get placements {
  if (_placements is EqualUnmodifiableListView) return _placements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placements);
}


/// Create a copy of HouseAd
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HouseAdCopyWith<_HouseAd> get copyWith => __$HouseAdCopyWithImpl<_HouseAd>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HouseAdToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HouseAd&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&const DeepCollectionEquality().equals(other.placements, _placements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,imagePath,cta,eventId,linkUrl,const DeepCollectionEquality().hash(_placements));
}

@override
String toString() {
    return 'HouseAd(id: $id, title: $title, body: $body, imagePath: $imagePath, cta: $cta, eventId: $eventId, linkUrl: $linkUrl, placements: $placements)';
}


}

/// @nodoc
abstract mixin class _$HouseAdCopyWith<$Res> implements $HouseAdCopyWith<$Res> {
  factory _$HouseAdCopyWith(_HouseAd value, $Res Function(_HouseAd) _then) = __$HouseAdCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? body, String? imagePath, String? cta, String? eventId, String? linkUrl, List<AdPlacement> placements
});




}
/// @nodoc
class __$HouseAdCopyWithImpl<$Res>
    implements _$HouseAdCopyWith<$Res> {
  __$HouseAdCopyWithImpl(this._self, this._then);

  final _HouseAd _self;
  final $Res Function(_HouseAd) _then;

/// Create a copy of HouseAd
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = freezed,Object? imagePath = freezed,Object? cta = freezed,Object? eventId = freezed,Object? linkUrl = freezed,Object? placements = null,}) {
  return _then(_HouseAd(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,placements: null == placements ? _self._placements : placements // ignore: cast_nullable_to_non_nullable
as List<AdPlacement>,
  ));
}


}


/// @nodoc
mixin _$AdsConfig {

 bool get enabled; int get eventsEvery; int get discoverEvery; List<HouseAd> get ads;
/// Create a copy of AdsConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdsConfigCopyWith<AdsConfig> get copyWith => _$AdsConfigCopyWithImpl<AdsConfig>(this as AdsConfig, _$identity);

  /// Serializes this AdsConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdsConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdsConfig&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.eventsEvery, _this.eventsEvery) || other.eventsEvery == _this.eventsEvery)&&(identical(other.discoverEvery, _this.discoverEvery) || other.discoverEvery == _this.discoverEvery)&&const DeepCollectionEquality().equals(other.ads, _this.ads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdsConfig;
  return Object.hash(runtimeType,_this.enabled,_this.eventsEvery,_this.discoverEvery,const DeepCollectionEquality().hash(_this.ads));
}

@override
String toString() {
  final _this = this as AdsConfig;
  return 'AdsConfig(enabled: ${_this.enabled}, eventsEvery: ${_this.eventsEvery}, discoverEvery: ${_this.discoverEvery}, ads: ${_this.ads})';
}


}

/// @nodoc
abstract mixin class $AdsConfigCopyWith<$Res>  {
  factory $AdsConfigCopyWith(AdsConfig value, $Res Function(AdsConfig) _then) = _$AdsConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled, int eventsEvery, int discoverEvery, List<HouseAd> ads
});




}
/// @nodoc
class _$AdsConfigCopyWithImpl<$Res>
    implements $AdsConfigCopyWith<$Res> {
  _$AdsConfigCopyWithImpl(this._self, this._then);

  final AdsConfig _self;
  final $Res Function(AdsConfig) _then;

/// Create a copy of AdsConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? eventsEvery = null,Object? discoverEvery = null,Object? ads = null,}) {
  return _then(AdsConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,eventsEvery: null == eventsEvery ? _self.eventsEvery : eventsEvery // ignore: cast_nullable_to_non_nullable
as int,discoverEvery: null == discoverEvery ? _self.discoverEvery : discoverEvery // ignore: cast_nullable_to_non_nullable
as int,ads: null == ads ? _self.ads : ads // ignore: cast_nullable_to_non_nullable
as List<HouseAd>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdsConfig].
extension AdsConfigPatterns on AdsConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdsConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdsConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdsConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdsConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdsConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdsConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  int eventsEvery,  int discoverEvery,  List<HouseAd> ads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdsConfig() when $default != null:
return $default(_that.enabled,_that.eventsEvery,_that.discoverEvery,_that.ads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  int eventsEvery,  int discoverEvery,  List<HouseAd> ads)  $default,) {final _that = this;
switch (_that) {
case _AdsConfig():
return $default(_that.enabled,_that.eventsEvery,_that.discoverEvery,_that.ads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  int eventsEvery,  int discoverEvery,  List<HouseAd> ads)?  $default,) {final _that = this;
switch (_that) {
case _AdsConfig() when $default != null:
return $default(_that.enabled,_that.eventsEvery,_that.discoverEvery,_that.ads);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdsConfig extends AdsConfig {
  const _AdsConfig({this.enabled = false, this.eventsEvery = 6, this.discoverEvery = 20,  List<HouseAd> ads = const []}): _ads = ads,super._();
  factory _AdsConfig.fromJson(Map<String, dynamic> json) => _$AdsConfigFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  int eventsEvery;
@override@JsonKey() final  int discoverEvery;
 final  List<HouseAd> _ads;
@override@JsonKey() List<HouseAd> get ads {
  if (_ads is EqualUnmodifiableListView) return _ads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ads);
}


/// Create a copy of AdsConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdsConfigCopyWith<_AdsConfig> get copyWith => __$AdsConfigCopyWithImpl<_AdsConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdsConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdsConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.eventsEvery, eventsEvery) || other.eventsEvery == eventsEvery)&&(identical(other.discoverEvery, discoverEvery) || other.discoverEvery == discoverEvery)&&const DeepCollectionEquality().equals(other.ads, _ads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,eventsEvery,discoverEvery,const DeepCollectionEquality().hash(_ads));
}

@override
String toString() {
    return 'AdsConfig(enabled: $enabled, eventsEvery: $eventsEvery, discoverEvery: $discoverEvery, ads: $ads)';
}


}

/// @nodoc
abstract mixin class _$AdsConfigCopyWith<$Res> implements $AdsConfigCopyWith<$Res> {
  factory _$AdsConfigCopyWith(_AdsConfig value, $Res Function(_AdsConfig) _then) = __$AdsConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int eventsEvery, int discoverEvery, List<HouseAd> ads
});




}
/// @nodoc
class __$AdsConfigCopyWithImpl<$Res>
    implements _$AdsConfigCopyWith<$Res> {
  __$AdsConfigCopyWithImpl(this._self, this._then);

  final _AdsConfig _self;
  final $Res Function(_AdsConfig) _then;

/// Create a copy of AdsConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? eventsEvery = null,Object? discoverEvery = null,Object? ads = null,}) {
  return _then(_AdsConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,eventsEvery: null == eventsEvery ? _self.eventsEvery : eventsEvery // ignore: cast_nullable_to_non_nullable
as int,discoverEvery: null == discoverEvery ? _self.discoverEvery : discoverEvery // ignore: cast_nullable_to_non_nullable
as int,ads: null == ads ? _self._ads : ads // ignore: cast_nullable_to_non_nullable
as List<HouseAd>,
  ));
}


}


/// @nodoc
mixin _$AdminAd {

 String get id; String get title; DateTime get startsAt; String? get body; String? get imagePath; String? get cta; String? get eventId; String? get linkUrl; List<AdPlacement> get placements; DateTime? get endsAt; bool get active;@JsonKey(includeToJson: false) int get impressions;@JsonKey(includeToJson: false) int get clicks;
/// Create a copy of AdminAd
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAdCopyWith<AdminAd> get copyWith => _$AdminAdCopyWithImpl<AdminAd>(this as AdminAd, _$identity);

  /// Serializes this AdminAd to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminAd;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAd&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.cta, _this.cta) || other.cta == _this.cta)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.linkUrl, _this.linkUrl) || other.linkUrl == _this.linkUrl)&&const DeepCollectionEquality().equals(other.placements, _this.placements)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.impressions, _this.impressions) || other.impressions == _this.impressions)&&(identical(other.clicks, _this.clicks) || other.clicks == _this.clicks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminAd;
  return Object.hash(runtimeType,_this.id,_this.title,_this.startsAt,_this.body,_this.imagePath,_this.cta,_this.eventId,_this.linkUrl,const DeepCollectionEquality().hash(_this.placements),_this.endsAt,_this.active,_this.impressions,_this.clicks);
}

@override
String toString() {
  final _this = this as AdminAd;
  return 'AdminAd(id: ${_this.id}, title: ${_this.title}, startsAt: ${_this.startsAt}, body: ${_this.body}, imagePath: ${_this.imagePath}, cta: ${_this.cta}, eventId: ${_this.eventId}, linkUrl: ${_this.linkUrl}, placements: ${_this.placements}, endsAt: ${_this.endsAt}, active: ${_this.active}, impressions: ${_this.impressions}, clicks: ${_this.clicks})';
}


}

/// @nodoc
abstract mixin class $AdminAdCopyWith<$Res>  {
  factory $AdminAdCopyWith(AdminAd value, $Res Function(AdminAd) _then) = _$AdminAdCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime startsAt, String? body, String? imagePath, String? cta, String? eventId, String? linkUrl, List<AdPlacement> placements, DateTime? endsAt, bool active,@JsonKey(includeToJson: false) int impressions,@JsonKey(includeToJson: false) int clicks
});




}
/// @nodoc
class _$AdminAdCopyWithImpl<$Res>
    implements $AdminAdCopyWith<$Res> {
  _$AdminAdCopyWithImpl(this._self, this._then);

  final AdminAd _self;
  final $Res Function(AdminAd) _then;

/// Create a copy of AdminAd
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? body = freezed,Object? imagePath = freezed,Object? cta = freezed,Object? eventId = freezed,Object? linkUrl = freezed,Object? placements = null,Object? endsAt = freezed,Object? active = null,Object? impressions = null,Object? clicks = null,}) {
  return _then(AdminAd(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,placements: null == placements ? _self.placements : placements // ignore: cast_nullable_to_non_nullable
as List<AdPlacement>,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminAd].
extension AdminAdPatterns on AdminAd {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAd value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAd() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAd value)  $default,){
final _that = this;
switch (_that) {
case _AdminAd():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAd value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAd() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startsAt,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements,  DateTime? endsAt,  bool active, @JsonKey(includeToJson: false)  int impressions, @JsonKey(includeToJson: false)  int clicks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAd() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements,_that.endsAt,_that.active,_that.impressions,_that.clicks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startsAt,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements,  DateTime? endsAt,  bool active, @JsonKey(includeToJson: false)  int impressions, @JsonKey(includeToJson: false)  int clicks)  $default,) {final _that = this;
switch (_that) {
case _AdminAd():
return $default(_that.id,_that.title,_that.startsAt,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements,_that.endsAt,_that.active,_that.impressions,_that.clicks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime startsAt,  String? body,  String? imagePath,  String? cta,  String? eventId,  String? linkUrl,  List<AdPlacement> placements,  DateTime? endsAt,  bool active, @JsonKey(includeToJson: false)  int impressions, @JsonKey(includeToJson: false)  int clicks)?  $default,) {final _that = this;
switch (_that) {
case _AdminAd() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.body,_that.imagePath,_that.cta,_that.eventId,_that.linkUrl,_that.placements,_that.endsAt,_that.active,_that.impressions,_that.clicks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminAd extends AdminAd {
  const _AdminAd({required this.id, required this.title, required this.startsAt, this.body, this.imagePath, this.cta, this.eventId, this.linkUrl,  List<AdPlacement> placements = AdPlacement.values, this.endsAt, this.active = true, @JsonKey(includeToJson: false) this.impressions = 0, @JsonKey(includeToJson: false) this.clicks = 0}): _placements = placements,super._();
  factory _AdminAd.fromJson(Map<String, dynamic> json) => _$AdminAdFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime startsAt;
@override final  String? body;
@override final  String? imagePath;
@override final  String? cta;
@override final  String? eventId;
@override final  String? linkUrl;
 final  List<AdPlacement> _placements;
@override@JsonKey() List<AdPlacement> get placements {
  if (_placements is EqualUnmodifiableListView) return _placements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placements);
}

@override final  DateTime? endsAt;
@override@JsonKey() final  bool active;
@override@JsonKey(includeToJson: false) final  int impressions;
@override@JsonKey(includeToJson: false) final  int clicks;

/// Create a copy of AdminAd
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAdCopyWith<_AdminAd> get copyWith => __$AdminAdCopyWithImpl<_AdminAd>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminAdToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAd&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.body, body) || other.body == body)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl)&&const DeepCollectionEquality().equals(other.placements, _placements)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.active, active) || other.active == active)&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.clicks, clicks) || other.clicks == clicks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,startsAt,body,imagePath,cta,eventId,linkUrl,const DeepCollectionEquality().hash(_placements),endsAt,active,impressions,clicks);
}

@override
String toString() {
    return 'AdminAd(id: $id, title: $title, startsAt: $startsAt, body: $body, imagePath: $imagePath, cta: $cta, eventId: $eventId, linkUrl: $linkUrl, placements: $placements, endsAt: $endsAt, active: $active, impressions: $impressions, clicks: $clicks)';
}


}

/// @nodoc
abstract mixin class _$AdminAdCopyWith<$Res> implements $AdminAdCopyWith<$Res> {
  factory _$AdminAdCopyWith(_AdminAd value, $Res Function(_AdminAd) _then) = __$AdminAdCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime startsAt, String? body, String? imagePath, String? cta, String? eventId, String? linkUrl, List<AdPlacement> placements, DateTime? endsAt, bool active,@JsonKey(includeToJson: false) int impressions,@JsonKey(includeToJson: false) int clicks
});




}
/// @nodoc
class __$AdminAdCopyWithImpl<$Res>
    implements _$AdminAdCopyWith<$Res> {
  __$AdminAdCopyWithImpl(this._self, this._then);

  final _AdminAd _self;
  final $Res Function(_AdminAd) _then;

/// Create a copy of AdminAd
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? body = freezed,Object? imagePath = freezed,Object? cta = freezed,Object? eventId = freezed,Object? linkUrl = freezed,Object? placements = null,Object? endsAt = freezed,Object? active = null,Object? impressions = null,Object? clicks = null,}) {
  return _then(_AdminAd(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,cta: freezed == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as String?,eventId: freezed == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String?,linkUrl: freezed == linkUrl ? _self.linkUrl : linkUrl // ignore: cast_nullable_to_non_nullable
as String?,placements: null == placements ? _self._placements : placements // ignore: cast_nullable_to_non_nullable
as List<AdPlacement>,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
