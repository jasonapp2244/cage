import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsView extends StatefulWidget {
  const NotificationsSettingsView({super.key});

  @override
  State<NotificationsSettingsView> createState() =>
      _NotificationsSettingsViewState();
}

class _NotificationsSettingsViewState extends State<NotificationsSettingsView> {
  bool pushNotifications = false;
  bool booking = false;
  bool sessionReminder = false;
  bool emailAlerts = true;
  bool passwordChangeAlert = true;
  bool cancellation = true;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.white.withValues(alpha: 0.6),
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                  Text(
                    "9:41",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_4_bar,
                        color: AppColor.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.battery_full, color: AppColor.white, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Navigation header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Notification settings
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Push Notifications
                    _buildNotificationRow(
                      title: "Push Notifications",
                      value: pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          pushNotifications = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Booking
                    _buildNotificationRow(
                      title: "Booking",
                      value: booking,
                      onChanged: (value) {
                        setState(() {
                          booking = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Session Reminder
                    _buildNotificationRow(
                      title: "Session Reminder",
                      value: sessionReminder,
                      onChanged: (value) {
                        setState(() {
                          sessionReminder = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email Alerts
                    _buildNotificationRow(
                      title: "Enable/Disable Email Alerts",
                      value: emailAlerts,
                      onChanged: (value) {
                        setState(() {
                          emailAlerts = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password Change Alert
                    _buildNotificationRow(
                      title: "Password Change Alert",
                      value: passwordChangeAlert,
                      onChanged: (value) {
                        setState(() {
                          passwordChangeAlert = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Cancellation
                    _buildNotificationRow(
                      title: "Cancelation",
                      value: cancellation,
                      onChanged: (value) {
                        setState(() {
                          cancellation = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Home indicator
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.white,
              fontFamily: AppFonts.appFont,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.red,
            activeTrackColor: AppColor.red.withValues(alpha: 0.3),
            inactiveThumbColor: AppColor.white.withValues(alpha: 0.6),
            inactiveTrackColor: AppColor.white.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
