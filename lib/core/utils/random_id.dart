import 'dart:math';

final _random = Random.secure();

/// Random 128-bit id as 32 hex chars (used for storage object names).
String randomId() => List.generate(
  16,
  (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
).join();
