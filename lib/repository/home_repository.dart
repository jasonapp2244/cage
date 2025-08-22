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
          DateTime createdAt;
          try {
            if (data['createdAt'] is Timestamp) {
              createdAt = (data['createdAt'] as Timestamp).toDate();
            } else if (data['createdAt'] is DateTime) {
              createdAt = data['createdAt'] as DateTime;
            } else {
              createdAt = DateTime.now(); // Fallback
            }
          } catch (e) {
            createdAt = DateTime.now(); // Fallback
          }

          // Determine role data with better error handling
          dynamic roleData;
          try {
            if (data['fighterData'] != null) {
              roleData = FighterDataModel.fromMap(data['fighterData']);
            } else if (data['promoterData'] != null) {
              roleData = PromoterDataModel.fromMap(data['promoterData']);
            } else {
              roleData = null; // No role data yet
            }
          } catch (e) {
            print('Error parsing role data: $e');
            roleData = null;
          }

          return UserModel(
            id: doc.id,
            email: data['email'] ?? '',
            createdAt: createdAt,
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
      DateTime createdAt;
      try {
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is DateTime) {
          createdAt = data['createdAt'] as DateTime;
        } else {
          createdAt = DateTime.now();
        }
      } catch (e) {
        createdAt = DateTime.now();
      }

      // Determine role data
      dynamic roleData;
      try {
        if (data['fighterData'] != null) {
          roleData = FighterDataModel.fromMap(data['fighterData']);
        } else if (data['promoterData'] != null) {
          roleData = PromoterDataModel.fromMap(data['promoterData']);
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
        createdAt: createdAt,
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
