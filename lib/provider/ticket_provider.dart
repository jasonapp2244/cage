import 'package:flutter/material.dart';
import 'package:cage/models/ticket_model.dart';
import 'package:cage/repository/ticket_repository.dart';
import 'package:cage/utils/routes/utils.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketModel> _tickets = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<TicketModel> get tickets => _tickets;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  /// Initialize the ticket stream listener
  void initializeTicketStream() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      TicketRepository.fetchUserTickets().listen(
        (tickets) {
          _tickets = tickets;
          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validate ticket form data
  String? validateTicketForm(String subject, String message) {
    if (subject.trim().isEmpty) {
      return 'Please enter a subject';
    }

    if (message.trim().isEmpty) {
      return 'Please enter a message';
    }

    return null; // No validation errors
  }

  /// Create ticket with validation and UI state management
  Future<bool> createTicketWithValidation(
    String subject,
    String message, {
    String? attachmentUrl,
  }) async {
    // Validate input
    final validationError = validateTicketForm(subject, message);
    if (validationError != null) {
      Utils.tosatMassage(validationError);
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final ticket = TicketModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subject: subject.trim(),
        message: message.trim(),
        status: 'open',
        createdAt: DateTime.now(),
        userId: Utils.getCurrentUid(),
        attachmentUrl: attachmentUrl,
      );

      await TicketRepository.createTicket(ticket);
      // No need to call fetchTickets() - the stream will automatically update

      _isSubmitting = false;
      notifyListeners();

      Utils.tosatMassage('Ticket created successfully!');
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();

      Utils.tosatMassage('Failed to create ticket: ${e.toString()}');
      return false;
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
      // No need to call fetchTickets() - the stream will automatically update
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
