import 'dart:typed_data';

import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'events_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

/// The signed-in user's role (UI only; the database enforces permissions).
@riverpod
UserRole currentRole(Ref ref) =>
    ref.watch(myProfileProvider).value?.role ?? UserRole.user;

/// Search/filters of the "Próximos" tab.
@riverpod
class EventListFilters extends _$EventListFilters {
  @override
  EventFilters build() => const EventFilters();

  // Methods (not setters) keep call sites explicit.
  // ignore: use_setters_to_change_properties
  void update(EventFilters filters) => state = filters;
}

/// Discovery radius (km). Only notifies listeners when the value changes.
@riverpod
int? discoveryRadius(Ref ref) =>
    ref.watch(myProfileProvider).value?.discoveryRadiusKm;

@riverpod
Future<List<EventListEntry>> eventList(Ref ref, EventListScope scope) {
  final filters = scope == EventListScope.nearby
      ? ref.watch(eventListFiltersProvider)
      : const EventFilters();
  // Changing the radius or the account re-runs the list.
  ref
    ..watch(discoveryRadiusProvider)
    ..watch(currentUserIdProvider);
  return ref
      .watch(eventsRepositoryProvider)
      .list(scope: scope, filters: filters);
}

@riverpod
Future<EventDetail> eventDetail(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).fetch(eventId);

@riverpod
Future<bool> isAttending(Ref ref, String eventId) => ref
    .watch(eventsRepositoryProvider)
    .isAttending(_requireUserId(ref), eventId);

@riverpod
Future<List<EventAttendee>> eventAttendees(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).attendees(eventId);

@riverpod
Future<AttendeeCounts> eventAttendeeCounts(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).attendeeCounts(eventId);

@riverpod
Future<EventCreator?> eventCreator(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).creator(eventId);

@riverpod
Future<List<EventDetail>> pendingEvents(Ref ref) =>
    ref.watch(eventsRepositoryProvider).pending();

void _refreshEvent(Ref ref, String eventId) {
  ref
    ..invalidate(eventDetailProvider(eventId))
    ..invalidate(isAttendingProvider(eventId))
    ..invalidate(eventAttendeesProvider(eventId))
    ..invalidate(eventAttendeeCountsProvider(eventId))
    ..invalidate(eventListProvider)
    ..invalidate(myAttendingEventsProvider);
}

/// "Eu vou" (free in any city, SPEC 15).
@riverpod
class AttendanceEditor extends _$AttendanceEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> setAttending(String eventId, {required bool attending}) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(eventsRepositoryProvider)
            .setAttending(
              userId: _requireUserId(ref),
              eventId: eventId,
              attending: attending,
            );
        _refreshEvent(ref, eventId);
        return true;
      });
}

/// Create/edit/moderate events (SPEC 7.2/7.3).
@riverpod
class EventEditor extends _$EventEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<List<SimilarEvent>?> findSimilar({
    required String name,
    required DateTime startsAt,
    required String city,
  }) => runAction(
    ref,
    (s) => state = s,
    () => ref
        .read(eventsRepositoryProvider)
        .findSimilar(name: name, startsAt: startsAt, city: city),
  );

  /// Creates the event (and its venue), uploads the cover and marks the
  /// creator as going. [venue] has no event id yet.
  Future<EventDetail?> create(
    Map<String, Object?> fields, {
    Uint8List? cover,
    EventVenue? venue,
  }) => runAction(ref, (s) => state = s, () async {
    final repository = ref.read(eventsRepositoryProvider);
    final event = await repository.create(fields);
    if (venue != null) {
      await repository.saveVenue(venue.copyWith(eventId: event.id));
    }
    if (cover != null) await repository.setCover(event.id, cover);
    // Attendance is only allowed on approved events; a suggestion waits
    // for the curators first.
    if (event.status == EventStatus.approved) {
      await repository.setAttending(
        userId: _requireUserId(ref),
        eventId: event.id,
        attending: true,
      );
    }
    ref
      ..invalidate(eventListProvider)
      ..invalidate(pendingEventsProvider);
    return event;
  });

  Future<bool?> save(
    String eventId,
    Map<String, Object?> fields, {
    Uint8List? cover,
    EventVenue? venue,
  }) => runAction(ref, (s) => state = s, () async {
    final repository = ref.read(eventsRepositoryProvider);
    await repository.update(eventId, fields);
    if (venue != null) await repository.saveVenue(venue);
    ref.invalidate(eventVenueProvider(eventId));
    if (cover != null) await repository.setCover(eventId, cover);
    _refreshEvent(ref, eventId);
    ref.invalidate(pendingEventsProvider);
    return true;
  });

  Future<bool?> setStatus(
    String eventId,
    EventStatus status, {
    String? rejectionReason,
  }) => runAction(ref, (s) => state = s, () async {
    await ref
        .read(eventsRepositoryProvider)
        .setStatus(eventId, status, rejectionReason: rejectionReason);
    _refreshEvent(ref, eventId);
    ref.invalidate(pendingEventsProvider);
    return true;
  });
}

/// "Próximos" shown as a list or on the map (SPEC 7.4).
enum EventsViewMode { list, map }

@Riverpod(keepAlive: true)
class EventsView extends _$EventsView {
  @override
  EventsViewMode build() => EventsViewMode.list;

  void toggle() => state = state == EventsViewMode.list
      ? EventsViewMode.map
      : EventsViewMode.list;
}

/// Same filters and radius as the list, with room for more pins.
@riverpod
Future<List<EventListEntry>> eventMap(Ref ref) {
  final filters = ref.watch(eventListFiltersProvider);
  ref
    ..watch(discoveryRadiusProvider)
    ..watch(currentUserIdProvider);
  return ref
      .watch(eventsRepositoryProvider)
      .list(scope: EventListScope.nearby, filters: filters, limit: 100);
}

/// The venue of an event; null while secret or not set.
@riverpod
Future<EventVenue?> eventVenue(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).venue(eventId);

// Producers -----------------------------------------------------------------

@riverpod
Future<EventInsights> eventInsights(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).insights(eventId);

@riverpod
class FeatureEditor extends _$FeatureEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// [days] null removes the highlight.
  Future<bool?> feature(String eventId, {int? days}) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(eventsRepositoryProvider).feature(eventId, days: days);
        ref
          ..invalidate(eventDetailProvider(eventId))
          ..invalidate(eventListProvider);
        return true;
      });
}

@riverpod
Future<List<FeaturedPrice>> featuredPrices(Ref ref) =>
    ref.watch(eventsRepositoryProvider).featuredPrices();

@riverpod
Future<FeaturedRequest?> openFeaturedRequest(Ref ref, String eventId) =>
    ref.watch(eventsRepositoryProvider).openFeaturedRequest(eventId);

@riverpod
Future<List<AdminFeaturedRequest>> adminFeaturedRequests(Ref ref) =>
    ref.watch(eventsRepositoryProvider).adminFeaturedRequests();

/// A producer asking for a highlight, and the admin settling team requests.
@riverpod
class FeaturedSales extends _$FeaturedSales {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> request(
    String eventId, {
    required int days,
    required FeaturedMethod method,
  }) => runAction(ref, (s) => state = s, () async {
    await ref
        .read(eventsRepositoryProvider)
        .requestFeatured(eventId, days: days, method: method);
    ref.invalidate(openFeaturedRequestProvider(eventId));
    return true;
  });

  Future<bool?> review(AdminFeaturedRequest request, {required bool approve}) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(eventsRepositoryProvider)
            .reviewFeatured(request.id, approve: approve);
        ref
          ..invalidate(adminFeaturedRequestsProvider)
          ..invalidate(eventDetailProvider(request.eventId))
          ..invalidate(eventListProvider);
        return true;
      });

  /// After a store purchase the webhook turns the highlight on.
  void refreshAfterPurchase(String eventId) => ref
    ..invalidate(openFeaturedRequestProvider(eventId))
    ..invalidate(eventDetailProvider(eventId))
    ..invalidate(eventListProvider);
}
