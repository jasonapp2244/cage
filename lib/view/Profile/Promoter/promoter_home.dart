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
import 'package:cage/models/fighter_model.dart';
import 'package:cage/services/event_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cage/models/event_interest_model.dart';
import 'package:cage/repository/event_interest_repository.dart';
import 'package:cage/repository/subscription_repository.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PromoterHome extends StatefulWidget {
  final AdvancedDrawerController? drawerController;
  const PromoterHome({super.key, this.drawerController});

  @override
  State<PromoterHome> createState() => _PromoterHomeState();
}

class _PromoterHomeState extends State<PromoterHome> {
  final EventService _eventService = EventService();

  /// Validates if a URL is a valid image URL
  /// Returns false for social media page URLs (Instagram, Facebook, etc.)
  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    // Check if URL contains common social media domains (not image URLs)
    final invalidDomains = [
      'instagram.com',
      'facebook.com',
      'twitter.com',
      'linkedin.com',
      'youtube.com',
    ];

    final lowerUrl = url.toLowerCase();
    for (var domain in invalidDomains) {
      if (lowerUrl.contains(domain) &&
          !lowerUrl.contains('/p/') &&
          !lowerUrl.contains('/photo/')) {
        return false;
      }
    }

    // Check if URL ends with common image extensions or contains image indicators
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
    final hasImageExtension = imageExtensions.any(
      (ext) => lowerUrl.contains(ext),
    );

    // Allow URLs that have image extensions or are from known image hosting services
    final imageHostingServices = [
      'i.imgur.com',
      'imgur.com',
      'postimg.cc',
      'cloudinary.com',
      'storage.googleapis.com',
      'firebasestorage.googleapis.com',
      'amazonaws.com',
      'devonlinetestserver.com',
    ];

    final isImageHosting = imageHostingServices.any(
      (service) => lowerUrl.contains(service),
    );

    return hasImageExtension || isImageHosting;
  }

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
                          Expanded(
                            child: Text(
                              companyName,
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.18),
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(40),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 0.0),
                          //   child: Image(
                          //     width: Responsive.w(70),
                          //     image: const AssetImage(
                          //       "assets/icons/Mask group.png",
                          //     ),
                          //   ),
                          // ),
                          // RotatedBox(
                          //   quarterTurns: 4,
                          //   child: Text(
                          //     companyName,
                          //     style: TextStyle(
                          //       color: AppColor.white.withValues(alpha: 0.18),
                          //       fontFamily: AppFonts.appFont,
                          //       fontWeight: FontWeight.normal,
                          //       fontSize: Responsive.sp(40),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                ),

                // 🔹 Stats Cards with dynamic promoter data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard("Total Events", "0"),
                          _buildStatCard("Events", "0"),
                        ],
                      );
                    }

                    final currentUserId = userSnapshot.data!.id;

                    return StreamBuilder<List<EventModel>>(
                      stream: _eventService.getEventsByPromoter(currentUserId),
                      builder: (context, eventsSnapshot) {
                        String totalEvents = "0";
                        String activeEvents = "0";

                        if (eventsSnapshot.hasData) {
                          final events = eventsSnapshot.data ?? [];
                          totalEvents = events.length.toString();

                          // Count active events (not past, deadline not passed)
                          final now = DateTime.now();
                          activeEvents = events
                              .where((event) {
                                final isPast = event.eventDate.isBefore(now);
                                final deadlinePassed = event.deadlineToApply
                                    .isBefore(now);
                                return !isPast && !deadlinePassed;
                              })
                              .length
                              .toString();
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard("Total Events", totalEvents),
                            _buildStatCard("Active Events", activeEvents),
                          ],
                        );
                      },
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

                // 🔹 Recent Events - Fetch all active events from all promoters (including mine)
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
                        stream: _eventService.getActiveEvents(),
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
                            print(
                              'Error loading events: ${eventsSnapshot.error}',
                            );
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
                                      color: AppColor.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: Responsive.sp(10),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          final allEvents = eventsSnapshot.data ?? [];
                          
                          // Sort events: user's own events first, then others
                          final sortedEvents = List<EventModel>.from(allEvents);
                          sortedEvents.sort((a, b) {
                            final aIsMine = a.promoterId == currentUserId;
                            final bIsMine = b.promoterId == currentUserId;
                            
                            // If one is mine and the other isn't, mine comes first
                            if (aIsMine && !bIsMine) return -1;
                            if (!aIsMine && bIsMine) return 1;
                            
                            // If both are mine or both are not mine, sort by date (soonest first)
                            return a.eventDate.compareTo(b.eventDate);
                          });
                          
                          print(
                            'Loaded ${sortedEvents.length} events from all promoters (including ${sortedEvents.where((e) => e.promoterId == currentUserId).length} of mine)',
                          );

                          if (sortedEvents.isEmpty) {
                            return Center(
                              child: Text(
                                'No events yet',
                                style: TextStyle(color: AppColor.white),
                              ),
                            );
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortedEvents.length,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            itemBuilder: (context, index) {
                              final event = sortedEvents[index];
                              final isMyEvent = event.promoterId == currentUserId;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                ),
                                child: Container(
                                  width: Responsive.w(80),
                                  height: Responsive.h(100),
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      color: isMyEvent
                                          ? AppColor.red.withValues(alpha: 0.8)
                                          : AppColor.white.withValues(
                                              alpha: 0.1,
                                            ),
                                      width: isMyEvent ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: event.thumbnailImageUrl != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl: event
                                                        .thumbnailImageUrl!,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                              color: AppColor
                                                                  .white
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                              child: Icon(
                                                                Icons.image,
                                                                color: AppColor
                                                                    .white
                                                                    .withValues(
                                                                      alpha:
                                                                          0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                  ),
                                                )
                                              : Container(
                                                  color: AppColor.white
                                                      .withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: AppColor.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                        ),
                                        SizedBox(height: Responsive.h(1)),
                                        if (isMyEvent)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.red,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "My Event",
                                              style: TextStyle(
                                                color: AppColor.white,
                                                fontFamily: AppFonts.appFont,
                                                fontSize: Responsive.sp(8),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (isMyEvent) SizedBox(height: Responsive.h(0.5)),
                                        Text(
                                          event.eventTitle,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Responsive.textScaleFactor * 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: Responsive.h(1)),
                                        GestureDetector(
                                          onTap: () =>
                                              _showEventDetailsBottomSheet(
                                                context,
                                                event,
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
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(
                                                  "View Details",
                                                  style: GoogleFonts.dmSans(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        Responsive
                                                            .textScaleFactor *
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
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Subscribed Fighters Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subscribed Fighters",
                      style: TextStyle(
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.textScaleFactor * 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                
                // Subscribed Fighters List
                StreamBuilder<List<UserModel>>(
                  stream: SubscriptionRepository.getSubscribedFighters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColor.red),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print('Error loading subscribed fighters: ${snapshot.error}');
                      }
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'Error loading fighters',
                            style: TextStyle(
                              color: AppColor.white.withValues(alpha: 0.7),
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                      );
                    }

                    final fighters = snapshot.data ?? [];

                    if (fighters.isEmpty) {
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'No subscribed fighters available',
                            style: TextStyle(
                              color: AppColor.white.withValues(alpha: 0.7),
                              fontSize: Responsive.sp(12),
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fighters.length,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, index) {
                          final fighter = fighters[index];
                          final fighterData = fighter.roleData as FighterDataModel;
                          
                          // Calculate average rating
                          final reviews = fighterData.reviews;
                          final averageRating = SubscriptionRepository.calculateAverageRating(reviews);
                          
                          // Get profile image
                          final profileImageUrl = fighterData.profileImageUrl ?? 
                                                (fighterData.urlProfile.isNotEmpty && fighterData.urlProfile != 'https' 
                                                  ? fighterData.urlProfile 
                                                  : null) ??
                                                fighterData.uploadProfile;
                          
                          // Get location
                          String location = "Location not set";
                          if (fighterData.location != null && fighterData.location!.isNotEmpty) {
                            location = fighterData.location!;
                            // Extract city and state if it's a full address
                            final parts = location.split(',');
                            if (parts.length >= 2) {
                              location = "${parts[parts.length - 2].trim()}, ${parts[parts.length - 1].trim()}";
                            }
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: Responsive.w(45),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColor.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile Image with Rating
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: profileImageUrl != null && 
                                               profileImageUrl.isNotEmpty &&
                                               profileImageUrl != 'https'
                                            ? CachedNetworkImage(
                                                imageUrl: profileImageUrl,
                                                width: double.infinity,
                                                height: Responsive.h(18),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => Container(
                                                  height: Responsive.h(18),
                                                  color: AppColor.white.withValues(alpha: 0.1),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      color: AppColor.red,
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  height: Responsive.h(18),
                                                  color: AppColor.white.withValues(alpha: 0.1),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: AppColor.white.withValues(alpha: 0.5),
                                                    size: 40,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: Responsive.h(18),
                                                color: AppColor.white.withValues(alpha: 0.1),
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppColor.white.withValues(alpha: 0.5),
                                                  size: 40,
                                                ),
                                              ),
                                      ),
                                      // Rating Badge
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.black.withValues(alpha: 0.7),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: AppColor.red,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                averageRating > 0 
                                                    ? averageRating.toStringAsFixed(1)
                                                    : '0.0',
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
                                      ),
                                    ],
                                  ),
                                  
                                  // Fighter Name and Location
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fighterData.fullName,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontFamily: AppFonts.appFont,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Responsive.sp(14),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: AppColor.white.withValues(alpha: 0.7),
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                location,
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
                                        SizedBox(height: 8),
                                        
                                        // View Profile Button
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FighterPublicProfile(
                                                  userData: fighter,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                              color: AppColor.white.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "View Profile",
                                                style: TextStyle(
                                                  color: AppColor.white,
                                                  fontFamily: AppFonts.appFont,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Responsive.sp(12),
                                                ),
                                              ),
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
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Requested Section (Fighters interested in events) - Only show when requests are available
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final currentUserId = userSnapshot.data!.id;

                    return StreamBuilder<List<EventInterestModel>>(
                      stream:
                          EventInterestRepository.getPendingInterestsForPromoter(
                            currentUserId,
                          ),
                      builder: (context, interestsSnapshot) {
                        // Don't show anything while loading or if there's an error
                        if (interestsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        if (interestsSnapshot.hasError) {
                          if (kDebugMode) {
                            print(
                              'Error loading requests: ${interestsSnapshot.error}',
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        final interests = interestsSnapshot.data ?? [];

                        // Only show the section if there are requests
                        if (interests.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        // Show the section when requests are available
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Requested",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Responsive.textScaleFactor * 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.h(2)),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: interests.length,
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                itemBuilder: (context, index) {
                                  final interest = interests[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _showFighterDetailsBottomSheet(
                                        context,
                                        interest,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: Container(
                                        width: Responsive.w(70),
                                        decoration: BoxDecoration(
                                          border: BoxBorder.all(
                                            color: AppColor.white.withValues(
                                              alpha: 0.1,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  if (interest.fighterProfileImage !=
                                                          null &&
                                                      _isValidImageUrl(
                                                        interest
                                                            .fighterProfileImage!,
                                                      ))
                                                    ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: interest
                                                            .fighterProfileImage!,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (
                                                              context,
                                                              url,
                                                            ) => CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColor.white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.1,
                                                                      ),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color:
                                                                        AppColor
                                                                            .red,
                                                                  ),
                                                            ),
                                                        errorWidget:
                                                            (
                                                              context,
                                                              url,
                                                              error,
                                                            ) => CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  AppColor.white
                                                                      .withValues(
                                                                        alpha:
                                                                            0.1,
                                                                      ),
                                                              child: Icon(
                                                                Icons.person,
                                                                color: AppColor
                                                                    .white,
                                                              ),
                                                            ),
                                                      ),
                                                    )
                                                  else
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: AppColor
                                                          .white
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                                      child: Icon(
                                                        Icons.person,
                                                        color: AppColor.white,
                                                      ),
                                                    ),
                                                  SizedBox(
                                                    width: Responsive.w(2),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          interest.fighterName,
                                                          style: TextStyle(
                                                            color:
                                                                AppColor.white,
                                                            fontFamily: AppFonts
                                                                .appFont,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                Responsive.sp(
                                                                  12,
                                                                ),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          'Interested in',
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .white
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                            fontFamily: AppFonts
                                                                .appFont,
                                                            fontSize:
                                                                Responsive.sp(
                                                                  9,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: Responsive.h(1)),
                                              Text(
                                                interest.eventTitle,
                                                style: TextStyle(
                                                  color: AppColor.white,
                                                  fontFamily: AppFonts.appFont,
                                                  fontSize: Responsive.sp(10),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: Responsive.h(1)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await EventInterestRepository.updateInterestStatus(
                                                        interest.id,
                                                        'accepted',
                                                      );
                                                      if (context.mounted) {
                                                        Utils.flushBarErrorMassage(
                                                          'Request accepted',
                                                          context,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize:
                                                              Responsive.sp(9),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await EventInterestRepository.updateInterestStatus(
                                                        interest.id,
                                                        'rejected',
                                                      );
                                                      if (context.mounted) {
                                                        Utils.flushBarErrorMassage(
                                                          'Request rejected',
                                                          context,
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize:
                                                              Responsive.sp(9),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
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
                          ],
                        );
                      },
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                Responsive.textScaleFactor * 14,
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
                                          BorderRadiusDirectional.circular(22),
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
                                                Responsive.textScaleFactor * 12,
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
                    _buildDetailRow(
                      "Date",
                      DateFormat('MMMM d, yyyy').format(event.eventDate),
                    ),
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
                    _buildDetailRow(
                      "Fighting Style Preferred",
                      event.fightingStylePreferred,
                    ),
                    _buildDetailRow(
                      "Deadline to Apply",
                      DateFormat('MMMM d, yyyy').format(event.deadlineToApply),
                    ),
                    // Action Button
                    AuthButton(
                      buttontext: "Edit",
                      onPress: () {
                        Navigator.pop(context);
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

  // Fetch fighter details from Firestore
  Future<Map<String, dynamic>?> _fetchFighterDetails(String fighterId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(fighterId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching fighter details: $e');
      }
      rethrow;
    }
  }

  // Show fighter details bottom sheet
  void _showFighterDetailsBottomSheet(
    BuildContext context,
    EventInterestModel interest,
  ) {
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
          return FutureBuilder<Map<String, dynamic>?>(
            future: _fetchFighterDetails(interest.fighterId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColor.red),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.w(5)),
                    child: Column(
                      children: [
                        Text(
                          'Error loading fighter details',
                          style: TextStyle(color: AppColor.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          snapshot.error?.toString() ?? 'Unknown error',
                          style: TextStyle(
                            color: AppColor.white.withValues(alpha: 0.7),
                            fontSize: Responsive.sp(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final fighterData = snapshot.data!;
              final fighterInfo =
                  fighterData['fighterData'] as Map<String, dynamic>?;
              final email = fighterData['email'] ?? '';

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Fighter Details",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontSize: Responsive.sp(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Responsive.h(2)),

                      // Fighter Profile Image and Name
                      Center(
                        child: Column(
                          children: [
                            if (interest.fighterProfileImage != null &&
                                _isValidImageUrl(interest.fighterProfileImage!))
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: interest.fighterProfileImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.red,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColor.white
                                            .withValues(alpha: 0.1),
                                        child: Icon(
                                          Icons.person,
                                          color: AppColor.white,
                                          size: 50,
                                        ),
                                      ),
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColor.white.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: AppColor.white,
                                  size: 50,
                                ),
                              ),
                            SizedBox(height: Responsive.h(1)),
                            Text(
                              interest.fighterName,
                              style: GoogleFonts.dmSans(
                                color: AppColor.white,
                                fontSize: Responsive.sp(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: GoogleFonts.dmSans(
                                  color: AppColor.white.withValues(alpha: 0.7),
                                  fontSize: Responsive.sp(12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: Responsive.h(2)),

                      // Event Information
                      Text(
                        "Interested In Event:",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontSize: Responsive.sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          interest.eventTitle,
                          style: GoogleFonts.dmSans(
                            color: AppColor.white,
                            fontSize: Responsive.sp(14),
                          ),
                        ),
                      ),
                      SizedBox(height: Responsive.h(2)),

                      Divider(color: AppColor.white.withValues(alpha: 0.2)),
                      SizedBox(height: Responsive.h(1)),

                      // Fighter Information
                      if (fighterInfo != null) ...[
                        Text(
                          "Fighter Information",
                          style: GoogleFonts.dmSans(
                            color: AppColor.white,
                            fontSize: Responsive.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Responsive.h(1)),

                        if (fighterInfo['fullName'] != null)
                          _buildDetailRow(
                            "Full Name",
                            fighterInfo['fullName'] ?? 'N/A',
                          ),
                        if (fighterInfo['age'] != null)
                          _buildDetailRow("Age", fighterInfo['age'].toString()),
                        if (fighterInfo['height'] != null)
                          _buildDetailRow(
                            "Height",
                            fighterInfo['height'] ?? 'N/A',
                          ),
                        if (fighterInfo['weight'] != null)
                          _buildDetailRow(
                            "Weight",
                            fighterInfo['weight']?.toString() ?? 'N/A',
                          ),
                        if (fighterInfo['fightingStyle'] != null)
                          _buildDetailRow(
                            "Fighting Style",
                            fighterInfo['fightingStyle'] ?? 'N/A',
                          ),
                        if (fighterInfo['fightWin'] != null ||
                            fighterInfo['fightsLose'] != null)
                          _buildDetailRow(
                            "Record",
                            "${fighterInfo['fightWin'] ?? 0}W - ${fighterInfo['fightsLose'] ?? 0}L",
                          ),
                        if (fighterInfo['fightsKnockout'] != null)
                          _buildDetailRow(
                            "KO/TKO",
                            fighterInfo['fightsKnockout'].toString(),
                          ),
                        if (fighterInfo['coachName'] != null)
                          _buildDetailRow(
                            "Coach",
                            fighterInfo['coachName'] ?? 'N/A',
                          ),
                        if (fighterInfo['coachContact'] != null)
                          _buildDetailRow(
                            "Coach Contact",
                            fighterInfo['coachContact'] ?? 'N/A',
                          ),
                        if (fighterInfo['lastExam'] != null)
                          _buildDetailRow(
                            "Last Medical Exam",
                            fighterInfo['lastExam'] ?? 'N/A',
                          ),
                        if (fighterInfo['lastBlood'] != null)
                          _buildDetailRow(
                            "Last Blood Test",
                            fighterInfo['lastBlood'].toString(),
                          ),
                      ] else
                        Text(
                          "Fighter information not available",
                          style: GoogleFonts.dmSans(
                            color: AppColor.white.withValues(alpha: 0.7),
                            fontSize: Responsive.sp(12),
                          ),
                        ),

                      SizedBox(height: Responsive.h(2)),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await EventInterestRepository.updateInterestStatus(
                                  interest.id,
                                  'accepted',
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Utils.flushBarErrorMassage(
                                    'Request accepted',
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Accept Request',
                                    style: GoogleFonts.dmSans(
                                      color: AppColor.white,
                                      fontSize: Responsive.sp(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Responsive.w(2)),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await EventInterestRepository.updateInterestStatus(
                                  interest.id,
                                  'rejected',
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Utils.flushBarErrorMassage(
                                    'Request rejected',
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Reject Request',
                                    style: GoogleFonts.dmSans(
                                      color: AppColor.white,
                                      fontSize: Responsive.sp(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(2)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
