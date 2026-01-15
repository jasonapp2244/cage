import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/notification_model.dart';
import 'package:cage/utils/routes/utils.dart';

class NotificationRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream notifications for current user (promoter or fighter)
  static Stream<List<NotificationModel>> getNotificationsForUser() {
    try {
      final userId = Utils.getCurrentUid();
      
      // Get notifications where user is either promoter or fighter
      return _firestore
          .collection('notifications')
          .snapshots()
          .map((snapshot) {
        final notifications = snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
            .where((notification) =>
                notification.promoterId == userId ||
                notification.fighterId == userId)
            .toList();
        
        // Sort by createdAt descending (newest first) on client side
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        return notifications;
      });
    } catch (e) {
      print('Error getting notifications stream: $e');
      return Stream.value([]);
    }
  }

  // Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  // Mark all notifications as read
  static Future<void> markAllAsRead() async {
    try {
      final userId = Utils.getCurrentUid();
      final batch = _firestore.batch();
      
      // Get all unread notifications for the current user (as promoter or fighter)
      final notifications = await _firestore
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();

      for (var doc in notifications.docs) {
        final data = doc.data();
        if (data['promoterId'] == userId || data['fighterId'] == userId) {
          batch.update(doc.reference, {'read': true});
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      rethrow;
    }
  }

  // Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  // Delete notifications by interestId (for event interest notifications)
  static Future<void> deleteNotificationsByInterestId(String interestId) async {
    try {
      final notifications = await _firestore
          .collection('notifications')
          .where('interestId', isEqualTo: interestId)
          .get();

      final batch = _firestore.batch();
      for (var doc in notifications.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print('Error deleting notifications by interestId: $e');
      // Don't rethrow - notification deletion failure shouldn't prevent status update
    }
  }

  // Get unread count
  static Stream<int> getUnreadCount() {
    try {
      final userId = Utils.getCurrentUid();
      
      return _firestore
          .collection('notifications')
          .where('read', isEqualTo: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.where((doc) {
          final data = doc.data();
          return data['promoterId'] == userId || data['fighterId'] == userId;
        }).length;
      });
    } catch (e) {
      print('Error getting unread count: $e');
      return Stream.value(0);
    }
  }
}
