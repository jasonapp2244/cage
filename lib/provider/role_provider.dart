import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  String _selectedRole = "Fighter";

  String get selectedRole => _selectedRole;

  void selectRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }
}
