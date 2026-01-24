import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/models/profile_media_model.dart';
import 'package:cage/repository/report_repository.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/services/profile_media_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/fighter/all_reviews_screen.dart';
import 'package:cage/view/Profile/fighter/full_screen_media_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoterPublicProfile extends StatefulWidget {
  final UserModel userData;

  const PromoterPublicProfile({super.key, required this.userData});

  @override
  State<PromoterPublicProfile> createState() => _PromoterPublicProfileState();
}

class _PromoterPublicProfileState extends State<PromoterPublicProfile> {
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    if (widget.userData.roleData is! PromoterDataModel) {
      return Scaffold(
        backgroundColor: AppColor.black,
        body: SafeArea(
          child: Center(
            child: Text(
              "Invalid promoter data",
              style: TextStyle(color: AppColor.white),
            ),
          ),
        ),
      );
    }

    final promoter = widget.userData.roleData as PromoterDataModel;
    final EventService eventService = EventService();

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            "assets/icons/arrow-left-01.svg",
                            color: AppColor.red,
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        Text(
                          promoter.companyName != null &&
                                  promoter.companyName!.isNotEmpty
                              ? "${promoter.companyName} Profile"
                              : "Promoter Profile",
                          style: TextStyle(
                            fontSize: Responsive.textScaleFactor * 24,
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showReportDialog(context, widget.userData),
                      child: Icon(
                        Icons.flag_outlined,
                        color: AppColor.red,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.h(2)),

                // Promoter Profile Section
                _buildPromoterProfileSection(context, promoter),

                SizedBox(height: Responsive.h(1)),

                // Company Description Section
                Text(
                  promoter.companyAbout ?? "No description available",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                SizedBox(height: Responsive.h(1)),

                // Stats Cards Section
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "No of Event Managed",
                        (promoter.numberOfEvents ?? 0).toString(),
                      ),
                    ),
                    SizedBox(width: Responsive.w(2)),
                    Expanded(
                      child: _buildStatCard(
                        "Location",
                        promoter.location ?? "N/A",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.h(2)),

                // Active Events Section
                _buildActiveEventsSection(context, eventService),

                // Past Events Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Past Events",
                    style: TextStyle(
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(16),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(1)),

                // Past Events List
                StreamBuilder<List<EventModel>>(
                  stream: eventService.getPastEventsByPromoter(
                    widget.userData.id,
                  ),
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

                    if (snapshot.hasError) {
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
                            'Error loading events',
                            style: TextStyle(
                              color: AppColor.white.withValues(alpha: 0.7),
                            ),
                          ),
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
                            "No past events",
                            style: TextStyle(
                              color: AppColor.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    }

                    final events = snapshot.data!;
                    return SizedBox(
                      height: Responsive.h(30),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _buildEventCard(context, event);
                        },
                      ),
                    );
                  },
                ),

                SizedBox(height: Responsive.h(2)),

                // Reviews Section
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
                              fighterUserId: widget.userData.id,
                              fighterName: promoter.companyName ?? "Promoter",
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
                          SvgPicture.asset("assets/icons/Vector (2).svg"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),

                // Latest Review Section
                FutureBuilder<ReviewModel?>(
                  future: ReviewRepository.getLatestPromoterReview(
                    widget.userData.id,
                  ),
                  builder: (context, reviewSnapshot) {
                    if (reviewSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.white.withValues(alpha: 0.1),
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
                            color: AppColor.white.withValues(alpha: 0.1),
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
                                color: AppColor.white.withValues(alpha: 0.5),
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Be among the first to support this fighter",
                                style: TextStyle(
                                  color: AppColor.white.withValues(alpha: 0.7),
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
                          color: AppColor.white.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: AppColor.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StreamBuilder<UserModel?>(
                                  stream: UserRepository.fetchUserByIdStream(
                                    latestReview.reviewerId,
                                  ),
                                  builder: (context, userSnapshot) {
                                    String? profileImageUrl;

                                    if (userSnapshot.hasData &&
                                        userSnapshot.data != null) {
                                      final user = userSnapshot.data!;
                                      if (user.isFighter &&
                                          user.roleData is FighterDataModel) {
                                        final fighter =
                                            user.roleData as FighterDataModel;
                                        profileImageUrl =
                                            fighter.profileImageUrl;
                                      } else if (user.isPromoter &&
                                          user.roleData is PromoterDataModel) {
                                        final promoter =
                                            user.roleData as PromoterDataModel;
                                        profileImageUrl =
                                            promoter.profileImageUrl;
                                      }
                                    }

                                    if (profileImageUrl != null &&
                                        profileImageUrl.isNotEmpty) {
                                      return CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColor.red,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                              profileImageUrl,
                                            ),
                                        onBackgroundImageError:
                                            (exception, stackTrace) {
                                              // Handle error silently
                                            },
                                      );
                                    }

                                    // Fallback to initial if no profile picture
                                    return CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColor.red,
                                      child: Text(
                                        latestReview.reviewerName.isNotEmpty
                                            ? latestReview.reviewerName[0]
                                                  .toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontFamily: AppFonts.appFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive.sp(12),
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
                                          fontFamily: AppFonts.appFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Responsive.sp(10),
                                        ),
                                      ),
                                      Text(
                                        latestReview.reviewerRole,
                                        style: TextStyle(
                                          color: AppColor.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontFamily: AppFonts.appFont,
                                          fontSize: Responsive.sp(8),
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
                                          color: index < latestReview.rating
                                              ? AppColor.red
                                              : AppColor.white.withValues(
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
                                        color: AppColor.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontFamily: AppFonts.appFont,
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
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // 🔹 Rate Promoter Button (only show when current user is a fighter)
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final currentUser = snapshot.data!;

                      // Hide button if user is viewing their own profile
                      if (currentUser.id == widget.userData.id) {
                        return Container();
                      }

                      // Hide button if current user is a promoter
                      if (currentUser.isPromoter) {
                        return Container();
                      }

                      // Show button only if current user is a fighter
                      if (currentUser.isFighter) {
                        final promoterUserId = widget.userData.id;
                        // Check if user has already reviewed this promoter
                        return FutureBuilder<bool>(
                          future: ReviewRepository.hasAlreadyReviewed(
                            reviewerId: currentUser.id,
                            reviewedUserId: promoterUserId,
                          ),
                          builder: (context, reviewSnapshot) {
                            // Hide button if already reviewed
                            if (reviewSnapshot.hasData &&
                                reviewSnapshot.data == true) {
                              return Container();
                            }

                            // Show button if not reviewed yet or still checking
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: Responsive.h(2)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _ratePromoterBottomSheet(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.red,
                                          foregroundColor: AppColor.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: Responsive.h(1.5),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Rate This Promoter",
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.sp(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }

                    return Container();
                  },
                ),

                SizedBox(height: Responsive.h(2)),

                // Photos Section
                _buildPhotosSection(context, widget.userData.id, false),

                // Videos Section
                _buildVideosSection(context, widget.userData.id, false),

                SizedBox(height: Responsive.h(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoterProfileSection(
    BuildContext context,
    PromoterDataModel promoter,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
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
                      image: AssetImage("assets/images/Ellipse 24 (1).png"),
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage("assets/images/Ellipse 24 (1).png"),
                    ),
                  ),
                )
              : Image(image: AssetImage("assets/images/Ellipse 24 (1).png")),
        ),
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
            GestureDetector(
              onTap: () {
                if (promoter.contactNumber != null &&
                    promoter.contactNumber!.isNotEmpty &&
                    promoter.contactNumber != "Phone not set") {
                  _launchPhone(context, promoter.contactNumber!);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/icons/call.svg"),
                  SizedBox(width: Responsive.w(1)),
                  Text(
                    promoter.contactNumber ?? "Phone not set",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 12,
                      color:
                          (promoter.contactNumber != null &&
                              promoter.contactNumber!.isNotEmpty &&
                              promoter.contactNumber != "Phone not set")
                          ? AppColor.red
                          : AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.normal,
                      decoration:
                          (promoter.contactNumber != null &&
                              promoter.contactNumber!.isNotEmpty &&
                              promoter.contactNumber != "Phone not set")
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (promoter.contactEmail != null &&
                    promoter.contactEmail!.isNotEmpty &&
                    promoter.contactEmail != "Email not set") {
                  _launchEmail(context, promoter.contactEmail!);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/icons/mail-02.svg"),
                  SizedBox(width: Responsive.w(1)),
                  Text(
                    promoter.contactEmail ?? "Email not set",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 12,
                      color:
                          (promoter.contactEmail != null &&
                              promoter.contactEmail!.isNotEmpty &&
                              promoter.contactEmail != "Email not set")
                          ? AppColor.red
                          : AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.normal,
                      decoration:
                          (promoter.contactEmail != null &&
                              promoter.contactEmail!.isNotEmpty &&
                              promoter.contactEmail != "Email not set")
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: Responsive.w(10)),
      ],
    );
  }

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    return Container(
      width: Responsive.w(70),
      margin: EdgeInsets.only(right: Responsive.w(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppColor.black,
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            child:
                event.thumbnailImageUrl != null &&
                    event.thumbnailImageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: event.thumbnailImageUrl!,
                    width: double.infinity,
                    height: Responsive.h(20),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: Responsive.h(20),
                      color: AppColor.white.withValues(alpha: 0.1),
                      child: Icon(Icons.image, color: AppColor.white),
                    ),
                  )
                : Container(
                    height: Responsive.h(20),
                    color: AppColor.white.withValues(alpha: 0.1),
                    child: Icon(Icons.image, color: AppColor.white),
                  ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 5.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.eventTitle,
                    style: TextStyle(
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(14),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.5),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColor.white.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: Responsive.w(1)),
                      Expanded(
                        child: Text(
                          DateFormat('MMM dd, yyyy').format(event.eventDate),
                          style: TextStyle(
                            color: AppColor.white.withValues(alpha: 0.7),
                            fontFamily: AppFonts.appFont,
                            fontSize: Responsive.sp(10),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColor.white.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: Responsive.w(1)),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(
                            color: AppColor.white.withValues(alpha: 0.7),
                            fontFamily: AppFonts.appFont,
                            fontSize: Responsive.sp(10),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, UserModel reportedUser) {
    final TextEditingController descriptionController = TextEditingController();
    String selectedReason = 'Inappropriate Content';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColor.black,
          title: Text(
            'Report User',
            style: TextStyle(
              color: AppColor.white,
              fontFamily: AppFonts.appFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for reporting:',
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontSize: Responsive.sp(14),
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.red, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedReason,
                      isExpanded: true,
                      dropdownColor: AppColor.black,
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                      ),
                      items:
                          [
                            'Inappropriate Content',
                            'Harassment',
                            'Fake Profile',
                            'Spam',
                            'Other',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setDialogState(() {
                            selectedReason = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  'Additional details (optional):',
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontSize: Responsive.sp(14),
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  style: TextStyle(color: AppColor.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.05),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.red, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.red, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Provide additional information...',
                    hintStyle: TextStyle(
                      color: AppColor.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                descriptionController.dispose();
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: AppColor.white)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Show loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(color: AppColor.red),
                    ),
                  );

                  await ReportRepository.submitReport(
                    reportedUserId: reportedUser.id,
                    reason: selectedReason,
                    description: descriptionController.text.trim().isNotEmpty
                        ? descriptionController.text.trim()
                        : null,
                  );

                  // Close loading and dialog
                  Navigator.pop(context); // Close loading
                  descriptionController.dispose();
                  Navigator.pop(context); // Close dialog

                  // Show success message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Report submitted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  // Close loading
                  Navigator.pop(context);

                  // Show error message
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error submitting report: ${e.toString()}',
                        ),
                        backgroundColor: AppColor.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppColor.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ratePromoterBottomSheet(BuildContext context) {
    final String promoterUserId = widget.userData.id;
    final String promoterName =
        (widget.userData.roleData as PromoterDataModel).companyName ??
        'Promoter';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: AppColor.black,
      builder: (context) {
        return _PromoterRatingBottomSheetContent(
          promoterUserId: promoterUserId,
          promoterName: promoterName,
        );
      },
    );
  }

  Widget _buildActiveEventsSection(
    BuildContext context,
    EventService eventService,
  ) {
    return StreamBuilder<List<EventModel>>(
      stream: eventService.getActiveEventsByPromoter(widget.userData.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        final events = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(
              height: Responsive.h(30),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _buildEventCard(context, event);
                },
              ),
            ),
            SizedBox(height: Responsive.h(2)),
          ],
        );
      },
    );
  }

  Widget _buildPhotosSection(
    BuildContext context,
    String userId,
    bool isOwnProfile,
  ) {
    return StreamBuilder<List<ProfileMediaModel>>(
      stream: ProfileMediaService.getPhotosStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            _buildPhotosGrid(context, userId, isOwnProfile),
            SizedBox(height: Responsive.h(2)),
          ],
        );
      },
    );
  }

  Widget _buildVideosSection(
    BuildContext context,
    String userId,
    bool isOwnProfile,
  ) {
    return StreamBuilder<List<ProfileMediaModel>>(
      stream: ProfileMediaService.getVideosStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            _buildVideosGrid(context, userId, isOwnProfile),
            SizedBox(height: Responsive.h(2)),
          ],
        );
      },
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
          return SizedBox.shrink();
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
                      onDelete: null, // No delete for public profile
                    ),
                  ),
                );
              },
              child: _buildMediaItem(context, photos[index], isOwnProfile),
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
          return SizedBox.shrink();
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
                      onDelete: null, // No delete for public profile
                    ),
                  ),
                );
              },
              child: _buildMediaItem(context, videos[index], isOwnProfile),
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
      ],
    );
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri =
        Uri.parse('mailto:${Uri.encodeComponent(email)}');

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        Utils.flushBarErrorMassage(
          'Could not open email app. Is one installed?',
          context,
        );
      }
    } catch (e, st) {
      debugPrint('Email launcher error: $e\n$st');
      if (context.mounted) {
        Utils.flushBarErrorMassage('Could not launch email: ${e.toString()}', context);
      }
    }
  }

  Future<void> _launchPhone(BuildContext context, String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri phoneUri = Uri.parse('tel:$cleanedNumber');

    try {
      final launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        Utils.flushBarErrorMassage(
          'Could not open phone dialer',
          context,
        );
      }
    } catch (e, st) {
      debugPrint('Phone launcher error: $e\n$st');
      if (context.mounted) {
        Utils.flushBarErrorMassage('Error: ${e.toString()}', context);
      }
    }
  }
}

class _PromoterRatingBottomSheetContent extends StatefulWidget {
  final String promoterUserId;
  final String promoterName;

  const _PromoterRatingBottomSheetContent({
    required this.promoterUserId,
    required this.promoterName,
  });

  @override
  State<_PromoterRatingBottomSheetContent> createState() =>
      _PromoterRatingBottomSheetContentState();
}

class _PromoterRatingBottomSheetContentState
    extends State<_PromoterRatingBottomSheetContent> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasAlreadyReviewed = false;
  bool _isCheckingReview = true;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyReviewed();
  }

  Future<void> _checkIfAlreadyReviewed() async {
    try {
      final reviewerId = Utils.getCurrentUid();
      final alreadyReviewed = await ReviewRepository.hasAlreadyReviewedPromoter(
        reviewerId: reviewerId,
        promoterUserId: widget.promoterUserId,
      );

      if (mounted) {
        setState(() {
          _hasAlreadyReviewed = alreadyReviewed;
          _isCheckingReview = false;
        });

        if (alreadyReviewed) {
          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "You have already reviewed this user. Each user can only give one review.",
                    style: GoogleFonts.dmSans(color: AppColor.white),
                  ),
                  backgroundColor: AppColor.red,
                  duration: Duration(seconds: 3),
                ),
              );
              Navigator.pop(context);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingReview = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_hasAlreadyReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You have already reviewed this user. Each user can only give one review.",
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: AppColor.red,
        ),
      );
      Navigator.pop(context);
      return;
    }

    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select a rating",
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: AppColor.red,
        ),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please write a review",
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: AppColor.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentUser = await UserRepository.fetchCurrentUserOnce();
      String reviewerName = 'Anonymous';
      String reviewerRole = 'Unknown';

      if (currentUser.isFighter && currentUser.roleData != null) {
        final fighterData = currentUser.roleData as FighterDataModel;
        reviewerName = fighterData.fullName.isNotEmpty
            ? fighterData.fullName
            : 'Fighter';
        reviewerRole = 'Fighter';
      } else if (currentUser.isPromoter && currentUser.roleData != null) {
        final promoterData = currentUser.roleData as PromoterDataModel;
        reviewerName = promoterData.companyName ?? 'Promoter';
        reviewerRole = 'Promoter';
      }

      await ReviewRepository.addPromoterReview(
        promoterUserId: widget.promoterUserId,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        reviewerName: reviewerName,
        reviewerEmail: currentUser.email,
        reviewerRole: reviewerRole,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Review submitted successfully!",
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Failed to submit review. Please try again.";

      if (e.toString().contains('already reviewed')) {
        errorMessage =
            "You have already reviewed this user. Each user can only give one review.";
        setState(() {
          _hasAlreadyReviewed = true;
        });
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: AppColor.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: Responsive.w(5),
        right: Responsive.w(5),
        top: Responsive.h(1),
      ),
      child: _isCheckingReview
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(3)),
              child: Center(
                child: CircularProgressIndicator(color: AppColor.red),
              ),
            )
          : _hasAlreadyReviewed
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rate ${widget.promoterName}",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/IC_cross.svg"),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(3)),
                Icon(Icons.info_outline, color: AppColor.red, size: 48),
                SizedBox(height: Responsive.h(2)),
                Text(
                  "Already Reviewed",
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: Responsive.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                Text(
                  "You have already reviewed this user. Each user can only give one review.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: AppColor.white.withValues(alpha: 0.7),
                    fontSize: Responsive.sp(14),
                  ),
                ),
                SizedBox(height: Responsive.h(3)),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rate ${widget.promoterName}",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/icons/IC_cross.svg"),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                Text(
                  "Rate this promoter",
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: index < _selectedRating
                            ? AppColor.red
                            : AppColor.white.withValues(alpha: 0.3),
                        size: Responsive.sp(28),
                      ),
                    );
                  }),
                ),
                SizedBox(height: Responsive.h(1)),
                Text(
                  _selectedRating > 0
                      ? "$_selectedRating star${_selectedRating > 1 ? 's' : ''}"
                      : "Select a rating",
                  style: GoogleFonts.dmSans(
                    color: AppColor.white.withValues(alpha: 0.7),
                    fontSize: Responsive.sp(12),
                  ),
                ),
                SizedBox(height: Responsive.h(2)),

                Text(
                  "Write a review",
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                TextFormField(
                  controller: _commentController,
                  maxLines: 5,
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: Responsive.sp(12),
                  ),
                  decoration: InputDecoration(
                    hintText: "Share your experience with this promoter...",
                    hintStyle: GoogleFonts.dmSans(
                      color: AppColor.white.withValues(alpha: 0.5),
                      fontSize: Responsive.sp(12),
                    ),
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColor.white.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColor.white.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor.red, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(3)),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasAlreadyReviewed || _isSubmitting
                        ? null
                        : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasAlreadyReviewed
                          ? AppColor.white.withValues(alpha: 0.3)
                          : AppColor.red,
                      foregroundColor: AppColor.white,
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.h(1.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColor.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Submit Review",
                            style: GoogleFonts.dmSans(
                              color: AppColor.white,
                              fontSize: Responsive.sp(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
              ],
            ),
    );
  }
}
