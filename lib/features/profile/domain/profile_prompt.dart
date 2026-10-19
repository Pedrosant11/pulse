import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_prompt.freezed.dart';
part 'profile_prompt.g.dart';

/// The questions a profile can answer (`profile_prompts.prompt` check).
@JsonEnum(fieldRename: FieldRename.snake)
enum ProfilePrompt {
  dreamSet,
  onTheFloor,
  afterParty,
  bestParty,
  trackOnRepeat,
  festivalMust,
  greenFlag,
  crewRole,
  matchIf,
  winsMeOver,
}

/// One answer on a profile (up to 3, in order).
@freezed
abstract class PromptAnswer with _$PromptAnswer {
  const factory({required ProfilePrompt prompt, required String answer}) =
      _PromptAnswer;

  factory fromJson(Map<String, dynamic> json) => _$PromptAnswerFromJson(json);
}
