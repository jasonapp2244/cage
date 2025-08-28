import 'package:flutter/material.dart';

class ChangePasswordProvider extends ChangeNotifier {
  /// Visibility states
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  /// Controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Focus nodes
  final FocusNode oldPasswordFocus = FocusNode();
  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  final FocusNode saveFocus = FocusNode();

  // =====================
  // Getters for visibility
  // =====================
  bool get obscureOldPassword => _obscureOldPassword;
  bool get obscureNewPassword => _obscureNewPassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // =====================
  // Toggle visibility
  // =====================
  void toggleOldPasswordVisibility() {
    _obscureOldPassword = !_obscureOldPassword;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // =====================
  // Validation logic
  // =====================
  String? validatePasswords() {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      return "Please enter your old password.";
    }
    if (newPassword.isEmpty) {
      return "Please enter a new password.";
    }
    if (newPassword.length < 6) {
      return "New password must be at least 6 characters.";
    }
    if (newPassword != confirmPassword) {
      return "Passwords do not match.";
    }
    return null; // valid
  }

  // =====================
  // Password update logic (dummy API placeholder)
  // =====================
  Future<void> updatePassword() async {
    final error = validatePasswords();
    if (error != null) {
      throw Exception(error);
    }

    // TODO: Implement API call here
    await Future.delayed(const Duration(seconds: 2));
  }

  // =====================
  // Dispose controllers and focus nodes properly
  // =====================
  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();
    saveFocus.dispose();
    super.dispose();
  }
}
