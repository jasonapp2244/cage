import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileMediaModel {
  final String id;
  final String url;
  final String type; // 'photo' or 'video'
  final DateTime createdAt;
  final String userId;

  ProfileMediaModel({
    required this.id,
    required this.url,
    required this.type,
    required this.createdAt,
    required this.userId,
  });

  factory ProfileMediaModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime createdAt;

    if (map['createdAt'] == null) {
      createdAt = DateTime.now();
    } else if (map['createdAt'] is Timestamp) {
      // Firestore Timestamp
      createdAt = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is DateTime) {
      // Already a DateTime
      createdAt = map['createdAt'] as DateTime;
    } else if (map['createdAt'] is String) {
      // String format
      createdAt = DateTime.parse(map['createdAt'] as String);
    } else {
      // Fallback to current time
      createdAt = DateTime.now();
    }

    return ProfileMediaModel(
      id: id,
      url: map['url'] ?? '',
      type: map['type'] ?? 'photo',
      createdAt: createdAt,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }
}
