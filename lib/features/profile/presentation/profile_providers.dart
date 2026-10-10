import 'dart:async';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/data/profile_repository.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

@riverpod
Future<MyProfile> myProfile(Ref ref) =>
    ref.watch(profileRepositoryProvider).fetchMine(_requireUserId(ref));

/// The user as others see them (public_profiles view).
@riverpod
Future<PublicProfile> myPublicProfile(Ref ref) =>
    ref.watch(profileRepositoryProvider).fetchPublic(_requireUserId(ref));

/// Another user as shown to others (public_profiles view).
@riverpod
Future<PublicProfile> publicProfile(Ref ref, String userId) =>
    ref.watch(profileRepositoryProvider).fetchPublic(userId);

@riverpod
Future<List<ProfilePhoto>> profilePhotos(Ref ref, String userId) =>
    ref.watch(profileRepositoryProvider).fetchPhotos(userId);

@riverpod
Future<List<ProfilePhoto>> myPhotos(Ref ref) =>
    ref.watch(profilePhotosProvider(_requireUserId(ref)).future);

/// Signed URL for a private photo. Kept for a while and refreshed before
/// it expires; images are cached by storage path, not by URL.
@riverpod
Future<String> photoUrl(Ref ref, String storagePath) async {
  const lifetime = Duration(hours: 1);
  final link = ref.keepAlive();
  final timer = Timer(lifetime - const Duration(minutes: 5), link.close);
  ref.onDispose(timer.cancel);
  return await ref
      .watch(profileRepositoryProvider)
      .signedPhotoUrl(storagePath, lifetime);
}

@riverpod
Future<List<EventSummary>> myAttendingEvents(Ref ref) =>
    ref.watch(eventsRepositoryProvider).attending(_requireUserId(ref));

@riverpod
Future<List<EventSummary>> upcomingEvents(Ref ref, {String? state}) =>
    ref.watch(eventsRepositoryProvider).upcoming(state: state);

/// Saves profile sections (onboarding steps and edit screens).
@riverpod
class ProfileEditor extends _$ProfileEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// [nextStep] advances the saved onboarding progress.
  Future<bool?> save(Map<String, Object?> fields, {OnboardingStep? nextStep}) =>
      runAction(ref, (s) => state = s, () async {
        final userId = _requireUserId(ref);
        await ref.read(profileRepositoryProvider).update(userId, {
          ...fields,
          if (nextStep != null) 'onboarding_step': nextStep.index,
        });
        ref
          ..invalidate(myProfileProvider)
          ..invalidate(myPublicProfileProvider);
        return true;
      });

  /// Finishes the onboarding; the account refresh moves the router on.
  Future<bool?> completeOnboarding() =>
      runAction(ref, (s) => state = s, () async {
        final userId = _requireUserId(ref);
        await ref.read(profileRepositoryProvider).update(userId, {
          'onboarding_completed': true,
          'onboarding_step': OnboardingStep.values.length,
        });
        ref
          ..invalidate(myProfileProvider)
          ..invalidate(accountProvider);
        return true;
      });
}

@riverpod
class PhotosEditor extends _$PhotosEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  void _refresh() {
    ref
      ..invalidate(profilePhotosProvider)
      ..invalidate(myPublicProfileProvider);
  }

  /// Returns false when the user cancelled the picker.
  Future<bool?> add({
    required PhotoSource source,
    required int position,
    required String cropTitle,
  }) {
    final picker = ref.read(photoPickerProvider);
    final repository = ref.read(profileRepositoryProvider);
    return runAction(ref, (s) => state = s, () async {
      final jpeg = await picker.pick(source, cropTitle: cropTitle);
      if (jpeg == null) return false;
      await repository.addPhoto(
        userId: _requireUserId(ref),
        jpeg: jpeg,
        position: position,
      );
      _refresh();
      return true;
    });
  }

  Future<bool?> remove(ProfilePhoto photo) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(profileRepositoryProvider).removePhoto(photo);
        _refresh();
        return true;
      });

  Future<bool?> reorder(List<ProfilePhoto> ordered) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(profileRepositoryProvider).reorderPhotos([
          for (final p in ordered) p.id,
        ]);
        _refresh();
        return true;
      });
}
