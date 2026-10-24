import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/features/events/domain/event.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

/// Conquistas (achievements migration), rarest first.
@JsonEnum(fieldRename: FieldRename.snake)
enum AchievementKey {
  nightLegend,
  loyalToTheHouse,
  marathoner,
  eclectic,
  explorer,
  neverAlone,
  partyAnimal,
  firstParty,
}

@freezed
abstract class Achievement with _$Achievement {
  const factory({
    required AchievementKey key,
    required int progress,
    required int goal,
    required bool unlocked,
  }) = _Achievement;

  factory fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}

/// `my_passport()`: totals and the parties (last 3, or all with Black).
@freezed
abstract class Passport with _$Passport {
  const factory({
    @Default(0) int parties,
    @Default(0) int venues,
    @Default(0) int cities,
    @Default(0) int genres,

    /// The whole history (Pulse Black).
    @Default(false) bool full,
    @Default([]) List<EventSummary> entries,
  }) = _Passport;

  factory fromJson(Map<String, dynamic> json) => _$PassportFromJson(json);
}
