import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_repository.g.dart';

enum LocationFailureReason { serviceDisabled, denied, deniedForever }

class LocationUnavailable implements Exception {
  const new(this.reason);

  final LocationFailureReason reason;
}

/// Bundled IBGE municipality list (MIT, see assets/data/LICENSE-br-cities.txt).
@Riverpod(keepAlive: true)
Future<CityIndex> cityIndex(Ref ref) async {
  final raw = await rootBundle.loadString('assets/data/br_cities.json');
  final rows = jsonDecode(raw) as List<dynamic>;
  return CityIndex([
    for (final row in rows) City.fromRow(row as List<dynamic>),
  ]);
}

/// Device position, read once: approximate to suggest the city, precise
/// for a party check-in. Never tracked in the background.
class LocationRepository {
  Future<({double lat, double lng})> approximatePosition() async {
    await _ensurePermission();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return (lat: position.latitude, lng: position.longitude);
  }

  /// One precise reading for the check-in, with its accuracy (meters) and
  /// whether it came from a mock location app.
  Future<({double lat, double lng, double accuracy, bool mocked})>
  precisePosition() async {
    await _ensurePermission();
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        timeLimit: Duration(seconds: 20),
      ),
    );
    return (
      lat: position.latitude,
      lng: position.longitude,
      accuracy: position.accuracy,
      mocked: position.isMocked,
    );
  }

  Future<void> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationUnavailable(LocationFailureReason.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationUnavailable(LocationFailureReason.deniedForever);
    }
    if (permission == LocationPermission.denied) {
      throw const LocationUnavailable(LocationFailureReason.denied);
    }
  }
}

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) => LocationRepository();
