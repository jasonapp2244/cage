import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'appConfig';
  final String _documentId = 'appColors';

  DocumentReference get _doc =>
      _firestore.collection(_collectionName).doc(_documentId);

  Future<Map<String, int>> _fromDoc(DocumentSnapshot doc) {
    if (!doc.exists) return Future.value(_getDefaultColors());
    final data = doc.data()! as Map<String, dynamic>;
    return Future.value({
      'black': data['black'] as int? ?? 0xFF060606,
      'red': data['red'] as int? ?? 0xFFED1C24,
      'white': data['white'] as int? ?? 0xFFFFFFFF,
    });
  }

  /// Get app colors: cache-first for fast startup, then server.
  Future<Map<String, int>> getAppColors() async {
    try {
      final doc = await FirebaseCacheHelper.getDocCacheFirst(_doc);
      return _fromDoc(doc);
    } catch (e) {
      FirebaseCacheHelper.debugLog('Error fetching app colors: $e');
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
