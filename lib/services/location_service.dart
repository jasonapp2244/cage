import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';

class LocationService {
  // Use same key as map (iOS Info.plist GMSApiKey / Android manifest).
  // In Google Cloud: enable Geocoding API + Places API for this key and allow unrestricted or add iOS/Android apps.
  static const String _apiKey = 'AIzaSyDKFS3kaSGFiqTXQJC5n0YJFgidYHSMBhA';

  /// Get current location using GPS
  static Future<LatLng?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Search places using Google Places API
  static Future<List<LocationPrediction>> searchPlaces(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=${Uri.encodeComponent(query)}'
        '&key=$_apiKey'
        '&types=geocode',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final predictions = data['predictions'] as List;
        return predictions
            .map((prediction) => LocationPrediction.fromMap(prediction))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  /// Get place details by place ID
  static Future<LocationData?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId'
        '&key=$_apiKey'
        '&fields=geometry,formatted_address',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['result'];
        final location = result['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        final address = result['formatted_address'] ?? 'Selected Location';

        return LocationData(
          latitude: lat.toDouble(),
          longitude: lng.toDouble(),
          address: address,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  /// Get address from coordinates using reverse geocoding
  static Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      print('🔍 Starting reverse geocoding for: $latitude, $longitude');

      // Prefer platform geocoder (no Google web-service API key required).
      try {
        final placemarks = await geocoding.placemarkFromCoordinates(
          latitude,
          longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[
            if ((p.name ?? '').trim().isNotEmpty) p.name!.trim(),
            if ((p.locality ?? '').trim().isNotEmpty) p.locality!.trim(),
            if ((p.administrativeArea ?? '').trim().isNotEmpty)
              p.administrativeArea!.trim(),
            if ((p.postalCode ?? '').trim().isNotEmpty) p.postalCode!.trim(),
            if ((p.country ?? '').trim().isNotEmpty) p.country!.trim(),
          ];

          final address = parts.join(', ');
          if (address.isNotEmpty) {
            print('✅ Platform geocoder address: $address');
            return address;
          }
        }
      } catch (e) {
        // If platform geocoding fails (some devices/ROMs), fall back to Google API.
        print('⚠️ Platform geocoder failed, falling back to Google API: $e');
      }

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$latitude,$longitude'
        '&key=$_apiKey',
      );

      print('🌐 Making request to: $url');
      final response = await http
          .get(url)
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              print('⏰ Geocoding request timed out');
              throw Exception('Request timed out');
            },
          );
      print('📡 Response status: ${response.statusCode}');

      final data = json.decode(response.body);
      print('📝 Response data: $data');

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final address = result['formatted_address'];
        if (address != null && address.isNotEmpty) {
          print('✅ Successfully got address: $address');
          return address;
        }
      } else {
        print('❌ Geocoding failed. Status: ${data['status']}');
        if (data['error_message'] != null) {
          print('❌ Error message: ${data['error_message']}');
        }
      }

      // Return coordinates as fallback instead of "Selected Location"
      final fallbackAddress =
          'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      print('🔄 Using coordinate fallback: $fallbackAddress');
      return fallbackAddress;
    } catch (e) {
      print('💥 Error getting address from coordinates: $e');
      // Return coordinates as fallback instead of "Selected Location"
      final fallbackAddress =
          'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      print('🔄 Using coordinate fallback due to error: $fallbackAddress');
      return fallbackAddress;
    }
  }

  /// Get a human-friendly "City, State" label from coordinates.
  /// Falls back to a broader address (or coordinates) if needed.
  static Future<String> getCityStateFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Prefer platform geocoder (no Google web-service API key required).
      try {
        final placemarks = await geocoding.placemarkFromCoordinates(
          latitude,
          longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;

          final city = (p.locality ?? '').trim().isNotEmpty
              ? p.locality!.trim()
              : (p.subAdministrativeArea ?? '').trim();
          final state = (p.administrativeArea ?? '').trim();

          final parts = <String>[
            if (city.trim().isNotEmpty) city.trim(),
            if (state.isNotEmpty) state,
          ];

          if (parts.isNotEmpty) {
            return parts.join(', ');
          }
        }
      } catch (e) {
        // Fall back to Google Geocoding API
      }

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=$latitude,$longitude'
        '&key=$_apiKey',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' &&
          data['results'] != null &&
          (data['results'] as List).isNotEmpty) {
        final first = (data['results'] as List).first as Map<String, dynamic>;
        final components = (first['address_components'] as List?) ?? const [];

        String? getComponent(String type) {
          for (final c in components) {
            if (c is Map<String, dynamic>) {
              final types = (c['types'] as List?) ?? const [];
              if (types.contains(type)) {
                final name = (c['long_name'] ?? c['short_name'])?.toString();
                if (name != null && name.trim().isNotEmpty) return name.trim();
              }
            }
          }
          return null;
        }

        final city =
            getComponent('locality') ??
            getComponent('postal_town') ??
            getComponent('administrative_area_level_2');
        final state = getComponent('administrative_area_level_1');

        final parts = <String>[
          if (city != null && city.isNotEmpty) city,
          if (state != null && state.isNotEmpty) state,
        ];
        if (parts.isNotEmpty) return parts.join(', ');

        final formatted = first['formatted_address']?.toString();
        if (formatted != null && formatted.trim().isNotEmpty) {
          return formatted.trim();
        }
      }

      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      return 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  /// Create location data from coordinates
  static LocationData createLocationData({
    required double latitude,
    required double longitude,
    String? address,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      address:
          address ??
          'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
