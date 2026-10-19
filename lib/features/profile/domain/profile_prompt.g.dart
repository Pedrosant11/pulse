// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromptAnswer _$PromptAnswerFromJson(Map<String, dynamic> json) =>
    _PromptAnswer(
      prompt: $enumDecode(_$ProfilePromptEnumMap, json['prompt']),
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$PromptAnswerToJson(_PromptAnswer instance) =>
    <String, dynamic>{
      'prompt': _$ProfilePromptEnumMap[instance.prompt]!,
      'answer': instance.answer,
    };

const _$ProfilePromptEnumMap = {
  ProfilePrompt.dreamSet: 'dream_set',
  ProfilePrompt.onTheFloor: 'on_the_floor',
  ProfilePrompt.afterParty: 'after_party',
  ProfilePrompt.bestParty: 'best_party',
  ProfilePrompt.trackOnRepeat: 'track_on_repeat',
  ProfilePrompt.festivalMust: 'festival_must',
  ProfilePrompt.greenFlag: 'green_flag',
  ProfilePrompt.crewRole: 'crew_role',
  ProfilePrompt.matchIf: 'match_if',
  ProfilePrompt.winsMeOver: 'wins_me_over',
};
