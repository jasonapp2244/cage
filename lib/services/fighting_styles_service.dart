import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FightingStylesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'fightingStyles';

  Query get _query => _firestore.collection(_collectionName);

  List<String> _parseStyles(QuerySnapshot snapshot) {
    final styles = <String>[];
    for (final doc in snapshot.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>;
        final name = data['name'];
        if (name is String && name.isNotEmpty) styles.add(name);
      } catch (_) {}
    }
    styles.sort();
    return styles;
  }

  /// Get fighting styles: cache-first, then server.
  Future<List<String>> getAllFightingStyles() async {
    try {
      try {
        final q = _firestore.collection(_collectionName).orderBy('name');
        final snapshot = await FirebaseCacheHelper.getQueryCacheFirst(q);
        return _parseStyles(snapshot);
      } catch (_) {
        final snapshot = await FirebaseCacheHelper.getQueryCacheFirst(_query);
        return _parseStyles(snapshot);
      }
    } catch (e) {
      FirebaseCacheHelper.debugLog('Error fetching fighting styles: $e');
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
