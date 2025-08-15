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

  // Fetch current user data as a stream with proper role typing
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

          return UserModel(
            id: doc.id,
            email: data['email'] ?? '',
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            roleData: data['fighterData'] != null
                ? FighterDataModel.fromMap(data['fighterData'])
                : (data['promoterData'] != null
                      ? PromoterDataModel.fromMap(data['promoterData'])
                      : null), // or a default PromoterDataModel()
          );
        });
  }
}
