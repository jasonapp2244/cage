import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';

class AllReviewsScreen extends StatelessWidget {
  final String fighterUserId;
  final String fighterName;

  const AllReviewsScreen({
    super.key,
    required this.fighterUserId,
    required this.fighterName,
  });

  // Calculate rating distribution with counts
  Map<int, int> _calculateRatingCounts(List<ReviewModel> reviews) {
    Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in reviews) {
      ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
    }

    return ratingCounts;
  }

  // Calculate percentage for progress bar
  double _calculatePercentage(int count, int total) {
    if (total == 0) return 0.0;
    return count / total;
  }

  double _calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalRating = 0;
    for (var review in reviews) {
      totalRating += review.rating;
    }

    return totalRating / reviews.length;
  }

  Widget _buildRatingBar(int rating, int count, int totalReviews) {
    double percentage = _calculatePercentage(count, totalReviews);

    return Row(
      children: [
        Flexible(
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(4),
            backgroundColor: AppColor.white.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.red),
            value: percentage,
            minHeight: 6,
          ),
        ),
        SizedBox(width: Responsive.w(2)),
        Container(
          width: 15,
          child: Text(
            "$rating",
            style: TextStyle(
              fontSize: Responsive.textScaleFactor * 12,
              color: AppColor.white,
              fontFamily: AppFonts.appFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.white.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.arrow_back, color: AppColor.white),
          ),
        ),
        title: Text(
          "$fighterName Reviews",
          style: TextStyle(
            color: AppColor.white,
            fontFamily: AppFonts.appFont,
            fontWeight: FontWeight.bold,
            fontSize: Responsive.sp(18),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<List<ReviewModel>>(
          stream: ReviewRepository.getFighterReviews(fighterUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppColor.red),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColor.red, size: 48),
                    SizedBox(height: 16),
                    Text(
                      "Error loading reviews",
                      style: TextStyle(color: AppColor.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final reviews = snapshot.data ?? [];

            if (reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      color: AppColor.white.withOpacity(0.5),
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No reviews yet",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Be the first to review this fighter",
                      style: TextStyle(
                        color: AppColor.white.withOpacity(0.7),
                        fontFamily: AppFonts.appFont,
                        fontSize: Responsive.sp(14),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reviews summary with progress bars
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColor.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Left side - Average rating
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _calculateAverageRating(
                                reviews,
                              ).toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 48,
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Based on ${reviews.length} Review${reviews.length != 1 ? 's' : ''}",
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 12,
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Row(
                            //   children: [
                            //     ...List.generate(5, (index) {
                            //       return Icon(
                            //         Icons.star,
                            //         color:
                            //             index <
                            //                 _calculateAverageRating(
                            //                   reviews,
                            //                 ).round()
                            //             ? AppColor.red
                            //             : AppColor.white.withOpacity(0.3),
                            //         size: 20,
                            //       );
                            //     }),
                            //   ],
                            // ),
                          ],
                        ),

                        SizedBox(width: 24),

                        // Right side - Progress bars
                        Expanded(
                          child: Column(
                            children: () {
                              final ratingCounts = _calculateRatingCounts(
                                reviews,
                              );
                              final totalReviews = reviews.length;

                              return [
                                // 5 stars (top)
                                _buildRatingBar(
                                  5,
                                  ratingCounts[5] ?? 0,
                                  totalReviews,
                                ),
                                SizedBox(height: 8),
                                // 4 stars
                                _buildRatingBar(
                                  4,
                                  ratingCounts[4] ?? 0,
                                  totalReviews,
                                ),
                                SizedBox(height: 8),
                                // 3 stars
                                _buildRatingBar(
                                  3,
                                  ratingCounts[3] ?? 0,
                                  totalReviews,
                                ),
                                SizedBox(height: 8),
                                // 2 stars
                                _buildRatingBar(
                                  2,
                                  ratingCounts[2] ?? 0,
                                  totalReviews,
                                ),
                                SizedBox(height: 8),
                                // 1 star (bottom)
                                _buildRatingBar(
                                  1,
                                  ratingCounts[1] ?? 0,
                                  totalReviews,
                                ),
                              ];
                            }(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Reviews list
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return _buildReviewCard(review);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.black,
        border: Border.all(color: AppColor.white.withOpacity(0.1), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info and rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.red,
                child: Text(
                  review.reviewerName.isNotEmpty
                      ? review.reviewerName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(14),
                      ),
                    ),
                    Text(
                      review.reviewerRole,
                      style: TextStyle(
                        color: AppColor.white.withOpacity(0.7),
                        fontFamily: AppFonts.appFont,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < review.rating
                            ? AppColor.red
                            : AppColor.white.withOpacity(0.3),
                        size: 16,
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  Text(
                    Utils.convertToReadableFormat(
                      review.createdAt.toIso8601String(),
                    ),
                    style: TextStyle(
                      color: AppColor.white.withOpacity(0.5),
                      fontFamily: AppFonts.appFont,
                      fontSize: Responsive.sp(10),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          // Review comment
          Text(
            review.comment,
            style: TextStyle(
              color: AppColor.white,
              fontFamily: AppFonts.appFont,
              fontSize: Responsive.sp(12),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
