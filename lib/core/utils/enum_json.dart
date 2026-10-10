final _upper = RegExp('[A-Z]');

/// Database value of an enum declared with `@JsonEnum(fieldRename: snake)`
/// (e.g. `MusicGenre.drumAndBass` → `drum_and_bass`). Used when building
/// update payloads by hand.
String enumToDb(Enum value) =>
    value.name.replaceAllMapped(_upper, (m) => '_${m[0]!.toLowerCase()}');

List<String> enumsToDb(Iterable<Enum> values) => values.map(enumToDb).toList();
