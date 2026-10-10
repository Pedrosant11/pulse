import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/features/profile/data/location_repository.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('enumToDb', () {
    test('matches the database enum values', () {
      expect(enumToDb(MusicGenre.drumAndBass), 'drum_and_bass');
      expect(enumToDb(MusicGenre.discoNuDisco), 'disco_nu_disco');
      expect(enumToDb(Gender.preferNotSay), 'prefer_not_say');
      expect(enumToDb(AppMode.crew), 'crew');
      expect(enumsToDb([Gender.woman, Gender.nonBinary]), [
        'woman',
        'non_binary',
      ]);
    });
  });

  group('MyProfile.fromJson', () {
    test('reads snake_case columns and enums', () {
      final profile = MyProfile.fromJson({
        'id': 'u1',
        'first_name': 'Ana',
        'birth_date': '1994-03-12',
        'gender': 'woman',
        'orientation': 'bisexual',
        'lat': -23.55,
        'lng': -46.63,
        'music_genres': ['techno', 'melodic_techno'],
        'modes': ['date', 'crew'],
        'date_show_me': ['man', 'non_binary'],
        'date_age_min': 21,
        'date_age_max': 40,
        'pets': ['dog'],
        'onboarding_step': 3,
        // Extra columns from select() are ignored.
        'role': 'user',
      });
      expect(profile.firstName, 'Ana');
      expect(profile.birthDate, DateTime(1994, 3, 12));
      expect(profile.orientation, SexualOrientation.bisexual);
      expect(profile.musicGenres, [
        MusicGenre.techno,
        MusicGenre.melodicTechno,
      ]);
      expect(profile.modes, [AppMode.date, AppMode.crew]);
      expect(profile.dateShowMe, [Gender.man, Gender.nonBinary]);
      expect(profile.pets, [Pet.dog]);
      expect(profile.onboardingStep, 3);
      expect(profile.crewSameGenderOnly, isFalse);
    });
  });

  group('cities (bundled IBGE list)', () {
    late CityIndex index;

    setUpAll(() async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      index = await container.read(cityIndexProvider.future);
    });

    test('loads every municipality', () {
      expect(index.all.length, greaterThan(5500));
    });

    test('search ignores accents and case, prefix first', () {
      final results = index.search('sao paulo');
      expect(results.first.label, 'São Paulo, SP');
      expect(index.search('FLORIANOPOLIS').first.state, 'SC');
    });

    test('empty search lists capitals', () {
      expect(index.search('').every((c) => c.isCapital), isTrue);
    });

    test('nearest city from coordinates (on device)', () {
      expect(index.nearest(-23.56, -46.65).label, 'São Paulo, SP');
      expect(index.nearest(-22.97, -43.18).label, 'Rio de Janeiro, RJ');
    });

    test('normalizeForSearch', () {
      expect(normalizeForSearch('  Niterói '), 'niteroi');
      expect(normalizeForSearch('Conceição'), 'conceicao');
    });
  });

  test('distanceKm (SP ↔ RJ ≈ 360 km)', () {
    final d = distanceKm(-23.55, -46.63, -22.91, -43.17);
    expect(d, closeTo(360, 15));
  });

  test('asset is valid JSON', () async {
    final raw = await rootBundle.loadString('assets/data/br_cities.json');
    expect(raw.trimLeft().startsWith('['), isTrue);
  });
}
