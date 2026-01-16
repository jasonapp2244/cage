import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String currency; // USD, EUR, etc.
  final String duration; // "monthly", "yearly", "weekly", etc.
  final int durationInDays; // Number of days the subscription lasts
  final List<String> features; // List of features/benefits
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? stripePriceId; // Stripe price ID if using Stripe
  final int? sortOrder; // For ordering plans in UI

  SubscriptionPlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    this.currency = 'USD',
    required this.duration,
    required this.durationInDays,
    required this.features,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.stripePriceId,
    this.sortOrder,
  });

  factory SubscriptionPlanModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime? _parseDateTime(dynamic dateValue) {
      if (dateValue == null) return null;
      try {
        if (dateValue is DateTime) {
          return dateValue;
        } else if (dateValue is Timestamp) {
          return dateValue.toDate();
        } else if (dateValue is String) {
          return DateTime.parse(dateValue);
        }
      } catch (e) {
        // If parsing fails, return null or current time
        return null;
      }
      return null;
    }

    return SubscriptionPlanModel(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      amount: (map['amount'] is num) 
          ? map['amount'].toDouble() 
          : double.tryParse(map['amount']?.toString() ?? '0') ?? 0.0,
      currency: map['currency']?.toString() ?? 'USD',
      duration: map['duration']?.toString() ?? 'monthly',
      durationInDays: map['durationInDays'] is int 
          ? map['durationInDays'] 
          : int.tryParse(map['durationInDays']?.toString() ?? '30') ?? 30,
      features: map['features'] != null 
          ? (map['features'] is List 
              ? List<String>.from(map['features'].map((e) => e.toString())) 
              : [])
          : [],
      isActive: map['isActive'] ?? true,
      createdAt: _parseDateTime(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDateTime(map['updatedAt']),
      stripePriceId: map['stripePriceId']?.toString(),
      sortOrder: map['sortOrder'] is int 
          ? map['sortOrder'] 
          : (map['sortOrder'] != null ? int.tryParse(map['sortOrder'].toString()) : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'currency': currency,
      'duration': duration,
      'durationInDays': durationInDays,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stripePriceId': stripePriceId,
      'sortOrder': sortOrder,
    };
  }

  SubscriptionPlanModel copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? currency,
    String? duration,
    int? durationInDays,
    List<String>? features,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? stripePriceId,
    int? sortOrder,
  }) {
    return SubscriptionPlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      durationInDays: durationInDays ?? this.durationInDays,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stripePriceId: stripePriceId ?? this.stripePriceId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
