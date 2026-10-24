import 'package:pulse/features/profile/domain/city.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

/// "87% de match musical": how close two people's taste is, from 0 to 100.
/// Genres weigh most (shared over all the genres either likes); favorite DJs
/// in common add the rest (2 or more count fully). Null when either side
/// has no genres, so the card doesn't show a meaningless 0%.
int? musicMatch({
  required Set<MusicGenre> myGenres,
  required List<String> myDjs,
  required List<MusicGenre> theirGenres,
  required List<String> theirDjs,
}) {
  final theirs = {...theirGenres}..remove(MusicGenre.other);
  final mine = {...myGenres}..remove(MusicGenre.other);
  if (mine.isEmpty || theirs.isEmpty) return null;

  final genreScore =
      mine.intersection(theirs).length / mine.union(theirs).length;
  final myKeys = {for (final dj in myDjs) normalizeForSearch(dj)}..remove('');
  final theirKeys = {for (final dj in theirDjs) normalizeForSearch(dj)}
    ..remove('');
  if (myKeys.isEmpty || theirKeys.isEmpty) return (genreScore * 100).round();

  final sharedDjs = myKeys.intersection(theirKeys).length;
  final djScore = sharedDjs >= 2 ? 1.0 : sharedDjs / 2;
  return ((genreScore * 0.75 + djScore * 0.25) * 100).round();
}
