// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReferralInfo _$ReferralInfoFromJson(Map<String, dynamic> json) =>
    _ReferralInfo(
      code: json['code'] as String,
      invited: (json['invited'] as num?)?.toInt() ?? 0,
      rewarded: (json['rewarded'] as num?)?.toInt() ?? 0,
      canRedeem: json['can_redeem'] as bool? ?? false,
      referrerSuperlikes: (json['referrer_superlikes'] as num?)?.toInt() ?? 0,
      referrerBoosts: (json['referrer_boosts'] as num?)?.toInt() ?? 0,
      referredSuperlikes: (json['referred_superlikes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReferralInfoToJson(_ReferralInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'invited': instance.invited,
      'rewarded': instance.rewarded,
      'can_redeem': instance.canRedeem,
      'referrer_superlikes': instance.referrerSuperlikes,
      'referrer_boosts': instance.referrerBoosts,
      'referred_superlikes': instance.referredSuperlikes,
    };
