import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_console_models.freezed.dart';
part 'admin_console_models.g.dart';

/// `admin_dashboard()`: the app at a glance.
@freezed
abstract class AdminDashboard with _$AdminDashboard {
  const factory({
    required DashboardUsers users,
    required DashboardActivity activity,
    required DashboardPending pending,
    required DashboardPlans plans,
    @JsonKey(name: 'revenue_30d') required DashboardRevenue revenue30d,
    @Default([]) List<DashboardDay> daily,
  }) = _AdminDashboard;

  factory fromJson(Map<String, dynamic> json) => _$AdminDashboardFromJson(json);
}

@freezed
abstract class DashboardUsers with _$DashboardUsers {
  const factory({
    @Default(0) int total,
    @Default(0) int newToday,
    @JsonKey(name: 'new_7d') @Default(0) int new7d,
    @JsonKey(name: 'new_30d') @Default(0) int new30d,
    @JsonKey(name: 'active_24h') @Default(0) int active24h,
    @JsonKey(name: 'active_7d') @Default(0) int active7d,
    @Default(0) int paused,
    @Default(0) int restricted,
  }) = _DashboardUsers;

  factory fromJson(Map<String, dynamic> json) => _$DashboardUsersFromJson(json);
}

@freezed
abstract class DashboardActivity with _$DashboardActivity {
  const factory({
    @JsonKey(name: 'matches_24h') @Default(0) int matches24h,
    @JsonKey(name: 'matches_7d') @Default(0) int matches7d,
    @JsonKey(name: 'messages_24h') @Default(0) int messages24h,
    @JsonKey(name: 'messages_7d') @Default(0) int messages7d,
    @Default(0) int upcomingEvents,
    @Default(0) int featuredNow,
  }) = _DashboardActivity;

  factory fromJson(Map<String, dynamic> json) =>
      _$DashboardActivityFromJson(json);
}

@freezed
abstract class DashboardPending with _$DashboardPending {
  const factory({
    @Default(0) int events,
    @Default(0) int reports,
    @Default(0) int verifications,
    @Default(0) int badges,
    @Default(0) int roles,
    @Default(0) int featured,
  }) = _DashboardPending;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$DashboardPendingFromJson(json);

  int get total => events + reports + verifications + badges + roles + featured;
}

@freezed
abstract class DashboardPlans with _$DashboardPlans {
  const factory({
    @Default(0) int plus,
    @Default(0) int black,
    @Default(0) int trial,
    @Default(0) int store,
  }) = _DashboardPlans;

  factory fromJson(Map<String, dynamic> json) => _$DashboardPlansFromJson(json);
}

@freezed
abstract class DashboardRevenue with _$DashboardRevenue {
  const factory({
    @Default(0) double storeUsd,
    @Default(0) int featuredTeamCents,
  }) = _DashboardRevenue;

  factory fromJson(Map<String, dynamic> json) =>
      _$DashboardRevenueFromJson(json);
}

@freezed
abstract class DashboardDay with _$DashboardDay {
  const factory({
    required DateTime day,
    @Default(0) int signups,
    @Default(0) int matches,
  }) = _DashboardDay;

  factory fromJson(Map<String, dynamic> json) => _$DashboardDayFromJson(json);
}

/// One numeric setting of `private.app_settings`.
@freezed
abstract class AppSetting with _$AppSetting {
  const factory({required String key, required String value}) = _AppSetting;

  factory fromJson(Map<String, dynamic> json) => _$AppSettingFromJson(json);
}
