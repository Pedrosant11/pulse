import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared shape of form/action controllers: `state` is idle (data), loading
/// or the last error; the action returns its result, or null when it
/// failed (the error stays in `state` for the UI).
Future<T?> runAction<T>(
  Ref ref,
  void Function(AsyncValue<void> state) emit,
  Future<T> Function() action,
) async {
  emit(const AsyncLoading());
  try {
    final result = await action();
    if (ref.mounted) emit(const AsyncData(null));
    return result;
  } on Object catch (error, stackTrace) {
    if (ref.mounted) emit(AsyncError(error, stackTrace));
    return null;
  }
}
