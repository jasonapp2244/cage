class UserSubscriptionModel {
  final String id;
  final String userId; // Fighter ID
  final String planId; // Subscription plan ID
  final String planTitle;
  final double amount;
  final String paymentMethod; // "stripe", "apple_pay", "google_pay"
  final String status; // "pending", "active", "expired", "cancelled"
  final DateTime startDate;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? transactionId;
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;

  UserSubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planTitle,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.startDate,
    required this.expiryDate,
    required this.createdAt,
    this.updatedAt,
    this.transactionId,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
  });

  factory UserSubscriptionModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      if (dateValue.toString().contains('Timestamp')) {
        return dateValue.toDate();
      }
      try {
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    return UserSubscriptionModel(
      id: id,
      userId: map['userId'] ?? map['fighterId'] ?? '',
      planId: map['planId'] ?? '',
      planTitle: map['planTitle'] ?? '',
      amount: (map['amount'] is num) ? map['amount'].toDouble() : double.tryParse(map['amount']?.toString() ?? '0') ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? 'stripe',
      status: map['status'] ?? 'pending',
      startDate: parseDate(map['startDate']),
      expiryDate: parseDate(map['expiryDate']),
      createdAt: parseDate(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? parseDate(map['updatedAt']) : null,
      transactionId: map['transactionId'],
      stripeCustomerId: map['stripeCustomerId'],
      stripeSubscriptionId: map['stripeSubscriptionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'planId': planId,
      'planTitle': planTitle,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'transactionId': transactionId,
      'stripeCustomerId': stripeCustomerId,
      'stripeSubscriptionId': stripeSubscriptionId,
    };
  }

  bool get isActive => status == 'active' && expiryDate.isAfter(DateTime.now());
}
