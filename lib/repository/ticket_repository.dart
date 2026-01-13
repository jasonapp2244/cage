import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/utils/routes/utils.dart';

class TicketRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> createTicket(TicketModel ticket) async {
    try {
      final userId = Utils.getCurrentUid();

      // Get current user doc to get user name
      final userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      String userName = 'Unknown User';
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        // Try to get name from fighterData or promoterData
        if (data['fighterData'] != null && data['fighterData'] is Map) {
          final fighterData = data['fighterData'] as Map<String, dynamic>;
          userName =
              fighterData['name'] ??
              fighterData['fullName'] ??
              fighterData['displayName'] ??
              'Unknown User';
        } else if (data['promoterData'] != null &&
            data['promoterData'] is Map) {
          final promoterData = data['promoterData'] as Map<String, dynamic>;
          userName =
              promoterData['name'] ??
              promoterData['fullName'] ??
              promoterData['companyName'] ??
              'Unknown User';
        }
        // Fallback to direct name fields
        userName = userName == 'Unknown User'
            ? (data['name'] ??
                  data['fullName'] ??
                  data['displayName'] ??
                  'Unknown User')
            : userName;
      }

      final ticketMap = ticket.toJson();
      ticketMap['userId'] = userId;
      ticketMap['userName'] = userName;
      ticketMap['createdAt'] = FieldValue.serverTimestamp();
      ticketMap['category'] = 'General'; // Default category
      ticketMap['priority'] = 'Medium'; // Default priority

      // Save to centralized supportTickets collection (for admin access)
      final ticketRef = _firestore.collection('supportTickets').doc();
      await ticketRef.set(ticketMap);

      // Also save to user's own tickets array (for user's own view)
      List<dynamic> existingTickets = [];
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.containsKey('tickets')) {
        existingTickets = List<dynamic>.from(userDoc.data()!['tickets']);
      }

      // Update ticket ID to match the centralized collection
      ticketMap['id'] = ticketRef.id;
      existingTickets.add(ticketMap);

      // Save back to userData
      await FirebaseFirestore.instance.collection('userData').doc(userId).set({
        'tickets': existingTickets,
      }, SetOptions(merge: true));

      print("Ticket added successfully to both collections");
    } catch (e) {
      throw Exception("Failed to create ticket: $e");
    }
  }

  static Stream<List<TicketModel>> fetchUserTickets() {
    try {
      final userId = Utils.getCurrentUid();

      // Fetch from centralized supportTickets collection for real-time status updates
      return FirebaseFirestore.instance
          .collection('supportTickets')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) return [];

            return snapshot.docs.map((doc) {
              final data = doc.data();
              // Map to TicketModel format
              return TicketModel(
                id: doc.id,
                subject: data['subject'] ?? '',
                message: data['message'] ?? '',
                status: data['status'] ?? 'open',
                createdAt: data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
                updatedAt: data['updatedAt'] != null
                    ? (data['updatedAt'] as Timestamp).toDate()
                    : null,
                attachmentUrl: data['attachmentUrl'],
                userId: data['userId'] ?? userId,
              );
            }).toList();
          });
    } catch (e) {
      throw Exception("Failed to fetch tickets: $e");
    }
  }

  static Future<void> updateTicketStatus(String ticketId, String status) async {
    try {
      final userId = Utils.getCurrentUid();

      await _firestore
          .collection('userData')
          .doc(userId)
          .collection('tickets')
          .doc(ticketId)
          .update({
            'status': status,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to update ticket: $e');
    }
  }

  // Delete ticket
  static Future<void> deleteTicket(String ticketId) async {
    try {
      final userId = Utils.getCurrentUid();

      await _firestore
          .collection('userData')
          .doc(userId)
          .collection('tickets')
          .doc(ticketId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete ticket: $e');
    }
  }
}
