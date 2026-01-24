import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/review_model.dart';
import 'package:cage/models/profile_media_model.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/repository/review_repository.dart';
import 'package:cage/repository/report_repository.dart';
import 'package:cage/view/Profile/fighter/all_reviews_screen.dart';
import 'package:cage/view/Profile/fighter/profile_image_upload_view.dart';
import 'package:cage/view/Profile/fighter/full_screen_media_viewer.dart';
import 'package:cage/services/profile_media_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class FighterPublicProfile extends StatefulWidget {
  final UserModel? userData;

  const FighterPublicProfile({super.key, this.userData});

  @override
  State<FighterPublicProfile> createState() => _FighterPublicProfileState();
}

class _FighterPublicProfileState extends State<FighterPublicProfile> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    // Check if current user is viewing their own profile
    final currentUserId = UserRepository.getCurrentUid();
    final profileUserId = widget.userData?.id ?? currentUserId;
    final isOwnProfile =
        widget.userData == null || widget.userData?.id == currentUserId;

    return Scaffold(
      backgroundColor: AppColor.black,
      floatingActionButton: isOwnProfile && !_isUploading
          ? FloatingActionButton(
              onPressed: () =>
                  _showMediaPickerBottomSheet(context, profileUserId),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Show back arrow only when viewing someone else's profile
                            if (widget.userData != null)
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: Responsive.w(3),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/arrow-left-01.svg",
                                    color: AppColor.red,
                                  ),
                                ),
                              ),
                            Text(
                              widget.userData != null
                                  ? (widget.userData!.roleData
                                            is FighterDataModel
                                        ? ((widget.userData!.roleData
                                                      as FighterDataModel)
                                                  .fullName
                                                  .isNotEmpty
                                              ? "${(widget.userData!.roleData as FighterDataModel).fullName} Profile"
                                              : "Fighter Profile")
                                        : "Fighter Profile")
                                  : "Profile",
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 24,
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // Show report button only when viewing someone else's profile
                        if (widget.userData != null)
                          GestureDetector(
                            onTap: () =>
                                _showReportDialog(context, widget.userData!),
                            child: Icon(
                              Icons.flag_outlined,
                              color: AppColor.red,
                              size: 24,
                            ),
                          ),
                      ],
                    ),

                    // If userData is provided, use it directly; otherwise fetch current user
                    widget.userData != null
                        ? _buildProfileContent(
                            context,
                            widget.userData!,
                            isOwnProfile,
                          )
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

                              return _buildProfileContent(
                                context,
                                snapshot.data!,
                                true,
                              );
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

  Widget _buildProfileContent(
    BuildContext context,
    UserModel user,
    bool isOwnProfile,
  ) {
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
                color: AppColor.white.withValues(alpha: 0.7),
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
            GestureDetector(
              onTap: isOwnProfile
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileImageUploadView(),
                        ),
                      );
                    }
                  : null,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: AppColor.white.withValues(alpha: 0.1),
                child:
                    fighter.profileImageUrl != null &&
                        fighter.profileImageUrl!.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: fighter.profileImageUrl!,
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
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(2)),
                child: Column(
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
                    GestureDetector(
                      onTap: () {
                        final phone = fighter.coachContact;
                        if (phone.isNotEmpty && phone != "No phone number") {
                          _launchPhone(context, phone);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/icons/call.svg"),
                          SizedBox(width: Responsive.w(1)),
                          Flexible(
                            child: Builder(
                              builder: (context) {
                                final phone = fighter.coachContact;
                                final canCall =
                                    phone.isNotEmpty &&
                                    phone != "No phone number";
                                return Text(
                                  phone.isEmpty ? "No phone number" : phone,
                                  style: TextStyle(
                                    fontSize: Responsive.textScaleFactor * 12,
                                    color: canCall
                                        ? AppColor.red
                                        : AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.normal,
                                    decoration: canCall
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final email = user.email;
                        if (email.isNotEmpty && email != "No email") {
                          _launchEmail(context, email);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("assets/icons/mail-02.svg"),
                          SizedBox(width: Responsive.w(1)),
                          Flexible(
                            child: Builder(
                              builder: (context) {
                                final email = user.email;
                                final canEmail =
                                    email.isNotEmpty && email != "No email";
                                return Text(
                                  email.isEmpty ? "No email" : email,
                                  style: TextStyle(
                                    fontSize: Responsive.textScaleFactor * 12,
                                    color: canEmail
                                        ? AppColor.red
                                        : AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.normal,
                                    decoration: canEmail
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Only show edit button if viewing own profile
            if (isOwnProfile)
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
                      fighter.fightWin.toString() ?? "0",
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
                        fighter.fightsLose.toString() ?? "0",
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
                        fighter.fightsKnockout.toString() ?? "0",
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
        SizedBox(height: Responsive.h(1)),
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
            SizedBox(width: Responsive.w(2)),
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
                        fighter.fightingStyle ??
                            fighter.fightsStyle ??
                            "Not set",
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

        SizedBox(height: Responsive.h(2)),

        // Pose Image Display
        if (fighter.poseImageUrl != null && fighter.poseImageUrl!.isNotEmpty)
          Container(
            width: double.infinity,
            height: Responsive.h(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColor.white.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: fighter.poseImageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColor.black,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColor.red),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColor.black,
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      color: AppColor.red,
                      size: 48,
                    ),
                  ),
                ),
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
                Flexible(
                  child: GestureDetector(
                    onTap: fighter.urlProfile.isNotEmpty == true
                        ? () => _openTapologyUrl(fighter.urlProfile)
                        : null,
                    child: Text(
                      fighter.urlProfile ?? "Not set",
                      style: TextStyle(
                        color: fighter.urlProfile.isNotEmpty == true
                            ? AppColor.red
                            : AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                        decoration: fighter.urlProfile.isNotEmpty == true
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: AppColor.red,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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

        // Fighter Location Map
        if (fighter.latitude != null && fighter.longitude != null)
          _buildLocationMap(fighter),

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
                                profileImageUrl = fighter.profileImageUrl;
                              } else if (user.isPromoter &&
                                  user.roleData is PromoterDataModel) {
                                final promoter =
                                    user.roleData as PromoterDataModel;
                                profileImageUrl = promoter.profileImageUrl;
                              }
                            }

                            if (profileImageUrl != null &&
                                profileImageUrl.isNotEmpty) {
                              return CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColor.red,
                                backgroundImage: CachedNetworkImageProvider(
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
                                    ? latestReview.reviewerName[0].toUpperCase()
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
                                  color: AppColor.white.withValues(alpha: 0.7),
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
                                      : AppColor.white.withValues(alpha: 0.3),
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
                                color: AppColor.white.withValues(alpha: 0.5),
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
        StreamBuilder<UserModel>(
          stream: UserRepository.fetchCurrentUserStream(),
          builder: (context, snapshot) {
            // Debug: Print role detection
            print('=== DEBUG: Rate Button Role Check ===');
            print('Snapshot hasData: ${snapshot.hasData}');
            print('Connection state: ${snapshot.connectionState}');

            if (snapshot.hasData) {
              final currentUser = snapshot.data!;
              print('Current user role: ${currentUser.roleData}');
              print('Is Promoter: ${currentUser.isPromoter}');
              print('Is Fighter: ${currentUser.isFighter}');
              print('User ID: ${currentUser.id}');
              print('Fighter ID: ${widget.userData?.id ?? user.id}');

              // Hide button if user is viewing their own profile
              if (widget.userData == null ||
                  currentUser.id == widget.userData!.id) {
                print('🚫 HIDING BUTTON: User viewing own profile!');
                return Container();
              }

              // Hide button if current user is a fighter
              if (currentUser.isFighter) {
                print('🚫 HIDING BUTTON: User is a Fighter!');
                return Container();
              }

              // Show button only if current user is a promoter
              if (currentUser.isPromoter) {
                print('✅ SHOWING BUTTON: User is a Promoter!');
                final fighterUserId = widget.userData?.id ?? user.id;
                // Check if user has already reviewed this fighter
                return FutureBuilder<bool>(
                  future: ReviewRepository.hasAlreadyReviewed(
                    reviewerId: currentUser.id,
                    reviewedUserId: fighterUserId,
                  ),
                  builder: (context, reviewSnapshot) {
                    // Hide button if already reviewed
                    if (reviewSnapshot.hasData && reviewSnapshot.data == true) {
                      print(
                        '🚫 HIDING BUTTON: User already reviewed this fighter!',
                      );
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
                  },
                );
              }
            }

            // Return empty container if not a promoter or still loading
            print(
              '⚪ HIDING BUTTON: Default case (not promoter or still loading)',
            );
            return Container();
          },
        ),

        SizedBox(height: Responsive.h(2)),
        _buildPhotosSection(context, user.id, isOwnProfile),
        _buildVideosSection(context, user.id, isOwnProfile),
      ],
    );
  }

  Future<void> _openTapologyUrl(String url) async {
    try {
      // Ensure URL has a protocol (http:// or https://)
      String formattedUrl = url.trim();
      if (!formattedUrl.startsWith('http://') &&
          !formattedUrl.startsWith('https://')) {
        formattedUrl = 'https://$formattedUrl';
      }

      final Uri uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open URL: $url'),
              backgroundColor: AppColor.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: ${e.toString()}'),
            backgroundColor: AppColor.red,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri.parse('mailto:${Uri.encodeComponent(email)}');
    try {
      // LaunchMode.externalApplication required for mailto on Android 11+.
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email app. Is one installed?'),
            backgroundColor: AppColor.red,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Email launcher error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch email: ${e.toString()}'),
            backgroundColor: AppColor.red,
            duration: Duration(seconds: 4),
          ),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open phone dialer'),
            backgroundColor: AppColor.red,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Phone launcher error: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch phone: ${e.toString()}'),
            backgroundColor: AppColor.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _ratePromoterBottomSheet(BuildContext context) {
    // Get the fighter user data - either passed userData or current user
    final UserModel? fighterUser = widget.userData;
    final String fighterUserId = fighterUser?.id ?? '';
    final String fighterName =
        fighterUser?.roleData != null && fighterUser!.isFighter
        ? (fighterUser.roleData as FighterDataModel).fullName ?? 'Fighter'
        : 'Fighter';

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

  /// Build interactive Google Map widget for fighter's location
  Widget _buildLocationMap(FighterDataModel fighter) {
    final LatLng fighterLocation = LatLng(
      fighter.latitude!,
      fighter.longitude!,
    );

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Google Map with dark theme
            GoogleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: fighterLocation,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) async {
                // Apply dark map style from assets
                try {
                  final String mapStyle = await rootBundle.loadString(
                    'assets/map_style.json',
                  );
                  await controller.setMapStyle(mapStyle);
                } catch (e) {
                  print('Error setting map style: $e');
                }
              },
              markers: {
                Marker(
                  markerId: MarkerId('fighter_location'),
                  position: fighterLocation,
                  infoWindow: InfoWindow(
                    title: fighter.fullName,
                    snippet: fighter.location ?? "Fighter Location",
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              },
            ),

            // Location info overlay
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.black.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: AppColor.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Fighter Location",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 12,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (fighter.location != null) ...[
                      SizedBox(height: 4),
                      Text(
                        fighter.location!,
                        style: TextStyle(
                          color: AppColor.white.withValues(alpha: 0.9),
                          fontSize: 10,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Map type toggle button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.map, color: AppColor.white, size: 20),
              ),
            ),
          ],
        ),
      ),
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
        // Set uploading state
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

          // Show success/error message
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
    // Show confirmation dialog
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
      final alreadyReviewed = await ReviewRepository.hasAlreadyReviewed(
        reviewerId: reviewerId,
        reviewedUserId: widget.fighterUserId,
      );

      if (mounted) {
        setState(() {
          _hasAlreadyReviewed = alreadyReviewed;
          _isCheckingReview = false;
        });

        if (alreadyReviewed) {
          // Show error message and close bottom sheet after a delay
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
    // Check if user has already reviewed
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

      // Close dialog automatically after successful submission
      if (mounted) {
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
      }
    } catch (e) {
      print('Error submitting review: $e');
      String errorMessage = "Failed to submit review. Please try again.";

      // Check if the error is about already reviewed
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

                // Submit Button
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
