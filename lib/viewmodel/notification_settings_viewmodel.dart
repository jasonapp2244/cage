import 'package:cage/models/notification_settings_model.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationSettingsViewmodel extends ChangeNotifier {
  NotificationSettingsModel _settings = NotificationSettingsModel();
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  NotificationSettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Individual setting getters
  bool get pushNotifications => _settings.pushNotifications;
  bool get booking => _settings.booking;
  bool get sessionReminder => _settings.sessionReminder;
  bool get emailAlerts => _settings.emailAlerts;
  bool get passwordChangeAlert => _settings.passwordChangeAlert;
  bool get cancellation => _settings.cancellation;

  /// Initialize and fetch notification settings for current user
  Future<void> initializeSettings() async {
    await fetchNotificationSettings();
  }

  /// Fetch notification settings from Firebase
  Future<void> fetchNotificationSettings() async {
    try {
      _setLoading(true);
      _setError(null);

      final uid = Utils.getCurrentUid();
      if (uid == null) {
        _setError('User not authenticated');
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('notificationSettings')) {
          _settings = NotificationSettingsModel.fromMap(
            Map<String, dynamic>.from(data['notificationSettings']),
          );
        } else {
          // Create default settings if they don't exist
          _settings = NotificationSettingsModel();
          await _saveSettingsToFirebase();
        }
      } else {
        // Create default settings for new user
        _settings = NotificationSettingsModel();
        await _saveSettingsToFirebase();
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error fetching notification settings: $e');
      _setLoading(false);
    }
  }

  /// Update individual notification setting
  Future<void> updateNotificationSetting({
    required String settingName,
    required bool value,
  }) async {
    try {
      _setError(null);

      // Update local state immediately for UI responsiveness
      switch (settingName) {
        case 'pushNotifications':
          _settings = _settings.copyWith(pushNotifications: value);
          break;
        case 'booking':
          _settings = _settings.copyWith(booking: value);
          break;
        case 'sessionReminder':
          _settings = _settings.copyWith(sessionReminder: value);
          break;
        case 'emailAlerts':
          _settings = _settings.copyWith(emailAlerts: value);
          break;
        case 'passwordChangeAlert':
          _settings = _settings.copyWith(passwordChangeAlert: value);
          break;
        case 'cancellation':
          _settings = _settings.copyWith(cancellation: value);
          break;
        default:
          _setError('Unknown setting: $settingName');
          return;
      }

      notifyListeners();

      // Save to Firebase
      await _saveSettingsToFirebase();
    } catch (e) {
      _setError('Error updating $settingName: $e');
      // Revert changes on error by refetching
      await fetchNotificationSettings();
    }
  }

  /// Update push notifications setting
  Future<void> updatePushNotifications(bool value) async {
    await updateNotificationSetting(
      settingName: 'pushNotifications',
      value: value,
    );
  }

  /// Update booking setting
  Future<void> updateBooking(bool value) async {
    await updateNotificationSetting(settingName: 'booking', value: value);
  }

  /// Update session reminder setting
  Future<void> updateSessionReminder(bool value) async {
    await updateNotificationSetting(
      settingName: 'sessionReminder',
      value: value,
    );
  }

  /// Update email alerts setting
  Future<void> updateEmailAlerts(bool value) async {
    await updateNotificationSetting(settingName: 'emailAlerts', value: value);
  }

  /// Update password change alert setting
  Future<void> updatePasswordChangeAlert(bool value) async {
    await updateNotificationSetting(
      settingName: 'passwordChangeAlert',
      value: value,
    );
  }

  /// Update cancellation setting
  Future<void> updateCancellation(bool value) async {
    await updateNotificationSetting(settingName: 'cancellation', value: value);
  }

  /// Save settings to Firebase
  Future<void> _saveSettingsToFirebase() async {
    try {
      final uid = Utils.getCurrentUid();
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      await FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'notificationSettings': _settings.toMap(),
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _setError(null);
  }

  /// Reset settings to default
  Future<void> resetToDefaults() async {
    try {
      _setLoading(true);
      _setError(null);

      _settings = NotificationSettingsModel();
      await _saveSettingsToFirebase();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Error resetting settings: $e');
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
