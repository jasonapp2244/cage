import 'package:cloud_firestore/cloud_firestore.dart';

class AppColorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'appConfig';
  final String _documentId = 'appColors';

  // Get app colors from Firestore
  Future<Map<String, int>> getAppColors() async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(_documentId)
          .get();

      if (!doc.exists) {
        // Return default colors if document doesn't exist
        return _getDefaultColors();
      }

      final data = doc.data()!;
      return {
        'black': data['black'] as int? ?? 0xFF060606,
        'red': data['red'] as int? ?? 0xFFED1C24,
        'white': data['white'] as int? ?? 0xFFFFFFFF,
      };
    } catch (e) {
      print('Error fetching app colors: $e');
      return _getDefaultColors();
    }
  }

  // Stream app colors for real-time updates
  Stream<Map<String, int>> streamAppColors() {
    return _firestore
        .collection(_collectionName)
        .doc(_documentId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return _getDefaultColors();
      }

      final data = snapshot.data()!;
      return {
        'black': data['black'] as int? ?? 0xFF060606,
        'red': data['red'] as int? ?? 0xFFED1C24,
        'white': data['white'] as int? ?? 0xFFFFFFFF,
      };
    });
  }

  // Get default colors
  Map<String, int> _getDefaultColors() {
    return {
      'black': 0xFF060606,
      'red': 0xFFED1C24,
      'white': 0xFFFFFFFF,
    };
  }
}
