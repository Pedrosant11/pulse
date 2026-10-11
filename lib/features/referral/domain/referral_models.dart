import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_models.freezed.dart';
part 'referral_models.g.dart';

/// The person's referral code and how it went (`get_my_referral()`).
@freezed
abstract class ReferralInfo with _$ReferralInfo {
  const factory({
    required String code,
    @Default(0) int invited,
    @Default(0) int rewarded,

    /// True until the person has used a code or made a first match.
    @Default(false) bool canRedeem,
    @Default(0) int referrerSuperlikes,
    @Default(0) int referrerBoosts,
    @Default(0) int referredSuperlikes,
  }) = _ReferralInfo;

  factory fromJson(Map<String, dynamic> json) => _$ReferralInfoFromJson(json);
}
