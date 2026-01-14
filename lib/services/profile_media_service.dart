import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cage/models/profile_media_model.dart';

class ProfileMediaService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload photo or video
  static Future<String?> uploadMedia({
    required File file,
    required String userId,
    required String type, // 'photo' or 'video'
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = type == 'video' ? 'mp4' : 'jpg';
      final fileName = '${userId}_$timestamp.$extension';
      
      final storageRef = _storage
          .ref()
          .child('profileMedia')
          .child(userId)
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save to Firestore
      final mediaData = {
        'url': downloadUrl,
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      };

      await _firestore
          .collection('userData')
          .doc(userId)
          .collection('profileMedia')
          .add(mediaData);

      return downloadUrl;
    } catch (e) {
      print('Error uploading media: $e');
      return null;
    }
  }

  // Get all media for a user
  static Stream<List<ProfileMediaModel>> getMediaStream(String userId) {
    return _firestore
        .collection('userData')
        .doc(userId)
        .collection('profileMedia')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProfileMediaModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get photos only
  static Stream<List<ProfileMediaModel>> getPhotosStream(String userId) {
    return _firestore
        .collection('userData')
        .doc(userId)
        .collection('profileMedia')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Filter photos client-side and sort by createdAt
      final allMedia = snapshot.docs
          .map((doc) => ProfileMediaModel.fromMap(doc.data(), doc.id))
          .where((media) => media.type == 'photo')
          .toList();
      
      // Sort by createdAt descending (most recent first)
      allMedia.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allMedia;
    });
  }

  // Get videos only
  static Stream<List<ProfileMediaModel>> getVideosStream(String userId) {
    return _firestore
        .collection('userData')
        .doc(userId)
        .collection('profileMedia')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Filter videos client-side and sort by createdAt
      final allMedia = snapshot.docs
          .map((doc) => ProfileMediaModel.fromMap(doc.data(), doc.id))
          .where((media) => media.type == 'video')
          .toList();
      
      // Sort by createdAt descending (most recent first)
      allMedia.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allMedia;
    });
  }

  // Delete media
  static Future<bool> deleteMedia({
    required String userId,
    required String mediaId,
    required String mediaUrl,
  }) async {
    try {
      // Delete from Firestore
      await _firestore
          .collection('userData')
          .doc(userId)
          .collection('profileMedia')
          .doc(mediaId)
          .delete();

      // Delete from Storage
      try {
        final ref = _storage.refFromURL(mediaUrl);
        await ref.delete();
      } catch (e) {
        print('Error deleting from storage: $e');
        // Continue even if storage deletion fails
      }

      return true;
    } catch (e) {
      print('Error deleting media: $e');
      return false;
    }
  }
}
