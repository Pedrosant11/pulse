import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/errors/crash_reporter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Recorder implements CrashReporter {
  final errors = <Object>[];

  @override
  void record(Object error, StackTrace? stackTrace, {bool fatal = false}) =>
      errors.add(error);

  @override
  void setUser(String? userId) {}
}

void main() {
  late _Recorder recorder;

  setUp(() => crashReporter = recorder = _Recorder());
  tearDown(() => crashReporter = const NoCrashReporter());

  test('unexpected errors go to the crash report', () async {
    await expectLater(
      guardFailures<void>(() async => throw StateError('bug')),
      throwsA(isA<UnknownFailure>()),
    );
    expect(recorder.errors.single, isA<StateError>());
  });

  test('expected failures (rules, network) are not reported', () async {
    await expectLater(
      guardFailures<void>(
        () async => throw const PostgrestException(
          message: 'Too far',
          code: 'P0001',
          hint: 'checkin_too_far',
        ),
      ),
      throwsA(isA<CheckInFailure>()),
    );
    await expectLater(
      guardFailures<void>(
        () async => throw const PostgrestException(
          message: 'nope',
          code: '42501',
        ),
      ),
      throwsA(isA<AppFailure>()),
    );
    expect(recorder.errors, isEmpty);
  });
}
