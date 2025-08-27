import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location_model.dart';

class LocationHelper {
  /// Retrieve saved location from Firestore
  static Future<LocationData?> getSavedLocation(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();

      final data = doc.data();
      if (data != null) {
        final role = data['role'];
        final sectionKey = role == 'Fighter' ? 'fighterData' : 'promoterData';
        final sectionData = data[sectionKey];

        if (sectionData != null && sectionData['selectLocation'] != null) {
          return LocationData.fromMap(sectionData['selectLocation']);
        }
      }
      return null;
    } catch (e) {
      print('Error retrieving saved location: $e');
      return null;
    }
  }

  /// Save location to Firestore
  static Future<bool> saveLocation(
    String uid,
    LocationData locationData,
  ) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();

      final data = doc.data();
      if (data != null) {
        final role = data['role'];
        final sectionKey = role == 'Fighter' ? 'fighterData' : 'promoterData';

        await FirebaseFirestore.instance.collection('userData').doc(uid).set({
          sectionKey: {'selectLocation': locationData.toMap()},
        }, SetOptions(merge: true));

        return true;
      }
      return false;
    } catch (e) {
      print('Error saving location: $e');
      return false;
    }
  }

  /// Widget to display saved location
  static Widget buildLocationDisplay(String uid) {
    return FutureBuilder<LocationData?>(
      future: getSavedLocation(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading location: ${snapshot.error}');
        }

        final locationData = snapshot.data;
        if (locationData == null) {
          return const Text('No location saved');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Address: ${locationData.address}'),
            Text('Latitude: ${locationData.latitude.toStringAsFixed(6)}'),
            Text('Longitude: ${locationData.longitude.toStringAsFixed(6)}'),
            Text('Saved: ${locationData.timestamp}'),
          ],
        );
      },
    );
  }

  /// Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Calculate distance between two points (in meters)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        sin(_degreesToRadians(lat1)) *
            sin(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
