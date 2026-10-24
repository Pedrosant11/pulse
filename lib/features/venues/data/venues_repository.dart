import 'dart:typed_data';

import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'venues_repository.g.dart';

const _photosBucket = 'venue-photos';

/// Casas (venues migration). Who may add, edit, rate and approve is decided
/// by the database.
class VenuesRepository {
  new(this._client);

  final SupabaseClient _client;

  /// Approved venues (and my pending suggestions). With [query], by name
  /// anywhere; otherwise in [state] (null = everywhere).
  Future<List<Venue>> list({String? query, String? state, int limit = 50}) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'list_venues',
          params: {
            'p_query': (query ?? '').trim().isEmpty ? null : query!.trim(),
            'p_state': state,
            'p_limit': limit,
          },
        );
        return [
          for (final row in rows) Venue.fromJson(row as Map<String, dynamic>),
        ];
      });

  /// Null when it doesn't exist or isn't visible.
  Future<VenueDetail?> detail(String venueId) => guardFailures(() async {
    final row = await _client.rpc<Map<String, dynamic>?>(
      'get_venue',
      params: {'p_venue': venueId},
    );
    return row == null ? null : VenueDetail.fromJson(row);
  });

  Future<void> setFollowing(
    String venueId, {
    required String userId,
    required bool following,
  }) => guardFailures(() async {
    if (following) {
      await _client.from('venue_follows').upsert({
        'venue_id': venueId,
        'user_id': userId,
      });
    } else {
      await _client
          .from('venue_follows')
          .delete()
          .eq('venue_id', venueId)
          .eq('user_id', userId);
    }
  });

  /// Only after going to a party there ([VenueReviewNotAllowedFailure]).
  Future<void> rate(
    String venueId, {
    required String userId,
    required int rating,
    String? comment,
  }) => guardFailures(
    () => _client.from('venue_reviews').upsert({
      'venue_id': venueId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    }),
  );

  Future<void> deleteRating(String venueId, {required String userId}) =>
      guardFailures(
        () => _client
            .from('venue_reviews')
            .delete()
            .eq('venue_id', venueId)
            .eq('user_id', userId),
      );

  /// Returns the new venue's id. Producers' venues wait for the curators.
  Future<String> create(Map<String, Object?> fields) => guardFailures(() async {
    final row = await _client
        .from('venues')
        .insert(fields)
        .select('id')
        .single();
    return row['id'] as String;
  });

  Future<void> update(String venueId, Map<String, Object?> fields) =>
      guardFailures(
        () => _client.from('venues').update(fields).eq('id', venueId),
      );

  Future<void> setPhoto(String venueId, Uint8List jpeg) =>
      guardFailures(() async {
        final path = '$venueId/${randomId()}.jpg';
        await _client.storage
            .from(_photosBucket)
            .uploadBinary(
              path,
              jpeg,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        await update(venueId, {'photo_path': path});
      });

  String photoUrl(String path) =>
      _client.storage.from(_photosBucket).getPublicUrl(path);

  /// Curators: suggestions waiting, oldest first.
  Future<List<VenueDetail>> pending() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('pending_venues');
    return [
      for (final row in rows) VenueDetail.fromJson(row as Map<String, dynamic>),
    ];
  });

  Future<void> review(
    String venueId, {
    required bool approve,
    String? reason,
  }) => guardFailures(
    () => _client.rpc<void>(
      'admin_review_venue',
      params: {'p_venue': venueId, 'p_approve': approve, 'p_reason': reason},
    ),
  );
}

@Riverpod(keepAlive: true)
VenuesRepository venuesRepository(Ref ref) =>
    VenuesRepository(ref.watch(supabaseClientProvider));
