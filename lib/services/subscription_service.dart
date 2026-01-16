import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/subscription_plan_model.dart';
import 'package:cage/models/user_subscription_model.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _plansCollection = 'subscriptionPlans';
  static const String _subscriptionsCollection = 'subscriptions';
  
  // Firebase Functions URL
  static String get _functionsBaseUrl {
    return 'https://us-central1-cage-connect.cloudfunctions.net';
  }

  /// Get all active subscription plans
  Stream<List<SubscriptionPlanModel>> getActivePlans() {
    try {
      return _firestore
          .collection(_plansCollection)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final plans = <SubscriptionPlanModel>[];
        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            final plan = SubscriptionPlanModel.fromMap(data, doc.id);
            plans.add(plan);
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing subscription plan ${doc.id}: $e');
              print('Plan data: ${doc.data()}');
            }
            // Continue with other plans even if one fails
          }
        }
        // Sort by sortOrder if available
        plans.sort((a, b) {
          final aOrder = a.sortOrder ?? 999;
          final bOrder = b.sortOrder ?? 999;
          return aOrder.compareTo(bOrder);
        });
        return plans;
      }).handleError((error) {
        if (kDebugMode) {
          print('Error fetching subscription plans: $error');
        }
        return <SubscriptionPlanModel>[];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up subscription plans stream: $e');
      }
      // Return an empty stream with empty list
      return Stream.value(<SubscriptionPlanModel>[]);
    }
  }

  /// Get subscription plan by ID
  Future<SubscriptionPlanModel?> getPlanById(String planId) async {
    try {
      final doc = await _firestore.collection(_plansCollection).doc(planId).get();
      if (doc.exists) {
        return SubscriptionPlanModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching plan: $e');
      }
      return null;
    }
  }

  /// Create subscription payment
  Future<Map<String, dynamic>> createSubscriptionPayment({
    required String planId,
    required String paymentMethod,
    String? paymentToken,
  }) async {
    try {
      final userId = Utils.getCurrentUid();
      
      final response = await http.post(
        Uri.parse('$_functionsBaseUrl/createSubscriptionPayment'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'planId': planId,
          'paymentMethod': paymentMethod,
          'paymentToken': paymentToken,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Payment failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating subscription payment: $e');
      }
      rethrow;
    }
  }

  /// Get user's active subscription
  Stream<UserSubscriptionModel?> getUserActiveSubscription() {
    final userId = Utils.getCurrentUid();
    
    return _firestore
        .collection(_subscriptionsCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      
      // Get the most recent active subscription
      final doc = snapshot.docs.first;
      return UserSubscriptionModel.fromMap(doc.data(), doc.id);
    });
  }

  /// Get all user subscriptions
  Stream<List<UserSubscriptionModel>> getUserSubscriptions() {
    final userId = Utils.getCurrentUid();
    
    return _firestore
        .collection(_subscriptionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserSubscriptionModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    try {
      final userId = Utils.getCurrentUid();
      final snapshot = await _firestore
          .collection(_subscriptionsCollection)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();

      if (snapshot.docs.isEmpty) return false;

      final now = DateTime.now();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final expiryDate = (data['expiryDate'] as Timestamp).toDate();
        if (expiryDate.isAfter(now)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking active subscription: $e');
      }
      return false;
    }
  }
}
