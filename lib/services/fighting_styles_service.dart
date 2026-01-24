import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FightingStylesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'fightingStyles';

  // Get all fighting styles
  Future<List<String>> getAllFightingStyles() async {
    try {
      if (kDebugMode) {
        print('Fetching fighting styles from collection: $_collectionName');
      }
      
      // Try with orderBy first, if it fails (missing index), try without
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection(_collectionName)
            .orderBy('name')
            .get();
      } catch (e) {
        if (kDebugMode) {
          print('orderBy failed, trying without orderBy: $e');
        }
        // If orderBy fails (likely missing index), fetch without it
        snapshot = await _firestore
            .collection(_collectionName)
            .get();
      }

      final List<String> styles = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'];
          if (name is String && name.isNotEmpty) {
            styles.add(name);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing document ${doc.id}: $e');
          }
        }
      }

      // Sort client-side if orderBy wasn't used
      styles.sort();

      if (kDebugMode) {
        print('Successfully fetched ${styles.length} fighting styles');
      }

      return styles;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching fighting styles: $e');
      }
      // Return empty list if error occurs
      return [];
    }
  }

  // Stream fighting styles for real-time updates
  Stream<List<String>> streamFightingStyles() {
    return _firestore
        .collection(_collectionName)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .map((data) => data['name'] as String)
          .toList();
    });
  }
}
