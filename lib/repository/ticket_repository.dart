import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/utils/routes/utils.dart';

class TicketRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> createTicket(TicketModel ticket) async {
    try {
      final userId = Utils.getCurrentUid();
      if (userId == null) throw Exception("User not authenticated");

      final ticketMap = ticket.toJson();
      ticketMap['userId'] = userId;

      // Get current user doc
      final userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      // Existing tickets array (if any)
      List<dynamic> existingTickets = [];
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.containsKey('tickets')) {
        existingTickets = List<dynamic>.from(userDoc['tickets']);
      }

      // Append new ticket
      existingTickets.add(ticketMap);

      // Save back
      await FirebaseFirestore.instance.collection('userData').doc(userId).set({
        'tickets': existingTickets,
      }, SetOptions(merge: true));

      print("Ticket added successfully");
    } catch (e) {
      throw Exception("Failed to create ticket: $e");
    }
  }

  static Stream<List<TicketModel>> fetchUserTickets() {
    try {
      final userId = Utils.getCurrentUid();
      if (userId == null) throw Exception("User not authenticated");

      return FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .snapshots()
          .map((docSnap) {
            if (!docSnap.exists) return [];

            final data = docSnap.data();
            if (data == null || !data.containsKey('tickets')) return [];

            // Convert array of maps to TicketModel list
            final tickets = List<Map<String, dynamic>>.from(data['tickets']);
            return tickets.map((t) => TicketModel.fromJson(t)).toList();
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
