import 'dart:async';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class BlockStatusMonitor {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _subscription;

  // Start monitoring block status for a user
  void startMonitoring(String userId, VoidCallback onBlocked) {
    // Cancel existing subscription if any
    stopMonitoring();

    _subscription = _firestore
        .collection('userData')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data();
      if (data == null) {
        return;
      }

      final isBlocked = data['isBlocked'] ?? false;
      if (isBlocked) {
        // Check if it's a temporary block that has expired
        final blockType = data['blockType'] as String?;
        final blockUntil = data['blockUntil'];

        bool shouldBlock = true;

        if (blockType == 'temporary' && blockUntil != null) {
          DateTime? blockUntilDate;
          if (blockUntil is Timestamp) {
            blockUntilDate = blockUntil.toDate();
          } else if (blockUntil is DateTime) {
            blockUntilDate = blockUntil;
          }

          if (blockUntilDate != null) {
            if (DateTime.now().isAfter(blockUntilDate)) {
              // Temporary block has expired, unblock the user
              shouldBlock = false;
              _firestore.collection('userData').doc(userId).update({
                'isBlocked': false,
                'blockType': null,
                'blockUntil': null,
                'blockReason': null,
                'status': 'Active',
              }).catchError((e) {
                if (kDebugMode) {
                  print('Error unblocking user: $e');
                }
              });
            }
          }
        }

        if (shouldBlock) {
          if (kDebugMode) {
            print('User blocked detected, signing out...');
          }
          // Sign out the user and clear credentials
          FirebaseAuth.instance.signOut().then((_) async {
            await Utils.clearLoginCredentials();
            onBlocked();
          }).catchError((e) async {
            if (kDebugMode) {
              print('Error signing out blocked user: $e');
            }
            // Clear credentials even if signOut fails
            await Utils.clearLoginCredentials();
            // Still call the callback to handle the logout
            onBlocked();
          });
        }
      }
    }, onError: (error) {
      if (kDebugMode) {
        print('Error monitoring block status: $error');
      }
    });
  }

  // Stop monitoring
  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }

  // Dispose resources
  void dispose() {
    stopMonitoring();
  }
}
