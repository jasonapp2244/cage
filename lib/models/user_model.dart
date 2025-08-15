import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';

class UserModel {
  final String id;
  final String email;
  final DateTime createdAt;
  var roleData; // Contains either fighter or promoter data

  UserModel({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.roleData,
  });

  // Simple constructor from raw Map data (no Firestore dependency)
  factory UserModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return UserModel(
      id: id ?? data['id'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['createdAt'] is DateTime
          ? data['createdAt']
          : DateTime.parse(data['createdAt'] ?? '1970-01-01'),
      roleData: data['fighterData'] ?? data['promoterData'] ?? {},
    );
  }

  bool get isFighter => roleData is FighterDataModel;
  bool get isPromoter => roleData is PromoterDataModel;
  // Convert back to Map if needed
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      if (isFighter) 'fighterData': roleData,
      if (isPromoter) 'promoterData': roleData,
    };
  }
}
