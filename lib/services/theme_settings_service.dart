import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeSettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'appConfig';
  final String _documentId = 'themeSettings';

  DocumentReference get _doc =>
      _firestore.collection(_collectionName).doc(_documentId);

  Future<Map<String, dynamic>> _fromDoc(DocumentSnapshot doc) {
    if (!doc.exists) return Future.value(_getDefaultThemeSettings());
    final data = doc.data()! as Map<String, dynamic>;
    return Future.value({
      'fontSize': data['fontSize'] ?? 14.0,
      'headingFontSize': data['headingFontSize'] ?? 24.0,
      'textColor': data['textColor'] ?? 0xFFFFFFFF,
      'headingTextColor': data['headingTextColor'] ?? 0xFFFFFFFF,
      'boldText': data['boldText'] ?? false,
      'headingBold': data['headingBold'] ?? true,
      'textAlign': data['textAlign'] ?? 'left',
      'headingAlign': data['headingAlign'] ?? 'left',
      'primaryColor': data['primaryColor'] ?? 0xFFED1C24,
      'backgroundColor': data['backgroundColor'] ?? 0xFF060606,
    });
  }

  /// Get theme settings: cache-first for fast startup.
  Future<Map<String, dynamic>> getThemeSettings() async {
    try {
      final doc = await FirebaseCacheHelper.getDocCacheFirst(_doc);
      return _fromDoc(doc);
    } catch (e) {
      FirebaseCacheHelper.debugLog('Error fetching theme settings: $e');
      return _getDefaultThemeSettings();
    }
  }

  // Stream theme settings for real-time updates
  Stream<Map<String, dynamic>> streamThemeSettings() {
    return _firestore
        .collection(_collectionName)
        .doc(_documentId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return _getDefaultThemeSettings();
      }

      final data = snapshot.data()!;
      return {
        'fontSize': data['fontSize'] ?? 14.0,
        'headingFontSize': data['headingFontSize'] ?? 24.0,
        'textColor': data['textColor'] ?? 0xFFFFFFFF,
        'headingTextColor': data['headingTextColor'] ?? 0xFFFFFFFF,
        'boldText': data['boldText'] ?? false,
        'headingBold': data['headingBold'] ?? true,
        'textAlign': data['textAlign'] ?? 'left',
        'headingAlign': data['headingAlign'] ?? 'left',
        'primaryColor': data['primaryColor'] ?? 0xFFED1C24,
        'backgroundColor': data['backgroundColor'] ?? 0xFF060606,
      };
    });
  }

  // Get default theme settings
  Map<String, dynamic> _getDefaultThemeSettings() {
    return {
      'fontSize': 14.0,
      'headingFontSize': 24.0,
      'textColor': 0xFFFFFFFF,
      'headingTextColor': 0xFFFFFFFF,
      'boldText': false,
      'headingBold': true,
      'textAlign': 'left',
      'headingAlign': 'left',
      'primaryColor': 0xFFED1C24,
      'backgroundColor': 0xFF060606,
    };
  }
}
