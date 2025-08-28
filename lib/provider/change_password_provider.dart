import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null || user.email == null) {
        throw Exception("No user logged in");
      }

      // Step 1: Re-authenticate with old password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Update to new password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception("Old password is incorrect");
      } else if (e.code == 'weak-password') {
        throw Exception("New password is too weak");
      } else {
        throw Exception("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
