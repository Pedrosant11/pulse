// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Venue {

 String get id; String get name; String get city; String get state; String? get neighborhood; String? get address; double? get lat; double? get lng; String? get photoPath; double? get rating; int get ratingCount; int get followers; int get upcoming; bool get isFollowing; VenueStatus get status;
/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueCopyWith<Venue> get copyWith => _$VenueCopyWithImpl<Venue>(this as Venue, _$identity);

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Venue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Venue&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.neighborhood, _this.neighborhood) || other.neighborhood == _this.neighborhood)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.followers, _this.followers) || other.followers == _this.followers)&&(identical(other.upcoming, _this.upcoming) || other.upcoming == _this.upcoming)&&(identical(other.isFollowing, _this.isFollowing) || other.isFollowing == _this.isFollowing)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Venue;
  return Object.hash(runtimeType,_this.id,_this.name,_this.city,_this.state,_this.neighborhood,_this.address,_this.lat,_this.lng,_this.photoPath,_this.rating,_this.ratingCount,_this.followers,_this.upcoming,_this.isFollowing,_this.status);
}

@override
String toString() {
  final _this = this as Venue;
  return 'Venue(id: ${_this.id}, name: ${_this.name}, city: ${_this.city}, state: ${_this.state}, neighborhood: ${_this.neighborhood}, address: ${_this.address}, lat: ${_this.lat}, lng: ${_this.lng}, photoPath: ${_this.photoPath}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, followers: ${_this.followers}, upcoming: ${_this.upcoming}, isFollowing: ${_this.isFollowing}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $VenueCopyWith<$Res>  {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) _then) = _$VenueCopyWithImpl;
@useResult
$Res call({
 String id, String name, String city, String state, String? neighborhood, String? address, double? lat, double? lng, String? photoPath, double? rating, int ratingCount, int followers, int upcoming, bool isFollowing, VenueStatus status
});




}
/// @nodoc
class _$VenueCopyWithImpl<$Res>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._self, this._then);

  final Venue _self;
  final $Res Function(Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = null,Object? state = null,Object? neighborhood = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? photoPath = freezed,Object? rating = freezed,Object? ratingCount = null,Object? followers = null,Object? upcoming = null,Object? isFollowing = null,Object? status = null,}) {
  return _then(Venue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,neighborhood: freezed == neighborhood ? _self.neighborhood : neighborhood // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VenueStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Venue].
extension VenuePatterns on Venue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Venue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Venue value)  $default,){
final _that = this;
switch (_that) {
case _Venue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Venue value)?  $default,){
final _that = this;
switch (_that) {
case _Venue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String state,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  double? rating,  int ratingCount,  int followers,  int upcoming,  bool isFollowing,  VenueStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.state,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.rating,_that.ratingCount,_that.followers,_that.upcoming,_that.isFollowing,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String state,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  double? rating,  int ratingCount,  int followers,  int upcoming,  bool isFollowing,  VenueStatus status)  $default,) {final _that = this;
switch (_that) {
case _Venue():
return $default(_that.id,_that.name,_that.city,_that.state,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.rating,_that.ratingCount,_that.followers,_that.upcoming,_that.isFollowing,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String city,  String state,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  double? rating,  int ratingCount,  int followers,  int upcoming,  bool isFollowing,  VenueStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Venue() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.state,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.rating,_that.ratingCount,_that.followers,_that.upcoming,_that.isFollowing,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Venue implements Venue {
  const _Venue({required this.id, required this.name, required this.city, required this.state, this.neighborhood, this.address, this.lat, this.lng, this.photoPath, this.rating, this.ratingCount = 0, this.followers = 0, this.upcoming = 0, this.isFollowing = false, this.status = VenueStatus.approved});
  factory _Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);

@override final  String id;
@override final  String name;
@override final  String city;
@override final  String state;
@override final  String? neighborhood;
@override final  String? address;
@override final  double? lat;
@override final  double? lng;
@override final  String? photoPath;
@override final  double? rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int followers;
@override@JsonKey() final  int upcoming;
@override@JsonKey() final  bool isFollowing;
@override@JsonKey() final  VenueStatus status;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VenueCopyWith<_Venue> get copyWith => __$VenueCopyWithImpl<_Venue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VenueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Venue&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.neighborhood, neighborhood) || other.neighborhood == neighborhood)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,city,state,neighborhood,address,lat,lng,photoPath,rating,ratingCount,followers,upcoming,isFollowing,status);
}

@override
String toString() {
    return 'Venue(id: $id, name: $name, city: $city, state: $state, neighborhood: $neighborhood, address: $address, lat: $lat, lng: $lng, photoPath: $photoPath, rating: $rating, ratingCount: $ratingCount, followers: $followers, upcoming: $upcoming, isFollowing: $isFollowing, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VenueCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$VenueCopyWith(_Venue value, $Res Function(_Venue) _then) = __$VenueCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String city, String state, String? neighborhood, String? address, double? lat, double? lng, String? photoPath, double? rating, int ratingCount, int followers, int upcoming, bool isFollowing, VenueStatus status
});




}
/// @nodoc
class __$VenueCopyWithImpl<$Res>
    implements _$VenueCopyWith<$Res> {
  __$VenueCopyWithImpl(this._self, this._then);

  final _Venue _self;
  final $Res Function(_Venue) _then;

/// Create a copy of Venue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = null,Object? state = null,Object? neighborhood = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? photoPath = freezed,Object? rating = freezed,Object? ratingCount = null,Object? followers = null,Object? upcoming = null,Object? isFollowing = null,Object? status = null,}) {
  return _then(_Venue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,neighborhood: freezed == neighborhood ? _self.neighborhood : neighborhood // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VenueStatus,
  ));
}


}


/// @nodoc
mixin _$VenueDetail {

 String get id; String get name; String get city; String get state; VenueStatus get status; String? get description; String? get neighborhood; String? get address; double? get lat; double? get lng; String? get photoPath; String? get instagram; String? get rejectionReason; double? get rating; int get ratingCount; int get followers; bool get isFollowing;/// Went to a party there, so can rate it.
 bool get canReview; int? get myRating; String? get myComment; int get pastEvents; bool get canEdit; List<EventSummary> get upcoming; List<VenueReview> get reviews;
/// Create a copy of VenueDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueDetailCopyWith<VenueDetail> get copyWith => _$VenueDetailCopyWithImpl<VenueDetail>(this as VenueDetail, _$identity);

  /// Serializes this VenueDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VenueDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VenueDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.neighborhood, _this.neighborhood) || other.neighborhood == _this.neighborhood)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lng, _this.lng) || other.lng == _this.lng)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.instagram, _this.instagram) || other.instagram == _this.instagram)&&(identical(other.rejectionReason, _this.rejectionReason) || other.rejectionReason == _this.rejectionReason)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.ratingCount, _this.ratingCount) || other.ratingCount == _this.ratingCount)&&(identical(other.followers, _this.followers) || other.followers == _this.followers)&&(identical(other.isFollowing, _this.isFollowing) || other.isFollowing == _this.isFollowing)&&(identical(other.canReview, _this.canReview) || other.canReview == _this.canReview)&&(identical(other.myRating, _this.myRating) || other.myRating == _this.myRating)&&(identical(other.myComment, _this.myComment) || other.myComment == _this.myComment)&&(identical(other.pastEvents, _this.pastEvents) || other.pastEvents == _this.pastEvents)&&(identical(other.canEdit, _this.canEdit) || other.canEdit == _this.canEdit)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming)&&const DeepCollectionEquality().equals(other.reviews, _this.reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VenueDetail;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.city,_this.state,_this.status,_this.description,_this.neighborhood,_this.address,_this.lat,_this.lng,_this.photoPath,_this.instagram,_this.rejectionReason,_this.rating,_this.ratingCount,_this.followers,_this.isFollowing,_this.canReview,_this.myRating,_this.myComment,_this.pastEvents,_this.canEdit,const DeepCollectionEquality().hash(_this.upcoming),const DeepCollectionEquality().hash(_this.reviews)]);
}

@override
String toString() {
  final _this = this as VenueDetail;
  return 'VenueDetail(id: ${_this.id}, name: ${_this.name}, city: ${_this.city}, state: ${_this.state}, status: ${_this.status}, description: ${_this.description}, neighborhood: ${_this.neighborhood}, address: ${_this.address}, lat: ${_this.lat}, lng: ${_this.lng}, photoPath: ${_this.photoPath}, instagram: ${_this.instagram}, rejectionReason: ${_this.rejectionReason}, rating: ${_this.rating}, ratingCount: ${_this.ratingCount}, followers: ${_this.followers}, isFollowing: ${_this.isFollowing}, canReview: ${_this.canReview}, myRating: ${_this.myRating}, myComment: ${_this.myComment}, pastEvents: ${_this.pastEvents}, canEdit: ${_this.canEdit}, upcoming: ${_this.upcoming}, reviews: ${_this.reviews})';
}


}

/// @nodoc
abstract mixin class $VenueDetailCopyWith<$Res>  {
  factory $VenueDetailCopyWith(VenueDetail value, $Res Function(VenueDetail) _then) = _$VenueDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String city, String state, VenueStatus status, String? description, String? neighborhood, String? address, double? lat, double? lng, String? photoPath, String? instagram, String? rejectionReason, double? rating, int ratingCount, int followers, bool isFollowing, bool canReview, int? myRating, String? myComment, int pastEvents, bool canEdit, List<EventSummary> upcoming, List<VenueReview> reviews
});




}
/// @nodoc
class _$VenueDetailCopyWithImpl<$Res>
    implements $VenueDetailCopyWith<$Res> {
  _$VenueDetailCopyWithImpl(this._self, this._then);

  final VenueDetail _self;
  final $Res Function(VenueDetail) _then;

/// Create a copy of VenueDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = null,Object? state = null,Object? status = null,Object? description = freezed,Object? neighborhood = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? photoPath = freezed,Object? instagram = freezed,Object? rejectionReason = freezed,Object? rating = freezed,Object? ratingCount = null,Object? followers = null,Object? isFollowing = null,Object? canReview = null,Object? myRating = freezed,Object? myComment = freezed,Object? pastEvents = null,Object? canEdit = null,Object? upcoming = null,Object? reviews = null,}) {
  return _then(VenueDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VenueStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,neighborhood: freezed == neighborhood ? _self.neighborhood : neighborhood // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,instagram: freezed == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,myComment: freezed == myComment ? _self.myComment : myComment // ignore: cast_nullable_to_non_nullable
as String?,pastEvents: null == pastEvents ? _self.pastEvents : pastEvents // ignore: cast_nullable_to_non_nullable
as int,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<VenueReview>,
  ));
}

}


/// Adds pattern-matching-related methods to [VenueDetail].
extension VenueDetailPatterns on VenueDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VenueDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VenueDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VenueDetail value)  $default,){
final _that = this;
switch (_that) {
case _VenueDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VenueDetail value)?  $default,){
final _that = this;
switch (_that) {
case _VenueDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String state,  VenueStatus status,  String? description,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  String? instagram,  String? rejectionReason,  double? rating,  int ratingCount,  int followers,  bool isFollowing,  bool canReview,  int? myRating,  String? myComment,  int pastEvents,  bool canEdit,  List<EventSummary> upcoming,  List<VenueReview> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VenueDetail() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.state,_that.status,_that.description,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.instagram,_that.rejectionReason,_that.rating,_that.ratingCount,_that.followers,_that.isFollowing,_that.canReview,_that.myRating,_that.myComment,_that.pastEvents,_that.canEdit,_that.upcoming,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String city,  String state,  VenueStatus status,  String? description,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  String? instagram,  String? rejectionReason,  double? rating,  int ratingCount,  int followers,  bool isFollowing,  bool canReview,  int? myRating,  String? myComment,  int pastEvents,  bool canEdit,  List<EventSummary> upcoming,  List<VenueReview> reviews)  $default,) {final _that = this;
switch (_that) {
case _VenueDetail():
return $default(_that.id,_that.name,_that.city,_that.state,_that.status,_that.description,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.instagram,_that.rejectionReason,_that.rating,_that.ratingCount,_that.followers,_that.isFollowing,_that.canReview,_that.myRating,_that.myComment,_that.pastEvents,_that.canEdit,_that.upcoming,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String city,  String state,  VenueStatus status,  String? description,  String? neighborhood,  String? address,  double? lat,  double? lng,  String? photoPath,  String? instagram,  String? rejectionReason,  double? rating,  int ratingCount,  int followers,  bool isFollowing,  bool canReview,  int? myRating,  String? myComment,  int pastEvents,  bool canEdit,  List<EventSummary> upcoming,  List<VenueReview> reviews)?  $default,) {final _that = this;
switch (_that) {
case _VenueDetail() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.state,_that.status,_that.description,_that.neighborhood,_that.address,_that.lat,_that.lng,_that.photoPath,_that.instagram,_that.rejectionReason,_that.rating,_that.ratingCount,_that.followers,_that.isFollowing,_that.canReview,_that.myRating,_that.myComment,_that.pastEvents,_that.canEdit,_that.upcoming,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VenueDetail implements VenueDetail {
  const _VenueDetail({required this.id, required this.name, required this.city, required this.state, required this.status, this.description, this.neighborhood, this.address, this.lat, this.lng, this.photoPath, this.instagram, this.rejectionReason, this.rating, this.ratingCount = 0, this.followers = 0, this.isFollowing = false, this.canReview = false, this.myRating, this.myComment, this.pastEvents = 0, this.canEdit = false,  List<EventSummary> upcoming = const [],  List<VenueReview> reviews = const []}): _upcoming = upcoming,_reviews = reviews;
  factory _VenueDetail.fromJson(Map<String, dynamic> json) => _$VenueDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String city;
@override final  String state;
@override final  VenueStatus status;
@override final  String? description;
@override final  String? neighborhood;
@override final  String? address;
@override final  double? lat;
@override final  double? lng;
@override final  String? photoPath;
@override final  String? instagram;
@override final  String? rejectionReason;
@override final  double? rating;
@override@JsonKey() final  int ratingCount;
@override@JsonKey() final  int followers;
@override@JsonKey() final  bool isFollowing;
/// Went to a party there, so can rate it.
@override@JsonKey() final  bool canReview;
@override final  int? myRating;
@override final  String? myComment;
@override@JsonKey() final  int pastEvents;
@override@JsonKey() final  bool canEdit;
 final  List<EventSummary> _upcoming;
@override@JsonKey() List<EventSummary> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

 final  List<VenueReview> _reviews;
@override@JsonKey() List<VenueReview> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of VenueDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VenueDetailCopyWith<_VenueDetail> get copyWith => __$VenueDetailCopyWithImpl<_VenueDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VenueDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VenueDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.status, status) || other.status == status)&&(identical(other.description, description) || other.description == description)&&(identical(other.neighborhood, neighborhood) || other.neighborhood == neighborhood)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.instagram, instagram) || other.instagram == instagram)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.canReview, canReview) || other.canReview == canReview)&&(identical(other.myRating, myRating) || other.myRating == myRating)&&(identical(other.myComment, myComment) || other.myComment == myComment)&&(identical(other.pastEvents, pastEvents) || other.pastEvents == pastEvents)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming)&&const DeepCollectionEquality().equals(other.reviews, _reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,city,state,status,description,neighborhood,address,lat,lng,photoPath,instagram,rejectionReason,rating,ratingCount,followers,isFollowing,canReview,myRating,myComment,pastEvents,canEdit,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_reviews)]);
}

@override
String toString() {
    return 'VenueDetail(id: $id, name: $name, city: $city, state: $state, status: $status, description: $description, neighborhood: $neighborhood, address: $address, lat: $lat, lng: $lng, photoPath: $photoPath, instagram: $instagram, rejectionReason: $rejectionReason, rating: $rating, ratingCount: $ratingCount, followers: $followers, isFollowing: $isFollowing, canReview: $canReview, myRating: $myRating, myComment: $myComment, pastEvents: $pastEvents, canEdit: $canEdit, upcoming: $upcoming, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$VenueDetailCopyWith<$Res> implements $VenueDetailCopyWith<$Res> {
  factory _$VenueDetailCopyWith(_VenueDetail value, $Res Function(_VenueDetail) _then) = __$VenueDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String city, String state, VenueStatus status, String? description, String? neighborhood, String? address, double? lat, double? lng, String? photoPath, String? instagram, String? rejectionReason, double? rating, int ratingCount, int followers, bool isFollowing, bool canReview, int? myRating, String? myComment, int pastEvents, bool canEdit, List<EventSummary> upcoming, List<VenueReview> reviews
});




}
/// @nodoc
class __$VenueDetailCopyWithImpl<$Res>
    implements _$VenueDetailCopyWith<$Res> {
  __$VenueDetailCopyWithImpl(this._self, this._then);

  final _VenueDetail _self;
  final $Res Function(_VenueDetail) _then;

/// Create a copy of VenueDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = null,Object? state = null,Object? status = null,Object? description = freezed,Object? neighborhood = freezed,Object? address = freezed,Object? lat = freezed,Object? lng = freezed,Object? photoPath = freezed,Object? instagram = freezed,Object? rejectionReason = freezed,Object? rating = freezed,Object? ratingCount = null,Object? followers = null,Object? isFollowing = null,Object? canReview = null,Object? myRating = freezed,Object? myComment = freezed,Object? pastEvents = null,Object? canEdit = null,Object? upcoming = null,Object? reviews = null,}) {
  return _then(_VenueDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VenueStatus,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,neighborhood: freezed == neighborhood ? _self.neighborhood : neighborhood // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,instagram: freezed == instagram ? _self.instagram : instagram // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,canReview: null == canReview ? _self.canReview : canReview // ignore: cast_nullable_to_non_nullable
as bool,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,myComment: freezed == myComment ? _self.myComment : myComment // ignore: cast_nullable_to_non_nullable
as String?,pastEvents: null == pastEvents ? _self.pastEvents : pastEvents // ignore: cast_nullable_to_non_nullable
as int,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventSummary>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<VenueReview>,
  ));
}


}


/// @nodoc
mixin _$VenueReview {

 String get userId; String get firstName; int get rating; DateTime get updatedAt; String? get comment;
/// Create a copy of VenueReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueReviewCopyWith<VenueReview> get copyWith => _$VenueReviewCopyWithImpl<VenueReview>(this as VenueReview, _$identity);

  /// Serializes this VenueReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VenueReview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VenueReview&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.comment, _this.comment) || other.comment == _this.comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VenueReview;
  return Object.hash(runtimeType,_this.userId,_this.firstName,_this.rating,_this.updatedAt,_this.comment);
}

@override
String toString() {
  final _this = this as VenueReview;
  return 'VenueReview(userId: ${_this.userId}, firstName: ${_this.firstName}, rating: ${_this.rating}, updatedAt: ${_this.updatedAt}, comment: ${_this.comment})';
}


}

/// @nodoc
abstract mixin class $VenueReviewCopyWith<$Res>  {
  factory $VenueReviewCopyWith(VenueReview value, $Res Function(VenueReview) _then) = _$VenueReviewCopyWithImpl;
@useResult
$Res call({
 String userId, String firstName, int rating, DateTime updatedAt, String? comment
});




}
/// @nodoc
class _$VenueReviewCopyWithImpl<$Res>
    implements $VenueReviewCopyWith<$Res> {
  _$VenueReviewCopyWithImpl(this._self, this._then);

  final VenueReview _self;
  final $Res Function(VenueReview) _then;

/// Create a copy of VenueReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? firstName = null,Object? rating = null,Object? updatedAt = null,Object? comment = freezed,}) {
  return _then(VenueReview(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VenueReview].
extension VenueReviewPatterns on VenueReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VenueReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VenueReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VenueReview value)  $default,){
final _that = this;
switch (_that) {
case _VenueReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VenueReview value)?  $default,){
final _that = this;
switch (_that) {
case _VenueReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String firstName,  int rating,  DateTime updatedAt,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VenueReview() when $default != null:
return $default(_that.userId,_that.firstName,_that.rating,_that.updatedAt,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String firstName,  int rating,  DateTime updatedAt,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _VenueReview():
return $default(_that.userId,_that.firstName,_that.rating,_that.updatedAt,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String firstName,  int rating,  DateTime updatedAt,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _VenueReview() when $default != null:
return $default(_that.userId,_that.firstName,_that.rating,_that.updatedAt,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VenueReview implements VenueReview {
  const _VenueReview({required this.userId, required this.firstName, required this.rating, required this.updatedAt, this.comment});
  factory _VenueReview.fromJson(Map<String, dynamic> json) => _$VenueReviewFromJson(json);

@override final  String userId;
@override final  String firstName;
@override final  int rating;
@override final  DateTime updatedAt;
@override final  String? comment;

/// Create a copy of VenueReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VenueReviewCopyWith<_VenueReview> get copyWith => __$VenueReviewCopyWithImpl<_VenueReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VenueReviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VenueReview&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,firstName,rating,updatedAt,comment);
}

@override
String toString() {
    return 'VenueReview(userId: $userId, firstName: $firstName, rating: $rating, updatedAt: $updatedAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$VenueReviewCopyWith<$Res> implements $VenueReviewCopyWith<$Res> {
  factory _$VenueReviewCopyWith(_VenueReview value, $Res Function(_VenueReview) _then) = __$VenueReviewCopyWithImpl;
@override @useResult
$Res call({
 String userId, String firstName, int rating, DateTime updatedAt, String? comment
});




}
/// @nodoc
class __$VenueReviewCopyWithImpl<$Res>
    implements _$VenueReviewCopyWith<$Res> {
  __$VenueReviewCopyWithImpl(this._self, this._then);

  final _VenueReview _self;
  final $Res Function(_VenueReview) _then;

/// Create a copy of VenueReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? firstName = null,Object? rating = null,Object? updatedAt = null,Object? comment = freezed,}) {
  return _then(_VenueReview(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
