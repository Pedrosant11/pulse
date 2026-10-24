import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/discover/domain/music_match.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

void main() {
  test('same genres and 2+ DJs in common: 100%', () {
    expect(
      musicMatch(
        myGenres: {MusicGenre.techno, MusicGenre.house},
        myDjs: const ['Charlotte de Witte', 'Amelie Lens'],
        theirGenres: const [MusicGenre.house, MusicGenre.techno],
        theirDjs: const ['amelie lens', 'Charlotte De Witte', 'Fisher'],
      ),
      100,
    );
  });

  test('genres weigh most; one DJ in common adds half the DJ part', () {
    // Genres: 1 shared of 3 → 1/3; DJs: 1 shared → 0.5.
    expect(
      musicMatch(
        myGenres: {MusicGenre.techno, MusicGenre.house},
        myDjs: const ['Fisher'],
        theirGenres: const [MusicGenre.techno, MusicGenre.trance],
        theirDjs: const ['FISHER'],
      ),
      38,
    );
  });

  test('without DJs on one side, only genres count', () {
    expect(
      musicMatch(
        myGenres: {MusicGenre.techno},
        myDjs: const [],
        theirGenres: const [MusicGenre.techno, MusicGenre.house],
        theirDjs: const ['Fisher'],
      ),
      50,
    );
  });

  test('no genres on either side: nothing to show', () {
    expect(
      musicMatch(
        myGenres: const {},
        myDjs: const ['Fisher'],
        theirGenres: const [MusicGenre.techno],
        theirDjs: const ['Fisher'],
      ),
      isNull,
    );
    expect(
      musicMatch(
        myGenres: {MusicGenre.other},
        myDjs: const [],
        theirGenres: const [MusicGenre.other],
        theirDjs: const [],
      ),
      isNull,
    );
  });
}
