class TicketModel {
  final String id;
  final String subject;
  final String message;
  final String status; // 'open', 'in-progress', 'closed'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? attachmentUrl;
  final String userId;

  TicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.attachmentUrl,
    required this.userId,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 'open',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      attachmentUrl: json['attachmentUrl'],
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'attachmentUrl': attachmentUrl,
      'userId': userId,
    };
  }

  TicketModel copyWith({
    String? id,
    String? subject,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? attachmentUrl,
    String? userId,
  }) {
    return TicketModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      userId: userId ?? this.userId,
    );
  }
}
