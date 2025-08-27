class ReviewModel {
  final String id;
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerId; // UID of the person giving the review
  final String reviewedUserId; // UID of the person being reviewed (fighter)
  final int rating; // 1-5 stars
  final String comment;
  final DateTime createdAt;
  final String reviewerRole; // 'Promoter' or 'Fighter'

  ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.reviewerEmail,
    required this.reviewerId,
    required this.reviewedUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewerRole,
  });

  // Create ReviewModel from Firebase document
  factory ReviewModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return ReviewModel(
      id: id ?? data['id'] ?? '',
      reviewerName: data['reviewerName'] ?? '',
      reviewerEmail: data['reviewerEmail'] ?? '',
      reviewerId: data['reviewerId'] ?? '',
      reviewedUserId: data['reviewedUserId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      reviewerRole: data['reviewerRole'] ?? '',
    );
  }

  // Convert ReviewModel to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
      'reviewerId': reviewerId,
      'reviewedUserId': reviewedUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'reviewerRole': reviewerRole,
    };
  }

  // Create from Firestore Timestamp
  factory ReviewModel.fromFirestore(Map<String, dynamic> data, {String? id}) {
    return ReviewModel(
      id: id ?? data['id'] ?? '',
      reviewerName: data['reviewerName'] ?? '',
      reviewerEmail: data['reviewerEmail'] ?? '',
      reviewerId: data['reviewerId'] ?? '',
      reviewedUserId: data['reviewedUserId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      reviewerRole: data['reviewerRole'] ?? '',
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
      'reviewerId': reviewerId,
      'reviewedUserId': reviewedUserId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'reviewerRole': reviewerRole,
    };
  }
}
