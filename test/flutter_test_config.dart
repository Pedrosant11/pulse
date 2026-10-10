import 'dart:async';

import 'package:pulse/core/widgets/shader_effects.dart';
import 'package:pulse/core/widgets/state_views.dart';

/// Runs before every test file (flutter_test convention).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Animated shaders tick forever, so pumpAndSettle would never finish;
  // screens show their static fallback. shader_effects_test turns them on.
  Shaders.enabled = false;
  // Same for looping decorations (empty-state pulse): one cycle only.
  LoopingAnimations.enabled = false;
  await testMain();
}
