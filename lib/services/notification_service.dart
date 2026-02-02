import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Initialize notifications
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;
    } catch (e) {
      // Notifications not supported on this platform (e.g., web)
      if (kDebugMode) {
        print('Local notifications not available: $e');
      }
      _initialized = false;
    }
  }

  // Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
  }

  // Send event interest notification to promoter
  static Future<void> sendEventInterestNotification({
    required String promoterId,
    required String fighterName,
    required String eventTitle,
    required String eventId,
    required String interestId,
  }) async {
    try {
      // Try to initialize if not already done
      if (!_initialized) {
        await initialize();
      }
      
      // If still not initialized (e.g., web platform), skip local notification
      if (!_initialized) {
        // Still save to Firestore for the promoter
        await FirebaseFirestore.instance
            .collection('notifications')
            .add({
          'promoterId': promoterId,
          'type': 'event_interest',
          'title': 'New Event Interest',
          'body': '$fighterName is interested in "$eventTitle"',
          'fighterName': fighterName,
          'eventTitle': eventTitle,
          'eventId': eventId,
          'interestId': interestId,
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      // Get promoter's FCM token or device info for local notification
      // For now, we'll send a local notification
      // In production, you might want to use FCM for push notifications

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'event_interests',
        'Event Interests',
        channelDescription: 'Notifications for event interest requests',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await _notifications.show(
        notificationId,
        'New Event Interest',
        '$fighterName is interested in "$eventTitle"',
        details,
        payload: 'event_interest:$promoterId',
      );

      // Also save notification to Firestore for the promoter
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'promoterId': promoterId,
        'type': 'event_interest',
        'title': 'New Event Interest',
        'body': '$fighterName is interested in "$eventTitle"',
        'fighterName': fighterName,
        'eventTitle': eventTitle,
        'eventId': eventId,
        'interestId': interestId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Notification sent to promoter: $promoterId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }

  // Cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  // Send notification to fighter when they send a request
  static Future<void> sendRequestSentNotification({
    required String fighterId,
    required String eventTitle,
    required String promoterName,
    required String eventId,
    required String interestId,
  }) async {
    try {
      const title = 'Request Sent';
      final body = 'Your request for "$eventTitle" has been sent to $promoterName';

      // Try to initialize if not already done
      if (!_initialized) {
        await initialize();
      }

      // If still not initialized (e.g., web platform), skip local notification
      if (!_initialized) {
        // Still save to Firestore for the fighter
        await FirebaseFirestore.instance
            .collection('notifications')
            .add({
          'fighterId': fighterId,
          'type': 'request_sent',
          'title': title,
          'body': body,
          'promoterName': promoterName,
          'eventTitle': eventTitle,
          'eventId': eventId,
          'interestId': interestId,
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'request_sent',
        'Request Sent',
        channelDescription: 'Notifications when you send event requests',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await _notifications.show(
        notificationId,
        title,
        body,
        details,
        payload: 'request_sent:$fighterId',
      );

      // Also save notification to Firestore for the fighter
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'fighterId': fighterId,
        'type': 'request_sent',
        'title': title,
        'body': body,
        'promoterName': promoterName,
        'eventTitle': eventTitle,
        'eventId': eventId,
        'interestId': interestId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Request sent notification sent to fighter: $fighterId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending request sent notification: $e');
      }
    }
  }

  // Send notification to fighter when their request is accepted or rejected
  static Future<void> sendRequestStatusNotification({
    required String fighterId,
    required String promoterName,
    required String eventTitle,
    required String status, // 'accepted' or 'rejected'
    required String eventId,
    required String interestId,
  }) async {
    try {
      final title = status == 'accepted'
          ? 'Request Accepted'
          : 'Request Rejected';
      final body = status == 'accepted'
          ? 'Your request for "$eventTitle" has been accepted by $promoterName'
          : 'Your request for "$eventTitle" has been rejected by $promoterName';

      // Try to initialize if not already done
      if (!_initialized) {
        await initialize();
      }

      // If still not initialized (e.g., web platform), skip local notification
      if (!_initialized) {
        // Still save to Firestore for the fighter
        await FirebaseFirestore.instance
            .collection('notifications')
            .add({
          'fighterId': fighterId,
          'type': status == 'accepted' ? 'request_accepted' : 'request_rejected',
          'title': title,
          'body': body,
          'promoterName': promoterName,
          'eventTitle': eventTitle,
          'eventId': eventId,
          'interestId': interestId,
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'request_status',
        'Request Status',
        channelDescription: 'Notifications for event request status updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
      await _notifications.show(
        notificationId,
        title,
        body,
        details,
        payload: 'request_status:$fighterId',
      );

      // Also save notification to Firestore for the fighter
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'fighterId': fighterId,
        'type': status == 'accepted' ? 'request_accepted' : 'request_rejected',
        'title': title,
        'body': body,
        'promoterName': promoterName,
        'eventTitle': eventTitle,
        'eventId': eventId,
        'interestId': interestId,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('Request status notification sent to fighter: $fighterId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending request status notification: $e');
      }
    }
  }
}
