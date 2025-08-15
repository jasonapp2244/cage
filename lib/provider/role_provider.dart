import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier {
  String _selectedRole = "Fighter";

  String get selectedRole => _selectedRole;

  void selectRole(String role) {
    print('RoleProvider: Changing role from "$_selectedRole" to "$role"');
    _selectedRole = role;
    notifyListeners();
    print('RoleProvider: Role changed to "$_selectedRole"');
  }
}
