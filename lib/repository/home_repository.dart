import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
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
    final userId = Utils.getCurrentUid();

    return FirebaseFirestore.instance
        .collection('userData')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw Exception('User document not found');
          }

          final data = doc.data()!;

          // Safe date parsing
         
          // }

          // Determine role data with better error handling
          dynamic roleData;
          try {
            // Usage:

            if (_isValidRoleData(data['fighterData'])) {
              roleData = FighterDataModel.fromMap(
                Map<String, dynamic>.from(data['fighterData']),
              );
            } else if (_isValidRoleData(data['promoterData'])) {
              roleData = PromoterDataModel.fromMap(
                Map<String, dynamic>.from(data['promoterData']),
              );
            } else {
              roleData = null;
            }
          } catch (e) {
            print('Error parsing role data: $e');
            roleData = null;
          }

          return UserModel(
            id: doc.id,
            email: data['email'] ?? '',
            createdAt: DateTime.now(),
            roleData: roleData,
          );
        })
        .handleError((error) {
          print('Error in user stream: $error');
          // Return a default user model instead of throwing
          return UserModel(
            id: userId,
            email: '',
            createdAt: DateTime.now(),
            roleData: null,
          );
        });
  }

  // Alternative: Fetch user data once (faster for initial load)
  static Future<UserModel> fetchCurrentUserOnce() async {
    final userId = Utils.getCurrentUid();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw Exception('User document not found');
      }

      final data = doc.data()!;

      // Safe date parsing

      // Usage:
      dynamic? roleData;
      if (_isValidRoleData(data['fighterData'])) {
        roleData = FighterDataModel.fromMap(
          Map<String, dynamic>.from(data['fighterData']),
        );
      } else if (_isValidRoleData(data['promoterData'])) {
        roleData = PromoterDataModel.fromMap(
          Map<String, dynamic>.from(data['promoterData']),
        );
      } else {
        roleData = null;
      }

      return UserModel(
        id: doc.id,
        email: data['email'] ?? '',
        createdAt: DateTime.now(),
        roleData: roleData,
      );
    } catch (e) {
      print('Error fetching user data: $e');
      // Return a default user model
      return UserModel(
        id: userId,
        email: '',
        createdAt: DateTime.now(),
        roleData: null,
      );
    }
  }
}

bool _isValidRoleData(Map<String, dynamic>? map) {
  if (map == null) return false;
  // true if at least one field is not null
  return map.values.any((v) => v != null);
}
