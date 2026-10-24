import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/event_import.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'events_repository.g.dart';

const _summaryColumns =
    'id, name, venue_name, city, state, starts_at, ends_at, cover_path, '
    'genres, is_official';
const _coversBucket = 'event-covers';

enum EventListScope { nearby, mine }

class EventsRepository {
  new(this._client);

  final SupabaseClient _client;

  /// SPEC 7.3 list. See `list_events()` for the scope rules (radius,
  /// nationwide name search, "Meus eventos").
  Future<List<EventListEntry>> list({
    required EventListScope scope,
    EventFilters filters = const EventFilters(),
    DateTime? now,
    int limit = 30,
    int offset = 0,
  }) => guardFailures(() async {
    final (from, to) = dateWindow(filters.dateRange, now ?? DateTime.now());
    final rows = await _client.rpc<List<dynamic>>(
      'list_events',
      params: {
        'p_scope': scope.name,
        'p_query': filters.query.trim().isEmpty ? null : filters.query.trim(),
        'p_genres': filters.genres.isEmpty ? null : enumsToDb(filters.genres),
        'p_from': from?.toUtc().toIso8601String(),
        'p_to': to?.toUtc().toIso8601String(),
        'p_limit': limit,
        'p_offset': offset,
      },
    );
    return rows
        .map((r) => EventListEntry.fromJson(r as Map<String, dynamic>))
        .toList();
  });

  /// Upcoming approved events, soonest first (onboarding first-event step).
  Future<List<EventSummary>> upcoming({String? state, int limit = 20}) =>
      guardFailures(() async {
        final rows = await _client
            .from('events')
            .select(_summaryColumns)
            .eq('status', 'approved')
            .gt('ends_at', DateTime.now().toUtc().toIso8601String())
            .order('starts_at', ascending: true)
            .limit(limit);
        final events = rows.map(EventSummary.fromJson).toList();
        if (state == null) return events;
        return [
          ...events.where((e) => e.state == state),
          ...events.where((e) => e.state != state),
        ];
      });

  /// Upcoming approved events the user marked "Eu vou".
  Future<List<EventSummary>> attending(String userId) =>
      guardFailures(() async {
        final rows = await _client
            .from('event_attendance')
            .select('events!inner($_summaryColumns)')
            .eq('user_id', userId)
            .eq('events.status', 'approved')
            .gt('events.ends_at', DateTime.now().toUtc().toIso8601String());
        return [
          for (final row in rows)
            EventSummary.fromJson(row['events'] as Map<String, dynamic>),
        ]..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      });

  Future<EventDetail> fetch(String eventId) => guardFailures(() async {
    final row = await _client
        .from('events')
        .select()
        .eq('id', eventId)
        .single();
    return EventDetail.fromJson(row);
  });

  Future<bool> isAttending(String userId, String eventId) =>
      guardFailures(() async {
        final rows = await _client
            .from('event_attendance')
            .select('event_id')
            .eq('user_id', userId)
            .eq('event_id', eventId);
        return rows.isNotEmpty;
      });

  /// "Salvar": kept for later without "Eu vou".
  Future<bool> isSaved(String userId, String eventId) =>
      guardFailures(() async {
        final rows = await _client
            .from('event_saves')
            .select('event_id')
            .eq('user_id', userId)
            .eq('event_id', eventId);
        return rows.isNotEmpty;
      });

  Future<void> setSaved({
    required String userId,
    required String eventId,
    required bool saved,
  }) => guardFailures(() async {
    if (saved) {
      await _client.from('event_saves').upsert({
        'user_id': userId,
        'event_id': eventId,
      }, ignoreDuplicates: true);
    } else {
      await _client
          .from('event_saves')
          .delete()
          .eq('user_id', userId)
          .eq('event_id', eventId);
    }
  });

  /// "Tô ON" tonight (only matches and crew-mates see it).
  Future<bool> isOn(String userId, String eventId) => guardFailures(() async {
    final rows = await _client
        .from('event_on')
        .select('event_id')
        .eq('user_id', userId)
        .eq('event_id', eventId);
    return rows.isNotEmpty;
  });

  Future<void> setOn(String eventId, {required bool on}) => guardFailures(
    () => _client.rpc<void>('set_on', params: {'p_event': eventId, 'p_on': on}),
  );

  Future<List<OnPerson>> onPeople(String eventId) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'event_on_people',
      params: {'p_event': eventId},
    );
    return [
      for (final row in rows) OnPerson.fromJson(row as Map<String, dynamic>),
    ];
  });

  /// Cards on top of "Próximos" (`event_sections()`).
  Future<EventSections> sections() => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>('event_sections');
    return EventSections.fromJson(json);
  });

  Future<void> setAttending({
    required String userId,
    required String eventId,
    required bool attending,
  }) => guardFailures(() async {
    if (attending) {
      await _client.from('event_attendance').upsert({
        'user_id': userId,
        'event_id': eventId,
      }, ignoreDuplicates: true);
    } else {
      await _client
          .from('event_attendance')
          .delete()
          .eq('user_id', userId)
          .eq('event_id', eventId);
    }
  });

  Future<List<EventAttendee>> attendees(String eventId) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'get_event_attendees',
          params: {'p_event_id': eventId},
        );
        return rows
            .map((r) => EventAttendee.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  Future<AttendeeCounts> attendeeCounts(String eventId) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'get_event_attendee_counts',
          params: {
            'p_event_ids': [eventId],
          },
        );
        if (rows.isEmpty) return const AttendeeCounts();
        return AttendeeCounts.fromJson(rows.first as Map<String, dynamic>);
      });

  /// Creator details for moderators (null when the creator was deleted).
  Future<EventCreator?> creator(String eventId) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'get_event_creator',
      params: {'p_event_id': eventId},
    );
    if (rows.isEmpty) return null;
    return EventCreator.fromJson(rows.first as Map<String, dynamic>);
  });

  /// Anti-duplication check before creating (SPEC 7.2).
  Future<List<SimilarEvent>> findSimilar({
    required String name,
    required DateTime startsAt,
    required String city,
  }) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'find_similar_events',
      params: {
        'p_name': name,
        'p_starts_at': startsAt.toUtc().toIso8601String(),
        'p_city': city,
      },
    );
    return rows
        .map((r) => SimilarEvent.fromJson(r as Map<String, dynamic>))
        .toList();
  });

  /// Creates the event; status/official/creator are set by the database
  /// from the user's role. Returns the new event.
  Future<EventDetail> create(Map<String, Object?> fields) => guardFailures(
    () async {
      final row = await _client.from('events').insert(fields).select().single();
      return EventDetail.fromJson(row);
    },
  );

  Future<void> update(String eventId, Map<String, Object?> fields) =>
      guardFailures(
        () => _client.from('events').update(fields).eq('id', eventId),
      );

  /// The venue, or null while it is secret (RLS) or was never set.
  Future<EventVenue?> venue(String eventId) => guardFailures(() async {
    final row = await _client
        .from('event_venues')
        .select('event_id, address, lat, lng')
        .eq('event_id', eventId)
        .maybeSingle();
    return row == null ? null : EventVenue.fromJson(row);
  });

  /// Creates or replaces the venue (event editors only, RLS).
  Future<void> saveVenue(EventVenue venue) => guardFailures(
    () => _client.from('event_venues').upsert({
      'event_id': venue.eventId,
      'address': venue.address,
      'lat': venue.lat,
      'lng': venue.lng,
    }),
  );

  /// Uploads a cover to `{event}/{random}.jpg` and stores its path.
  /// "Importar de um link": the `event-preview` Edge Function reads the
  /// ticket page; fails with [EventLinkFailure].
  Future<ImportedEvent> preview(String url) => guardFailures(() async {
    final response = await _client.functions.invoke(
      'event-preview',
      body: {'url': url.trim()},
    );
    final event = parseEventPreview(
      Map<String, dynamic>.from(response.data as Map),
    );
    if (event.isEmpty) throw const EventLinkFailure(EventLinkProblem.noData);
    return event;
  });

  /// The page's image as a JPEG for the cover (null when it can't be read).
  Future<Uint8List?> downloadCover(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return null;
      return await FlutterImageCompress.compressWithList(
        response.bodyBytes,
        minWidth: 1600,
        minHeight: 900,
        quality: 85,
      );
    } on Object {
      return null;
    }
  }

  Future<void> setCover(String eventId, Uint8List jpeg) =>
      guardFailures(() async {
        final path = '$eventId/${randomId()}.jpg';
        await _client.storage
            .from(_coversBucket)
            .uploadBinary(
              path,
              jpeg,
              fileOptions: const FileOptions(contentType: 'image/jpeg'),
            );
        await _client
            .from('events')
            .update({'cover_path': path})
            .eq('id', eventId);
      });

  String coverUrl(String coverPath) =>
      _client.storage.from(_coversBucket).getPublicUrl(coverPath);

  /// Approval queue (curators/admins; RLS limits it to moderators).
  Future<List<EventDetail>> pending() => guardFailures(() async {
    final rows = await _client
        .from('events')
        .select()
        .eq('status', 'pending')
        .order('starts_at', ascending: true);
    return rows.map(EventDetail.fromJson).toList();
  });

  Future<void> setStatus(
    String eventId,
    EventStatus status, {
    String? rejectionReason,
  }) => update(eventId, {
    'status': status.name,
    if (status == EventStatus.rejected) 'rejection_reason': rejectionReason,
  });

  /// Admins only; [days] null removes the highlight.
  Future<void> feature(String eventId, {int? days}) => guardFailures(
    () => _client.rpc<void>(
      'admin_feature_event',
      params: {'p_event_id': eventId, 'p_days': days},
    ),
  );

  /// Creator and moderators only.
  Future<EventInsights> insights(String eventId) => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>(
      'get_event_insights',
      params: {'p_event_id': eventId},
    );
    return EventInsights.fromJson(json);
  });

  /// Counts a "Comprar ingresso" tap (deduplicated by the database).
  Future<void> logTicketClick(String eventId) => guardFailures(
    () =>
        _client.rpc<void>('log_ticket_click', params: {'p_event_id': eventId}),
  );

  // Paid highlights (featured_sales migration) ----------------------------

  Future<List<FeaturedPrice>> featuredPrices() => guardFailures(() async {
    final rows = await _client
        .from('featured_prices')
        .select()
        .order('days', ascending: true);
    return rows.map(FeaturedPrice.fromJson).toList();
  });

  /// The creator's open request for [eventId], if any.
  Future<FeaturedRequest?> openFeaturedRequest(String eventId) =>
      guardFailures(() async {
        final row = await _client
            .from('featured_requests')
            .select('id, event_id, days, price_cents, method, created_at')
            .eq('event_id', eventId)
            .eq('status', 'pending')
            .maybeSingle();
        return row == null ? null : FeaturedRequest.fromJson(row);
      });

  /// Creator only; the database checks the party and the region limit.
  Future<void> requestFeatured(
    String eventId, {
    required int days,
    required FeaturedMethod method,
  }) => guardFailures(
    () => _client.rpc<void>(
      'request_featured',
      params: {'p_event_id': eventId, 'p_days': days, 'p_method': method.name},
    ),
  );

  Future<List<AdminFeaturedRequest>> adminFeaturedRequests() => guardFailures(
    () async {
      final rows = await _client.rpc<List<dynamic>>('admin_featured_requests');
      return [
        for (final row in rows.cast<Map<String, dynamic>>())
          AdminFeaturedRequest.fromJson(row),
      ];
    },
  );

  /// Admin: paid (turns the highlight on) or not happening.
  Future<void> reviewFeatured(String requestId, {required bool approve}) =>
      guardFailures(
        () => _client.rpc<void>(
          'admin_review_featured',
          params: {'p_request': requestId, 'p_approve': approve},
        ),
      );
}

/// [range] as a [from, to) window in local time.
(DateTime?, DateTime?) dateWindow(EventDateRange range, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  switch (range) {
    case EventDateRange.any:
      return (null, null);
    case EventDateRange.today:
      // Parties run past midnight: "today" goes until 6 a.m. tomorrow.
      return (now, today.add(const Duration(days: 1, hours: 6)));
    case EventDateRange.weekend:
      // Until Monday 06:00 of the coming weekend. On Saturday/Sunday the
      // offset is negative, so it's the ongoing weekend's Friday.
      final fridayDay = today.day + (DateTime.friday - today.weekday);
      return (now, DateTime(today.year, today.month, fridayDay + 3, 6));
    case EventDateRange.next30Days:
      return (now, today.add(const Duration(days: 31)));
  }
}

@Riverpod(keepAlive: true)
EventsRepository eventsRepository(Ref ref) =>
    EventsRepository(ref.watch(supabaseClientProvider));
