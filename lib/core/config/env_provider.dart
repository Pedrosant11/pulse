import 'package:pulse/core/config/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env_provider.g.dart';

/// Overridden in `main.dart` with the validated [Env].
@Riverpod(keepAlive: true)
Env env(Ref ref) => throw UnimplementedError(
  'envProvider must be overridden in ProviderScope (see main.dart).',
);
