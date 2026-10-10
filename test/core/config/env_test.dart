import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/config/env.dart';

void main() {
  group('Env.parse', () {
    test('builds a valid env', () {
      final env = Env.parse(
        supabaseUrl: ' https://abc.supabase.co ',
        supabasePublishableKey: 'sb_publishable_x',
      );
      expect(env.supabaseUrl, 'https://abc.supabase.co');
      expect(env.supabasePublishableKey, 'sb_publishable_x');
    });

    test('lists every missing value', () {
      expect(
        () => Env.parse(supabaseUrl: '', supabasePublishableKey: ''),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('SUPABASE_URL'),
              contains('SUPABASE_PUBLISHABLE_KEY'),
            ),
          ),
        ),
      );
    });

    test('rejects a malformed url', () {
      expect(
        () => Env.parse(
          supabaseUrl: 'abc.supabase.co',
          supabasePublishableKey: 'key',
        ),
        throwsStateError,
      );
    });
  });
}
