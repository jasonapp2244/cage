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
      if (reviewerId == null) {
        throw Exception('User not authenticated');
      }

      // Create a new review document in the reviews collection
      final reviewDoc = _firestore.collection('reviews').doc();

      final review = ReviewModel(
        id: reviewDoc.id,
        reviewerName: reviewerName,
        reviewerEmail: reviewerEmail,
        reviewerId: reviewerId,
        reviewedUserId: fighterUserId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
        reviewerRole: reviewerRole,
      );

      // Save the review to the reviews collection
      await reviewDoc.set(review.toMap());

      print('Review added successfully to reviews collection');
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Failed to add review: $e');
    }
  }

  // Get all reviews for a specific fighter
  static Stream<List<ReviewModel>> getFighterReviews(String fighterUserId) {
    return _firestore
        .collection('reviews')
        .where('reviewedUserId', isEqualTo: fighterUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ReviewModel.fromMap(doc.data(), id: doc.id);
          }).toList();
        });
  }

  // Get the latest review for a fighter
  static Future<ReviewModel?> getLatestReview(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('reviewedUserId', isEqualTo: fighterUserId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final doc = snapshot.docs.first;
      return ReviewModel.fromMap(doc.data(), id: doc.id);
    } catch (e) {
      print('Error fetching latest review: $e');
      return null;
    }
  }

  // Get reviews count for a fighter
  static Future<int> getReviewsCount(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('reviewedUserId', isEqualTo: fighterUserId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting reviews count: $e');
      return 0;
    }
  }

  // Get average rating for a fighter
  static Future<double> getAverageRating(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('reviewedUserId', isEqualTo: fighterUserId)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      double totalRating = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalRating += (data['rating'] ?? 0).toDouble();
      }

      return totalRating / snapshot.docs.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  // Delete a review (only by the reviewer)
  static Future<void> deleteReview({required String reviewId}) async {
    try {
      final reviewerId = Utils.getCurrentUid();
      if (reviewerId == null) {
        throw Exception('User not authenticated');
      }

      // Check if the current user is the reviewer
      final reviewDoc = await _firestore
          .collection('reviews')
          .doc(reviewId)
          .get();
      if (!reviewDoc.exists) {
        throw Exception('Review not found');
      }

      final reviewData = reviewDoc.data();
      if (reviewData?['reviewerId'] != reviewerId) {
        throw Exception('You can only delete your own reviews');
      }

      await _firestore.collection('reviews').doc(reviewId).delete();
      print('Review deleted successfully');
    } catch (e) {
      print('Error deleting review: $e');
      throw Exception('Failed to delete review: $e');
    }
  }

  // Get reviews by a specific reviewer
  static Stream<List<ReviewModel>> getReviewsByReviewer(String reviewerId) {
    return _firestore
        .collection('reviews')
        .where('reviewerId', isEqualTo: reviewerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ReviewModel.fromMap(doc.data(), id: doc.id);
          }).toList();
        });
  }
}
