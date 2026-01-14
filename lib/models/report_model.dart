class ReportModel {
  final String id;
  final String reportedUserId; // ID of the user being reported
  final String reportedUserName; // Name of the user being reported
  final String reportedUserRole; // Role of the user being reported (Fighter/Promoter)
  final String reporterUserId; // ID of the user making the report
  final String reporterUserName; // Name of the user making the report
  final String reporterUserRole; // Role of the user making the report
  final String reason; // Reason for the report
  final String? description; // Optional description/details
  final DateTime createdAt;
  final String status; // 'pending', 'reviewed', 'resolved', 'dismissed'

  ReportModel({
    required this.id,
    required this.reportedUserId,
    required this.reportedUserName,
    required this.reportedUserRole,
    required this.reporterUserId,
    required this.reporterUserName,
    required this.reporterUserRole,
    required this.reason,
    this.description,
    required this.createdAt,
    this.status = 'pending',
  });

  factory ReportModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime createdAt;
    if (json['createdAt'] is DateTime) {
      createdAt = json['createdAt'] as DateTime;
    } else if (json['createdAt'] != null) {
      try {
        createdAt = DateTime.parse(json['createdAt'].toString());
      } catch (e) {
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }

    return ReportModel(
      id: id,
      reportedUserId: json['reportedUserId'] ?? '',
      reportedUserName: json['reportedUserName'] ?? '',
      reportedUserRole: json['reportedUserRole'] ?? '',
      reporterUserId: json['reporterUserId'] ?? '',
      reporterUserName: json['reporterUserName'] ?? '',
      reporterUserRole: json['reporterUserRole'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'],
      createdAt: createdAt,
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportedUserId': reportedUserId,
      'reportedUserName': reportedUserName,
      'reportedUserRole': reportedUserRole,
      'reporterUserId': reporterUserId,
      'reporterUserName': reporterUserName,
      'reporterUserRole': reporterUserRole,
      'reason': reason,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
