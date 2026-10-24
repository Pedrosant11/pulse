// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Venue _$VenueFromJson(Map<String, dynamic> json) => _Venue(
  id: json['id'] as String,
  name: json['name'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  neighborhood: json['neighborhood'] as String?,
  address: json['address'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  photoPath: json['photo_path'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  followers: (json['followers'] as num?)?.toInt() ?? 0,
  upcoming: (json['upcoming'] as num?)?.toInt() ?? 0,
  isFollowing: json['is_following'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$VenueStatusEnumMap, json['status']) ??
      VenueStatus.approved,
);

Map<String, dynamic> _$VenueToJson(_Venue instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'city': instance.city,
  'state': instance.state,
  'neighborhood': instance.neighborhood,
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
  'photo_path': instance.photoPath,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
  'followers': instance.followers,
  'upcoming': instance.upcoming,
  'is_following': instance.isFollowing,
  'status': _$VenueStatusEnumMap[instance.status]!,
};

const _$VenueStatusEnumMap = {
  VenueStatus.pending: 'pending',
  VenueStatus.approved: 'approved',
  VenueStatus.rejected: 'rejected',
};

_VenueDetail _$VenueDetailFromJson(Map<String, dynamic> json) => _VenueDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  status: $enumDecode(_$VenueStatusEnumMap, json['status']),
  description: json['description'] as String?,
  neighborhood: json['neighborhood'] as String?,
  address: json['address'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  photoPath: json['photo_path'] as String?,
  instagram: json['instagram'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  followers: (json['followers'] as num?)?.toInt() ?? 0,
  isFollowing: json['is_following'] as bool? ?? false,
  canReview: json['can_review'] as bool? ?? false,
  myRating: (json['my_rating'] as num?)?.toInt(),
  myComment: json['my_comment'] as String?,
  pastEvents: (json['past_events'] as num?)?.toInt() ?? 0,
  canEdit: json['can_edit'] as bool? ?? false,
  upcoming:
      (json['upcoming'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map((e) => VenueReview.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$VenueDetailToJson(_VenueDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'state': instance.state,
      'status': _$VenueStatusEnumMap[instance.status]!,
      'description': instance.description,
      'neighborhood': instance.neighborhood,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'photo_path': instance.photoPath,
      'instagram': instance.instagram,
      'rejection_reason': instance.rejectionReason,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'followers': instance.followers,
      'is_following': instance.isFollowing,
      'can_review': instance.canReview,
      'my_rating': instance.myRating,
      'my_comment': instance.myComment,
      'past_events': instance.pastEvents,
      'can_edit': instance.canEdit,
      'upcoming': instance.upcoming.map((e) => e.toJson()).toList(),
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
    };

_VenueReview _$VenueReviewFromJson(Map<String, dynamic> json) => _VenueReview(
  userId: json['user_id'] as String,
  firstName: json['first_name'] as String,
  rating: (json['rating'] as num).toInt(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$VenueReviewToJson(_VenueReview instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'rating': instance.rating,
      'updated_at': instance.updatedAt.toIso8601String(),
      'comment': instance.comment,
    };
