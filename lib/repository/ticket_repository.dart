import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/utils/routes/utils.dart';

class TicketRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new ticket
  static Future<void> createTicket(TicketModel ticket) async {
    try {
      final userId = Utils.getCurrentUid();
      final ticketData = ticket.toJson();
      ticketData['userId'] = userId;

      await _firestore
          .collection('userData')
          .doc(userId)
          .collection('tickets')
          .doc(ticket.id)
          .set(ticketData);
    } catch (e) {
      throw Exception('Failed to create ticket: $e');
    }
  }

  // Fetch all tickets for current user
  static Stream<List<TicketModel>> fetchUserTickets() {
    try {
      final userId = Utils.getCurrentUid();

      return _firestore
          .collection('userData')
          .doc(userId)
          .collection('tickets')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return TicketModel.fromJson(data);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to fetch tickets: $e');
    }
  }

  // Update ticket status
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
