import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable, listEquals;
import 'package:pulse/features/profile/domain/profile_enums.dart';

/// What a ticket page says about its event ("Importar de um link"). Every
/// field is optional: the form only fills what came, and the person
/// reviews everything before saving.
@immutable
class ImportedEvent {
  const new({
    required this.ticketUrl,
    this.name,
    this.description,
    this.startsAt,
    this.endsAt,
    this.venueName,
    this.address,
    this.city,
    this.state,
    this.lat,
    this.lng,
    this.imageUrl,
    this.lineup = const [],
    this.genres = const {},
  });

  final String ticketUrl;
  final String? name;
  final String? description;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? venueName;

  /// Street and number, without the city.
  final String? address;
  final String? city;

  /// UF ("RJ").
  final String? state;
  final double? lat;
  final double? lng;
  final String? imageUrl;
  final List<String> lineup;

  /// Guessed from the name, description and line-up.
  final Set<MusicGenre> genres;

  /// Nothing useful came (the page has no event data).
  bool get isEmpty =>
      name == null && startsAt == null && venueName == null && imageUrl == null;

  @override
  bool operator ==(Object other) =>
      other is ImportedEvent &&
      other.ticketUrl == ticketUrl &&
      other.name == name &&
      other.description == description &&
      other.startsAt == startsAt &&
      other.endsAt == endsAt &&
      other.venueName == venueName &&
      other.address == address &&
      other.city == city &&
      other.state == state &&
      other.lat == lat &&
      other.lng == lng &&
      other.imageUrl == imageUrl &&
      listEquals(other.lineup, lineup) &&
      other.genres.length == genres.length &&
      other.genres.containsAll(genres);

  @override
  int get hashCode => Object.hash(ticketUrl, name, startsAt, venueName);
}

/// Maps the `event-preview` response (JSON-LD blocks + meta tags) to an
/// [ImportedEvent]. schema.org Event data wins; Open Graph fills the gaps.
ImportedEvent parseEventPreview(Map<String, dynamic> preview) {
  final url = preview['url'] as String? ?? '';
  final meta = {
    for (final MapEntry(:key, :value)
        in ((preview['meta'] as Map?) ?? const {}).entries)
      '$key': '$value',
  };
  final event = _findEvent([
    for (final block in (preview['ldJson'] as List?) ?? const [])
      ?_tryJson('$block'),
  ]);

  final location = _first(event?['location']);
  final address = location is Map ? location['address'] : null;
  final postal = _first(address);
  final geo = location is Map ? _first(location['geo']) : null;

  String? text(Object? value) {
    final s = value is String ? _clean(value) : null;
    return s == null || s.isEmpty ? null : s;
  }

  final name =
      text(event?['name']) ??
      _stripSiteName(text(meta['og:title']) ?? text(preview['title']));
  final description =
      text(event?['description']) ??
      text(meta['og:description']) ??
      text(meta['description']);
  final lineup = <String>[
    for (final p in _list(event?['performer'])) ?text(p is Map ? p['name'] : p),
  ];
  final venueName = location is Map ? text(location['name']) : text(location);

  String? street;
  String? city;
  String? state;
  if (postal is Map) {
    street = text(postal['streetAddress']);
    city = text(postal['addressLocality']);
    state = _uf(text(postal['addressRegion']));
  } else if (text(postal) case final line?) {
    street = line;
  }

  return ImportedEvent(
    ticketUrl: url,
    name: name,
    description: description,
    startsAt: _date(event?['startDate']) ?? _date(meta['event:start_time']),
    endsAt: _date(event?['endDate']) ?? _date(meta['event:end_time']),
    venueName: venueName,
    address: street,
    city: city,
    state: state,
    lat: _num(geo is Map ? geo['latitude'] : null),
    lng: _num(geo is Map ? geo['longitude'] : null),
    imageUrl: _image(event?['image']) ?? text(meta['og:image']),
    lineup: lineup.toSet().take(50).toList(),
    genres: guessGenres([?name, ?description, ...lineup].join(' ')),
  );
}

/// Genres mentioned in [text] (most specific first, so "afro house" does not
/// also count as plain "house").
Set<MusicGenre> guessGenres(String text) {
  var t = ' ${text.toLowerCase()} ';
  final found = <MusicGenre>{};
  for (final (genre, words) in _genreWords) {
    for (final word in words) {
      if (t.contains(word)) {
        found.add(genre);
        t = t.replaceAll(word, ' ');
      }
    }
  }
  return found;
}

const List<(MusicGenre, List<String>)> _genreWords = [
  (MusicGenre.hardTechno, ['hard techno', 'hardtechno']),
  (MusicGenre.melodicTechno, ['melodic techno', 'melodic house', 'melodic']),
  (MusicGenre.techHouse, ['tech house', 'tech-house', 'techhouse']),
  (MusicGenre.afroHouse, ['afro house', 'afrohouse', 'afro-house']),
  (MusicGenre.discoNuDisco, ['nu disco', 'nu-disco', 'disco']),
  (
    MusicGenre.drumAndBass,
    ['drum and bass', 'drum & bass', 'drum n bass', 'dnb', "d'n'b"],
  ),
  (MusicGenre.psytrance, ['psytrance', 'psy trance', 'psy-trance', ' psy ']),
  (MusicGenre.trance, ['trance']),
  (MusicGenre.dubstep, ['dubstep']),
  (MusicGenre.minimal, ['minimal']),
  (MusicGenre.techno, ['techno']),
  (MusicGenre.house, ['house']),
  (MusicGenre.edm, [' edm ', 'electro house', 'big room']),
];

Object? _tryJson(String block) {
  try {
    return jsonDecode(block);
  } on FormatException {
    return null;
  }
}

/// First schema.org *Event node in the blocks (objects, lists, @graph).
Map<String, dynamic>? _findEvent(List<Object?> blocks) {
  final queue = [...blocks];
  while (queue.isNotEmpty) {
    final node = queue.removeAt(0);
    if (node is List) {
      queue.addAll(node);
    } else if (node is Map<String, dynamic>) {
      final types = _list(node['@type']).map((t) => '$t');
      if (types.any((t) => t.endsWith('Event') || t == 'Festival')) {
        return node;
      }
      if (node['@graph'] case final graph?) queue.add(graph);
    }
  }
  return null;
}

List<Object?> _list(Object? value) =>
    value == null ? const [] : (value is List ? value : [value]);

Object? _first(Object? value) =>
    value is List ? (value.isEmpty ? null : value.first) : value;

String? _image(Object? value) {
  final first = _first(value);
  if (first is String) return first.trim().isEmpty ? null : first.trim();
  if (first is Map) return _image(first['url'] ?? first['contentUrl']);
  return null;
}

double? _num(Object? value) =>
    value is num ? value.toDouble() : double.tryParse('${value ?? ''}');

DateTime? _date(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return DateTime.tryParse(value.trim());
}

/// "Festa X | Sympla" → "Festa X".
String? _stripSiteName(String? title) {
  if (title == null) return null;
  final parts = title.split(RegExp(r'\s+[|–—]\s+|\s+-\s+(?=[^-]+$)'));
  return parts.first.trim().isEmpty ? title : parts.first.trim();
}

String? _uf(String? region) {
  if (region == null) return null;
  final r = region.trim();
  if (r.length == 2) return r.toUpperCase();
  return _states[_fold(r)];
}

String _fold(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[áàâã]'), 'a')
    .replaceAll(RegExp('[éê]'), 'e')
    .replaceAll('í', 'i')
    .replaceAll(RegExp('[óôõ]'), 'o')
    .replaceAll('ú', 'u')
    .replaceAll('ç', 'c');

const _states = {
  'acre': 'AC',
  'alagoas': 'AL',
  'amapa': 'AP',
  'amazonas': 'AM',
  'bahia': 'BA',
  'ceara': 'CE',
  'distrito federal': 'DF',
  'espirito santo': 'ES',
  'goias': 'GO',
  'maranhao': 'MA',
  'mato grosso': 'MT',
  'mato grosso do sul': 'MS',
  'minas gerais': 'MG',
  'para': 'PA',
  'paraiba': 'PB',
  'parana': 'PR',
  'pernambuco': 'PE',
  'piaui': 'PI',
  'rio de janeiro': 'RJ',
  'rio grande do norte': 'RN',
  'rio grande do sul': 'RS',
  'rondonia': 'RO',
  'roraima': 'RR',
  'santa catarina': 'SC',
  'sao paulo': 'SP',
  'sergipe': 'SE',
  'tocantins': 'TO',
};

/// Plain text: tags removed, entities decoded, spaces collapsed.
String _clean(String html) {
  final noTags = html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp('</p>', caseSensitive: false), '\n')
      .replaceAll(RegExp('<[^>]+>'), '');
  final decoded = noTags.replaceAllMapped(
    RegExp(r'&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);'),
    (m) {
      final code = m[1]!;
      if (code.startsWith('#x') || code.startsWith('#X')) {
        return String.fromCharCode(int.parse(code.substring(2), radix: 16));
      }
      if (code.startsWith('#')) {
        return String.fromCharCode(int.parse(code.substring(1)));
      }
      return _entities[code] ?? m[0]!;
    },
  );
  return decoded
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t ]+'), ' ').trim())
      .join('\n')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();
}

const _entities = {
  'amp': '&',
  'quot': '"',
  'apos': "'",
  'lt': '<',
  'gt': '>',
  'nbsp': ' ',
};
