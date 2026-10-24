import 'dart:typed_data';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/venues/data/venues_repository.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venues_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.read(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

/// "Casas": by name anywhere, otherwise in [state] (null = everywhere).
@riverpod
Future<List<Venue>> venueList(Ref ref, String query, String? state) =>
    ref.watch(venuesRepositoryProvider).list(query: query, state: state);

@riverpod
Future<VenueDetail?> venueDetail(Ref ref, String venueId) =>
    ref.watch(venuesRepositoryProvider).detail(venueId);

/// Curators: suggested venues waiting for review.
@riverpod
Future<List<VenueDetail>> pendingVenues(Ref ref) =>
    ref.watch(venuesRepositoryProvider).pending();

/// Follow, rate, add/edit and review venues.
@riverpod
class VenueEditor extends _$VenueEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  VenuesRepository get _repository => ref.read(venuesRepositoryProvider);

  void _refresh(String venueId) => ref
    ..invalidate(venueDetailProvider(venueId))
    ..invalidate(venueListProvider);

  Future<bool?> setFollowing(String venueId, {required bool following}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.setFollowing(
          venueId,
          userId: _requireUserId(ref),
          following: following,
        );
        _refresh(venueId);
        return true;
      });

  Future<bool?> rate(String venueId, int rating, String? comment) =>
      runAction(ref, (s) => state = s, () async {
        final text = comment?.trim();
        await _repository.rate(
          venueId,
          userId: _requireUserId(ref),
          rating: rating,
          comment: text == null || text.isEmpty ? null : text,
        );
        _refresh(venueId);
        return true;
      });

  Future<bool?> deleteRating(String venueId) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.deleteRating(venueId, userId: _requireUserId(ref));
        _refresh(venueId);
        return true;
      });

  /// New venue (with its photo); returns its id.
  Future<String?> create(Map<String, Object?> fields, {Uint8List? photo}) =>
      runAction(ref, (s) => state = s, () async {
        final id = await _repository.create(fields);
        if (photo != null) await _repository.setPhoto(id, photo);
        ref
          ..invalidate(venueListProvider)
          ..invalidate(pendingVenuesProvider);
        return id;
      });

  Future<bool?> save(
    String venueId,
    Map<String, Object?> fields, {
    Uint8List? photo,
  }) => runAction(ref, (s) => state = s, () async {
    await _repository.update(venueId, fields);
    if (photo != null) await _repository.setPhoto(venueId, photo);
    _refresh(venueId);
    ref.invalidate(pendingVenuesProvider);
    return true;
  });

  /// Curators approve or refuse a suggestion.
  Future<bool?> review(
    String venueId, {
    required bool approve,
    String? reason,
  }) => runAction(ref, (s) => state = s, () async {
    await _repository.review(venueId, approve: approve, reason: reason);
    _refresh(venueId);
    ref.invalidate(pendingVenuesProvider);
    return true;
  });
}
