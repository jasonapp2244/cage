class EventModel {
  final String id;
  final String promoterId;
  final String promoterName;
  final String? promoterProfileImage;
  final String eventTitle;
  final String? thumbnailImageUrl;
  final String? referenceImageUrl;
  final String description;
  final DateTime eventDate;
  final String eventTime;
  final String location;
  final String eventType; // e.g., "Professional | Lightweight"
  final String weightClass; // e.g., "Lightweight 155 lbs"
  final String requiredRecord; // e.g., "Min. 2 wins"
  final String ageLimit; // e.g., "18-35"
  final String fightingStylePreferred; // e.g., "MMA / BJJ / Muay Thai"
  final DateTime deadlineToApply;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? locationCoordinates; // For map

  EventModel({
    required this.id,
    required this.promoterId,
    required this.promoterName,
    this.promoterProfileImage,
    required this.eventTitle,
    this.thumbnailImageUrl,
    this.referenceImageUrl,
    required this.description,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.eventType,
    required this.weightClass,
    required this.requiredRecord,
    required this.ageLimit,
    required this.fightingStylePreferred,
    required this.deadlineToApply,
    required this.createdAt,
    this.updatedAt,
    this.locationCoordinates,
  });

  // Check if event is past
  bool get isPast => eventDate.isBefore(DateTime.now());

  // Check if event is active (not past and deadline not passed)
  bool get isActive => !isPast && deadlineToApply.isAfter(DateTime.now());

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      promoterId: json['promoterId'] ?? '',
      promoterName: json['promoterName'] ?? '',
      promoterProfileImage: json['promoterProfileImage'],
      eventTitle: json['eventTitle'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'],
      referenceImageUrl: json['referenceImageUrl'],
      description: json['description'] ?? '',
      eventDate: json['eventDate'] != null
          ? (json['eventDate'] is DateTime
                ? json['eventDate'] as DateTime
                : DateTime.parse(json['eventDate']))
          : DateTime.now(),
      eventTime: json['eventTime'] ?? '',
      location: json['location'] ?? '',
      eventType: json['eventType'] ?? '',
      weightClass: json['weightClass'] ?? '',
      requiredRecord: json['requiredRecord'] ?? '',
      ageLimit: json['ageLimit'] ?? '',
      fightingStylePreferred: json['fightingStylePreferred'] ?? '',
      deadlineToApply: json['deadlineToApply'] != null
          ? (json['deadlineToApply'] is DateTime
                ? json['deadlineToApply'] as DateTime
                : DateTime.parse(json['deadlineToApply']))
          : DateTime.now(),
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
      locationCoordinates: json['locationCoordinates'] != null
          ? Map<String, dynamic>.from(json['locationCoordinates'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promoterId': promoterId,
      'promoterName': promoterName,
      'promoterProfileImage': promoterProfileImage,
      'eventTitle': eventTitle,
      'thumbnailImageUrl': thumbnailImageUrl,
      'referenceImageUrl': referenceImageUrl,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'location': location,
      'eventType': eventType,
      'weightClass': weightClass,
      'requiredRecord': requiredRecord,
      'ageLimit': ageLimit,
      'fightingStylePreferred': fightingStylePreferred,
      'deadlineToApply': deadlineToApply.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'locationCoordinates': locationCoordinates,
    };
  }

  EventModel copyWith({
    String? id,
    String? promoterId,
    String? promoterName,
    String? promoterProfileImage,
    String? eventTitle,
    String? thumbnailImageUrl,
    String? referenceImageUrl,
    String? description,
    DateTime? eventDate,
    String? eventTime,
    String? location,
    String? eventType,
    String? weightClass,
    String? requiredRecord,
    String? ageLimit,
    String? fightingStylePreferred,
    DateTime? deadlineToApply,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? locationCoordinates,
  }) {
    return EventModel(
      id: id ?? this.id,
      promoterId: promoterId ?? this.promoterId,
      promoterName: promoterName ?? this.promoterName,
      promoterProfileImage: promoterProfileImage ?? this.promoterProfileImage,
      eventTitle: eventTitle ?? this.eventTitle,
      thumbnailImageUrl: thumbnailImageUrl ?? this.thumbnailImageUrl,
      referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      eventType: eventType ?? this.eventType,
      weightClass: weightClass ?? this.weightClass,
      requiredRecord: requiredRecord ?? this.requiredRecord,
      ageLimit: ageLimit ?? this.ageLimit,
      fightingStylePreferred:
          fightingStylePreferred ?? this.fightingStylePreferred,
      deadlineToApply: deadlineToApply ?? this.deadlineToApply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      locationCoordinates: locationCoordinates ?? this.locationCoordinates,
    );
  }
}
