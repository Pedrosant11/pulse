import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

void main() {
  group('dateWindow', () {
    // 2026-10-07 is a Wednesday.
    final wednesday = DateTime(2026, 10, 7, 15);

    test('any → no bounds', () {
      expect(dateWindow(EventDateRange.any, wednesday), (null, null));
    });

    test('today runs until 6 a.m. tomorrow (parties cross midnight)', () {
      final (from, to) = dateWindow(EventDateRange.today, wednesday);
      expect(from, wednesday);
      expect(to, DateTime(2026, 10, 8, 6));
    });

    test('weekend ends Monday 6 a.m. of the coming weekend', () {
      expect(
        dateWindow(EventDateRange.weekend, wednesday).$2,
        DateTime(2026, 10, 12, 6),
      );
    });

    test('on Saturday/Sunday it is the ongoing weekend', () {
      final saturday = DateTime(2026, 10, 10, 1);
      final sunday = DateTime(2026, 10, 11, 20);
      expect(
        dateWindow(EventDateRange.weekend, saturday).$2,
        DateTime(2026, 10, 12, 6),
      );
      expect(
        dateWindow(EventDateRange.weekend, sunday).$2,
        DateTime(2026, 10, 12, 6),
      );
    });

    test('next 30 days', () {
      expect(
        dateWindow(EventDateRange.next30Days, wednesday).$2,
        DateTime(2026, 11, 7),
      );
    });
  });

  test('EventListEntry reads list_events() rows', () {
    final entry = EventListEntry.fromJson({
      'id': 'e1',
      'name': 'Noite Ácida',
      'venue_name': 'D-Edge',
      'city': 'São Paulo',
      'state': 'SP',
      'starts_at': '2026-10-10T02:00:00+00:00',
      'ends_at': '2026-10-10T10:00:00+00:00',
      'cover_path': null,
      'genres': ['techno', 'hard_techno'],
      'is_official': true,
      'status': 'approved',
      'is_mine': false,
      'is_going': true,
      'going_count': 7,
      'distance_km': 3.4,
    });
    expect(entry.genres, [MusicGenre.techno, MusicGenre.hardTechno]);
    expect(entry.status, EventStatus.approved);
    expect(entry.isGoing, isTrue);
    expect(entry.goingCount, 7);
    expect(entry.distanceKm, 3.4);
    expect(entry.startsAt.isUtc, isTrue);
  });
}
