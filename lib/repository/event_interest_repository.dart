import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/event_interest_model.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/repository/notification_repository.dart';
import 'package:cage/services/notification_service.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/foundation.dart';

class EventInterestRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'eventInterests';

  // Create event interest (fighter shows interest)
  // Returns the interest document ID
  static Future<String> createEventInterest(EventModel event) async {
    try {
      final fighterId = Utils.getCurrentUid();
      
      // Get fighter data
      final fighterDoc = await _firestore
          .collection('userData')
          .doc(fighterId)
          .get();

      String fighterName = 'Unknown Fighter';
      String? fighterProfileImage;

      if (fighterDoc.exists && fighterDoc.data() != null) {
        final data = fighterDoc.data()!;
        if (data['fighterData'] != null && data['fighterData'] is Map) {
          final fighterData = data['fighterData'] as Map<String, dynamic>;
          fighterName =
              fighterData['fullName'] ??
              fighterData['name'] ??
              fighterData['displayName'] ??
              'Unknown Fighter';
          fighterProfileImage = fighterData['urlProfile'] ?? fighterData['uploadProfile'];
        }
      }

      // Check if interest already exists
      final existingInterest = await _firestore
          .collection(_collectionName)
          .where('eventId', isEqualTo: event.id)
          .where('fighterId', isEqualTo: fighterId)
          .get();

      if (existingInterest.docs.isNotEmpty) {
        throw Exception('You have already shown interest in this event');
      }

      // Create interest document
      final interestData = {
        'eventId': event.id,
        'eventTitle': event.eventTitle,
        'fighterId': fighterId,
        'fighterName': fighterName,
        'fighterProfileImage': fighterProfileImage,
        'promoterId': event.promoterId,
        'promoterName': event.promoterName,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_collectionName).add(interestData);

      if (kDebugMode) {
        print('Event interest created successfully with ID: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating event interest: $e');
      }
      rethrow;
    }
  }

  // Get interests for a promoter (all requests for their events)
  static Stream<List<EventInterestModel>> getInterestsForPromoter(String promoterId) {
    return _firestore
        .collection(_collectionName)
        .where('promoterId', isEqualTo: promoterId)
        .snapshots()
        .map((snapshot) {
      final interests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return _mapDocumentToInterest(data);
      }).toList();
      
      // Sort by createdAt descending on client side
      interests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return interests;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error streaming interests for promoter $promoterId: $error');
      }
      return <EventInterestModel>[];
    });
  }

  // Get pending interests for a promoter
  static Stream<List<EventInterestModel>> getPendingInterestsForPromoter(String promoterId) {
    return _firestore
        .collection(_collectionName)
        .where('promoterId', isEqualTo: promoterId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final interests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return _mapDocumentToInterest(data);
      }).toList();
      
      // Sort by createdAt descending on client side
      interests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return interests;
    }).handleError((error) {
      if (kDebugMode) {
        print('Error streaming pending interests for promoter $promoterId: $error');
      }
      return <EventInterestModel>[];
    });
  }

  // Get interests by fighter
  static Stream<List<EventInterestModel>> getInterestsByFighter(String fighterId) {
    return _firestore
        .collection(_collectionName)
        .where('fighterId', isEqualTo: fighterId)
        .snapshots()
        .map((snapshot) {
      final interests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return _mapDocumentToInterest(data);
      }).toList();
      
      // Sort by createdAt descending on client side
      interests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return interests;
    });
  }

  // Update interest status (accept/reject)
  static Future<void> updateInterestStatus(String interestId, String status) async {
    try {
      // Get interest details before updating
      final interestDoc = await _firestore.collection(_collectionName).doc(interestId).get();
      
      if (!interestDoc.exists) {
        throw Exception('Interest not found');
      }

      final interestData = interestDoc.data()!;
      final fighterId = interestData['fighterId'] as String?;
      final eventTitle = interestData['eventTitle'] as String? ?? '';
      final eventId = interestData['eventId'] as String? ?? '';
      final promoterName = interestData['promoterName'] as String? ?? 'Promoter';

      // Update status
      await _firestore.collection(_collectionName).doc(interestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Interest status updated to: $status');
      }

      // Delete the original event interest notification for the promoter
      try {
        await NotificationRepository.deleteNotificationsByInterestId(interestId);
      } catch (e) {
        if (kDebugMode) {
          print('Error deleting event interest notification: $e');
        }
        // Don't throw - notification deletion failure shouldn't prevent status update
      }

      // Send notification to fighter if fighterId exists
      if (fighterId != null && fighterId.isNotEmpty) {
        try {
          // Send notification to fighter
          await NotificationService.sendRequestStatusNotification(
            fighterId: fighterId,
            promoterName: promoterName,
            eventTitle: eventTitle,
            status: status,
            eventId: eventId,
            interestId: interestId,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error sending notification to fighter: $e');
          }
          // Don't throw - notification failure shouldn't prevent status update
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating interest status: $e');
      }
      rethrow;
    }
  }

  // Check if fighter has already shown interest
  static Future<bool> hasFighterShownInterest(String eventId, String fighterId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('eventId', isEqualTo: eventId)
          .where('fighterId', isEqualTo: fighterId)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking interest: $e');
      }
      return false;
    }
  }

  // Get interest by ID
  static Future<EventInterestModel?> getInterestById(String interestId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(interestId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return _mapDocumentToInterest(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting interest by ID: $e');
      }
      return null;
    }
  }

  // Map Firestore document to EventInterestModel
  static EventInterestModel _mapDocumentToInterest(Map<String, dynamic> data) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is Timestamp) {
        return dateValue.toDate();
      }
      if (dateValue is DateTime) {
        return dateValue;
      }
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return EventInterestModel(
      id: data['id'] ?? '',
      eventId: data['eventId'] ?? '',
      eventTitle: data['eventTitle'] ?? '',
      fighterId: data['fighterId'] ?? '',
      fighterName: data['fighterName'] ?? '',
      fighterProfileImage: data['fighterProfileImage'],
      promoterId: data['promoterId'] ?? '',
      promoterName: data['promoterName'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: parseDate(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? parseDate(data['updatedAt']) : null,
    );
  }
}
