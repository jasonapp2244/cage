import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/profile_media_model.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/services/profile_media_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/Promoter/edit_promoter_profile.dart';
import 'package:cage/view/Profile/fighter/all_reviews_screen.dart';
import 'package:cage/view/Profile/fighter/profile_image_upload_view.dart';
import 'package:cage/view/Profile/fighter/full_screen_media_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PromoterProfileView extends StatefulWidget {
  const PromoterProfileView({super.key});

  @override
  State<PromoterProfileView> createState() => _PromoterProfileViewState();
}

class _PromoterProfileViewState extends State<PromoterProfileView> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      floatingActionButton: !_isUploading
          ? FloatingActionButton(
              onPressed: () {
                final currentUserId = UserRepository.getCurrentUid();
                _showMediaPickerBottomSheet(context, currentUserId);
              },
              backgroundColor: AppColor.red,
              child: Icon(Icons.add, color: AppColor.white),
            )
          : null,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: Responsive.textScaleFactor * 24,
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // 🔹 Promoter Profile Section with StreamBuilder
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, snapshot) {
                        // Debug prints
                        print('=== Promoter Profile Debug ===');
                        print('Connection State: ${snapshot.connectionState}');
                        print('Has Data: ${snapshot.hasData}');
                        print('Has Error: ${snapshot.hasError}');
                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(height: Responsive.h(2)),
                              CircularProgressIndicator(color: AppColor.red),
                              const SizedBox(height: 8),
                              Text(
                                "Loading profile...",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: Responsive.sp(12),
                                ),
                              ),
                            ],
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          print('No data available');
                          return _buildDefaultProfileSection(context);
                        }

                        final user = snapshot.data!;
                        print('User ID: ${user.id}');
                        print('User Email: ${user.email}');
                        print('Role Data Type: ${user.roleData.runtimeType}');
                        print('Is Promoter: ${user.isPromoter}');
                        print('Is Fighter: ${user.isFighter}');

                        if (user.roleData != null) {
                          print('Role Data: $user.roleData');
                        }

                        if (!user.isPromoter) {
                          print('User is not a promoter');
                          return _buildDefaultProfileSection(context);
                        }

                        final promoter = user.roleData as PromoterDataModel;

                        return _buildPromoterProfileSection(context, promoter);
                      },
                    ),

                    SizedBox(height: Responsive.h(1)),

                    // 🔹 Company Description Section
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, snapshot) {
                        String companyAbout = "No description available";

                        print('=== Company Description Debug ===');
                        print('Has Data: ${snapshot.hasData}');
                        print(
                          'Is Promoter: ${snapshot.hasData && snapshot.data != null ? snapshot.data!.isPromoter : false}',
                        );

                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isPromoter) {
                          final promoterData =
                              snapshot.data!.roleData as PromoterDataModel;
                          companyAbout =
                              promoterData.companyAbout ??
                              "No description available";
                          print('Company About: $companyAbout');
                        }

                        return Text(
                          companyAbout,
                          style: TextStyle(
                            fontSize: Responsive.textScaleFactor * 12,
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.normal,
                          ),
                        );
                      },
                    ),

                    // 🔹 Stats Cards Section
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  "No of Event Managed",
                                  "0",
                                ),
                              ),
                              SizedBox(width: Responsive.w(2)),
                              Expanded(
                                child: _buildStatCard("Average Rating", "0.0"),
                              ),
                            ],
                          );
                        }

                        final user = userSnapshot.data!;
                        if (!user.isPromoter) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  "No of Event Managed",
                                  "0",
                                ),
                              ),
                              SizedBox(width: Responsive.w(2)),
                              Expanded(
                                child: _buildStatCard("Average Rating", "0.0"),
                              ),
                            ],
                          );
                        }

                        final promoter = user.roleData as PromoterDataModel;
                        final userId = user.id;

                        // Use manually set numberOfEvents from promoter data
                        final numberOfEvents = (promoter.numberOfEvents ?? 0)
                            .toString();

                        // Calculate average rating from reviews
                        return StreamBuilder<List<ReviewModel>>(
                          stream: ReviewRepository.getPromoterReviews(userId),
                          builder: (context, reviewsSnapshot) {
                            String averageRating = "0.0";

                            if (reviewsSnapshot.hasData &&
                                reviewsSnapshot.data!.isNotEmpty) {
                              final reviews = reviewsSnapshot.data!;
                              double totalRating = 0;
                              for (var review in reviews) {
                                totalRating += review.rating;
                              }
                              averageRating = (totalRating / reviews.length)
                                  .toStringAsFixed(1);
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    "No of Event Managed",
                                    numberOfEvents,
                                  ),
                                ),
                                SizedBox(width: Responsive.w(2)),
                                Expanded(
                                  child: _buildStatCard(
                                    "Average Rating",
                                    averageRating,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: Responsive.h(2)),

                    // Create Event Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.CreateEventView,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.h(2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.red,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: AppColor.white, size: 20),
                            SizedBox(width: Responsive.w(2)),
                            Text(
                              "Create Event",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Reviews Section
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox.shrink();
                        }
                        final userId = userSnapshot.data!.id;
                        final promoter =
                            userSnapshot.data!.roleData as PromoterDataModel;
                        final companyName = promoter.companyName ?? "Promoter";

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reviews",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AllReviewsScreen(
                                          fighterUserId: userId,
                                          fighterName: companyName,
                                          isPromoter: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "View All",
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontFamily: AppFonts.appFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive.sp(10),
                                        ),
                                      ),
                                      SizedBox(width: Responsive.w(2)),
                                      SvgPicture.asset(
                                        "assets/icons/Vector (2).svg",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.h(1)),

                            // Latest Review Section
                            FutureBuilder<ReviewModel?>(
                              future: ReviewRepository.getLatestPromoterReview(
                                userId,
                              ),
                              builder: (context, reviewSnapshot) {
                                if (reviewSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      color: AppColor.black,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.red,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }

                                final latestReview = reviewSnapshot.data;

                                if (latestReview == null) {
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      color: AppColor.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.rate_review_outlined,
                                            color: AppColor.white.withValues(
                                              alpha: 0.5,
                                            ),
                                            size: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Be among the first to support this fighter",
                                            style: TextStyle(
                                              color: AppColor.white.withValues(
                                                alpha: 0.7,
                                              ),
                                              fontFamily: AppFonts.appFont,
                                              fontSize: Responsive.sp(12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    color: AppColor.black,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            StreamBuilder<UserModel?>(
                                              stream:
                                                  UserRepository.fetchUserByIdStream(
                                                    latestReview.reviewerId,
                                                  ),
                                              builder: (context, userSnapshot) {
                                                String? profileImageUrl;

                                                if (userSnapshot.hasData &&
                                                    userSnapshot.data != null) {
                                                  final user =
                                                      userSnapshot.data!;
                                                  if (user.isFighter &&
                                                      user.roleData
                                                          is FighterDataModel) {
                                                    final fighter =
                                                        user.roleData
                                                            as FighterDataModel;
                                                    profileImageUrl =
                                                        fighter.profileImageUrl;
                                                  } else if (user.isPromoter &&
                                                      user.roleData
                                                          is PromoterDataModel) {
                                                    final promoter =
                                                        user.roleData
                                                            as PromoterDataModel;
                                                    profileImageUrl = promoter
                                                        .profileImageUrl;
                                                  }
                                                }

                                                if (profileImageUrl != null &&
                                                    profileImageUrl
                                                        .isNotEmpty) {
                                                  return CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        AppColor.red,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                          profileImageUrl,
                                                        ),
                                                    onBackgroundImageError:
                                                        (
                                                          exception,
                                                          stackTrace,
                                                        ) {
                                                          // Handle error silently
                                                        },
                                                  );
                                                }

                                                // Fallback to initial if no profile picture
                                                return CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: AppColor.red,
                                                  child: Text(
                                                    latestReview
                                                            .reviewerName
                                                            .isNotEmpty
                                                        ? latestReview
                                                              .reviewerName[0]
                                                              .toUpperCase()
                                                        : 'U',
                                                    style: TextStyle(
                                                      color: AppColor.white,
                                                      fontFamily:
                                                          AppFonts.appFont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Responsive.sp(
                                                        12,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(width: Responsive.w(2)),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    latestReview.reviewerName,
                                                    style: TextStyle(
                                                      color: AppColor.white,
                                                      fontFamily:
                                                          AppFonts.appFont,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Responsive.sp(
                                                        10,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    latestReview.reviewerRole,
                                                    style: TextStyle(
                                                      color: AppColor.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      fontFamily:
                                                          AppFonts.appFont,
                                                      fontSize: Responsive.sp(
                                                        8,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: List.generate(5, (
                                                    index,
                                                  ) {
                                                    return Icon(
                                                      Icons.star,
                                                      color:
                                                          index <
                                                              latestReview
                                                                  .rating
                                                          ? AppColor.red
                                                          : AppColor.white
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                      size: 14,
                                                    );
                                                  }),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  Utils.convertToReadableFormat(
                                                    latestReview.createdAt
                                                        .toIso8601String(),
                                                  ),
                                                  style: TextStyle(
                                                    color: AppColor.white
                                                        .withValues(alpha: 0.5),
                                                    fontFamily:
                                                        AppFonts.appFont,
                                                    fontSize: Responsive.sp(8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Responsive.h(1)),
                                        Text(
                                          latestReview.comment,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontSize: Responsive.sp(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Active Events Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Active Events",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(16),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),

                    // Active Events List
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Container(
                            height: Responsive.h(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                "Loading events...",
                                style: TextStyle(
                                  color: AppColor.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          );
                        }

                        final userId = userSnapshot.data!.id;
                        final eventService = EventService();

                        return StreamBuilder<List<EventModel>>(
                          stream: eventService.getActiveEventsByPromoter(
                            userId,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.red,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              print(
                                'Error loading active events: ${snapshot.error}',
                              );
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'Error loading events',
                                    style: TextStyle(
                                      color: AppColor.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              print(
                                'No active events found for promoter: $userId',
                              );
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    "No active events",
                                    style: TextStyle(
                                      color: AppColor.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final events = snapshot.data!;
                            print(
                              'Loaded ${events.length} active events for promoter: $userId',
                            );
                            return SizedBox(
                              height: Responsive.h(30),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  return _buildEventCard(context, event, false);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Event History Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Event History",
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(16),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RoutesName.EventHistory,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(10),
                                ),
                              ),
                              SizedBox(width: Responsive.w(2)),
                              SvgPicture.asset("assets/icons/Vector (2).svg"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(1)),

                    // Event History List
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Container(
                            height: Responsive.h(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                "Loading history...",
                                style: TextStyle(
                                  color: AppColor.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          );
                        }

                        final userId = userSnapshot.data!.id;
                        final eventService = EventService();

                        return StreamBuilder<List<EventModel>>(
                          stream: eventService.getPastEventsByPromoter(userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.red,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              print(
                                'Error loading past events: ${snapshot.error}',
                              );
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'Error loading events',
                                    style: TextStyle(
                                      color: AppColor.white.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              print(
                                'No past events found for promoter: $userId',
                              );
                              return Container(
                                height: Responsive.h(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    "No past events",
                                    style: TextStyle(
                                      color: AppColor.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final events = snapshot.data!
                                .take(3)
                                .toList(); // Show only 3 recent
                            print(
                              'Loaded ${snapshot.data!.length} past events (showing ${events.length}) for promoter: $userId',
                            );
                            return Column(
                              children: events.map((event) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Responsive.h(1),
                                  ),
                                  child: _buildEventCard(context, event, true),
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: Responsive.h(2)),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Photos",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(16),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Container(
                            height: Responsive.h(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            ),
                          );
                        }
                        final currentUserId = userSnapshot.data!.id;
                        return _buildPhotosGrid(context, currentUserId, true);
                      },
                    ),
                    SizedBox(height: Responsive.h(2)),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Videos",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(16),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Container(
                            height: Responsive.h(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            ),
                          );
                        }
                        final currentUserId = userSnapshot.data!.id;
                        return _buildVideosGrid(context, currentUserId, true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Loading overlay
          if (_isUploading)
            Positioned.fill(
              child: Container(
                color: AppColor.black.withValues(alpha: 0.7),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColor.red),
                        SizedBox(height: 16),
                        Text(
                          'Uploading...',
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontSize: Responsive.sp(14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build default profile section when no data is available
  Widget _buildDefaultProfileSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColor.white.withValues(alpha: 0.1),
          child: Image(image: AssetImage("assets/images/Ellipse 24 (1).png")),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Company Name",
              style: TextStyle(
                fontSize: Responsive.textScaleFactor * 14,
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset("assets/icons/call.svg"),
                SizedBox(width: Responsive.w(1)),
                Text(
                  "Phone not set",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset("assets/icons/mail-02.svg"),
                SizedBox(width: Responsive.w(1)),
                Text(
                  "Email not set",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EditPromoterProfile()),
            );
          },
          child: SvgPicture.asset("assets/icons/edits.svg"),
        ),
      ],
    );
  }

  /// Build promoter profile section with actual data
  Widget _buildPromoterProfileSection(
    BuildContext context,
    PromoterDataModel promoter,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileImageUploadView(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 35,
                backgroundColor: AppColor.white.withValues(alpha: 0.1),
                child:
                    promoter.profileImageUrl != null &&
                        promoter.profileImageUrl!.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: promoter.profileImageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image(
                            image: AssetImage(
                              "assets/images/Ellipse 24 (1).png",
                            ),
                          ),
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage(
                              "assets/images/Ellipse 24 (1).png",
                            ),
                          ),
                        ),
                      )
                    : Image(
                        image: AssetImage("assets/images/Ellipse 24 (1).png"),
                      ),
              ),
            ),SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promoter.companyName ?? "Company Name",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 14,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/call.svg"),
                    SizedBox(width: Responsive.w(1)),
                    Text(
                      promoter.contactNumber ?? "Phone not set",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 12,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/mail-02.svg"),
                    SizedBox(width: Responsive.w(1)),
                    Text(
                      promoter.contactEmail ?? "Email not set",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 12,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditPromoterProfile(promoterData: promoter),
              ),
            );
          },
          child: SvgPicture.asset("assets/icons/edits.svg"),
        ),
      ],
    );
  }

  /// Reusable Stat Card
  Widget _buildStatCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.black,
        border: BoxBorder.all(
          color: AppColor.white.withValues(alpha: 0.1),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.normal,
                fontSize: Responsive.sp(10.5),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.sp(24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Event Card Widget
  Widget _buildEventCard(
    BuildContext context,
    EventModel event,
    bool isHistory,
  ) {
    Responsive.init(context);
    return GestureDetector(
      onTap: () {
        // Navigate to event details
        // You can create an event detail view later
      },
      child: Container(
        width: isHistory ? double.infinity : Responsive.w(70),
        margin: EdgeInsets.only(
          right: isHistory ? 0 : Responsive.w(2),
          bottom: isHistory ? Responsive.h(1) : 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColor.black,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image Section with Overlays
            Stack(
              children: [
                // Main Event Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child:
                      event.thumbnailImageUrl != null &&
                          event.thumbnailImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: event.thumbnailImageUrl!,
                          width: double.infinity,
                          height: Responsive.h(20),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: Responsive.h(20),
                            color: AppColor.white.withValues(alpha: 0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: Responsive.h(20),
                            color: AppColor.white.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.image,
                              color: AppColor.white.withValues(alpha: 0.5),
                            ),
                          ),
                        )
                      : Container(
                          height: Responsive.h(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.red.withValues(alpha: 0.3),
                                AppColor.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.event,
                            color: AppColor.white.withValues(alpha: 0.5),
                            size: 48,
                          ),
                        ),
                ),
                // Green overlay for background effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.green.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                // Date Badge (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('d').format(event.eventDate),
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(16),
                          ),
                        ),
                        Text(
                          DateFormat(
                            'MMM',
                          ).format(event.eventDate).toUpperCase(),
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.normal,
                            fontSize: Responsive.sp(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Edit & Delete Icons (Top Right) - Only for active events
                if (!isHistory)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.CreateEventView,
                              arguments: event,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColor.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: AppColor.white,
                              size: 20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColor.black,
                                title: Text(
                                  'Delete Event?',
                                  style: TextStyle(color: AppColor.white),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this event?',
                                  style: TextStyle(color: AppColor.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: AppColor.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                await EventService().deleteEvent(event.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Event deleted'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete: $e'),
                                      backgroundColor: AppColor.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: AppColor.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Event Title Overlay (Center Bottom of Image)
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.eventTitle,
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(14),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            // Event Details Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 3.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Type and Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 11,
                        color: AppColor.white.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            color: AppColor.white.withValues(alpha: 0.7),
                            fontFamily: AppFonts.appFont,
                            fontSize: Responsive.sp(9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  // Event Type Badge
                  if (event.eventType.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColor.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColor.red.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        event.eventType,
                        style: TextStyle(
                          color: AppColor.red,
                          fontFamily: AppFonts.appFont,
                          fontSize: Responsive.sp(8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: 3),
                  // View Details Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.EventDetailView,
                        arguments: event,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.black,
                        border: Border.all(
                          color: AppColor.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Details",
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(10),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 9,
                            color: AppColor.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosGrid(
    BuildContext context,
    String userId,
    bool isOwnProfile,
  ) {
    return StreamBuilder<List<ProfileMediaModel>>(
      stream: ProfileMediaService.getPhotosStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Responsive.h(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColor.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: Responsive.h(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                "No photos yet",
                style: TextStyle(color: AppColor.white.withValues(alpha: 0.5)),
              ),
            ),
          );
        }

        final photos = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenMediaViewer(
                      mediaList: photos,
                      initialIndex: index,
                      isOwnProfile: isOwnProfile,
                      userId: userId,
                      onDelete: isOwnProfile
                          ? (media) => _deleteMedia(context, userId, media)
                          : null,
                    ),
                  ),
                );
              },
              child: _buildMediaItem(
                context,
                photos[index],
                isOwnProfile,
                userId,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVideosGrid(
    BuildContext context,
    String userId,
    bool isOwnProfile,
  ) {
    return StreamBuilder<List<ProfileMediaModel>>(
      stream: ProfileMediaService.getVideosStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Responsive.h(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColor.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            height: Responsive.h(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.1),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                "No videos yet",
                style: TextStyle(color: AppColor.white.withValues(alpha: 0.5)),
              ),
            ),
          );
        }

        final videos = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenMediaViewer(
                      mediaList: videos,
                      initialIndex: index,
                      isOwnProfile: isOwnProfile,
                      userId: userId,
                      onDelete: isOwnProfile
                          ? (media) => _deleteMedia(context, userId, media)
                          : null,
                    ),
                  ),
                );
              },
              child: _buildMediaItem(
                context,
                videos[index],
                isOwnProfile,
                userId,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMediaItem(
    BuildContext context,
    ProfileMediaModel media,
    bool isOwnProfile,
    String userId,
  ) {
    // Check if URL is a video file
    final isVideoUrl =
        media.url.toLowerCase().endsWith('.mp4') ||
        media.url.toLowerCase().endsWith('.mov') ||
        media.url.toLowerCase().endsWith('.avi') ||
        media.url.toLowerCase().endsWith('.mkv') ||
        media.url.toLowerCase().endsWith('.webm') ||
        media.type == 'video';

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: media.type == 'photo' && !isVideoUrl
              ? CachedNetworkImage(
                  imageUrl: media.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColor.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.red,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColor.black,
                    child: Icon(Icons.error_outline, color: AppColor.red),
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    // For videos, show a placeholder instead of trying to load the video URL as an image
                    Container(
                      color: AppColor.black,
                      child: Center(
                        child: Icon(
                          Icons.videocam,
                          color: AppColor.white.withValues(alpha: 0.5),
                          size: 48,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: AppColor.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        if (isOwnProfile)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _deleteMedia(context, userId, media),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColor.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete, color: AppColor.white, size: 16),
              ),
            ),
          ),
      ],
    );
  }

  void _showMediaPickerBottomSheet(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(Responsive.w(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Responsive.w(15),
              height: 4,
              margin: EdgeInsets.only(bottom: Responsive.h(2)),
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.photo, color: AppColor.red),
              title: Text(
                "Upload Photo",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadMedia(userId, 'photo', ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColor.red),
              title: Text(
                "Take Photo",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadMedia(userId, 'photo', ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: AppColor.red),
              title: Text(
                "Upload Video",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadMedia(userId, 'video', ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: AppColor.red),
              title: Text(
                "Record Video",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadMedia(userId, 'video', ImageSource.camera);
              },
            ),
            SizedBox(height: Responsive.h(2)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadMedia(
    String userId,
    String type,
    ImageSource source,
  ) async {
    if (!mounted) return;

    try {
      final ImagePicker picker = ImagePicker();
      XFile? file;

      if (type == 'photo') {
        file = await picker.pickImage(source: source, imageQuality: 85);
      } else {
        file = await picker.pickVideo(source: source);
      }

      if (file != null && mounted) {
        setState(() {
          _isUploading = true;
        });

        try {
          final uploadResult = await ProfileMediaService.uploadMedia(
            file: File(file.path),
            userId: userId,
            type: type,
          );

          if (!mounted) return;

          final scaffoldMessenger = ScaffoldMessenger.of(context);
          if (uploadResult != null) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  '${type == 'photo' ? 'Photo' : 'Video'} uploaded successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to upload ${type == 'photo' ? 'photo' : 'video'}. Please try again.',
                ),
                backgroundColor: AppColor.red,
              ),
            );
          }
        } catch (uploadError) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${uploadError.toString()}'),
              backgroundColor: AppColor.red,
            ),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isUploading = false;
            });
          }
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColor.red,
        ),
      );

      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _deleteMedia(
    BuildContext context,
    String userId,
    ProfileMediaModel media,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.black,
        title: Text(
          'Delete ${media.type == 'photo' ? 'Photo' : 'Video'}?',
          style: TextStyle(color: AppColor.white),
        ),
        content: Text(
          'Are you sure you want to delete this ${media.type == 'photo' ? 'photo' : 'video'}?',
          style: TextStyle(color: AppColor.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColor.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: AppColor.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ProfileMediaService.deleteMedia(
        userId: userId,
        mediaId: media.id,
        mediaUrl: media.url,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${media.type == 'photo' ? 'Photo' : 'Video'} deleted successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete ${media.type == 'photo' ? 'photo' : 'video'}. Please try again.',
            ),
            backgroundColor: AppColor.red,
          ),
        );
      }
    }
  }
}
