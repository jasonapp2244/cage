import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String? promoterId; // For notifications sent to promoters
  final String? fighterId; // For notifications sent to fighters
  final String type; // 'event_interest', 'request_accepted', 'request_rejected', etc.
  final String title;
  final String body;
  final String? fighterName;
  final String? promoterName;
  final String? eventTitle;
  final String? eventId;
  final String? interestId;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.promoterId,
    this.fighterId,
    required this.type,
    required this.title,
    required this.body,
    this.fighterName,
    this.promoterName,
    this.eventTitle,
    this.eventId,
    this.interestId,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    Timestamp? createdAtTimestamp = map['createdAt'] as Timestamp?;
    DateTime createdAt = createdAtTimestamp?.toDate() ?? DateTime.now();

    return NotificationModel(
      id: id,
      promoterId: map['promoterId'],
      fighterId: map['fighterId'],
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      fighterName: map['fighterName'],
      promoterName: map['promoterName'],
      eventTitle: map['eventTitle'],
      eventId: map['eventId'],
      interestId: map['interestId'],
      read: map['read'] ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'promoterId': promoterId,
      'fighterId': fighterId,
      'type': type,
      'title': title,
      'body': body,
      'fighterName': fighterName,
      'promoterName': promoterName,
      'eventTitle': eventTitle,
      'eventId': eventId,
      'interestId': interestId,
      'read': read,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? promoterId,
    String? fighterId,
    String? type,
    String? title,
    String? body,
    String? fighterName,
    String? promoterName,
    String? eventTitle,
    String? eventId,
    String? interestId,
    bool? read,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      promoterId: promoterId ?? this.promoterId,
      fighterId: fighterId ?? this.fighterId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      fighterName: fighterName ?? this.fighterName,
      promoterName: promoterName ?? this.promoterName,
      eventTitle: eventTitle ?? this.eventTitle,
      eventId: eventId ?? this.eventId,
      interestId: interestId ?? this.interestId,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
