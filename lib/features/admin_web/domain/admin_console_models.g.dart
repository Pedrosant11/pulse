// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_console_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminDashboard _$AdminDashboardFromJson(Map<String, dynamic> json) =>
    _AdminDashboard(
      users: DashboardUsers.fromJson(json['users'] as Map<String, dynamic>),
      activity: DashboardActivity.fromJson(
        json['activity'] as Map<String, dynamic>,
      ),
      pending: DashboardPending.fromJson(
        json['pending'] as Map<String, dynamic>,
      ),
      plans: DashboardPlans.fromJson(json['plans'] as Map<String, dynamic>),
      revenue30d: DashboardRevenue.fromJson(
        json['revenue_30d'] as Map<String, dynamic>,
      ),
      daily:
          (json['daily'] as List<dynamic>?)
              ?.map((e) => DashboardDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AdminDashboardToJson(_AdminDashboard instance) =>
    <String, dynamic>{
      'users': instance.users.toJson(),
      'activity': instance.activity.toJson(),
      'pending': instance.pending.toJson(),
      'plans': instance.plans.toJson(),
      'revenue_30d': instance.revenue30d.toJson(),
      'daily': instance.daily.map((e) => e.toJson()).toList(),
    };

_DashboardUsers _$DashboardUsersFromJson(Map<String, dynamic> json) =>
    _DashboardUsers(
      total: (json['total'] as num?)?.toInt() ?? 0,
      newToday: (json['new_today'] as num?)?.toInt() ?? 0,
      new7d: (json['new_7d'] as num?)?.toInt() ?? 0,
      new30d: (json['new_30d'] as num?)?.toInt() ?? 0,
      active24h: (json['active_24h'] as num?)?.toInt() ?? 0,
      active7d: (json['active_7d'] as num?)?.toInt() ?? 0,
      paused: (json['paused'] as num?)?.toInt() ?? 0,
      restricted: (json['restricted'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardUsersToJson(_DashboardUsers instance) =>
    <String, dynamic>{
      'total': instance.total,
      'new_today': instance.newToday,
      'new_7d': instance.new7d,
      'new_30d': instance.new30d,
      'active_24h': instance.active24h,
      'active_7d': instance.active7d,
      'paused': instance.paused,
      'restricted': instance.restricted,
    };

_DashboardActivity _$DashboardActivityFromJson(Map<String, dynamic> json) =>
    _DashboardActivity(
      matches24h: (json['matches_24h'] as num?)?.toInt() ?? 0,
      matches7d: (json['matches_7d'] as num?)?.toInt() ?? 0,
      messages24h: (json['messages_24h'] as num?)?.toInt() ?? 0,
      messages7d: (json['messages_7d'] as num?)?.toInt() ?? 0,
      upcomingEvents: (json['upcoming_events'] as num?)?.toInt() ?? 0,
      featuredNow: (json['featured_now'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardActivityToJson(_DashboardActivity instance) =>
    <String, dynamic>{
      'matches_24h': instance.matches24h,
      'matches_7d': instance.matches7d,
      'messages_24h': instance.messages24h,
      'messages_7d': instance.messages7d,
      'upcoming_events': instance.upcomingEvents,
      'featured_now': instance.featuredNow,
    };

_DashboardPending _$DashboardPendingFromJson(Map<String, dynamic> json) =>
    _DashboardPending(
      events: (json['events'] as num?)?.toInt() ?? 0,
      reports: (json['reports'] as num?)?.toInt() ?? 0,
      verifications: (json['verifications'] as num?)?.toInt() ?? 0,
      badges: (json['badges'] as num?)?.toInt() ?? 0,
      roles: (json['roles'] as num?)?.toInt() ?? 0,
      featured: (json['featured'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardPendingToJson(_DashboardPending instance) =>
    <String, dynamic>{
      'events': instance.events,
      'reports': instance.reports,
      'verifications': instance.verifications,
      'badges': instance.badges,
      'roles': instance.roles,
      'featured': instance.featured,
    };

_DashboardPlans _$DashboardPlansFromJson(Map<String, dynamic> json) =>
    _DashboardPlans(
      plus: (json['plus'] as num?)?.toInt() ?? 0,
      black: (json['black'] as num?)?.toInt() ?? 0,
      trial: (json['trial'] as num?)?.toInt() ?? 0,
      store: (json['store'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardPlansToJson(_DashboardPlans instance) =>
    <String, dynamic>{
      'plus': instance.plus,
      'black': instance.black,
      'trial': instance.trial,
      'store': instance.store,
    };

_DashboardRevenue _$DashboardRevenueFromJson(Map<String, dynamic> json) =>
    _DashboardRevenue(
      storeUsd: (json['store_usd'] as num?)?.toDouble() ?? 0,
      featuredTeamCents: (json['featured_team_cents'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardRevenueToJson(_DashboardRevenue instance) =>
    <String, dynamic>{
      'store_usd': instance.storeUsd,
      'featured_team_cents': instance.featuredTeamCents,
    };

_DashboardDay _$DashboardDayFromJson(Map<String, dynamic> json) =>
    _DashboardDay(
      day: DateTime.parse(json['day'] as String),
      signups: (json['signups'] as num?)?.toInt() ?? 0,
      matches: (json['matches'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DashboardDayToJson(_DashboardDay instance) =>
    <String, dynamic>{
      'day': instance.day.toIso8601String(),
      'signups': instance.signups,
      'matches': instance.matches,
    };

_AppSetting _$AppSettingFromJson(Map<String, dynamic> json) =>
    _AppSetting(key: json['key'] as String, value: json['value'] as String);

Map<String, dynamic> _$AppSettingToJson(_AppSetting instance) =>
    <String, dynamic>{'key': instance.key, 'value': instance.value};
