// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventSummary _$EventSummaryFromJson(Map<String, dynamic> json) =>
    _EventSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      venueName: json['venue_name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      coverPath: json['cover_path'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
              .toList() ??
          const [],
      isOfficial: json['is_official'] as bool? ?? false,
    );

Map<String, dynamic> _$EventSummaryToJson(_EventSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue_name': instance.venueName,
      'city': instance.city,
      'state': instance.state,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'cover_path': instance.coverPath,
      'genres': instance.genres.map((e) => _$MusicGenreEnumMap[e]!).toList(),
      'is_official': instance.isOfficial,
    };

const _$MusicGenreEnumMap = {
  MusicGenre.techno: 'techno',
  MusicGenre.house: 'house',
  MusicGenre.techHouse: 'tech_house',
  MusicGenre.melodicTechno: 'melodic_techno',
  MusicGenre.psytrance: 'psytrance',
  MusicGenre.trance: 'trance',
  MusicGenre.drumAndBass: 'drum_and_bass',
  MusicGenre.dubstep: 'dubstep',
  MusicGenre.afroHouse: 'afro_house',
  MusicGenre.minimal: 'minimal',
  MusicGenre.hardTechno: 'hard_techno',
  MusicGenre.discoNuDisco: 'disco_nu_disco',
  MusicGenre.edm: 'edm',
  MusicGenre.other: 'other',
};

_EventListEntry _$EventListEntryFromJson(Map<String, dynamic> json) =>
    _EventListEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      venueName: json['venue_name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      coverPath: json['cover_path'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
              .toList() ??
          const [],
      isOfficial: json['is_official'] as bool? ?? false,
      isMine: json['is_mine'] as bool? ?? false,
      isGoing: json['is_going'] as bool? ?? false,
      goingCount: (json['going_count'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      pinLat: (json['pin_lat'] as num?)?.toDouble(),
      pinLng: (json['pin_lng'] as num?)?.toDouble(),
      pinExact: json['pin_exact'] as bool? ?? false,
      locationRevealAt: json['location_reveal_at'] == null
          ? null
          : DateTime.parse(json['location_reveal_at'] as String),
    );

Map<String, dynamic> _$EventListEntryToJson(_EventListEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue_name': instance.venueName,
      'city': instance.city,
      'state': instance.state,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status]!,
      'cover_path': instance.coverPath,
      'genres': instance.genres.map((e) => _$MusicGenreEnumMap[e]!).toList(),
      'is_official': instance.isOfficial,
      'is_mine': instance.isMine,
      'is_going': instance.isGoing,
      'going_count': instance.goingCount,
      'distance_km': instance.distanceKm,
      'pin_lat': instance.pinLat,
      'pin_lng': instance.pinLng,
      'pin_exact': instance.pinExact,
      'location_reveal_at': instance.locationRevealAt?.toIso8601String(),
    };

const _$EventStatusEnumMap = {
  EventStatus.pending: 'pending',
  EventStatus.approved: 'approved',
  EventStatus.rejected: 'rejected',
  EventStatus.cancelled: 'cancelled',
};

_EventDetail _$EventDetailFromJson(Map<String, dynamic> json) => _EventDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  venueName: json['venue_name'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  status: $enumDecode(_$EventStatusEnumMap, json['status']),
  description: json['description'] as String?,
  coverPath: json['cover_path'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  locationRevealHours: (json['location_reveal_hours'] as num?)?.toInt(),
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
          .toList() ??
      const [],
  lineup:
      (json['lineup'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  ticketUrl: json['ticket_url'] as String?,
  ticketCoupon: json['ticket_coupon'] as String?,
  minAge: (json['min_age'] as num?)?.toInt() ?? 18,
  isOfficial: json['is_official'] as bool? ?? false,
  createdBy: json['created_by'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
);

Map<String, dynamic> _$EventDetailToJson(_EventDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue_name': instance.venueName,
      'city': instance.city,
      'state': instance.state,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status]!,
      'description': instance.description,
      'cover_path': instance.coverPath,
      'lat': instance.lat,
      'lng': instance.lng,
      'location_reveal_hours': instance.locationRevealHours,
      'genres': instance.genres.map((e) => _$MusicGenreEnumMap[e]!).toList(),
      'lineup': instance.lineup,
      'ticket_url': instance.ticketUrl,
      'ticket_coupon': instance.ticketCoupon,
      'min_age': instance.minAge,
      'is_official': instance.isOfficial,
      'created_by': instance.createdBy,
      'rejection_reason': instance.rejectionReason,
    };

_EventVenue _$EventVenueFromJson(Map<String, dynamic> json) => _EventVenue(
  eventId: json['event_id'] as String,
  address: json['address'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$EventVenueToJson(_EventVenue instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_EventAttendee _$EventAttendeeFromJson(Map<String, dynamic> json) =>
    _EventAttendee(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String?,
      photoPath: json['photo_path'] as String?,
      modes:
          (json['modes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AppModeEnumMap, e))
              .toList() ??
          const [],
      isMatch: json['is_match'] as bool? ?? false,
    );

Map<String, dynamic> _$EventAttendeeToJson(_EventAttendee instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'photo_path': instance.photoPath,
      'modes': instance.modes.map((e) => _$AppModeEnumMap[e]!).toList(),
      'is_match': instance.isMatch,
    };

const _$AppModeEnumMap = {AppMode.date: 'date', AppMode.crew: 'crew'};

_AttendeeCounts _$AttendeeCountsFromJson(Map<String, dynamic> json) =>
    _AttendeeCounts(
      total: (json['total'] as num?)?.toInt() ?? 0,
      dateCount: (json['date_count'] as num?)?.toInt() ?? 0,
      crewCount: (json['crew_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AttendeeCountsToJson(_AttendeeCounts instance) =>
    <String, dynamic>{
      'total': instance.total,
      'date_count': instance.dateCount,
      'crew_count': instance.crewCount,
    };

_SimilarEvent _$SimilarEventFromJson(Map<String, dynamic> json) =>
    _SimilarEvent(
      id: json['id'] as String,
      name: json['name'] as String,
      venueName: json['venue_name'] as String,
      city: json['city'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SimilarEventToJson(_SimilarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'venue_name': instance.venueName,
      'city': instance.city,
      'starts_at': instance.startsAt.toIso8601String(),
      'status': _$EventStatusEnumMap[instance.status]!,
    };

_EventCreator _$EventCreatorFromJson(Map<String, dynamic> json) =>
    _EventCreator(
      userId: json['user_id'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      memberSince: DateTime.parse(json['member_since'] as String),
      firstName: json['first_name'] as String?,
      photoPath: json['photo_path'] as String?,
      eventsCreated: (json['events_created'] as num?)?.toInt() ?? 0,
      eventsRejected: (json['events_rejected'] as num?)?.toInt() ?? 0,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$EventCreatorToJson(_EventCreator instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'role': _$UserRoleEnumMap[instance.role]!,
      'member_since': instance.memberSince.toIso8601String(),
      'first_name': instance.firstName,
      'photo_path': instance.photoPath,
      'events_created': instance.eventsCreated,
      'events_rejected': instance.eventsRejected,
      'email': instance.email,
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.curator: 'curator',
  UserRole.producer: 'producer',
  UserRole.admin: 'admin',
};

_HereFriend _$HereFriendFromJson(Map<String, dynamic> json) => _HereFriend(
  userId: json['user_id'] as String,
  firstName: json['first_name'] as String,
  relation: json['relation'] as String,
  photoPath: json['photo_path'] as String?,
);

Map<String, dynamic> _$HereFriendToJson(_HereFriend instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'relation': instance.relation,
      'photo_path': instance.photoPath,
    };
