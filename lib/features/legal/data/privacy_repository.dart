import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'privacy_repository.g.dart';

/// LGPD rights in the app (SPEC 5.4).
class PrivacyRepository {
  new(this._client);

  final SupabaseClient _client;

  /// How long the photo links in the export stay valid.
  static const photoLinkValidity = Duration(days: 7);

  /// Everything the app holds about the user (`export_my_data()`), with
  /// temporary download links for the photos (private bucket).
  Future<Map<String, dynamic>> exportMyData() => guardFailures(() async {
    final data = Map<String, dynamic>.from(
      await _client.rpc<Map<String, dynamic>>('export_my_data'),
    );
    final photos = (data['photos'] as List).cast<Map<String, dynamic>>();
    if (photos.isNotEmpty) {
      final signed = await _client.storage
          .from('profile-photos')
          .createSignedUrlsResult([
            for (final p in photos) p['storage_path'] as String,
          ], photoLinkValidity.inSeconds);
      final urls = {
        for (final result in signed)
          if (result case SignedUrlSuccess(:final path, :final signedUrl))
            path: signedUrl,
      };
      data['photos'] = [
        for (final photo in photos)
          {...photo, 'download_url': urls[photo['storage_path']]},
      ];
    }
    return data;
  });

  /// Writes the export to a JSON file and opens the share sheet (save to
  /// Files, Drive, e-mail…).
  Future<void> shareExport(Map<String, dynamic> data) =>
      guardFailures(() async {
        final directory = await getTemporaryDirectory();
        final date = DateTime.now().toIso8601String().substring(0, 10);
        final file = File('${directory.path}/pulse-meus-dados-$date.json');
        await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(data),
        );
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'application/json')],
            subject: 'Meus dados do Pulse',
          ),
        );
      });
}

@Riverpod(keepAlive: true)
PrivacyRepository privacyRepository(Ref ref) =>
    PrivacyRepository(ref.watch(supabaseClientProvider));
