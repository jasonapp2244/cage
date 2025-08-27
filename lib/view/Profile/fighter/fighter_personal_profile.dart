import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:cage/widgets/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/view/Profile/fighter/all_reviews_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FighterPublicProfile extends StatelessWidget {
  final UserModel? userData;

  const FighterPublicProfile({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      userData != null ? "Fighter Profile" : "Profile",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 24,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // If userData is provided, use it directly; otherwise fetch current user
                userData != null
                    ? _buildProfileContent(context, userData!)
                    : StreamBuilder<UserModel>(
                        stream: UserRepository.fetchCurrentUserStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColor.red,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Loading your profile...",
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
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
                                    'Error loading data',
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Retry
                                    },
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(color: AppColor.white),
                              ),
                            );
                          }

                          return _buildProfileContent(context, snapshot.data!);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    if (user.roleData is! FighterDataModel) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, color: AppColor.red, size: 48),
            SizedBox(height: 16),
            Text(
              "No fighter data found",
              style: TextStyle(color: AppColor.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Please complete your profile setup",
              style: TextStyle(
                color: AppColor.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final fighter = user.roleData as FighterDataModel;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppColor.white.withValues(alpha: 0.1),
              child: Image(
                image: AssetImage("assets/images/Ellipse 24 (1).png"),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fighter.fullName ?? "Fighter Name",
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
                      fighter.coachContact ?? "No phone number",
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
                      user.email ?? "No email",
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
                  MaterialPageRoute(
                    builder: (_) => EidtProfile(fighterData: fighter),
                  ),
                );
              },
              child: SvgPicture.asset("assets/icons/edits.svg"),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Responsive.w(30),
              height: Responsive.w(22),
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
                      "Wins",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10.5),
                      ),
                    ),
                    Text(
                      fighter.fightWin?.toString() ?? "0",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: Responsive.w(2)),

            Expanded(
              child: Container(
                height: Responsive.w(22),
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
                        "Losses",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(10.5),
                        ),
                      ),
                      Text(
                        fighter.fightsLose?.toString() ?? "0",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: Responsive.w(2)),

            Expanded(
              child: Container(
                height: Responsive.w(22),
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
                        "Knockouts",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(10.5),
                        ),
                      ),
                      Text(
                        fighter.fightsKnockout?.toString() ?? "0",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Container(
                // width: Responsive.w(30),
                height: Responsive.w(22),
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
                        "Weight Style",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(10.5),
                        ),
                      ),
                      Text(
                        fighter.weight.toString(),
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
              ),
            ),
            Expanded(
              child: Container(
                // width: Responsive.w(30),
                height: Responsive.w(22),
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
                        "Fighting Style",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(10.5),
                        ),
                      ),
                      Text(
                        fighter.fightsStyle.toString(),
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: Responsive.h(1)),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: AppColor.white.withValues(alpha: 0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            color: AppColor.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Coach Name",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                    Text(
                      fighter.coachName ?? "Not set",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                  ],
                ),
                Row(children: [Expanded(child: Divider())]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone No",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                    Text(
                      fighter.coachContact ?? "Not set",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: Responsive.h(1)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: AppColor.white.withValues(alpha: 0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            color: AppColor.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tapology URL ",
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(12),
                  ),
                ),
                Text(
                  fighter.urlProfile ?? "Not set",
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
        SizedBox(height: Responsive.h(1)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: AppColor.white.withValues(alpha: 0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            color: AppColor.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Medical Info",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                  ],
                ),
                Row(children: [Expanded(child: Divider())]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blood Test",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                    Text(
                      Utils.convertToReadableFormat(
                        fighter.lastBlood.toString(),
                      ),
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Physical Exam",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                    Text(
                      Utils.convertToReadableFormat(fighter.lastExam),
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Eye Exam",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                    Text(
                      Utils.convertToReadableFormat(fighter.eyeExam.toString()),
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Responsive.h(1)),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: Image(image: AssetImage("assets/images/Frame 1000002180.png")),
        ),

        SizedBox(height: Responsive.h(1)),

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
                      fighterUserId: user.id,
                      fighterName: fighter.fullName ?? "Fighter",
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
          future: ReviewRepository.getLatestReview(user.id),
          builder: (context, reviewSnapshot) {
            if (reviewSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.white.withOpacity(0.1),
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
                    color: AppColor.white.withOpacity(0.1),
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
                        color: AppColor.white.withOpacity(0.5),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "No reviews yet",
                        style: TextStyle(
                          color: AppColor.white.withOpacity(0.7),
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
                  color: AppColor.white.withOpacity(0.1),
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
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColor.red,
                          child: Text(
                            latestReview.reviewerName.isNotEmpty
                                ? latestReview.reviewerName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: AppColor.white.withOpacity(0.7),
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
                                      : AppColor.white.withOpacity(0.3),
                                  size: 14,
                                );
                              }),
                            ),
                            SizedBox(height: 2),
                            Text(
                              Utils.convertToReadableFormat(
                                latestReview.createdAt.toIso8601String(),
                              ),
                              style: TextStyle(
                                color: AppColor.white.withOpacity(0.5),
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

        // 🔹 Rate Fighter Button (only show when current user is a promoter)
        FutureBuilder<String?>(
          future: _getCurrentUserRole(),
          builder: (context, snapshot) {
            // Debug: Print role detection
            print('=== DEBUG: Rate Button Role Check ===');
            print('Snapshot hasData: ${snapshot.hasData}');
            print('Snapshot data: "${snapshot.data}"');
            print('Connection state: ${snapshot.connectionState}');
            print('Is equal to Promoter: ${snapshot.data == 'Promoter'}');
            print('Is equal to Fighter: ${snapshot.data == 'Fighter'}');
            print('Raw comparison: "${snapshot.data}" == "Promoter"');
            print('=====================================');

            // Only show button if current user is a promoter
            // SAFETY CHECK: Explicitly hide button if role is Fighter
            if (snapshot.hasData && snapshot.data == 'Fighter') {
              print('🚫 HIDING BUTTON: User is a Fighter!');
              return Container(); // Explicitly hide for fighters
            }

            if (snapshot.hasData && snapshot.data == 'Promoter') {
              print('✅ SHOWING BUTTON: User is a Promoter!');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: Responsive.h(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Rate This Fighter",
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
            }

            // Return empty container if not a promoter or still loading
            print(
              '⚪ HIDING BUTTON: Default case (not promoter or still loading)',
            );
            return Container();
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
        // Add your photos grid or list view here
        // This is just a placeholder - you'll need to implement your actual photos display
        Container(
          height: Responsive.h(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.white.withOpacity(0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              "Photos will be displayed here",
              style: TextStyle(color: AppColor.white.withOpacity(0.5)),
            ),
          ),
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
        // Add your videos grid or list view here
        // This is just a placeholder - you'll need to implement your actual videos display
        Container(
          height: Responsive.h(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.white.withOpacity(0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              "Videos will be displayed here",
              style: TextStyle(color: AppColor.white.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to get current user's role from Firestore
  Future<String?> _getCurrentUserRole() async {
    try {
      print('=== DEBUG: Getting Current User Role ===');

      // First check local storage
      final savedRole = await Utils.getSavedRole('role');
      print('Saved role from local storage: "$savedRole"');

      if (savedRole != null) {
        print('Returning saved role: "$savedRole"');
        return savedRole;
      }

      // If not in local storage, fetch from Firestore
      final userId = Utils.getCurrentUid();
      print('Current user ID: $userId');

      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      print('Document exists: ${doc.exists}');
      if (doc.exists) {
        final docData = doc.data();
        print('Document data: $docData');

        final role = docData?['role'] as String?;
        print('Role field from Firestore: "$role"');

        if (role != null) {
          await Utils.saveSavedRole('role', role);
          print('Saved role to local storage: "$role"');
        }
        print('Returning Firestore role: "$role"');
        return role;
      }
      print('Document does not exist, returning null');
      return null;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  void _ratePromoterBottomSheet(BuildContext context) {
    // Get the fighter user data - either passed userData or current user
    final UserModel? fighterUser = userData;
    final String fighterUserId = fighterUser?.id ?? '';
    final String fighterName =
        fighterUser?.roleData != null && fighterUser!.isFighter
        ? (fighterUser.roleData as FighterDataModel).fullName ?? 'Fighter'
        : 'Fighter';

    print('=== DEBUG: Rating Bottom Sheet ===');
    print('Fighter User ID: $fighterUserId');
    print('Fighter Name: $fighterName');
    print('Fighter User Data: $fighterUser');
    print('===================================');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: AppColor.black,
      builder: (context) {
        return _RatingBottomSheetContent(
          fighterUserId: fighterUserId,
          fighterName: fighterName,
        );
      },
    );
  }
}

class _RatingBottomSheetContent extends StatefulWidget {
  final String fighterUserId;
  final String fighterName;

  const _RatingBottomSheetContent({
    required this.fighterUserId,
    required this.fighterName,
  });

  @override
  State<_RatingBottomSheetContent> createState() =>
      _RatingBottomSheetContentState();
}

class _RatingBottomSheetContentState extends State<_RatingBottomSheetContent> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
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
      print('=== DEBUG: Submit Review ===');
      print('Fighter User ID: ${widget.fighterUserId}');
      print('Fighter Name: ${widget.fighterName}');
      print('Selected Rating: $_selectedRating');
      print('Comment: ${_commentController.text.trim()}');

      // Get current user data for reviewer info
      final currentUser = await UserRepository.fetchCurrentUserOnce();
      String reviewerName = 'Anonymous';
      String reviewerRole = 'Unknown';

      print('Current User: ${currentUser.email}');
      print('Is Promoter: ${currentUser.isPromoter}');
      print('Is Fighter: ${currentUser.isFighter}');
      print('Role Data: ${currentUser.roleData}');

      if (currentUser.isPromoter && currentUser.roleData != null) {
        final promoterData = currentUser.roleData as PromoterDataModel;
        reviewerName = promoterData.companyName ?? 'Promoter';
        reviewerRole = 'Promoter';
      } else if (currentUser.isFighter && currentUser.roleData != null) {
        final fighterData = currentUser.roleData as FighterDataModel;
        reviewerName = fighterData.fullName ?? 'Fighter';
        reviewerRole = 'Fighter';
      }

      print('Reviewer Name: $reviewerName');
      print('Reviewer Role: $reviewerRole');

      await ReviewRepository.addReview(
        fighterUserId: widget.fighterUserId,
        rating: _selectedRating,
        comment: _commentController.text.trim(),
        reviewerName: reviewerName,
        reviewerEmail: currentUser.email,
        reviewerRole: reviewerRole,
      );

      print('Review submitted successfully!');
      print('============================');

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Review submitted successfully!",
            style: GoogleFonts.dmSans(color: AppColor.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to submit review. Please try again.",
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rate ${widget.fighterName}",
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

          // Rating Stars Section
          Text(
            "Rate this fighter",
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
                      : AppColor.white.withOpacity(0.3),
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
              color: AppColor.white.withOpacity(0.7),
              fontSize: Responsive.sp(12),
            ),
          ),
          SizedBox(height: Responsive.h(2)),

          // Comment Section
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
              hintText: "Share your experience with this fighter...",
              hintStyle: GoogleFonts.dmSans(
                color: AppColor.white.withOpacity(0.5),
                fontSize: Responsive.sp(12),
              ),
              filled: true,
              fillColor: AppColor.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.white.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.red, width: 2),
              ),
            ),
          ),
          SizedBox(height: Responsive.h(3)),

          // Submit Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.red,
                foregroundColor: AppColor.white,
                padding: EdgeInsets.symmetric(vertical: Responsive.h(1.5)),
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
