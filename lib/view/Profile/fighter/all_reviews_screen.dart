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
            child: Icon(
              Icons.arrow_back,
              color: AppColor.white,
            ),
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
                    Icon(
                      Icons.error_outline,
                      color: AppColor.red,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Error loading reviews",
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 16,
                      ),
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
                  // Reviews summary
                  FutureBuilder<double>(
                    future: ReviewRepository.getAverageRating(fighterUserId),
                    builder: (context, avgSnapshot) {
                      final avgRating = avgSnapshot.data ?? 0.0;
                      return Container(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${reviews.length} Reviews",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontSize: Responsive.sp(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        color: index < avgRating.round()
                                            ? AppColor.red
                                            : AppColor.white.withOpacity(0.3),
                                        size: 20,
                                      );
                                    }),
                                    SizedBox(width: 8),
                                    Text(
                                      "${avgRating.toStringAsFixed(1)} average",
                                      style: TextStyle(
                                        color: AppColor.white.withOpacity(0.7),
                                        fontFamily: AppFonts.appFont,
                                        fontSize: Responsive.sp(12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
        border: Border.all(
          color: AppColor.white.withOpacity(0.1),
          width: 1,
        ),
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
