import 'dart:math';

import 'package:flutter/foundation.dart' show immutable;

/// Brazilian municipality (IBGE list bundled in assets/data/br_cities.json).
@immutable
class City {
  const new({
    required this.name,
    required this.state,
    required this.lat,
    required this.lng,
    this.isCapital = false,
  });

  factory fromRow(List<dynamic> row) => City(
    name: row[0] as String,
    state: row[1] as String,
    lat: (row[2] as num).toDouble(),
    lng: (row[3] as num).toDouble(),
    isCapital: row[4] == 1,
  );

  final String name;

  /// UF, e.g. "SP".
  final String state;
  final double lat;
  final double lng;
  final bool isCapital;

  String get label => '$name, $state';

  @override
  bool operator ==(Object other) =>
      other is City && other.name == name && other.state == state;

  @override
  int get hashCode => Object.hash(name, state);
}

/// Search and nearest-city lookup, entirely on device (no geocoding
/// service receives the user's location).
class CityIndex {
  new(List<City> cities)
    : _cities = cities,
      _keys = [for (final c in cities) normalizeForSearch(c.name)];

  final List<City> _cities;
  final List<String> _keys;

  List<City> get all => _cities;

  /// Accent/case-insensitive. Prefix matches first, capitals first.
  List<City> search(String query, {int limit = 30}) {
    final q = normalizeForSearch(query);
    if (q.isEmpty) {
      return _cities.where((c) => c.isCapital).take(limit).toList();
    }
    final prefix = <City>[];
    final contains = <City>[];
    for (var i = 0; i < _cities.length; i++) {
      final key = _keys[i];
      if (key.startsWith(q)) {
        prefix.add(_cities[i]);
      } else if (key.contains(q)) {
        contains.add(_cities[i]);
      }
    }
    int byCapital(City a, City b) =>
        (b.isCapital ? 1 : 0) - (a.isCapital ? 1 : 0);
    prefix.sort(byCapital);
    contains.sort(byCapital);
    return [...prefix, ...contains].take(limit).toList();
  }

  City? find(String name, String state) {
    for (final c in _cities) {
      if (c.state == state && c.name == name) return c;
    }
    return null;
  }

  City nearest(double lat, double lng) {
    var best = _cities.first;
    var bestDistance = double.infinity;
    for (final c in _cities) {
      final d = distanceKm(lat, lng, c.lat, c.lng);
      if (d < bestDistance) {
        bestDistance = d;
        best = c;
      }
    }
    return best;
  }
}

/// Great-circle distance (haversine).
double distanceKm(double lat1, double lng1, double lat2, double lng2) {
  const earthRadiusKm = 6371.0;
  double rad(double deg) => deg * pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLng = rad(lng2 - lng1);
  final a =
      pow(sin(dLat / 2), 2) +
      cos(rad(lat1)) * cos(rad(lat2)) * pow(sin(dLng / 2), 2);
  return 2 * earthRadiusKm * asin(sqrt(a));
}

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ç': 'c', 'ñ': 'n',
};

String normalizeForSearch(String value) {
  final lower = value.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_accents[char] ?? char);
  }
  return buffer.toString();
}
