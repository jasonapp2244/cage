import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/utils/routes/utils.dart';

class ReviewRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new review to a fighter's profile
  static Future<void> addReview({
    required String fighterUserId,
    required int rating,
    required String comment,
    required String reviewerName,
    required String reviewerEmail,
    required String reviewerRole,
  }) async {
    try {
      final reviewerId = Utils.getCurrentUid();
      final reviewId = _firestore.collection('userData').doc().id;

      final review = ReviewModel(
        id: reviewId,
        reviewerName: reviewerName,
        reviewerEmail: reviewerEmail,
        reviewerId: reviewerId,
        reviewedUserId: fighterUserId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        reviewerRole: reviewerRole,
      );

      // Get current reviews array
      final userDoc = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      List<Map<String, dynamic>> currentReviews = [];
      if (userDoc.exists && userDoc.data()?['reviews'] != null) {
        currentReviews = List<Map<String, dynamic>>.from(userDoc.data()!['reviews']);
      }

      // Add new review to the array
      currentReviews.insert(0, review.toMap()); // Insert at beginning for latest first

      // Update the userData document with new reviews array
      await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .update({
        'reviews': currentReviews,
      });

      print('Review added successfully to reviews array');
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Failed to add review: $e');
    }
  }

  // Get all reviews for a specific fighter
  static Stream<List<ReviewModel>> getFighterReviews(String fighterUserId) {
    return _firestore
        .collection('userData')
        .doc(fighterUserId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data()?['reviews'] == null) {
        return <ReviewModel>[];
      }

      final reviewsData = List<Map<String, dynamic>>.from(snapshot.data()!['reviews']);
      return reviewsData.map((reviewData) {
        return ReviewModel.fromMap(reviewData);
      }).toList();
    });
  }

  // Get the latest review for a fighter
  static Future<ReviewModel?> getLatestReview(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!snapshot.exists || snapshot.data()?['reviews'] == null) {
        return null;
      }

      final reviewsData = List<Map<String, dynamic>>.from(snapshot.data()!['reviews']);
      if (reviewsData.isEmpty) {
        return null;
      }

      // Return the first review (most recent since we insert at beginning)
      return ReviewModel.fromMap(reviewsData.first);
    } catch (e) {
      print('Error fetching latest review: $e');
      return null;
    }
  }

  // Get reviews count for a fighter
  static Future<int> getReviewsCount(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!snapshot.exists || snapshot.data()?['reviews'] == null) {
        return 0;
      }

      final reviewsData = List<Map<String, dynamic>>.from(snapshot.data()!['reviews']);
      return reviewsData.length;
    } catch (e) {
      print('Error getting reviews count: $e');
      return 0;
    }
  }

  // Get average rating for a fighter
  static Future<double> getAverageRating(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!snapshot.exists || snapshot.data()?['reviews'] == null) {
        return 0.0;
      }

      final reviewsData = List<Map<String, dynamic>>.from(snapshot.data()!['reviews']);
      if (reviewsData.isEmpty) return 0.0;

      double totalRating = 0;
      for (var review in reviewsData) {
        totalRating += (review['rating'] ?? 0).toDouble();
      }

      return totalRating / reviewsData.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  // Delete a review (if needed)
  static Future<void> deleteReview({
    required String fighterUserId,
    required String reviewId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!snapshot.exists || snapshot.data()?['reviews'] == null) {
        return;
      }

      List<Map<String, dynamic>> reviewsData = 
          List<Map<String, dynamic>>.from(snapshot.data()!['reviews']);

      // Remove the review with matching ID
      reviewsData.removeWhere((review) => review['id'] == reviewId);

      // Update the userData document
      await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .update({
        'reviews': reviewsData,
      });

      print('Review deleted successfully');
    } catch (e) {
      print('Error deleting review: $e');
      throw Exception('Failed to delete review: $e');
    }
  }
}
