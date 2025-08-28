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

      // Generate a unique review ID
      final reviewId = _firestore.collection('temp').doc().id;

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

      // Get the fighter's current userData document
      final userDoc = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!userDoc.exists) {
        throw Exception('Fighter not found');
      }

      final userData = userDoc.data()!;
      final role = userData['role'];
      
      if (role != 'Fighter') {
        throw Exception('Reviews can only be added to fighters');
      }

      // Get existing reviews or create empty array
      List<dynamic> existingReviews = [];
      if (userData['fighterData'] != null && userData['fighterData']['reviews'] != null) {
        existingReviews = List<dynamic>.from(userData['fighterData']['reviews']);
      }

      // Add the new review to the array
      existingReviews.add(review.toMap());

      // Update the fighter's userData document with the new review
      await _firestore.collection('userData').doc(fighterUserId).set({
        'fighterData': {
          'reviews': existingReviews,
        },
      }, SetOptions(merge: true));

      print('Review added successfully to fighter userData');
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
          if (!snapshot.exists) return <ReviewModel>[];
          
          final userData = snapshot.data()!;
          final fighterData = userData['fighterData'];
          
          if (fighterData == null || fighterData['reviews'] == null) {
            return <ReviewModel>[];
          }
          
          final reviewsList = List<dynamic>.from(fighterData['reviews']);
          final reviews = reviewsList.map((reviewData) {
            return ReviewModel.fromMap(
              Map<String, dynamic>.from(reviewData),
              id: reviewData['id'],
            );
          }).toList();
          
          // Sort by creation date (newest first)
          reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          return reviews;
        });
  }

  // Get the latest review for a fighter
  static Future<ReviewModel?> getLatestReview(String fighterUserId) async {
    try {
      final snapshot = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!snapshot.exists) return null;
      
      final userData = snapshot.data()!;
      final fighterData = userData['fighterData'];
      
      if (fighterData == null || fighterData['reviews'] == null) {
        return null;
      }
      
      final reviewsList = List<dynamic>.from(fighterData['reviews']);
      if (reviewsList.isEmpty) return null;
      
      final reviews = reviewsList.map((reviewData) {
        return ReviewModel.fromMap(
          Map<String, dynamic>.from(reviewData),
          id: reviewData['id'],
        );
      }).toList();
      
      // Sort by creation date and return the latest
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return reviews.first;
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

      if (!snapshot.exists) return 0;
      
      final userData = snapshot.data()!;
      final fighterData = userData['fighterData'];
      
      if (fighterData == null || fighterData['reviews'] == null) {
        return 0;
      }
      
      final reviewsList = List<dynamic>.from(fighterData['reviews']);
      return reviewsList.length;
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

      if (!snapshot.exists) return 0.0;
      
      final userData = snapshot.data()!;
      final fighterData = userData['fighterData'];
      
      if (fighterData == null || fighterData['reviews'] == null) {
        return 0.0;
      }
      
      final reviewsList = List<dynamic>.from(fighterData['reviews']);
      if (reviewsList.isEmpty) return 0.0;

      double totalRating = 0;
      for (var reviewData in reviewsList) {
        totalRating += (reviewData['rating'] ?? 0).toDouble();
      }

      return totalRating / reviewsList.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  // Delete a review (only by the reviewer or the fighter whose profile it is)
  static Future<void> deleteReview({
    required String reviewId,
    required String fighterUserId,
  }) async {
    try {
      final currentUserId = Utils.getCurrentUid();
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Get the fighter's userData
      final userDoc = await _firestore
          .collection('userData')
          .doc(fighterUserId)
          .get();

      if (!userDoc.exists) {
        throw Exception('Fighter not found');
      }

      final userData = userDoc.data()!;
      final fighterData = userData['fighterData'];
      
      if (fighterData == null || fighterData['reviews'] == null) {
        throw Exception('No reviews found');
      }

      List<dynamic> reviews = List<dynamic>.from(fighterData['reviews']);
      
      // Find the review to delete
      final reviewIndex = reviews.indexWhere((review) => review['id'] == reviewId);
      
      if (reviewIndex == -1) {
        throw Exception('Review not found');
      }

      final reviewToDelete = reviews[reviewIndex];
      
      // Check if the current user can delete this review
      // (either the reviewer or the fighter whose profile it is)
      if (reviewToDelete['reviewerId'] != currentUserId && fighterUserId != currentUserId) {
        throw Exception('You can only delete your own reviews or reviews on your profile');
      }

      // Remove the review from the array
      reviews.removeAt(reviewIndex);

      // Update the fighter's userData
      await _firestore.collection('userData').doc(fighterUserId).set({
        'fighterData': {
          'reviews': reviews,
        },
      }, SetOptions(merge: true));

      print('Review deleted successfully');
    } catch (e) {
      print('Error deleting review: $e');
      throw Exception('Failed to delete review: $e');
    }
  }

  // Get reviews by a specific reviewer
  // Note: This method is less efficient since we need to scan all fighter documents
  // Consider creating a separate collection for reviewer-based queries if needed frequently
  static Future<List<ReviewModel>> getReviewsByReviewer(String reviewerId) async {
    try {
      final allReviews = <ReviewModel>[];
      
      // Query all users with role = 'Fighter'
      final fightersSnapshot = await _firestore
          .collection('userData')
          .where('role', isEqualTo: 'Fighter')
          .get();

      for (final fighterDoc in fightersSnapshot.docs) {
        final userData = fighterDoc.data();
        final fighterData = userData['fighterData'];
        
        if (fighterData != null && fighterData['reviews'] != null) {
          final reviewsList = List<dynamic>.from(fighterData['reviews']);
          
          // Filter reviews by the specific reviewer
          final reviewerReviews = reviewsList
              .where((reviewData) => reviewData['reviewerId'] == reviewerId)
              .map((reviewData) => ReviewModel.fromMap(
                    Map<String, dynamic>.from(reviewData),
                    id: reviewData['id'],
                  ))
              .toList();
          
          allReviews.addAll(reviewerReviews);
        }
      }
      
      // Sort by creation date (newest first)
      allReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return allReviews;
    } catch (e) {
      print('Error fetching reviews by reviewer: $e');
      return <ReviewModel>[];
    }
  }
}
