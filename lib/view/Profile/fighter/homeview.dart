import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/repository/event_interest_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/services/notification_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerControllerProvider>(
      context,
      listen: false,
    );

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/icons/Group 9.svg"),

                    /// ✅ StreamBuilder for user data
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: [
                              CircularProgressIndicator(color: AppColor.red),
                              const SizedBox(height: 8),
                              Text(
                                "Loading...",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: Responsive.sp(10),
                                ),
                              ),
                            ],
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return Column(
                            children: [
                              Text(
                                "Hi👋 Guest",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(18),
                                ),
                              ),
                              Text(
                                "Location not set",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                            ],
                          );
                        }

                        final user = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              "Hi👋 ${user.isFighter ? (user.roleData as FighterDataModel).fullName : 'User'}",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(18),
                              ),
                            ),
                            Text(
                              user.isFighter
                                  ? _extractCityAndCountry((user.roleData as FighterDataModel).location) ??
                                        "Location not set"
                                  : "Location not set",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(8.5),
                              ),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),

                    GestureDetector(
                      onTap: drawerProvider.toggleDrawer,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.white.withValues(alpha: 0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset("assets/icons/menu-11.svg"),
                        ),
                      ),
                    ),
                  ],
                ),

                // SvgPicture.asset("assets/icons/Mask group (1).svg"),
                Container(
                  color: AppColor.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: StreamBuilder<UserModel>(
                          stream: UserRepository.fetchCurrentUserStream(),
                          builder: (context, snapshot) {
                            String? poseImageUrl;

                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isFighter) {
                              final fighterData =
                                  snapshot.data!.roleData as FighterDataModel;
                              poseImageUrl = fighterData.poseImageUrl;
                            }

                            if (poseImageUrl != null && poseImageUrl.isNotEmpty) {
                              return CachedNetworkImage(
                                imageUrl: poseImageUrl,
                                width: Responsive.w(70),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: Responsive.w(70),
                                  height: Responsive.h(50),
                                  color: AppColor.black,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.red,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image(
                                  width: Responsive.w(70),
                                  image: AssetImage("assets/icons/Mask group.png"),
                                ),
                              );
                            } else {
                              return Image(
                                width: Responsive.w(70),
                                image: AssetImage("assets/icons/Mask group.png"),
                              );
                            }
                          },
                        ),
                      ),
                      StreamBuilder<UserModel>(
                        stream: UserRepository.fetchCurrentUserStream(),
                        builder: (context, snapshot) {
                          String weight = "0 LBS";

                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isFighter) {
                            final fighterData =
                                snapshot.data!.roleData as FighterDataModel;
                            weight =
                                fighterData.weight != null &&
                                    fighterData.weight!.isNotEmpty
                                ? "${fighterData.weight} LBS"
                                : "0 LBS";
                          }

                          return RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              weight,
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.18),
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(40),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // 🔹 Wins / Losses / Knockouts with dynamic data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String wins = "0", losses = "0", knockouts = "0";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isFighter) {
                      final fighterData =
                          snapshot.data!.roleData as FighterDataModel;
                      wins = fighterData.fightWin.toString();
                      losses = fighterData.fightsLose.toString();
                      knockouts = fighterData.fightsKnockout.toString();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard("Wins", wins),
                        _buildStatCard("Losses", losses),
                        _buildStatCard("Knockouts", knockouts),
                      ],
                    );
                  },
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Coach Name with dynamic data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String coachName = "Not set";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isFighter) {
                      final fighterData =
                          snapshot.data!.roleData as FighterDataModel;
                      coachName = fighterData.coachName.isEmpty
                          ? "Not set"
                          : fighterData.coachName;
                    }

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                        border: BoxBorder.all(
                          color: AppColor.white.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Coach Name",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                            Text(
                              coachName,
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Fights",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),

                    // SizedBox(width: Responsive.w(5)),
                    Row(
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
                  ],
                ),

                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: SizedBox(
                          child: Container(
                            width: Responsive.w(50),
                            height: Responsive.h(100),

                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                color: AppColor.white.withValues(alpha: 0.1),
                                // width: Responsive.w(0),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                      "assets/images/Frame 1000002190.png",
                                    ),
                                  ),
                                  SizedBox(height: Responsive.h(1)),

                                  Text(
                                    "Jake “The Beast” Miller - 🏆 Win (KO)",
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontFamily: AppFonts.appFont,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.sp(10),
                                    ),
                                  ),
                                  SizedBox(height: Responsive.h(1)),

                                  Row(
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
                
                // Active Events Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Events",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                    Row(
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
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                
                // Active Events List
                SizedBox(
                  height: 200,
                  child: StreamBuilder<List<EventModel>>(
                    stream: EventService().getActiveEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: AppColor.red),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading events',
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: Responsive.sp(10),
                            ),
                          ),
                        );
                      }

                      final events = snapshot.data ?? [];

                      if (events.isEmpty) {
                        return Center(
                          child: Text(
                            'No active events available',
                            style: TextStyle(
                              color: AppColor.white.withValues(alpha: 0.7),
                              fontSize: Responsive.sp(10),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: SizedBox(
                              child: Container(
                                width: Responsive.w(50),
                                height: Responsive.h(100),
                                decoration: BoxDecoration(
                                  border: BoxBorder.all(
                                    color: AppColor.white.withValues(alpha: 0.1),
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Event Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: event.thumbnailImageUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: event.thumbnailImageUrl!,
                                                width: double.infinity,
                                                height: Responsive.h(12),
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url, error) => Container(
                                                  height: Responsive.h(12),
                                                  color: AppColor.white.withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: AppColor.white.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: Responsive.h(12),
                                                color: AppColor.white.withValues(alpha: 0.1),
                                                child: Icon(
                                                  Icons.image,
                                                  color: AppColor.white.withValues(alpha: 0.5),
                                                ),
                                              ),
                                      ),
                                      SizedBox(height: Responsive.h(1)),
                                      
                                      // Event Title
                                      Expanded(
                                        child: Text(
                                          event.eventTitle,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.sp(10),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: Responsive.h(1)),
                                      
                                      // View Detail Button
                                      GestureDetector(
                                        onTap: () {
                                          _showEventDetailsBottomSheet(context, event);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "View Detail",
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
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: Responsive.h(2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Stat Card
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: Responsive.w(27),
      height: Responsive.w(22),
      decoration: BoxDecoration(
        color: AppColor.black,
        border: BoxBorder.all(
          color: AppColor.white.withValues(alpha: 0.1),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
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
                fontSize: Responsive.sp(10.5),
              ),
            ),
            Text(
              value,
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
    );
  }

  /// Extract city and country from location data
  String? _extractCityAndCountry(String? locationData) {
    if (locationData == null || locationData.isEmpty) {
      return null;
    }

    // Debug: Print the raw location data to see what we're working with
    print("Raw location data: '$locationData'");

    // Check if it's coordinates (contains only numbers, dots, minus signs and comma)
    if (RegExp(r'^[\d\.-]+,\s*[\d\.-]+$').hasMatch(locationData.trim())) {
      // This is coordinates format like "latitude, longitude"
      print("Detected coordinates format: $locationData");
      return "Location set"; // Generic message for coordinates
    }

    // Check if it's a JSON-like string or other format
    if (locationData.startsWith('{') || locationData.contains('latitude') || locationData.contains('longitude')) {
      print("Detected complex location data: $locationData");
      return "Location set"; // Generic message for complex data
    }

    // If it's an address string, parse it
    final parts = locationData.split(',').map((e) => e.trim()).toList();
    print("Address parts: $parts");
    
    if (parts.length >= 4) {
      // For US format: "Street, City, State ZipCode, Country"
      // Extract city (index length-3) and country (last index)
      final city = parts[parts.length - 3];
      final country = parts[parts.length - 1];
      return "$city, $country";
    } else if (parts.length == 3) {
      // For format: "Street, City, Country"
      final city = parts[1];
      final country = parts[2];
      return "$city, $country";
    } else if (parts.length == 2) {
      // For format: "City, Country"
      final city = parts[0];
      final country = parts[1];
      return "$city, $country";
    } else if (parts.length == 1) {
      // If only one part, return it as is
      return parts[0];
    }
    
    return locationData; // Fallback to original data
  }

  /// Show event details bottom sheet with send request functionality
  void _showEventDetailsBottomSheet(BuildContext context, EventModel event) {
    showModalBottomSheet(
      context: context,
      barrierColor: AppColor.white.withValues(alpha: 0.2),
      isScrollControlled: true,
      backgroundColor: AppColor.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: Responsive.w(5),
                right: Responsive.w(5),
                top: Responsive.h(3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Event Details",
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontSize: Responsive.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: event.thumbnailImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: event.thumbnailImageUrl!,
                            width: double.infinity,
                            height: Responsive.h(25),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: Responsive.h(25),
                              color: AppColor.white.withValues(alpha: 0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.red,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: Responsive.h(25),
                              color: AppColor.white.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.image,
                                color: AppColor.white.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Container(
                            height: Responsive.h(25),
                            color: AppColor.white.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.image,
                              color: AppColor.white.withValues(alpha: 0.5),
                            ),
                          ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Title
                  Text(
                    event.eventTitle,
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Responsive.h(1)),

                  // Event Description
                  Text(
                    event.description,
                    style: GoogleFonts.dmSans(
                      color: AppColor.white.withValues(alpha: 0.8),
                      fontSize: Responsive.sp(12),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  Divider(
                    color: AppColor.white.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: Responsive.h(1)),

                  // Host Information
                  if (event.promoterProfileImage != null)
                    Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: event.promoterProfileImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColor.white.withValues(alpha: 0.1),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.red,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColor.white.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.person,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.promoterName,
                              style: GoogleFonts.dmSans(
                                color: AppColor.white,
                                fontSize: Responsive.sp(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hosted By",
                              style: GoogleFonts.dmSans(
                                color: AppColor.white.withValues(alpha: 0.7),
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(height: Responsive.h(1)),

                  // Event Details
                  _buildDetailRow("Event Date", DateFormat('MMMM dd, yyyy').format(event.eventDate)),
                  _buildDetailRow("Event Time", event.eventTime),
                  _buildDetailRow("Location", event.location),
                  _buildDetailRow("Event Type", event.eventType),
                  _buildDetailRow("Weight Class", event.weightClass),
                  _buildDetailRow("Required Record", event.requiredRecord),
                  _buildDetailRow("Age Limit", event.ageLimit),
                  _buildDetailRow("Fighting Style Preferred", event.fightingStylePreferred),
                  _buildDetailRow(
                    "Deadline to Apply",
                    DateFormat('MMMM dd, yyyy').format(event.deadlineToApply),
                  ),
                  
                  SizedBox(height: Responsive.h(2)),
                  
                  // Send Request Button
                  _SendRequestButton(event: event),
                  
                  SizedBox(height: Responsive.h(2)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$label: ",
              style: GoogleFonts.dmSans(
                color: AppColor.white,
                fontSize: Responsive.sp(9),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                color: AppColor.white,
                fontSize: Responsive.sp(9),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// Send Request Button Widget
class _SendRequestButton extends StatefulWidget {
  final EventModel event;

  const _SendRequestButton({required this.event});

  @override
  State<_SendRequestButton> createState() => _SendRequestButtonState();
}

class _SendRequestButtonState extends State<_SendRequestButton> {
  bool _hasSentRequest = false;
  bool _isLoading = false;
  StreamSubscription? _interestSubscription;

  @override
  void initState() {
    super.initState();
    _checkRequestStatus();
    _listenToRequestChanges();
  }

  @override
  void dispose() {
    _interestSubscription?.cancel();
    super.dispose();
  }

  void _listenToRequestChanges() {
    final fighterId = Utils.getCurrentUid();
    _interestSubscription = EventInterestRepository
        .getInterestsByFighter(fighterId)
        .listen((interests) {
      final hasRequest = interests.any(
        (interest) => interest.eventId == widget.event.id,
      );
      
      if (mounted && _hasSentRequest != hasRequest) {
        setState(() {
          _hasSentRequest = hasRequest;
        });
      }
    });
  }

  Future<void> _checkRequestStatus() async {
    try {
      final fighterId = Utils.getCurrentUid();
      final hasRequest = await EventInterestRepository.hasFighterShownInterest(
        widget.event.id,
        fighterId,
      );
      
      if (mounted) {
        setState(() {
          _hasSentRequest = hasRequest;
        });
      }
    } catch (e) {
      // Error checking, but continue
    }
  }

  Future<void> _handleSendRequest() async {
    // Prevent multiple taps
    if (_isLoading || _hasSentRequest) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Double check before creating
      final fighterId = Utils.getCurrentUid();
      final alreadyRequested = await EventInterestRepository.hasFighterShownInterest(
        widget.event.id,
        fighterId,
      );

      if (alreadyRequested) {
        if (mounted) {
          setState(() {
            _hasSentRequest = true;
            _isLoading = false;
          });
          Utils.flushBarErrorMassage(
            'You have already sent a request for this event',
            context,
          );
        }
        return;
      }

      // Create interest and get interest ID
      final interestId = await EventInterestRepository.createEventInterest(widget.event);

      // Update state IMMEDIATELY before doing other async operations
      if (mounted) {
        setState(() {
          _hasSentRequest = true;
          _isLoading = false;
        });
      }

      // Get fighter name for notification
      final fighterDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(fighterId)
          .get();
      
      String fighterName = 'A fighter';
      if (fighterDoc.exists && fighterDoc.data() != null) {
        final data = fighterDoc.data()!;
        if (data['fighterData'] != null && data['fighterData'] is Map) {
          final fighterData = data['fighterData'] as Map<String, dynamic>;
          fighterName =
              fighterData['fullName'] ??
              fighterData['name'] ??
              fighterData['displayName'] ??
              'A fighter';
        }
      }

      // Send notification to promoter (non-blocking)
      NotificationService.sendEventInterestNotification(
        promoterId: widget.event.promoterId,
        fighterName: fighterName,
        eventTitle: widget.event.eventTitle,
        eventId: widget.event.id,
        interestId: interestId,
      ).catchError((e) {
        // Notification failed, but interest was created successfully
        print('Notification error: $e');
      });

      // Show success message
      if (mounted) {
        Utils.flushBarErrorMassage(
          'Request sent! The promoter will be notified.',
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Utils.flushBarErrorMassage(
          'Error: ${e.toString()}',
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _hasSentRequest,
      child: Opacity(
        opacity: _hasSentRequest ? 0.6 : 1.0,
        child: AuthButton(
          buttontext: _hasSentRequest ? "Request Sent" : "Send Request",
          onPress: _handleSendRequest,
          loading: _isLoading,
        ),
      ),
    );
  }
}
