import 'package:flutter/material.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/repository/ticket_repository.dart';
import 'package:cage/utils/routes/utils.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  bool _isLoading = false;
  String? _error;

  List<TicketModel> get tickets => _tickets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTickets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await for (final tickets in TicketRepository.fetchUserTickets()) {
        _tickets = tickets;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTicket(
    String subject,
    String message, {
    String? attachmentUrl,
  }) async {
    try {
      final ticket = TicketModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: subject,
        message: message,
        status: 'open',
        createdAt: DateTime.now(),
        userId: Utils.getCurrentUid(),
        attachmentUrl: attachmentUrl,
      );

      await TicketRepository.createTicket(ticket);
      await fetchTickets();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw Exception('Failed to create ticket: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<TicketModel> getTicketsByStatus(String status) {
    return _tickets.where((ticket) => ticket.status == status).toList();
  }
}
