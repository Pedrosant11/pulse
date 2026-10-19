import 'dart:typed_data';

import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'ads_repository.g.dart';

/// Own ads and their numbers (ads migration). Who sees ads and how often is
/// decided by `get_ads()`; only admins write ads (RLS).
class AdsRepository {
  new(this._client);

  final SupabaseClient _client;

  static const _bucket = 'ad-images';

  Future<AdsConfig> config() => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>('get_ads');
    return AdsConfig.fromJson(json);
  });

  /// Counted once per person a day by the database; failures don't matter.
  Future<void> log(String adId, {required bool click}) async {
    try {
      await _client.rpc<void>(
        'log_ad',
        params: {'p_ad': adId, 'p_kind': click ? 'click' : 'impression'},
      );
    } on Object {
      // Numbers are best effort.
    }
  }

  String imageUrl(String path) =>
      _client.storage.from(_bucket).getPublicUrl(path);

  // Admin ---------------------------------------------------------------

  Future<List<AdminAd>> all() => guardFailures(() async {
    final rows = await _client
        .from('ads')
        .select()
        .order('created_at', ascending: false);
    final stats = await _client.rpc<List<dynamic>>('admin_ad_stats');
    final byAd = {
      for (final s in stats.cast<Map<String, dynamic>>()) s['ad_id']: s,
    };
    return [
      for (final row in rows)
        AdminAd.fromJson({
          ...row,
          'impressions': byAd[row['id']]?['impressions'] ?? 0,
          'clicks': byAd[row['id']]?['clicks'] ?? 0,
        }),
    ];
  });

  /// Creates or updates an ad; a new [image] replaces the old one.
  Future<void> save(AdminAd ad, {Uint8List? image, bool isNew = false}) =>
      guardFailures(() async {
        var imagePath = ad.imagePath;
        if (image != null) {
          imagePath = '${randomId()}.jpg';
          await _client.storage
              .from(_bucket)
              .uploadBinary(
                imagePath,
                image,
                fileOptions: const FileOptions(contentType: 'image/jpeg'),
              );
        }
        final fields = {
          'title': ad.title.trim(),
          'body': _blankToNull(ad.body),
          'cta': _blankToNull(ad.cta),
          'image_path': imagePath,
          'event_id': ad.eventId,
          'link_url': ad.eventId == null ? _blankToNull(ad.linkUrl) : null,
          'placements': enumsToDb(ad.placements),
          'starts_at': ad.startsAt.toUtc().toIso8601String(),
          'ends_at': ad.endsAt?.toUtc().toIso8601String(),
          'active': ad.active,
        };
        if (isNew) {
          await _client.from('ads').insert({
            ...fields,
            'created_by': _client.auth.currentUser?.id,
          });
        } else {
          await _client.from('ads').update(fields).eq('id', ad.id);
        }
        final old = ad.imagePath;
        if (image != null && old != null) {
          await _client.storage.from(_bucket).remove([old]);
        }
      });

  Future<void> delete(AdminAd ad) => guardFailures(() async {
    await _client.from('ads').delete().eq('id', ad.id);
    if (ad.imagePath case final path?) {
      await _client.storage.from(_bucket).remove([path]);
    }
  });

  static String? _blankToNull(String? value) =>
      (value ?? '').trim().isEmpty ? null : value!.trim();
}

@riverpod
AdsRepository adsRepository(Ref ref) =>
    AdsRepository(ref.watch(supabaseClientProvider));
