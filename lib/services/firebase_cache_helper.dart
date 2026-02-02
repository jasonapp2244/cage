import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Helper for cache-first Firebase reads. Use Firestore persistence + GetOptions
/// to load from cache immediately, then optionally refresh from server.
class FirebaseCacheHelper {
  static const _cacheOptions = GetOptions(source: Source.cache);
  static const _serverOptions = GetOptions(source: Source.server);

  /// Get document: try cache first (instant), fallback to server.
  static Future<DocumentSnapshot> getDocCacheFirst(DocumentReference ref) async {
    try {
      final cached = await ref.get(_cacheOptions);
      if (cached.exists) return cached;
    } catch (_) {
      // Cache miss or error — fetch from server
    }
    return ref.get(_serverOptions);
  }

  /// Get document from cache only. Returns null if not in cache.
  static Future<DocumentSnapshot?> getDocFromCache(DocumentReference ref) async {
    try {
      final cached = await ref.get(_cacheOptions);
      return cached.exists ? cached : null;
    } catch (_) {
      return null;
    }
  }

  /// Get query: try cache first. If cache has docs, use them; else fetch from server.
  static Future<QuerySnapshot> getQueryCacheFirst(Query query) async {
    try {
      final cached = await query.get(_cacheOptions);
      if (cached.docs.isNotEmpty) return cached;
    } catch (_) {
      // Cache miss or error
    }
    return query.get(_serverOptions);
  }

  /// Get query from cache only. Returns null if empty or error.
  static Future<QuerySnapshot?> getQueryFromCache(Query query) async {
    try {
      final cached = await query.get(_cacheOptions);
      return cached.docs.isNotEmpty ? cached : null;
    } catch (_) {
      return null;
    }
  }

  /// Get query from server only (e.g. for explicit refresh).
  static Future<QuerySnapshot> getQueryFromServer(Query query) async {
    return query.get(_serverOptions);
  }

  /// Get document from server only.
  static Future<DocumentSnapshot> getDocFromServer(DocumentReference ref) async {
    return ref.get(_serverOptions);
  }

  /// Log only in debug (avoids print in release).
  static void debugLog(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print(message);
    }
  }
}
