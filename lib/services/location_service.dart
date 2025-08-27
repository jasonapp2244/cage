import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';

class LocationService {
  static const String _apiKey = 'AIzaSyD6fce90tdhc2Vms4O-8JqwvF7feJrYE3I';

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

  /// Create location data from coordinates
  static LocationData createLocationData({
    required double latitude,
    required double longitude,
    String? address,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      address: address ?? 'Selected Location',
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
