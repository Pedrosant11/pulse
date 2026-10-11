import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:pulse/l10n/app_localizations.dart';

String poseLabel(AppLocalizations l10n, VerificationPose pose) =>
    switch (pose) {
      VerificationPose.thumbsUp => l10n.poseThumbsUp,
      VerificationPose.peaceSign => l10n.posePeaceSign,
      VerificationPose.handOnHead => l10n.poseHandOnHead,
      VerificationPose.pointUp => l10n.posePointUp,
      VerificationPose.handOnChin => l10n.poseHandOnChin,
    };

/// Picture of the pose (universal, not a text to translate).
String poseEmoji(VerificationPose pose) => switch (pose) {
  VerificationPose.thumbsUp => '👍',
  VerificationPose.peaceSign => '✌️',
  VerificationPose.handOnHead => '🙆',
  VerificationPose.pointUp => '☝️',
  VerificationPose.handOnChin => '🤔',
};
