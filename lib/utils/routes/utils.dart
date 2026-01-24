import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Utils {
  static void tosatMassage(String massage) {
    // Note: Fluttertoast has issues serializing Color objects through platform channels
    // Using default colors to avoid serialization errors
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: massage,
    );
  }

  static void fieldFoucsChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFoucs,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFoucs);
  }

  static void flushBarErrorMassage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(15),
        //backgroudColors
        message: message,
        borderRadius: BorderRadius.circular(20),
        backgroundColor: AppColor.red,
        title: "Error",
        titleColor: AppColor.white,
        messageColor: AppColor.white,
        positionOffset: 20,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(Icons.error, size: 28, color: Colors.white),
        duration: Duration(seconds: 3),
      )..show(context),
    );
  }

  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static Future<void> saveSavedRole(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> getSavedRole(String key) async {
    return await storage.read(key: key);
  }

  // ✅ Remove a single key
  static Future<void> removeSavedRole(String key) async {
    await storage.delete(key: key);
  }

  // ✅ Clear everything (all keys/values)
  static Future<void> clearAll() async {
    await storage.deleteAll();
  }

  // Save login credentials
  static Future<void> saveLoginCredentials(
    String email,
    String password,
  ) async {
    await storage.write(key: 'saved_email', value: email);
    await storage.write(key: 'saved_password', value: password);
    await storage.write(key: 'is_logged_in', value: 'true');
  }

  // Get saved login credentials
  static Future<Map<String, String?>> getLoginCredentials() async {
    final email = await storage.read(key: 'saved_email');
    final password = await storage.read(key: 'saved_password');
    final isLoggedIn = await storage.read(key: 'is_logged_in');
    return {'email': email, 'password': password, 'isLoggedIn': isLoggedIn};
  }

  // Clear login credentials
  static Future<void> clearLoginCredentials() async {
    await storage.delete(key: 'saved_email');
    await storage.delete(key: 'saved_password');
    await storage.delete(key: 'is_logged_in');
  }

  static String getCurrentUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // This is the uid you pass to addUserFieldByRole
    } else {
      throw Exception('User not logged in');
    }
  }

  /// Converts date from "12 Apr 2025" format to "22/08/2025" format
  static String convertDateFormat(String dateString) {
    try {
      // Parse the input date string (e.g., "12 Apr 2025")
      final inputFormat = DateFormat('dd MMM yyyy');
      final date = inputFormat.parse(dateString);

      // Format to output format (e.g., "22/08/2025")
      final outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(date);
    } catch (e) {
      // Return original string if parsing fails
      return dateString;
    }
  }

  /// Converts date from various formats (ISO 8601, "22/08/2025", "14/1/2026", etc.) to "12 Apr 2025" format
  static String convertToReadableFormat(String dateString) {
    try {
      DateTime? date;

      // Try ISO 8601 format first (e.g., "2026-01-14T03:42:41.383322" or "2026-01-14T03:42:41Z")
      try {
        date = DateTime.parse(dateString);
      } catch (_) {
        // Try parsing as slash-separated date format manually
        // Handle formats like "14/1/2026", "22/08/2025", etc.
        if (dateString.contains('/')) {
          try {
            final parts = dateString.split('/');
            if (parts.length == 3) {
              final day = int.parse(parts[0].trim());
              final month = int.parse(parts[1].trim());
              final year = int.parse(parts[2].trim());
              date = DateTime(year, month, day);
            }
          } catch (_) {
            // Manual parsing failed, try DateFormat as fallback
          }
        }

        // If manual parsing didn't work, try DateFormat patterns as fallback
        if (date == null) {
          final formats = [
            'dd/MM/yyyy', // "22/08/2025" - double digit day and month
            'd/MM/yyyy', // "4/01/2026" - single digit day, double digit month
            'dd/M/yyyy', // "14/1/2026" - double digit day, single digit month
            'd/M/yyyy', // "4/1/2026" - single digit day and month
            'MM/dd/yyyy', // US format fallback
            'M/d/yyyy', // US format fallback
          ];

          for (final format in formats) {
            try {
              final inputFormat = DateFormat(format);
              date = inputFormat.parse(dateString);
              break;
            } catch (_) {
              // Continue to next format
            }
          }
        }
      }

      // If date is still null, parsing failed
      if (date == null) {
        return dateString;
      }

      // Format to readable format (e.g., "12 Apr 2025")
      final outputFormat = DateFormat('dd MMM yyyy');
      return outputFormat.format(date);
    } catch (e) {
      // Return original string if parsing fails
      return dateString;
    }
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snakBar(
  String massage,
  BuildContext context,
) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(massage)));
}
