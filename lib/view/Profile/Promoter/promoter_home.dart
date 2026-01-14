import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/fighter_personal_profile.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/services/event_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class PromoterHome extends StatefulWidget {
  final AdvancedDrawerController? drawerController;
  const PromoterHome({super.key, this.drawerController});

  @override
  State<PromoterHome> createState() => _PromoterHomeState();
}

class _PromoterHomeState extends State<PromoterHome> {
  final EventService _eventService = EventService();

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
                // 🔹 Header Row with StreamBuilder for promoter data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/icons/Group 9.svg"),

                    /// ✅ StreamBuilder for promoter data
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

                        if (!user.isPromoter) {
                          return Column(
                            children: [
                              Text(
                                "Hi👋 User",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(18),
                                ),
                              ),
                              Text(
                                "Not a promoter",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                            ],
                          );
                        }

                        final promoter = user.roleData as PromoterDataModel;
                        final promoterName =
                            promoter.prompterName ?? "Promoter";
                        final location =
                            promoter.location ?? "Location not set";

                        return Column(
                          children: [
                            Text(
                              "Hi👋 $promoterName",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(18),
                              ),
                            ),
                            Text(
                              location,
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(10.5),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // Menu button for drawer
                    GestureDetector(
                      onTap: () {
                        widget.drawerController?.showDrawer();
                      },
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

                SizedBox(height: Responsive.h(2)),

                // 🔹 Company Logo and Name Section
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String companyName = "Company Name";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isPromoter) {
                      final promoterData =
                          snapshot.data!.roleData as PromoterDataModel;
                      companyName = promoterData.companyName ?? "Company Name";
                    }

                    return Container(
                      color: AppColor.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Image(
                              width: Responsive.w(70),
                              image: const AssetImage(
                                "assets/icons/Mask group.png",
                              ),
                            ),
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              companyName,
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.18),
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 🔹 Stats Cards with dynamic promoter data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String numberOfEvents = "0";
                    String totalEvents = "0";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isPromoter) {
                      final promoterData =
                          snapshot.data!.roleData as PromoterDataModel;
                      numberOfEvents = (promoterData.numberOfEvents ?? 0)
                          .toString();
                      totalEvents = (promoterData.numberOfEvents ?? 0)
                          .toString();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard("Events", numberOfEvents),
                        _buildStatCard("Total Events", totalEvents),
                      ],
                    );
                  },
                ),

                SizedBox(height: Responsive.h(2)),

                // 🔹 Company Info Section
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String companyName = "Not set";
                    String contactEmail = "Not set";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isPromoter) {
                      final promoterData =
                          snapshot.data!.roleData as PromoterDataModel;
                      companyName = promoterData.companyName ?? "Not set";
                      contactEmail = promoterData.contactEmail ?? "Not set";
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Company Name",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                Text(
                                  companyName,
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.h(1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Contact Email",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                Text(
                                  contactEmail,
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: Responsive.h(2)),

                // 🔹 Recent Events
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Events",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.textScaleFactor * 14,
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
                            fontSize: Responsive.textScaleFactor * 14,
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        SvgPicture.asset("assets/icons/Vector (2).svg"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Recent Events - Fetch from Firestore
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColor.red),
                        ),
                      );
                    }

                    final currentUserId = userSnapshot.data!.id;

                    return SizedBox(
                      height: 300,
                      child: StreamBuilder<List<EventModel>>(
                        stream: _eventService.getEventsByPromoter(currentUserId),
                        builder: (context, eventsSnapshot) {
                          if (eventsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.red,
                              ),
                            );
                          }

                          if (eventsSnapshot.hasError) {
                            print('Error loading events for promoter: ${eventsSnapshot.error}');
                            print('Promoter ID: $currentUserId');
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Error loading events',
                                    style: TextStyle(color: AppColor.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${eventsSnapshot.error}',
                                    style: TextStyle(
                                      color: AppColor.white.withValues(alpha: 0.7),
                                      fontSize: Responsive.sp(10),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          final events = eventsSnapshot.data ?? [];
                          print('Loaded ${events.length} events for promoter: $currentUserId');

                          if (events.isEmpty) {
                            print('No events found for promoter: $currentUserId');
                            return Center(
                              child: Text(
                                'No events yet',
                                style: TextStyle(color: AppColor.white),
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
                                child: Container(
                                  width: Responsive.w(80),
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
                                        Expanded(
                                          child: event.thumbnailImageUrl != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl: event.thumbnailImageUrl!,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) => Container(
                                                      color: AppColor.white.withValues(alpha: 0.1),
                                                      child: Icon(
                                                        Icons.image,
                                                        color: AppColor.white.withValues(alpha: 0.5),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  color: AppColor.white.withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: AppColor.white.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                        ),
                                        SizedBox(height: Responsive.h(1)),
                                        Text(
                                          event.eventTitle,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.textScaleFactor * 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: Responsive.h(1)),
                                        GestureDetector(
                                          onTap: () => _showEventDetailsBottomSheet(
                                            context,
                                            event,
                                          ),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadiusDirectional.circular(22),
                                              color: AppColor.white.withValues(alpha: 0.1),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "View Details",
                                                  style: GoogleFonts.dmSans(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Responsive.textScaleFactor * 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Fighter Scouting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Fighter Scouting",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.textScaleFactor * 14,
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
                            fontSize: Responsive.textScaleFactor * 14,
                          ),
                        ),
                        SizedBox(width: Responsive.w(2)),
                        SvgPicture.asset("assets/icons/Vector (2).svg"),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(2)),

                SizedBox(
                  height: Responsive.h(30),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                            width: Responsive.w(50),
                            height: Responsive.h(50),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: Responsive.sp(34),
                                        backgroundImage: AssetImage(
                                          "assets/images/Frame 1000002190.png",
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "4.7",
                                            style: TextStyle(
                                              color: AppColor.white,
                                              fontFamily: AppFonts.appFont,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Responsive.textScaleFactor *
                                                  14,
                                            ),
                                          ),
                                          SizedBox(width: Responsive.w(1)),
                                          SvgPicture.asset(
                                            "assets/icons/Vector (3).svg",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.h(2)),
                                  Text(
                                    "Corey Herwitz",
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontFamily: AppFonts.appFont,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Responsive.textScaleFactor * 14,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.h(1)),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/location-05 (1).svg",
                                      ),
                                      SizedBox(width: Responsive.w(1)),
                                      Text(
                                        "San Francisco, CA",
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontFamily: AppFonts.appFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              Responsive.textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.h(1)),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FighterPublicProfile(),
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                              22,
                                            ),
                                        color: AppColor.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "View Profile",
                                            style: GoogleFonts.dmSans(
                                              color: AppColor.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Responsive.textScaleFactor *
                                                  12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                        ),
                      );
                    },
                  ),
                ),
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
      width: Responsive.w(45),
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
}

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
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Fight Details",
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

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColor.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(0.5)),

                  // Additional Info Section
                  _buildDetailRow("Date", DateFormat('MMMM d, yyyy').format(event.eventDate)),
                  _buildDetailRow("Time", event.eventTime),
                  _buildDetailRow("Location", event.location),

                  SizedBox(height: Responsive.h(0.5)),
                  SvgPicture.asset("assets/images/Frame 1000002180.svg"),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.red),
                      borderRadius: BorderRadius.circular(22),
                      color: AppColor.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Open Map",
                          style: GoogleFonts.dmSans(
                            color: AppColor.white,
                            fontSize: Responsive.sp(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildDetailRow("Event Type", event.eventType),
                  _buildDetailRow("Weight Class", event.weightClass),
                  _buildDetailRow("Required Record", event.requiredRecord),
                  _buildDetailRow("Age Limit", event.ageLimit),
                  _buildDetailRow("Fighting Style Preferred", event.fightingStylePreferred),
                  _buildDetailRow("Deadline to Apply", DateFormat('MMMM d, yyyy').format(event.deadlineToApply)),
                  // Action Button
                  AuthButton(
                    buttontext: "Edit",
                    onPress: () {
                      // _ratePromoterBottomSheet(context);
                      Navigator.pop(context);

                      // Utils.flushBarErrorMassage("Rate Promoter", context);
                    },
                    loading: false,
                  ),
                  SizedBox(height: Responsive.h(2)),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Responsive.h(1)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.dmSans(
            color: AppColor.white,
            fontSize: Responsive.sp(9),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            color: AppColor.white,
            fontSize: Responsive.sp(9),
          ),
        ),
      ],
    ),
  );
}
