import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/event_model.dart';
import 'package:flutter/foundation.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'events';

  // Create event
  Future<String> createEvent(EventModel event) async {
    try {
      final eventMap = event.toJson();
      eventMap['createdAt'] = FieldValue.serverTimestamp();
      eventMap['updatedAt'] = FieldValue.serverTimestamp();

      // Convert dates to Timestamps for Firestore
      eventMap['eventDate'] = Timestamp.fromDate(event.eventDate);
      eventMap['deadlineToApply'] = Timestamp.fromDate(event.deadlineToApply);

      final docRef = await _firestore.collection(_collectionName).add(eventMap);

      if (kDebugMode) {
        print('Event created with ID: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating event: $e');
      }
      throw Exception('Failed to create event: $e');
    }
  }

  // Get all active events (for fighters to see)
  // Note: Removed orderBy temporarily to avoid Firestore composite index requirement
  // Events will be sorted client-side instead
  Stream<List<EventModel>> getActiveEvents() {
    return _firestore
        .collection(_collectionName)
        .where('eventDate', isGreaterThan: Timestamp.now())
        .snapshots()
        .map((snapshot) {
          final events = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return _mapDocumentToEvent(data);
          }).toList();
          
          // Sort by eventDate ascending (soonest first) on client side
          events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
          
          return events;
        })
        .handleError((error) {
          if (kDebugMode) {
            print('Error fetching active events: $error');
          }
          return <EventModel>[];
        });
  }

  // Get all events (for admin)
  Future<List<EventModel>> getAllEvents() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('eventDate', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return _mapDocumentToEvent(data);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all events: $e');
      }
      throw Exception('Failed to fetch events: $e');
    }
  }

  // Get events by promoter ID
  // Note: Removed orderBy temporarily to avoid Firestore composite index requirement
  // Events will be sorted client-side instead
  Stream<List<EventModel>> getEventsByPromoter(String promoterId) {
    return _firestore
        .collection(_collectionName)
        .where('promoterId', isEqualTo: promoterId)
        .snapshots()
        .map((snapshot) {
          final events = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return _mapDocumentToEvent(data);
          }).toList();
          
          // Sort by eventDate descending (most recent first) on client side
          events.sort((a, b) => b.eventDate.compareTo(a.eventDate));
          
          return events;
        })
        .handleError((error) {
          if (kDebugMode) {
            print('Error fetching events by promoter: $error');
            print('Promoter ID: $promoterId');
          }
          return <EventModel>[];
        });
  }

  // Get active events by promoter (not past)
  // Note: Removed orderBy temporarily to avoid Firestore composite index requirement
  // Events will be sorted client-side instead
  Stream<List<EventModel>> getActiveEventsByPromoter(String promoterId) {
    return _firestore
        .collection(_collectionName)
        .where('promoterId', isEqualTo: promoterId)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          final events = snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return _mapDocumentToEvent(data);
              })
              .where((event) => event.eventDate.isAfter(now))
              .toList();
          
          // Sort by eventDate ascending (soonest first) on client side
          events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
          
          return events;
        })
        .handleError((error) {
          if (kDebugMode) {
            print('Error fetching active events by promoter: $error');
            print('Promoter ID: $promoterId');
          }
          return <EventModel>[];
        });
  }

  // Get past events by promoter (history)
  // Note: Removed orderBy temporarily to avoid Firestore composite index requirement
  // Events will be sorted client-side instead
  Stream<List<EventModel>> getPastEventsByPromoter(String promoterId) {
    return _firestore
        .collection(_collectionName)
        .where('promoterId', isEqualTo: promoterId)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now();
          final events = snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return _mapDocumentToEvent(data);
              })
              .where((event) => event.eventDate.isBefore(now))
              .toList();
          
          // Sort by eventDate descending (most recent first) on client side
          events.sort((a, b) => b.eventDate.compareTo(a.eventDate));
          
          return events;
        })
        .handleError((error) {
          if (kDebugMode) {
            print('Error fetching past events by promoter: $error');
            print('Promoter ID: $promoterId');
          }
          return <EventModel>[];
        });
  }

  // Get event by ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return _mapDocumentToEvent(data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching event by ID: $e');
      }
      return null;
    }
  }

  // Update event
  Future<void> updateEvent(String eventId, EventModel event) async {
    try {
      final eventMap = event.toJson();
      eventMap['updatedAt'] = FieldValue.serverTimestamp();
      eventMap['eventDate'] = Timestamp.fromDate(event.eventDate);
      eventMap['deadlineToApply'] = Timestamp.fromDate(event.deadlineToApply);

      // Remove id from update
      eventMap.remove('id');

      await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .update(eventMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating event: $e');
      }
      throw Exception('Failed to update event: $e');
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting event: $e');
      }
      throw Exception('Failed to delete event: $e');
    }
  }

  // Map Firestore document to EventModel
  EventModel _mapDocumentToEvent(Map<String, dynamic> data) {
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

    return EventModel(
      id: data['id'] ?? '',
      promoterId: data['promoterId'] ?? '',
      promoterName: data['promoterName'] ?? '',
      promoterProfileImage: data['promoterProfileImage'],
      eventTitle: data['eventTitle'] ?? '',
      thumbnailImageUrl: data['thumbnailImageUrl'],
      referenceImageUrl: data['referenceImageUrl'],
      description: data['description'] ?? '',
      eventDate: parseDate(data['eventDate']),
      eventTime: data['eventTime'] ?? '',
      location: data['location'] ?? '',
      eventType: data['eventType'] ?? '',
      weightClass: data['weightClass'] ?? '',
      requiredRecord: data['requiredRecord'] ?? '',
      ageLimit: data['ageLimit'] ?? '',
      fightingStylePreferred: data['fightingStylePreferred'] ?? '',
      deadlineToApply: parseDate(data['deadlineToApply']),
      createdAt: parseDate(data['createdAt']),
      updatedAt: data['updatedAt'] != null
          ? parseDate(data['updatedAt'])
          : null,
      locationCoordinates: data['locationCoordinates'] != null
          ? Map<String, dynamic>.from(data['locationCoordinates'])
          : null,
    );
  }
}
