import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/events/domain/event_import.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

void main() {
  test('schema.org Event: name, dates, venue, address, geo, line-up', () {
    final event = parseEventPreview({
      'url': 'https://www.sympla.com.br/evento/beltran/123',
      'ldJson': [
        jsonEncode({
          '@context': 'https://schema.org',
          '@type': 'MusicEvent',
          'name': 'Beltran na D-EDGE Rio',
          'description': '<p>Tech house a noite toda &amp; <b>3 anos</b></p>',
          'startDate': '2026-11-06T23:00:00-03:00',
          'endDate': '2026-11-07T06:00:00-03:00',
          'image': ['https://cdn.example.com/beltran.jpg'],
          'location': {
            '@type': 'Place',
            'name': 'D-EDGE Rio',
            'address': {
              '@type': 'PostalAddress',
              'streetAddress': 'Av. Rodrigues Alves, 293',
              'addressLocality': 'Rio de Janeiro',
              'addressRegion': 'Rio de Janeiro',
            },
            'geo': {'latitude': -22.8963, 'longitude': '-43.1858'},
          },
          'performer': [
            {'@type': 'Person', 'name': 'Beltran'},
            {'@type': 'Person', 'name': 'Beltran'},
          ],
        }),
      ],
      'meta': {'og:title': 'Outro título | Sympla'},
    });

    expect(event.name, 'Beltran na D-EDGE Rio');
    expect(event.description, 'Tech house a noite toda & 3 anos');
    expect(event.startsAt, DateTime.utc(2026, 11, 7, 2));
    expect(event.endsAt, DateTime.utc(2026, 11, 7, 9));
    expect(event.venueName, 'D-EDGE Rio');
    expect(event.address, 'Av. Rodrigues Alves, 293');
    expect(event.city, 'Rio de Janeiro');
    expect(event.state, 'RJ');
    expect(event.lat, -22.8963);
    expect(event.lng, -43.1858);
    expect(event.imageUrl, 'https://cdn.example.com/beltran.jpg');
    expect(event.lineup, ['Beltran']);
    expect(event.genres, {MusicGenre.techHouse});
    expect(event.ticketUrl, 'https://www.sympla.com.br/evento/beltran/123');
  });

  test('finds the event inside @graph and lists', () {
    final event = parseEventPreview({
      'url': 'https://shotgun.live/events/x',
      'ldJson': [
        'not json at all',
        jsonEncode({
          '@graph': [
            {'@type': 'Organization', 'name': 'Shotgun'},
            {
              '@type': ['Event', 'Thing'],
              'name': 'BOMA',
              'location': 'Praça Mauá',
            },
          ],
        }),
      ],
    });
    expect(event.name, 'BOMA');
    expect(event.venueName, 'Praça Mauá');
  });

  test('without JSON-LD, Open Graph fills name, image and description', () {
    final event = parseEventPreview({
      'url': 'https://www.ingresse.com/d-edge-rio-3-anos/',
      'ldJson': <String>[],
      'meta': {
        'og:title': 'D-EDGE RIO • 3 ANOS | Ingresse',
        'og:image': 'https://kraken.ingresse.com/poster.jpg',
        'og:description': 'Hard techno e afro house na pista',
      },
    });
    expect(event.name, 'D-EDGE RIO • 3 ANOS');
    expect(event.imageUrl, 'https://kraken.ingresse.com/poster.jpg');
    expect(event.startsAt, isNull);
    expect(event.genres, {MusicGenre.hardTechno, MusicGenre.afroHouse});
    expect(event.isEmpty, isFalse);
  });

  test('a page with nothing about an event is empty', () {
    final event = parseEventPreview({
      'url': 'https://example.com',
      'ldJson': [
        jsonEncode({'@type': 'WebSite', 'name': 'Example'}),
      ],
      'meta': <String, String>{},
    });
    expect(event.isEmpty, isTrue);
  });

  test('genres: the specific one wins over the generic one', () {
    expect(guessGenres('Melodic Techno ao pôr do sol'), {
      MusicGenre.melodicTechno,
    });
    expect(guessGenres('Noite de drum & bass e dubstep'), {
      MusicGenre.drumAndBass,
      MusicGenre.dubstep,
    });
    expect(guessGenres('Festival de psy'), {MusicGenre.psytrance});
    expect(guessGenres('Samba e pagode'), isEmpty);
  });
}
