import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pulse/core/errors/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_repository.g.dart';

/// An address or place found by the search.
final class PlaceSuggestion {
  const new({required this.label, required this.lat, required this.lng});

  /// Readable address, e.g. "Blitz Haus, Rua Augusta 657, Higienópolis,
  /// São Paulo".
  final String label;
  final double lat;
  final double lng;
}

/// City the event is in: completes the query and biases the results.
typedef SearchCity = ({String name, String state, double lat, double lng});

final _cepPattern = RegExp(r'^\s*(\d{5})-?(\d{3})\s*$');

/// Address search for the event venue (SPEC 7.4). Free and keyless:
///
/// - CEP → street from ViaCEP (Brazilian CEP base), placed on the map
///   with Photon.
/// - Anything else → Photon (OpenStreetMap geocoder by komoot): addresses
///   with number and many venues by name, limited to Brazil, completed with
///   the event's city and biased towards it.
/// - [reverse] names the point tapped on the map.
///
/// The public Photon server is for fair use; when the app grows, point
/// [photonHost] to a self-hosted instance (same API).
class PlaceSearchRepository {
  new({http.Client? client, this.photonHost = 'photon.komoot.io'})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String photonHost;

  /// Photon asks clients to identify themselves.
  static const _headers = {'User-Agent': 'Pulse/1.0 (com.pulseapp.pulse)'};

  /// Brazil (west, south, east, north).
  static const _brazilBox = '-74.0,-34.0,-34.0,5.5';

  Future<List<PlaceSuggestion>> search(String query, {SearchCity? city}) =>
      guardFailures(() async {
        final text = query.trim();
        if (text.length < 3) return const [];
        final cep = _cepPattern.firstMatch(text);
        if (cep != null) return await _searchCep('${cep[1]}${cep[2]}');

        // "Rua X 123" → "Rua X 123, São Paulo".
        final completed =
            city == null || text.toLowerCase().contains(city.name.toLowerCase())
            ? text
            : '$text, ${city.name}';
        return await _geocode(
          completed,
          near: city == null ? null : (lat: city.lat, lng: city.lng),
        );
      });

  /// Address of a point (map tap), or null when nothing is known there.
  Future<String?> reverse(double lat, double lng) => guardFailures(() async {
    final features = await _get(
      Uri.https(photonHost, '/reverse', {
        'lat': '$lat',
        'lon': '$lng',
        'limit': '1',
      }),
    );
    return features.isEmpty ? null : _label(features.first);
  });

  Future<List<PlaceSuggestion>> _searchCep(String cep) async {
    final response = await _client.get(
      Uri.https('viacep.com.br', '/ws/$cep/json/'),
    );
    if (response.statusCode != 200) return const [];
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (data['erro'] != null) return const [];
    final street = (data['logradouro'] as String? ?? '').trim();
    final district = (data['bairro'] as String? ?? '').trim();
    final cityName = data['localidade'] as String? ?? '';
    final state = data['uf'] as String? ?? '';
    if (street.isEmpty) return const [];

    // ViaCEP has no coordinates: place the street on the map.
    final places = await _geocode('$street, $cityName');
    if (places.isEmpty) return const [];
    return [
      PlaceSuggestion(
        label: [
          street,
          if (district.isNotEmpty) district,
          '$cityName - $state',
        ].join(', '),
        lat: places.first.lat,
        lng: places.first.lng,
      ),
    ];
  }

  Future<List<PlaceSuggestion>> _geocode(
    String text, {
    ({double lat, double lng})? near,
  }) async {
    final features = await _get(
      Uri.https(photonHost, '/api', {
        'q': text,
        'limit': '6',
        'bbox': _brazilBox,
        if (near != null) ...{'lat': '${near.lat}', 'lon': '${near.lng}'},
      }),
    );
    return [
      for (final feature in features)
        if ((feature['properties'] as Map?)?['countrycode'] == 'BR')
          if ((feature['geometry'] as Map?)?['coordinates'] case [
            final num lng,
            final num lat,
          ])
            PlaceSuggestion(
              label: _label(feature),
              lat: lat.toDouble(),
              lng: lng.toDouble(),
            ),
    ];
  }

  Future<List<Map<String, dynamic>>> _get(Uri uri) async {
    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode == 429) throw const RateLimitedFailure();
    if (response.statusCode != 200) {
      throw UnknownFailure('Geocoding HTTP ${response.statusCode}');
    }
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return ((body['features'] as List?) ?? const [])
        .cast<Map<String, dynamic>>();
  }

  /// "Blitz Haus, Rua Augusta 657, Higienópolis, São Paulo".
  static String _label(Map<String, dynamic> feature) {
    final p = (feature['properties'] as Map?) ?? const {};
    String? text(String key) {
      final value = (p[key] as String?)?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final street = text('street');
    final number = text('housenumber');
    final name = text('name');
    final streetLine = street == null
        ? null
        : number == null
        ? street
        : '$street $number';
    final parts = <String>[
      if (name != null && name != street) name,
      ?streetLine,
      ?(text('district') ?? text('locality')),
      ?text('city'),
    ];
    // Drop repeats ("São Paulo, São Paulo").
    final unique = <String>[];
    for (final part in parts) {
      if (unique.isEmpty || unique.last != part) unique.add(part);
    }
    return unique.join(', ');
  }
}

@Riverpod(keepAlive: true)
PlaceSearchRepository placeSearchRepository(Ref ref) => PlaceSearchRepository();
