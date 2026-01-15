class EventInterestModel {
  final String id;
  final String eventId;
  final String eventTitle;
  final String fighterId;
  final String fighterName;
  final String? fighterProfileImage;
  final String promoterId;
  final String promoterName;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;

  EventInterestModel({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.fighterId,
    required this.fighterName,
    this.fighterProfileImage,
    required this.promoterId,
    required this.promoterName,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory EventInterestModel.fromJson(Map<String, dynamic> json) {
    return EventInterestModel(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      eventTitle: json['eventTitle'] ?? '',
      fighterId: json['fighterId'] ?? '',
      fighterName: json['fighterName'] ?? '',
      fighterProfileImage: json['fighterProfileImage'],
      promoterId: json['promoterId'] ?? '',
      promoterName: json['promoterName'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
                ? json['createdAt'] as DateTime
                : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is DateTime
                ? json['updatedAt'] as DateTime
                : DateTime.parse(json['updatedAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'fighterId': fighterId,
      'fighterName': fighterName,
      'fighterProfileImage': fighterProfileImage,
      'promoterId': promoterId,
      'promoterName': promoterName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  EventInterestModel copyWith({
    String? id,
    String? eventId,
    String? eventTitle,
    String? fighterId,
    String? fighterName,
    String? fighterProfileImage,
    String? promoterId,
    String? promoterName,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventInterestModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      fighterId: fighterId ?? this.fighterId,
      fighterName: fighterName ?? this.fighterName,
      fighterProfileImage: fighterProfileImage ?? this.fighterProfileImage,
      promoterId: promoterId ?? this.promoterId,
      promoterName: promoterName ?? this.promoterName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
