class NotificationSettingsModel {
  final bool pushNotifications;
  final bool booking;
  final bool sessionReminder;
  final bool emailAlerts;
  final bool passwordChangeAlert;
  final bool cancellation;

  NotificationSettingsModel({
    this.pushNotifications = false,
    this.booking = false,
    this.sessionReminder = false,
    this.emailAlerts = true,
    this.passwordChangeAlert = true,
    this.cancellation = true,
  });

  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      pushNotifications: map['pushNotifications'] ?? false,
      booking: map['booking'] ?? false,
      sessionReminder: map['sessionReminder'] ?? false,
      emailAlerts: map['emailAlerts'] ?? true,
      passwordChangeAlert: map['passwordChangeAlert'] ?? true,
      cancellation: map['cancellation'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pushNotifications': pushNotifications,
      'booking': booking,
      'sessionReminder': sessionReminder,
      'emailAlerts': emailAlerts,
      'passwordChangeAlert': passwordChangeAlert,
      'cancellation': cancellation,
    };
  }

  NotificationSettingsModel copyWith({
    bool? pushNotifications,
    bool? booking,
    bool? sessionReminder,
    bool? emailAlerts,
    bool? passwordChangeAlert,
    bool? cancellation,
  }) {
    return NotificationSettingsModel(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      booking: booking ?? this.booking,
      sessionReminder: sessionReminder ?? this.sessionReminder,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      passwordChangeAlert: passwordChangeAlert ?? this.passwordChangeAlert,
      cancellation: cancellation ?? this.cancellation,
    );
  }

  @override
  String toString() {
    return 'NotificationSettingsModel(pushNotifications: $pushNotifications, booking: $booking, sessionReminder: $sessionReminder, emailAlerts: $emailAlerts, passwordChangeAlert: $passwordChangeAlert, cancellation: $cancellation)';
  }
}
