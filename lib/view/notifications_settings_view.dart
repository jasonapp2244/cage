import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/viewmodel/notification_settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NotificationsSettingsView extends StatefulWidget {
  const NotificationsSettingsView({super.key});

  @override
  State<NotificationsSettingsView> createState() =>
      _NotificationsSettingsViewState();
}

class _NotificationsSettingsViewState extends State<NotificationsSettingsView> {
  @override
  void initState() {
    super.initState();
    // Initialize notification settings when widget loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationSettingsViewmodel>(
        context,
        listen: false,
      );
      provider.initializeSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Consumer<NotificationSettingsViewmodel>(
      builder: (context, notificationProvider, child) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: SafeArea(
            child: Column(
              children: [
                // Status bar

                // Navigation header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/arrow-left-01.svg",
                        ),
                      ),
                      Text(
                        "Notification",
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
                  child: notificationProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: AppColor.red),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Error message
                              if (notificationProvider.errorMessage != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          notificationProvider.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontFamily: AppFonts.appFont,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            notificationProvider.clearError(),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Push Notifications
                              _buildNotificationRow(
                                title: "Push Notifications",
                                value: notificationProvider.pushNotifications,
                                onChanged: notificationProvider
                                    .updatePushNotifications,
                              ),
                              const SizedBox(height: 12),

                              // Booking
                              _buildNotificationRow(
                                title: "Booking",
                                value: notificationProvider.booking,
                                onChanged: notificationProvider.updateBooking,
                              ),
                              const SizedBox(height: 12),

                              // Session Reminder
                              _buildNotificationRow(
                                title: "Session Reminder",
                                value: notificationProvider.sessionReminder,
                                onChanged:
                                    notificationProvider.updateSessionReminder,
                              ),
                              const SizedBox(height: 12),

                              // Email Alerts
                              _buildNotificationRow(
                                title: "Enable/Disable Email Alerts",
                                value: notificationProvider.emailAlerts,
                                onChanged:
                                    notificationProvider.updateEmailAlerts,
                              ),
                              const SizedBox(height: 12),

                              // Password Change Alert
                              _buildNotificationRow(
                                title: "Password Change Alert",
                                value: notificationProvider.passwordChangeAlert,
                                onChanged: notificationProvider
                                    .updatePasswordChangeAlert,
                              ),
                              const SizedBox(height: 12),

                              // Cancellation
                              _buildNotificationRow(
                                title: "Cancelation",
                                value: notificationProvider.cancellation,
                                onChanged:
                                    notificationProvider.updateCancellation,
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
      },
    );
  }

  Widget _buildNotificationRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.white.withValues(alpha: 0.1)),

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
            thumbColor: MaterialStateProperty.all(Colors.white),

            activeTrackColor: Color(0xffED1C24),
            inactiveThumbColor: AppColor.white.withValues(alpha: 0.6),
            inactiveTrackColor: AppColor.white.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
