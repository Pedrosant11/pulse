// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_console_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminDashboard {

 DashboardUsers get users; DashboardActivity get activity; DashboardPending get pending; DashboardPlans get plans;@JsonKey(name: 'revenue_30d') DashboardRevenue get revenue30d; List<DashboardDay> get daily;
/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDashboardCopyWith<AdminDashboard> get copyWith => _$AdminDashboardCopyWithImpl<AdminDashboard>(this as AdminDashboard, _$identity);

  /// Serializes this AdminDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDashboard&&(identical(other.users, _this.users) || other.users == _this.users)&&(identical(other.activity, _this.activity) || other.activity == _this.activity)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.plans, _this.plans) || other.plans == _this.plans)&&(identical(other.revenue30d, _this.revenue30d) || other.revenue30d == _this.revenue30d)&&const DeepCollectionEquality().equals(other.daily, _this.daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminDashboard;
  return Object.hash(runtimeType,_this.users,_this.activity,_this.pending,_this.plans,_this.revenue30d,const DeepCollectionEquality().hash(_this.daily));
}

@override
String toString() {
  final _this = this as AdminDashboard;
  return 'AdminDashboard(users: ${_this.users}, activity: ${_this.activity}, pending: ${_this.pending}, plans: ${_this.plans}, revenue30d: ${_this.revenue30d}, daily: ${_this.daily})';
}


}

/// @nodoc
abstract mixin class $AdminDashboardCopyWith<$Res>  {
  factory $AdminDashboardCopyWith(AdminDashboard value, $Res Function(AdminDashboard) _then) = _$AdminDashboardCopyWithImpl;
@useResult
$Res call({
 DashboardUsers users, DashboardActivity activity, DashboardPending pending, DashboardPlans plans,@JsonKey(name: 'revenue_30d') DashboardRevenue revenue30d, List<DashboardDay> daily
});


$DashboardUsersCopyWith<$Res> get users;$DashboardActivityCopyWith<$Res> get activity;$DashboardPendingCopyWith<$Res> get pending;$DashboardPlansCopyWith<$Res> get plans;$DashboardRevenueCopyWith<$Res> get revenue30d;

}
/// @nodoc
class _$AdminDashboardCopyWithImpl<$Res>
    implements $AdminDashboardCopyWith<$Res> {
  _$AdminDashboardCopyWithImpl(this._self, this._then);

  final AdminDashboard _self;
  final $Res Function(AdminDashboard) _then;

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? activity = null,Object? pending = null,Object? plans = null,Object? revenue30d = null,Object? daily = null,}) {
  return _then(AdminDashboard(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as DashboardUsers,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as DashboardActivity,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as DashboardPending,plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as DashboardPlans,revenue30d: null == revenue30d ? _self.revenue30d : revenue30d // ignore: cast_nullable_to_non_nullable
as DashboardRevenue,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DashboardDay>,
  ));
}
/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardUsersCopyWith<$Res> get users {
  
  return $DashboardUsersCopyWith<$Res>(_self.users, (value) {
    return _then(_self.copyWith(users: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardActivityCopyWith<$Res> get activity {
  
  return $DashboardActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPendingCopyWith<$Res> get pending {
  
  return $DashboardPendingCopyWith<$Res>(_self.pending, (value) {
    return _then(_self.copyWith(pending: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPlansCopyWith<$Res> get plans {
  
  return $DashboardPlansCopyWith<$Res>(_self.plans, (value) {
    return _then(_self.copyWith(plans: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardRevenueCopyWith<$Res> get revenue30d {
  
  return $DashboardRevenueCopyWith<$Res>(_self.revenue30d, (value) {
    return _then(_self.copyWith(revenue30d: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminDashboard].
extension AdminDashboardPatterns on AdminDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDashboard value)  $default,){
final _that = this;
switch (_that) {
case _AdminDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardUsers users,  DashboardActivity activity,  DashboardPending pending,  DashboardPlans plans, @JsonKey(name: 'revenue_30d')  DashboardRevenue revenue30d,  List<DashboardDay> daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
return $default(_that.users,_that.activity,_that.pending,_that.plans,_that.revenue30d,_that.daily);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardUsers users,  DashboardActivity activity,  DashboardPending pending,  DashboardPlans plans, @JsonKey(name: 'revenue_30d')  DashboardRevenue revenue30d,  List<DashboardDay> daily)  $default,) {final _that = this;
switch (_that) {
case _AdminDashboard():
return $default(_that.users,_that.activity,_that.pending,_that.plans,_that.revenue30d,_that.daily);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardUsers users,  DashboardActivity activity,  DashboardPending pending,  DashboardPlans plans, @JsonKey(name: 'revenue_30d')  DashboardRevenue revenue30d,  List<DashboardDay> daily)?  $default,) {final _that = this;
switch (_that) {
case _AdminDashboard() when $default != null:
return $default(_that.users,_that.activity,_that.pending,_that.plans,_that.revenue30d,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminDashboard implements AdminDashboard {
  const _AdminDashboard({required this.users, required this.activity, required this.pending, required this.plans, @JsonKey(name: 'revenue_30d') required this.revenue30d,  List<DashboardDay> daily = const []}): _daily = daily;
  factory _AdminDashboard.fromJson(Map<String, dynamic> json) => _$AdminDashboardFromJson(json);

@override final  DashboardUsers users;
@override final  DashboardActivity activity;
@override final  DashboardPending pending;
@override final  DashboardPlans plans;
@override@JsonKey(name: 'revenue_30d') final  DashboardRevenue revenue30d;
 final  List<DashboardDay> _daily;
@override@JsonKey() List<DashboardDay> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}


/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDashboardCopyWith<_AdminDashboard> get copyWith => __$AdminDashboardCopyWithImpl<_AdminDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDashboard&&(identical(other.users, users) || other.users == users)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.plans, plans) || other.plans == plans)&&(identical(other.revenue30d, revenue30d) || other.revenue30d == revenue30d)&&const DeepCollectionEquality().equals(other.daily, _daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,users,activity,pending,plans,revenue30d,const DeepCollectionEquality().hash(_daily));
}

@override
String toString() {
    return 'AdminDashboard(users: $users, activity: $activity, pending: $pending, plans: $plans, revenue30d: $revenue30d, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$AdminDashboardCopyWith<$Res> implements $AdminDashboardCopyWith<$Res> {
  factory _$AdminDashboardCopyWith(_AdminDashboard value, $Res Function(_AdminDashboard) _then) = __$AdminDashboardCopyWithImpl;
@override @useResult
$Res call({
 DashboardUsers users, DashboardActivity activity, DashboardPending pending, DashboardPlans plans,@JsonKey(name: 'revenue_30d') DashboardRevenue revenue30d, List<DashboardDay> daily
});


@override $DashboardUsersCopyWith<$Res> get users;@override $DashboardActivityCopyWith<$Res> get activity;@override $DashboardPendingCopyWith<$Res> get pending;@override $DashboardPlansCopyWith<$Res> get plans;@override $DashboardRevenueCopyWith<$Res> get revenue30d;

}
/// @nodoc
class __$AdminDashboardCopyWithImpl<$Res>
    implements _$AdminDashboardCopyWith<$Res> {
  __$AdminDashboardCopyWithImpl(this._self, this._then);

  final _AdminDashboard _self;
  final $Res Function(_AdminDashboard) _then;

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? activity = null,Object? pending = null,Object? plans = null,Object? revenue30d = null,Object? daily = null,}) {
  return _then(_AdminDashboard(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as DashboardUsers,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as DashboardActivity,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as DashboardPending,plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as DashboardPlans,revenue30d: null == revenue30d ? _self.revenue30d : revenue30d // ignore: cast_nullable_to_non_nullable
as DashboardRevenue,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DashboardDay>,
  ));
}

/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardUsersCopyWith<$Res> get users {
  
  return $DashboardUsersCopyWith<$Res>(_self.users, (value) {
    return _then(_self.copyWith(users: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardActivityCopyWith<$Res> get activity {
  
  return $DashboardActivityCopyWith<$Res>(_self.activity, (value) {
    return _then(_self.copyWith(activity: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPendingCopyWith<$Res> get pending {
  
  return $DashboardPendingCopyWith<$Res>(_self.pending, (value) {
    return _then(_self.copyWith(pending: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPlansCopyWith<$Res> get plans {
  
  return $DashboardPlansCopyWith<$Res>(_self.plans, (value) {
    return _then(_self.copyWith(plans: value));
  });
}/// Create a copy of AdminDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardRevenueCopyWith<$Res> get revenue30d {
  
  return $DashboardRevenueCopyWith<$Res>(_self.revenue30d, (value) {
    return _then(_self.copyWith(revenue30d: value));
  });
}
}


/// @nodoc
mixin _$DashboardUsers {

 int get total; int get newToday;@JsonKey(name: 'new_7d') int get new7d;@JsonKey(name: 'new_30d') int get new30d;@JsonKey(name: 'active_24h') int get active24h;@JsonKey(name: 'active_7d') int get active7d; int get paused; int get restricted;
/// Create a copy of DashboardUsers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardUsersCopyWith<DashboardUsers> get copyWith => _$DashboardUsersCopyWithImpl<DashboardUsers>(this as DashboardUsers, _$identity);

  /// Serializes this DashboardUsers to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardUsers;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardUsers&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.newToday, _this.newToday) || other.newToday == _this.newToday)&&(identical(other.new7d, _this.new7d) || other.new7d == _this.new7d)&&(identical(other.new30d, _this.new30d) || other.new30d == _this.new30d)&&(identical(other.active24h, _this.active24h) || other.active24h == _this.active24h)&&(identical(other.active7d, _this.active7d) || other.active7d == _this.active7d)&&(identical(other.paused, _this.paused) || other.paused == _this.paused)&&(identical(other.restricted, _this.restricted) || other.restricted == _this.restricted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardUsers;
  return Object.hash(runtimeType,_this.total,_this.newToday,_this.new7d,_this.new30d,_this.active24h,_this.active7d,_this.paused,_this.restricted);
}

@override
String toString() {
  final _this = this as DashboardUsers;
  return 'DashboardUsers(total: ${_this.total}, newToday: ${_this.newToday}, new7d: ${_this.new7d}, new30d: ${_this.new30d}, active24h: ${_this.active24h}, active7d: ${_this.active7d}, paused: ${_this.paused}, restricted: ${_this.restricted})';
}


}

/// @nodoc
abstract mixin class $DashboardUsersCopyWith<$Res>  {
  factory $DashboardUsersCopyWith(DashboardUsers value, $Res Function(DashboardUsers) _then) = _$DashboardUsersCopyWithImpl;
@useResult
$Res call({
 int total, int newToday,@JsonKey(name: 'new_7d') int new7d,@JsonKey(name: 'new_30d') int new30d,@JsonKey(name: 'active_24h') int active24h,@JsonKey(name: 'active_7d') int active7d, int paused, int restricted
});




}
/// @nodoc
class _$DashboardUsersCopyWithImpl<$Res>
    implements $DashboardUsersCopyWith<$Res> {
  _$DashboardUsersCopyWithImpl(this._self, this._then);

  final DashboardUsers _self;
  final $Res Function(DashboardUsers) _then;

/// Create a copy of DashboardUsers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? newToday = null,Object? new7d = null,Object? new30d = null,Object? active24h = null,Object? active7d = null,Object? paused = null,Object? restricted = null,}) {
  return _then(DashboardUsers(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,newToday: null == newToday ? _self.newToday : newToday // ignore: cast_nullable_to_non_nullable
as int,new7d: null == new7d ? _self.new7d : new7d // ignore: cast_nullable_to_non_nullable
as int,new30d: null == new30d ? _self.new30d : new30d // ignore: cast_nullable_to_non_nullable
as int,active24h: null == active24h ? _self.active24h : active24h // ignore: cast_nullable_to_non_nullable
as int,active7d: null == active7d ? _self.active7d : active7d // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as int,restricted: null == restricted ? _self.restricted : restricted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardUsers].
extension DashboardUsersPatterns on DashboardUsers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardUsers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardUsers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardUsers value)  $default,){
final _that = this;
switch (_that) {
case _DashboardUsers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardUsers value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardUsers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int newToday, @JsonKey(name: 'new_7d')  int new7d, @JsonKey(name: 'new_30d')  int new30d, @JsonKey(name: 'active_24h')  int active24h, @JsonKey(name: 'active_7d')  int active7d,  int paused,  int restricted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardUsers() when $default != null:
return $default(_that.total,_that.newToday,_that.new7d,_that.new30d,_that.active24h,_that.active7d,_that.paused,_that.restricted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int newToday, @JsonKey(name: 'new_7d')  int new7d, @JsonKey(name: 'new_30d')  int new30d, @JsonKey(name: 'active_24h')  int active24h, @JsonKey(name: 'active_7d')  int active7d,  int paused,  int restricted)  $default,) {final _that = this;
switch (_that) {
case _DashboardUsers():
return $default(_that.total,_that.newToday,_that.new7d,_that.new30d,_that.active24h,_that.active7d,_that.paused,_that.restricted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int newToday, @JsonKey(name: 'new_7d')  int new7d, @JsonKey(name: 'new_30d')  int new30d, @JsonKey(name: 'active_24h')  int active24h, @JsonKey(name: 'active_7d')  int active7d,  int paused,  int restricted)?  $default,) {final _that = this;
switch (_that) {
case _DashboardUsers() when $default != null:
return $default(_that.total,_that.newToday,_that.new7d,_that.new30d,_that.active24h,_that.active7d,_that.paused,_that.restricted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardUsers implements DashboardUsers {
  const _DashboardUsers({this.total = 0, this.newToday = 0, @JsonKey(name: 'new_7d') this.new7d = 0, @JsonKey(name: 'new_30d') this.new30d = 0, @JsonKey(name: 'active_24h') this.active24h = 0, @JsonKey(name: 'active_7d') this.active7d = 0, this.paused = 0, this.restricted = 0});
  factory _DashboardUsers.fromJson(Map<String, dynamic> json) => _$DashboardUsersFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int newToday;
@override@JsonKey(name: 'new_7d') final  int new7d;
@override@JsonKey(name: 'new_30d') final  int new30d;
@override@JsonKey(name: 'active_24h') final  int active24h;
@override@JsonKey(name: 'active_7d') final  int active7d;
@override@JsonKey() final  int paused;
@override@JsonKey() final  int restricted;

/// Create a copy of DashboardUsers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardUsersCopyWith<_DashboardUsers> get copyWith => __$DashboardUsersCopyWithImpl<_DashboardUsers>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardUsersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardUsers&&(identical(other.total, total) || other.total == total)&&(identical(other.newToday, newToday) || other.newToday == newToday)&&(identical(other.new7d, new7d) || other.new7d == new7d)&&(identical(other.new30d, new30d) || other.new30d == new30d)&&(identical(other.active24h, active24h) || other.active24h == active24h)&&(identical(other.active7d, active7d) || other.active7d == active7d)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.restricted, restricted) || other.restricted == restricted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,newToday,new7d,new30d,active24h,active7d,paused,restricted);
}

@override
String toString() {
    return 'DashboardUsers(total: $total, newToday: $newToday, new7d: $new7d, new30d: $new30d, active24h: $active24h, active7d: $active7d, paused: $paused, restricted: $restricted)';
}


}

/// @nodoc
abstract mixin class _$DashboardUsersCopyWith<$Res> implements $DashboardUsersCopyWith<$Res> {
  factory _$DashboardUsersCopyWith(_DashboardUsers value, $Res Function(_DashboardUsers) _then) = __$DashboardUsersCopyWithImpl;
@override @useResult
$Res call({
 int total, int newToday,@JsonKey(name: 'new_7d') int new7d,@JsonKey(name: 'new_30d') int new30d,@JsonKey(name: 'active_24h') int active24h,@JsonKey(name: 'active_7d') int active7d, int paused, int restricted
});




}
/// @nodoc
class __$DashboardUsersCopyWithImpl<$Res>
    implements _$DashboardUsersCopyWith<$Res> {
  __$DashboardUsersCopyWithImpl(this._self, this._then);

  final _DashboardUsers _self;
  final $Res Function(_DashboardUsers) _then;

/// Create a copy of DashboardUsers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? newToday = null,Object? new7d = null,Object? new30d = null,Object? active24h = null,Object? active7d = null,Object? paused = null,Object? restricted = null,}) {
  return _then(_DashboardUsers(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,newToday: null == newToday ? _self.newToday : newToday // ignore: cast_nullable_to_non_nullable
as int,new7d: null == new7d ? _self.new7d : new7d // ignore: cast_nullable_to_non_nullable
as int,new30d: null == new30d ? _self.new30d : new30d // ignore: cast_nullable_to_non_nullable
as int,active24h: null == active24h ? _self.active24h : active24h // ignore: cast_nullable_to_non_nullable
as int,active7d: null == active7d ? _self.active7d : active7d // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as int,restricted: null == restricted ? _self.restricted : restricted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardActivity {

@JsonKey(name: 'matches_24h') int get matches24h;@JsonKey(name: 'matches_7d') int get matches7d;@JsonKey(name: 'messages_24h') int get messages24h;@JsonKey(name: 'messages_7d') int get messages7d; int get upcomingEvents; int get featuredNow;
/// Create a copy of DashboardActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardActivityCopyWith<DashboardActivity> get copyWith => _$DashboardActivityCopyWithImpl<DashboardActivity>(this as DashboardActivity, _$identity);

  /// Serializes this DashboardActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardActivity&&(identical(other.matches24h, _this.matches24h) || other.matches24h == _this.matches24h)&&(identical(other.matches7d, _this.matches7d) || other.matches7d == _this.matches7d)&&(identical(other.messages24h, _this.messages24h) || other.messages24h == _this.messages24h)&&(identical(other.messages7d, _this.messages7d) || other.messages7d == _this.messages7d)&&(identical(other.upcomingEvents, _this.upcomingEvents) || other.upcomingEvents == _this.upcomingEvents)&&(identical(other.featuredNow, _this.featuredNow) || other.featuredNow == _this.featuredNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardActivity;
  return Object.hash(runtimeType,_this.matches24h,_this.matches7d,_this.messages24h,_this.messages7d,_this.upcomingEvents,_this.featuredNow);
}

@override
String toString() {
  final _this = this as DashboardActivity;
  return 'DashboardActivity(matches24h: ${_this.matches24h}, matches7d: ${_this.matches7d}, messages24h: ${_this.messages24h}, messages7d: ${_this.messages7d}, upcomingEvents: ${_this.upcomingEvents}, featuredNow: ${_this.featuredNow})';
}


}

/// @nodoc
abstract mixin class $DashboardActivityCopyWith<$Res>  {
  factory $DashboardActivityCopyWith(DashboardActivity value, $Res Function(DashboardActivity) _then) = _$DashboardActivityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'matches_24h') int matches24h,@JsonKey(name: 'matches_7d') int matches7d,@JsonKey(name: 'messages_24h') int messages24h,@JsonKey(name: 'messages_7d') int messages7d, int upcomingEvents, int featuredNow
});




}
/// @nodoc
class _$DashboardActivityCopyWithImpl<$Res>
    implements $DashboardActivityCopyWith<$Res> {
  _$DashboardActivityCopyWithImpl(this._self, this._then);

  final DashboardActivity _self;
  final $Res Function(DashboardActivity) _then;

/// Create a copy of DashboardActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matches24h = null,Object? matches7d = null,Object? messages24h = null,Object? messages7d = null,Object? upcomingEvents = null,Object? featuredNow = null,}) {
  return _then(DashboardActivity(
matches24h: null == matches24h ? _self.matches24h : matches24h // ignore: cast_nullable_to_non_nullable
as int,matches7d: null == matches7d ? _self.matches7d : matches7d // ignore: cast_nullable_to_non_nullable
as int,messages24h: null == messages24h ? _self.messages24h : messages24h // ignore: cast_nullable_to_non_nullable
as int,messages7d: null == messages7d ? _self.messages7d : messages7d // ignore: cast_nullable_to_non_nullable
as int,upcomingEvents: null == upcomingEvents ? _self.upcomingEvents : upcomingEvents // ignore: cast_nullable_to_non_nullable
as int,featuredNow: null == featuredNow ? _self.featuredNow : featuredNow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardActivity].
extension DashboardActivityPatterns on DashboardActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardActivity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardActivity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'matches_24h')  int matches24h, @JsonKey(name: 'matches_7d')  int matches7d, @JsonKey(name: 'messages_24h')  int messages24h, @JsonKey(name: 'messages_7d')  int messages7d,  int upcomingEvents,  int featuredNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardActivity() when $default != null:
return $default(_that.matches24h,_that.matches7d,_that.messages24h,_that.messages7d,_that.upcomingEvents,_that.featuredNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'matches_24h')  int matches24h, @JsonKey(name: 'matches_7d')  int matches7d, @JsonKey(name: 'messages_24h')  int messages24h, @JsonKey(name: 'messages_7d')  int messages7d,  int upcomingEvents,  int featuredNow)  $default,) {final _that = this;
switch (_that) {
case _DashboardActivity():
return $default(_that.matches24h,_that.matches7d,_that.messages24h,_that.messages7d,_that.upcomingEvents,_that.featuredNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'matches_24h')  int matches24h, @JsonKey(name: 'matches_7d')  int matches7d, @JsonKey(name: 'messages_24h')  int messages24h, @JsonKey(name: 'messages_7d')  int messages7d,  int upcomingEvents,  int featuredNow)?  $default,) {final _that = this;
switch (_that) {
case _DashboardActivity() when $default != null:
return $default(_that.matches24h,_that.matches7d,_that.messages24h,_that.messages7d,_that.upcomingEvents,_that.featuredNow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardActivity implements DashboardActivity {
  const _DashboardActivity({@JsonKey(name: 'matches_24h') this.matches24h = 0, @JsonKey(name: 'matches_7d') this.matches7d = 0, @JsonKey(name: 'messages_24h') this.messages24h = 0, @JsonKey(name: 'messages_7d') this.messages7d = 0, this.upcomingEvents = 0, this.featuredNow = 0});
  factory _DashboardActivity.fromJson(Map<String, dynamic> json) => _$DashboardActivityFromJson(json);

@override@JsonKey(name: 'matches_24h') final  int matches24h;
@override@JsonKey(name: 'matches_7d') final  int matches7d;
@override@JsonKey(name: 'messages_24h') final  int messages24h;
@override@JsonKey(name: 'messages_7d') final  int messages7d;
@override@JsonKey() final  int upcomingEvents;
@override@JsonKey() final  int featuredNow;

/// Create a copy of DashboardActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardActivityCopyWith<_DashboardActivity> get copyWith => __$DashboardActivityCopyWithImpl<_DashboardActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardActivityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardActivity&&(identical(other.matches24h, matches24h) || other.matches24h == matches24h)&&(identical(other.matches7d, matches7d) || other.matches7d == matches7d)&&(identical(other.messages24h, messages24h) || other.messages24h == messages24h)&&(identical(other.messages7d, messages7d) || other.messages7d == messages7d)&&(identical(other.upcomingEvents, upcomingEvents) || other.upcomingEvents == upcomingEvents)&&(identical(other.featuredNow, featuredNow) || other.featuredNow == featuredNow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,matches24h,matches7d,messages24h,messages7d,upcomingEvents,featuredNow);
}

@override
String toString() {
    return 'DashboardActivity(matches24h: $matches24h, matches7d: $matches7d, messages24h: $messages24h, messages7d: $messages7d, upcomingEvents: $upcomingEvents, featuredNow: $featuredNow)';
}


}

/// @nodoc
abstract mixin class _$DashboardActivityCopyWith<$Res> implements $DashboardActivityCopyWith<$Res> {
  factory _$DashboardActivityCopyWith(_DashboardActivity value, $Res Function(_DashboardActivity) _then) = __$DashboardActivityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'matches_24h') int matches24h,@JsonKey(name: 'matches_7d') int matches7d,@JsonKey(name: 'messages_24h') int messages24h,@JsonKey(name: 'messages_7d') int messages7d, int upcomingEvents, int featuredNow
});




}
/// @nodoc
class __$DashboardActivityCopyWithImpl<$Res>
    implements _$DashboardActivityCopyWith<$Res> {
  __$DashboardActivityCopyWithImpl(this._self, this._then);

  final _DashboardActivity _self;
  final $Res Function(_DashboardActivity) _then;

/// Create a copy of DashboardActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matches24h = null,Object? matches7d = null,Object? messages24h = null,Object? messages7d = null,Object? upcomingEvents = null,Object? featuredNow = null,}) {
  return _then(_DashboardActivity(
matches24h: null == matches24h ? _self.matches24h : matches24h // ignore: cast_nullable_to_non_nullable
as int,matches7d: null == matches7d ? _self.matches7d : matches7d // ignore: cast_nullable_to_non_nullable
as int,messages24h: null == messages24h ? _self.messages24h : messages24h // ignore: cast_nullable_to_non_nullable
as int,messages7d: null == messages7d ? _self.messages7d : messages7d // ignore: cast_nullable_to_non_nullable
as int,upcomingEvents: null == upcomingEvents ? _self.upcomingEvents : upcomingEvents // ignore: cast_nullable_to_non_nullable
as int,featuredNow: null == featuredNow ? _self.featuredNow : featuredNow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardPending {

 int get events; int get reports; int get verifications; int get badges; int get roles; int get featured;
/// Create a copy of DashboardPending
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPendingCopyWith<DashboardPending> get copyWith => _$DashboardPendingCopyWithImpl<DashboardPending>(this as DashboardPending, _$identity);

  /// Serializes this DashboardPending to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardPending;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPending&&(identical(other.events, _this.events) || other.events == _this.events)&&(identical(other.reports, _this.reports) || other.reports == _this.reports)&&(identical(other.verifications, _this.verifications) || other.verifications == _this.verifications)&&(identical(other.badges, _this.badges) || other.badges == _this.badges)&&(identical(other.roles, _this.roles) || other.roles == _this.roles)&&(identical(other.featured, _this.featured) || other.featured == _this.featured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardPending;
  return Object.hash(runtimeType,_this.events,_this.reports,_this.verifications,_this.badges,_this.roles,_this.featured);
}

@override
String toString() {
  final _this = this as DashboardPending;
  return 'DashboardPending(events: ${_this.events}, reports: ${_this.reports}, verifications: ${_this.verifications}, badges: ${_this.badges}, roles: ${_this.roles}, featured: ${_this.featured})';
}


}

/// @nodoc
abstract mixin class $DashboardPendingCopyWith<$Res>  {
  factory $DashboardPendingCopyWith(DashboardPending value, $Res Function(DashboardPending) _then) = _$DashboardPendingCopyWithImpl;
@useResult
$Res call({
 int events, int reports, int verifications, int badges, int roles, int featured
});




}
/// @nodoc
class _$DashboardPendingCopyWithImpl<$Res>
    implements $DashboardPendingCopyWith<$Res> {
  _$DashboardPendingCopyWithImpl(this._self, this._then);

  final DashboardPending _self;
  final $Res Function(DashboardPending) _then;

/// Create a copy of DashboardPending
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? events = null,Object? reports = null,Object? verifications = null,Object? badges = null,Object? roles = null,Object? featured = null,}) {
  return _then(DashboardPending(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as int,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as int,verifications: null == verifications ? _self.verifications : verifications // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as int,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPending].
extension DashboardPendingPatterns on DashboardPending {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPending value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPending() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPending value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPending():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPending value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPending() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int events,  int reports,  int verifications,  int badges,  int roles,  int featured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPending() when $default != null:
return $default(_that.events,_that.reports,_that.verifications,_that.badges,_that.roles,_that.featured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int events,  int reports,  int verifications,  int badges,  int roles,  int featured)  $default,) {final _that = this;
switch (_that) {
case _DashboardPending():
return $default(_that.events,_that.reports,_that.verifications,_that.badges,_that.roles,_that.featured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int events,  int reports,  int verifications,  int badges,  int roles,  int featured)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPending() when $default != null:
return $default(_that.events,_that.reports,_that.verifications,_that.badges,_that.roles,_that.featured);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPending extends DashboardPending {
  const _DashboardPending({this.events = 0, this.reports = 0, this.verifications = 0, this.badges = 0, this.roles = 0, this.featured = 0}): super._();
  factory _DashboardPending.fromJson(Map<String, dynamic> json) => _$DashboardPendingFromJson(json);

@override@JsonKey() final  int events;
@override@JsonKey() final  int reports;
@override@JsonKey() final  int verifications;
@override@JsonKey() final  int badges;
@override@JsonKey() final  int roles;
@override@JsonKey() final  int featured;

/// Create a copy of DashboardPending
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPendingCopyWith<_DashboardPending> get copyWith => __$DashboardPendingCopyWithImpl<_DashboardPending>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPendingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPending&&(identical(other.events, events) || other.events == events)&&(identical(other.reports, reports) || other.reports == reports)&&(identical(other.verifications, verifications) || other.verifications == verifications)&&(identical(other.badges, badges) || other.badges == badges)&&(identical(other.roles, roles) || other.roles == roles)&&(identical(other.featured, featured) || other.featured == featured));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,events,reports,verifications,badges,roles,featured);
}

@override
String toString() {
    return 'DashboardPending(events: $events, reports: $reports, verifications: $verifications, badges: $badges, roles: $roles, featured: $featured)';
}


}

/// @nodoc
abstract mixin class _$DashboardPendingCopyWith<$Res> implements $DashboardPendingCopyWith<$Res> {
  factory _$DashboardPendingCopyWith(_DashboardPending value, $Res Function(_DashboardPending) _then) = __$DashboardPendingCopyWithImpl;
@override @useResult
$Res call({
 int events, int reports, int verifications, int badges, int roles, int featured
});




}
/// @nodoc
class __$DashboardPendingCopyWithImpl<$Res>
    implements _$DashboardPendingCopyWith<$Res> {
  __$DashboardPendingCopyWithImpl(this._self, this._then);

  final _DashboardPending _self;
  final $Res Function(_DashboardPending) _then;

/// Create a copy of DashboardPending
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? events = null,Object? reports = null,Object? verifications = null,Object? badges = null,Object? roles = null,Object? featured = null,}) {
  return _then(_DashboardPending(
events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as int,reports: null == reports ? _self.reports : reports // ignore: cast_nullable_to_non_nullable
as int,verifications: null == verifications ? _self.verifications : verifications // ignore: cast_nullable_to_non_nullable
as int,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as int,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardPlans {

 int get plus; int get black; int get trial; int get store;
/// Create a copy of DashboardPlans
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPlansCopyWith<DashboardPlans> get copyWith => _$DashboardPlansCopyWithImpl<DashboardPlans>(this as DashboardPlans, _$identity);

  /// Serializes this DashboardPlans to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardPlans;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPlans&&(identical(other.plus, _this.plus) || other.plus == _this.plus)&&(identical(other.black, _this.black) || other.black == _this.black)&&(identical(other.trial, _this.trial) || other.trial == _this.trial)&&(identical(other.store, _this.store) || other.store == _this.store));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardPlans;
  return Object.hash(runtimeType,_this.plus,_this.black,_this.trial,_this.store);
}

@override
String toString() {
  final _this = this as DashboardPlans;
  return 'DashboardPlans(plus: ${_this.plus}, black: ${_this.black}, trial: ${_this.trial}, store: ${_this.store})';
}


}

/// @nodoc
abstract mixin class $DashboardPlansCopyWith<$Res>  {
  factory $DashboardPlansCopyWith(DashboardPlans value, $Res Function(DashboardPlans) _then) = _$DashboardPlansCopyWithImpl;
@useResult
$Res call({
 int plus, int black, int trial, int store
});




}
/// @nodoc
class _$DashboardPlansCopyWithImpl<$Res>
    implements $DashboardPlansCopyWith<$Res> {
  _$DashboardPlansCopyWithImpl(this._self, this._then);

  final DashboardPlans _self;
  final $Res Function(DashboardPlans) _then;

/// Create a copy of DashboardPlans
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plus = null,Object? black = null,Object? trial = null,Object? store = null,}) {
  return _then(DashboardPlans(
plus: null == plus ? _self.plus : plus // ignore: cast_nullable_to_non_nullable
as int,black: null == black ? _self.black : black // ignore: cast_nullable_to_non_nullable
as int,trial: null == trial ? _self.trial : trial // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPlans].
extension DashboardPlansPatterns on DashboardPlans {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPlans value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPlans() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPlans value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPlans():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPlans value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPlans() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int plus,  int black,  int trial,  int store)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPlans() when $default != null:
return $default(_that.plus,_that.black,_that.trial,_that.store);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int plus,  int black,  int trial,  int store)  $default,) {final _that = this;
switch (_that) {
case _DashboardPlans():
return $default(_that.plus,_that.black,_that.trial,_that.store);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int plus,  int black,  int trial,  int store)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPlans() when $default != null:
return $default(_that.plus,_that.black,_that.trial,_that.store);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPlans implements DashboardPlans {
  const _DashboardPlans({this.plus = 0, this.black = 0, this.trial = 0, this.store = 0});
  factory _DashboardPlans.fromJson(Map<String, dynamic> json) => _$DashboardPlansFromJson(json);

@override@JsonKey() final  int plus;
@override@JsonKey() final  int black;
@override@JsonKey() final  int trial;
@override@JsonKey() final  int store;

/// Create a copy of DashboardPlans
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPlansCopyWith<_DashboardPlans> get copyWith => __$DashboardPlansCopyWithImpl<_DashboardPlans>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPlansToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPlans&&(identical(other.plus, plus) || other.plus == plus)&&(identical(other.black, black) || other.black == black)&&(identical(other.trial, trial) || other.trial == trial)&&(identical(other.store, store) || other.store == store));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plus,black,trial,store);
}

@override
String toString() {
    return 'DashboardPlans(plus: $plus, black: $black, trial: $trial, store: $store)';
}


}

/// @nodoc
abstract mixin class _$DashboardPlansCopyWith<$Res> implements $DashboardPlansCopyWith<$Res> {
  factory _$DashboardPlansCopyWith(_DashboardPlans value, $Res Function(_DashboardPlans) _then) = __$DashboardPlansCopyWithImpl;
@override @useResult
$Res call({
 int plus, int black, int trial, int store
});




}
/// @nodoc
class __$DashboardPlansCopyWithImpl<$Res>
    implements _$DashboardPlansCopyWith<$Res> {
  __$DashboardPlansCopyWithImpl(this._self, this._then);

  final _DashboardPlans _self;
  final $Res Function(_DashboardPlans) _then;

/// Create a copy of DashboardPlans
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plus = null,Object? black = null,Object? trial = null,Object? store = null,}) {
  return _then(_DashboardPlans(
plus: null == plus ? _self.plus : plus // ignore: cast_nullable_to_non_nullable
as int,black: null == black ? _self.black : black // ignore: cast_nullable_to_non_nullable
as int,trial: null == trial ? _self.trial : trial // ignore: cast_nullable_to_non_nullable
as int,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardRevenue {

 double get storeUsd; int get featuredTeamCents;
/// Create a copy of DashboardRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardRevenueCopyWith<DashboardRevenue> get copyWith => _$DashboardRevenueCopyWithImpl<DashboardRevenue>(this as DashboardRevenue, _$identity);

  /// Serializes this DashboardRevenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardRevenue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardRevenue&&(identical(other.storeUsd, _this.storeUsd) || other.storeUsd == _this.storeUsd)&&(identical(other.featuredTeamCents, _this.featuredTeamCents) || other.featuredTeamCents == _this.featuredTeamCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardRevenue;
  return Object.hash(runtimeType,_this.storeUsd,_this.featuredTeamCents);
}

@override
String toString() {
  final _this = this as DashboardRevenue;
  return 'DashboardRevenue(storeUsd: ${_this.storeUsd}, featuredTeamCents: ${_this.featuredTeamCents})';
}


}

/// @nodoc
abstract mixin class $DashboardRevenueCopyWith<$Res>  {
  factory $DashboardRevenueCopyWith(DashboardRevenue value, $Res Function(DashboardRevenue) _then) = _$DashboardRevenueCopyWithImpl;
@useResult
$Res call({
 double storeUsd, int featuredTeamCents
});




}
/// @nodoc
class _$DashboardRevenueCopyWithImpl<$Res>
    implements $DashboardRevenueCopyWith<$Res> {
  _$DashboardRevenueCopyWithImpl(this._self, this._then);

  final DashboardRevenue _self;
  final $Res Function(DashboardRevenue) _then;

/// Create a copy of DashboardRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeUsd = null,Object? featuredTeamCents = null,}) {
  return _then(DashboardRevenue(
storeUsd: null == storeUsd ? _self.storeUsd : storeUsd // ignore: cast_nullable_to_non_nullable
as double,featuredTeamCents: null == featuredTeamCents ? _self.featuredTeamCents : featuredTeamCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardRevenue].
extension DashboardRevenuePatterns on DashboardRevenue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardRevenue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardRevenue value)  $default,){
final _that = this;
switch (_that) {
case _DashboardRevenue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardRevenue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double storeUsd,  int featuredTeamCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardRevenue() when $default != null:
return $default(_that.storeUsd,_that.featuredTeamCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double storeUsd,  int featuredTeamCents)  $default,) {final _that = this;
switch (_that) {
case _DashboardRevenue():
return $default(_that.storeUsd,_that.featuredTeamCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double storeUsd,  int featuredTeamCents)?  $default,) {final _that = this;
switch (_that) {
case _DashboardRevenue() when $default != null:
return $default(_that.storeUsd,_that.featuredTeamCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardRevenue implements DashboardRevenue {
  const _DashboardRevenue({this.storeUsd = 0, this.featuredTeamCents = 0});
  factory _DashboardRevenue.fromJson(Map<String, dynamic> json) => _$DashboardRevenueFromJson(json);

@override@JsonKey() final  double storeUsd;
@override@JsonKey() final  int featuredTeamCents;

/// Create a copy of DashboardRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardRevenueCopyWith<_DashboardRevenue> get copyWith => __$DashboardRevenueCopyWithImpl<_DashboardRevenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardRevenueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardRevenue&&(identical(other.storeUsd, storeUsd) || other.storeUsd == storeUsd)&&(identical(other.featuredTeamCents, featuredTeamCents) || other.featuredTeamCents == featuredTeamCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,storeUsd,featuredTeamCents);
}

@override
String toString() {
    return 'DashboardRevenue(storeUsd: $storeUsd, featuredTeamCents: $featuredTeamCents)';
}


}

/// @nodoc
abstract mixin class _$DashboardRevenueCopyWith<$Res> implements $DashboardRevenueCopyWith<$Res> {
  factory _$DashboardRevenueCopyWith(_DashboardRevenue value, $Res Function(_DashboardRevenue) _then) = __$DashboardRevenueCopyWithImpl;
@override @useResult
$Res call({
 double storeUsd, int featuredTeamCents
});




}
/// @nodoc
class __$DashboardRevenueCopyWithImpl<$Res>
    implements _$DashboardRevenueCopyWith<$Res> {
  __$DashboardRevenueCopyWithImpl(this._self, this._then);

  final _DashboardRevenue _self;
  final $Res Function(_DashboardRevenue) _then;

/// Create a copy of DashboardRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeUsd = null,Object? featuredTeamCents = null,}) {
  return _then(_DashboardRevenue(
storeUsd: null == storeUsd ? _self.storeUsd : storeUsd // ignore: cast_nullable_to_non_nullable
as double,featuredTeamCents: null == featuredTeamCents ? _self.featuredTeamCents : featuredTeamCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardDay {

 DateTime get day; int get signups; int get matches;
/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDayCopyWith<DashboardDay> get copyWith => _$DashboardDayCopyWithImpl<DashboardDay>(this as DashboardDay, _$identity);

  /// Serializes this DashboardDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDay&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.signups, _this.signups) || other.signups == _this.signups)&&(identical(other.matches, _this.matches) || other.matches == _this.matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardDay;
  return Object.hash(runtimeType,_this.day,_this.signups,_this.matches);
}

@override
String toString() {
  final _this = this as DashboardDay;
  return 'DashboardDay(day: ${_this.day}, signups: ${_this.signups}, matches: ${_this.matches})';
}


}

/// @nodoc
abstract mixin class $DashboardDayCopyWith<$Res>  {
  factory $DashboardDayCopyWith(DashboardDay value, $Res Function(DashboardDay) _then) = _$DashboardDayCopyWithImpl;
@useResult
$Res call({
 DateTime day, int signups, int matches
});




}
/// @nodoc
class _$DashboardDayCopyWithImpl<$Res>
    implements $DashboardDayCopyWith<$Res> {
  _$DashboardDayCopyWithImpl(this._self, this._then);

  final DashboardDay _self;
  final $Res Function(DashboardDay) _then;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? signups = null,Object? matches = null,}) {
  return _then(DashboardDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,signups: null == signups ? _self.signups : signups // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardDay].
extension DashboardDayPatterns on DashboardDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardDay value)  $default,){
final _that = this;
switch (_that) {
case _DashboardDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardDay value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  int signups,  int matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
return $default(_that.day,_that.signups,_that.matches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  int signups,  int matches)  $default,) {final _that = this;
switch (_that) {
case _DashboardDay():
return $default(_that.day,_that.signups,_that.matches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  int signups,  int matches)?  $default,) {final _that = this;
switch (_that) {
case _DashboardDay() when $default != null:
return $default(_that.day,_that.signups,_that.matches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardDay implements DashboardDay {
  const _DashboardDay({required this.day, this.signups = 0, this.matches = 0});
  factory _DashboardDay.fromJson(Map<String, dynamic> json) => _$DashboardDayFromJson(json);

@override final  DateTime day;
@override@JsonKey() final  int signups;
@override@JsonKey() final  int matches;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDayCopyWith<_DashboardDay> get copyWith => __$DashboardDayCopyWithImpl<_DashboardDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDayToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardDay&&(identical(other.day, day) || other.day == day)&&(identical(other.signups, signups) || other.signups == signups)&&(identical(other.matches, matches) || other.matches == matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,signups,matches);
}

@override
String toString() {
    return 'DashboardDay(day: $day, signups: $signups, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$DashboardDayCopyWith<$Res> implements $DashboardDayCopyWith<$Res> {
  factory _$DashboardDayCopyWith(_DashboardDay value, $Res Function(_DashboardDay) _then) = __$DashboardDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, int signups, int matches
});




}
/// @nodoc
class __$DashboardDayCopyWithImpl<$Res>
    implements _$DashboardDayCopyWith<$Res> {
  __$DashboardDayCopyWithImpl(this._self, this._then);

  final _DashboardDay _self;
  final $Res Function(_DashboardDay) _then;

/// Create a copy of DashboardDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? signups = null,Object? matches = null,}) {
  return _then(_DashboardDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,signups: null == signups ? _self.signups : signups // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AppSetting {

 String get key; String get value;
/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingCopyWith<AppSetting> get copyWith => _$AppSettingCopyWithImpl<AppSetting>(this as AppSetting, _$identity);

  /// Serializes this AppSetting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppSetting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSetting&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.value, _this.value) || other.value == _this.value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppSetting;
  return Object.hash(runtimeType,_this.key,_this.value);
}

@override
String toString() {
  final _this = this as AppSetting;
  return 'AppSetting(key: ${_this.key}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $AppSettingCopyWith<$Res>  {
  factory $AppSettingCopyWith(AppSetting value, $Res Function(AppSetting) _then) = _$AppSettingCopyWithImpl;
@useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class _$AppSettingCopyWithImpl<$Res>
    implements $AppSettingCopyWith<$Res> {
  _$AppSettingCopyWithImpl(this._self, this._then);

  final AppSetting _self;
  final $Res Function(AppSetting) _then;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,}) {
  return _then(AppSetting(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSetting].
extension AppSettingPatterns on AppSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSetting value)  $default,){
final _that = this;
switch (_that) {
case _AppSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSetting value)?  $default,){
final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
return $default(_that.key,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String value)  $default,) {final _that = this;
switch (_that) {
case _AppSetting():
return $default(_that.key,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String value)?  $default,) {final _that = this;
switch (_that) {
case _AppSetting() when $default != null:
return $default(_that.key,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSetting implements AppSetting {
  const _AppSetting({required this.key, required this.value});
  factory _AppSetting.fromJson(Map<String, dynamic> json) => _$AppSettingFromJson(json);

@override final  String key;
@override final  String value;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingCopyWith<_AppSetting> get copyWith => __$AppSettingCopyWithImpl<_AppSetting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSetting&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,value);
}

@override
String toString() {
    return 'AppSetting(key: $key, value: $value)';
}


}

/// @nodoc
abstract mixin class _$AppSettingCopyWith<$Res> implements $AppSettingCopyWith<$Res> {
  factory _$AppSettingCopyWith(_AppSetting value, $Res Function(_AppSetting) _then) = __$AppSettingCopyWithImpl;
@override @useResult
$Res call({
 String key, String value
});




}
/// @nodoc
class __$AppSettingCopyWithImpl<$Res>
    implements _$AppSettingCopyWith<$Res> {
  __$AppSettingCopyWithImpl(this._self, this._then);

  final _AppSetting _self;
  final $Res Function(_AppSetting) _then;

/// Create a copy of AppSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,}) {
  return _then(_AppSetting(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
