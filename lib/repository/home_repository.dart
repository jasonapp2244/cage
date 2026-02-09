import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/services/firebase_cache_helper.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  // Get current user's UID from Firebase Auth
  static String getCurrentUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('User not logged in');
    }
  }

  bool hasValidData(Map<String, dynamic>? map) {
    return map != null && map.isNotEmpty && map.values.any((v) => v != null);
  }

  // Fetch current user data as a stream with proper error handling
  static Stream<UserModel> fetchCurrentUserStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Return an empty stream if user is not logged in
      return Stream.value(UserModel(
        id: '',
        email: '',
        createdAt: DateTime.now(),
        roleData: null,
      ));
    }
    
    final userId = user.uid;

    return FirebaseFirestore.instance
        .collection('userData')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw Exception('User document not found');
          }

          final data = doc.data()!;
          final fd = data['fighterData'];
          final pd = data['promoterData'];

          dynamic roleData;
          try {
            if (fd is Map<String, dynamic> && _isValidRoleData(fd)) {
              roleData = FighterDataModel.fromMap(Map<String, dynamic>.from(fd));
            } else if (pd is Map<String, dynamic> && _isValidRoleData(pd)) {
              roleData = PromoterDataModel.fromMap(Map<String, dynamic>.from(pd));
            } else {
              roleData = null;
            }
          } catch (_) {
            roleData = null;
          }

          return UserModel(
            id: doc.id,
            email: data['email'] as String? ?? '',
            createdAt: DateTime.now(),
            roleData: roleData,
          );
        })
        .handleError((error) {
          FirebaseCacheHelper.debugLog('Error in user stream: $error');
          // Return a default user model instead of throwing
          return UserModel(
            id: userId,
            email: '',
            createdAt: DateTime.now(),
            roleData: null,
          );
        });
  }

  static UserModel _docToUser(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    dynamic roleData;
    try {
      final fd = data['fighterData'];
      final pd = data['promoterData'];
      if (fd is Map<String, dynamic> && _isValidRoleData(fd)) {
        roleData = FighterDataModel.fromMap(Map<String, dynamic>.from(fd));
      } else if (pd is Map<String, dynamic> && _isValidRoleData(pd)) {
        roleData = PromoterDataModel.fromMap(Map<String, dynamic>.from(pd));
      } else {
        roleData = null;
      }
    } catch (_) {
      roleData = null;
    }
    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      createdAt: DateTime.now(),
      roleData: roleData,
    );
  }

  /// Fetch current user once: cache-first for fast load.
  static Future<UserModel> fetchCurrentUserOnce() async {
    final userId = Utils.getCurrentUid();
    final ref = FirebaseFirestore.instance.collection('userData').doc(userId);
    try {
      final doc = await FirebaseCacheHelper.getDocCacheFirst(ref);
      if (!doc.exists) throw Exception('User document not found');
      return _docToUser(doc);
    } catch (e) {
      FirebaseCacheHelper.debugLog('Error fetching user data: $e');
      return UserModel(
        id: userId,
        email: '',
        createdAt: DateTime.now(),
        roleData: null,
      );
    }
  }

  /// Fetch user by ID: cache-first (e.g. reviewer avatars).
  static Future<UserModel?> fetchUserById(String userId) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('userData')
          .doc(userId);
      final doc = await FirebaseCacheHelper.getDocCacheFirst(ref);
      if (!doc.exists) return null;
      return _docToUser(doc);
    } catch (e) {
      FirebaseCacheHelper.debugLog('Error fetching user by ID: $e');
      return null;
    }
  }

  // Fetch user by ID as a stream (for real-time updates)
  static Stream<UserModel?> fetchUserByIdStream(String userId) {
    return FirebaseFirestore.instance
        .collection('userData')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;

          final data = doc.data()!;
          final fd = data['fighterData'];
          final pd = data['promoterData'];

          dynamic roleData;
          try {
            if (fd is Map<String, dynamic> && _isValidRoleData(fd)) {
              roleData = FighterDataModel.fromMap(Map<String, dynamic>.from(fd));
            } else if (pd is Map<String, dynamic> && _isValidRoleData(pd)) {
              roleData = PromoterDataModel.fromMap(Map<String, dynamic>.from(pd));
            } else {
              roleData = null;
            }
          } catch (_) {
            roleData = null;
          }

          return UserModel(
            id: doc.id,
            email: data['email'] as String? ?? '',
            createdAt: DateTime.now(),
            roleData: roleData,
          );
        });
  }
}

bool _isValidRoleData(Map<String, dynamic>? map) {
  if (map == null) return false;
  // true if at least one field is not null
  return map.values.any((v) => v != null);
}
