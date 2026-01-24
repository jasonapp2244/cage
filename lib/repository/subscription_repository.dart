import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:flutter/foundation.dart';

class SubscriptionRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _subscriptionCollection = 'subscriptions';
  static const String _userCollection = 'userData';

  /// Get all fighters with active subscriptions
  /// A subscription is active if expiryDate > current date and status is 'active'
  static Stream<List<UserModel>> getSubscribedFighters() {
    final now = DateTime.now();
    
    return _firestore
        .collection(_subscriptionCollection)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .asyncMap((subscriptionSnapshot) async {
      final subscribedFighterIds = <String>{};
      
      // Filter subscriptions by expiry date
      for (var doc in subscriptionSnapshot.docs) {
        final data = doc.data();
        final expiryDate = data['expiryDate'];
        
        if (expiryDate != null) {
          DateTime expiry;
          if (expiryDate is Timestamp) {
            expiry = expiryDate.toDate();
          } else if (expiryDate is DateTime) {
            expiry = expiryDate;
          } else if (expiryDate is String) {
            try {
              expiry = DateTime.parse(expiryDate);
            } catch (e) {
              if (kDebugMode) {
                print('Error parsing expiry date: $e');
              }
              continue;
            }
          } else {
            continue;
          }
          
          // Only include if subscription hasn't expired
          if (expiry.isAfter(now)) {
            final fighterId = data['fighterId'] ?? data['userId'] ?? data['user'];
            if (fighterId != null && fighterId.toString().isNotEmpty) {
              subscribedFighterIds.add(fighterId.toString());
            }
          }
        }
      }
      
      if (subscribedFighterIds.isEmpty) {
        return <UserModel>[];
      }
      
      // Fetch fighter user data
      final fighters = <UserModel>[];
      
      for (var fighterId in subscribedFighterIds) {
        try {
          final fighterDoc = await _firestore
              .collection(_userCollection)
              .doc(fighterId)
              .get();
          
          if (!fighterDoc.exists) continue;
          
          final data = fighterDoc.data()!;
          if (data['role'] != 'Fighter') continue;
          
          // Parse fighter data
          DateTime createdAt;
          try {
            if (data['createdAt'] is Timestamp) {
              createdAt = (data['createdAt'] as Timestamp).toDate();
            } else if (data['createdAt'] is DateTime) {
              createdAt = data['createdAt'] as DateTime;
            } else {
              createdAt = DateTime.now();
            }
          } catch (e) {
            createdAt = DateTime.now();
          }
          
          FighterDataModel? fighterData;
          try {
            if (data['fighterData'] != null) {
              fighterData = FighterDataModel.fromMap(data['fighterData']);
            } else {
              // Try to create fighter data from direct fields
              final fighterMap = {
                'age': data['age'] ?? 0,
                'coachContact': data['coachContact'] ?? '',
                'coachName': data['coachName'] ?? '',
                'fightingStyle': data['fightingStyle'],
                'fightWin': data['fightWin'] ?? 0,
                'fightsKnockout': data['fightsKnockout'] ?? 0,
                'fightsLose': data['fightsLose'] ?? 0,
                'fightsStyle': data['fightsStyle'] ?? 'options',
                'fullName': data['fullName'] ?? '',
                'height': data['height'] ?? '',
                'lastBlood': data['lastBlood'] ?? 'Not set',
                'lastExam': data['lastExam'] ?? 'Not set',
                'uploadProfile': data['uploadProfile'],
                'urlProfile': data['urlProfile'] ?? 'https',
                'weight': data['weight'],
                'selectLocation': data['selectLocation'],
              };
              fighterData = FighterDataModel.fromMap(fighterMap);
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing fighter data: $e');
            }
            continue;
          }
          
          fighters.add(UserModel(
            id: fighterDoc.id,
            email: data['email'] ?? '',
            createdAt: createdAt,
            roleData: fighterData,
          ));
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching fighter $fighterId: $e');
          }
        }
      }
      
      return fighters;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error fetching subscribed fighters: $error');
      }
      return <UserModel>[];
    });
  }
  
  /// Calculate average rating for a fighter
  static double calculateAverageRating(List<dynamic>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0.0;
    
    double totalRating = 0;
    int count = 0;
    
    for (var review in reviews) {
      if (review is Map) {
        final rating = review['rating'];
        if (rating != null) {
          totalRating += (rating is int ? rating.toDouble() : (rating as num).toDouble());
          count++;
        }
      }
    }
    
    if (count == 0) return 0.0;
    return totalRating / count;
  }
}
