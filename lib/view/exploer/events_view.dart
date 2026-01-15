import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:cage/widgets/likes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/repository/event_interest_repository.dart';
import 'package:cage/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  /// Validates if a URL is a valid image URL
  /// Returns false for social media page URLs (Instagram, Facebook, etc.)
  static bool _isValidImageUrl(String url) {
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
      if (lowerUrl.contains(domain) && !lowerUrl.contains('/p/') && !lowerUrl.contains('/photo/')) {
        return false;
      }
    }
    
    // Check if URL ends with common image extensions or contains image indicators
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
    final hasImageExtension = imageExtensions.any((ext) => lowerUrl.contains(ext));
    
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
    
    final isImageHosting = imageHostingServices.any((service) => lowerUrl.contains(service));
    
    return hasImageExtension || isImageHosting;
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                height: Responsive.h(7.0),
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  style: TextStyle(color: AppColor.white),
                  cursorColor: AppColor.red,
                  cursorErrorColor: AppColor.red,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColor.red),
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Responsive.w(3)),
                      child: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.08),
                    hintText: "Search Event ...",
                    hintStyle: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                      fontSize: Responsive.sp(12),
                    ),
                  ),
                ),
              ),

              // Events List
              Expanded(
                child: StreamBuilder<List<EventModel>>(
                  stream: EventService().getActiveEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: AppColor.red),
                      );
                    }

                    if (snapshot.hasError) {
                      print('Error loading events: ${snapshot.error}');
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
                              '${snapshot.error}',
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

                    final events = snapshot.data ?? [];
                    print('Loaded ${events.length} events');

                    if (events.isEmpty) {
                      return Center(
                        child: Text(
                          'No events available',
                          style: TextStyle(color: AppColor.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: events.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final event = events[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        width: Responsive.w(50),
                        height: Responsive.h(36),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColor.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: event.thumbnailImageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: event.thumbnailImageUrl!,
                                        width: double.infinity,
                                        height: Responsive.h(20),
                                        fit: BoxFit.cover,
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
                                        color: AppColor.white.withValues(alpha: 0.1),
                                        child: Icon(
                                          Icons.image,
                                          color: AppColor.white.withValues(alpha: 0.5),
                                        ),
                                      ),
                              ),
                              SizedBox(height: Responsive.h(1)),
                              Text(
                                "Jake \"The Beast\" Miller - � Win (KO)",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(10),
                                ),
                              ),
                              SizedBox(height: Responsive.h(1)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // View Details Button
                                  GestureDetector(
                                    onTap: () {
                                      _showEventDetailsBottomSheet(context, event);
                                    },
                                    child: Container(
                                      width: Responsive.w(40),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: AppColor.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "View Details",
                                          style: GoogleFonts.dmSans(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Interested Button with Status Check
                                  _InterestedButton(event: event),
                                ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ratePromoterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: AppColor.black,
      builder: (context) {
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
                    "Rate Promoter",
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

              TextFormField(
                maxLines: 5,
                style: TextStyle(color: AppColor.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.white.withValues(alpha: 0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  hint: Text(
                    "Describe your experience",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(2)),
              Container(
                width: MediaQuery.sizeOf(context).width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColor.white.withValues(alpha: 0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomRatingBar(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(2)),

              AuthButton(
                buttontext: "Submit",
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Utils.flushBarErrorMassage("Reset link sent!", context);
                },
                loading: false,
              ),
              SizedBox(height: Responsive.h(2)),
            ],
          ),
        );
      },
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

                    // Host Information
                    if (event.promoterProfileImage != null &&
                        _isValidImageUrl(event.promoterProfileImage!))
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

                    // Additional Info Section
                    _buildDetailRow(
                      "Event Date",
                      DateFormat('MMMM dd, yyyy').format(event.eventDate),
                    ),
                    _buildDetailRow("Event Time", event.eventTime),
                    _buildDetailRow("Location", event.location),

                    SizedBox(height: Responsive.h(0.5)),
                    if (event.locationCoordinates != null)
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
                      DateFormat('MMMM dd, yyyy').format(event.deadlineToApply),
                    ),
                    // Action Button
                    AuthButton(
                      buttontext: "Rate Promoter",
                      onPress: () {
                        _ratePromoterBottomSheet(context);
                        // Navigator.pop(context);

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
}

// Interested Button Widget with Status Check
class _InterestedButton extends StatefulWidget {
  final EventModel event;

  const _InterestedButton({required this.event});

  @override
  State<_InterestedButton> createState() => _InterestedButtonState();
}

class _InterestedButtonState extends State<_InterestedButton> {
  bool _hasShownInterest = false;
  bool _isLoading = false;
  StreamSubscription? _interestSubscription;

  @override
  void initState() {
    super.initState();
    _checkInterestStatus();
    _listenToInterestChanges();
  }

  @override
  void dispose() {
    _interestSubscription?.cancel();
    super.dispose();
  }

  void _listenToInterestChanges() {
    final fighterId = Utils.getCurrentUid();
    _interestSubscription = EventInterestRepository
        .getInterestsByFighter(fighterId)
        .listen((interests) {
      final hasInterest = interests.any(
        (interest) => interest.eventId == widget.event.id,
      );
      
      if (mounted && _hasShownInterest != hasInterest) {
        setState(() {
          _hasShownInterest = hasInterest;
        });
      }
    });
  }

  Future<void> _checkInterestStatus() async {
    try {
      final fighterId = Utils.getCurrentUid();
      final hasInterest = await EventInterestRepository.hasFighterShownInterest(
        widget.event.id,
        fighterId,
      );
      
      if (mounted) {
        setState(() {
          _hasShownInterest = hasInterest;
        });
      }
    } catch (e) {
      // Error checking, but continue
    }
  }

  Future<void> _handleInterested() async {
    // Prevent multiple taps
    if (_isLoading || _hasShownInterest) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Double check before creating
      final fighterId = Utils.getCurrentUid();
      final alreadyInterested = await EventInterestRepository.hasFighterShownInterest(
        widget.event.id,
        fighterId,
      );

      if (alreadyInterested) {
        if (mounted) {
          setState(() {
            _hasShownInterest = true;
            _isLoading = false;
          });
          if (mounted) {
            Utils.flushBarErrorMassage(
              'You have already shown interest in this event',
              context,
            );
          }
        }
        return;
      }

      // Create interest and get interest ID
      final interestId = await EventInterestRepository.createEventInterest(widget.event);

      // Update state IMMEDIATELY before doing other async operations
      if (mounted) {
        setState(() {
          _hasShownInterest = true;
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
        if (kDebugMode) {
          print('Notification error: $e');
        }
      });

      // Show success message
      if (mounted) {
        Utils.flushBarErrorMassage(
          'Interest shown! The promoter will be notified.',
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          Utils.flushBarErrorMassage(
            'Error: ${e.toString()}',
            context,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = _hasShownInterest || _isLoading;

    return AbsorbPointer(
      absorbing: isDisabled,
      child: GestureDetector(
        onTap: _handleInterested,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            width: Responsive.w(40),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: _hasShownInterest
                  ? AppColor.white.withValues(alpha: 0.3)
                  : AppColor.red,
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: AppColor.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _hasShownInterest ? "Already\nInterested" : "Interested",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: _hasShownInterest ? Responsive.sp(8) : null,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}






// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/utils/routes/responsive.dart';
// import 'package:cage/utils/routes/utils.dart';
// import 'package:cage/widgets/auth_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EventsView extends StatelessWidget {
//   const EventsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Responsive.init(context);
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             children: [
//               Container(
//                 height: Responsive.h(7.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: TextField(
//                     scrollController: ScrollController(keepScrollOffset: true),
//                     style: TextStyle(color: AppColor.white),
//                     // controller: phoneController,
//                     // focusNode: phoneFoucsNode,
//                     cursorColor: AppColor.red,
//                     cursorErrorColor: AppColor.red,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(
//                           Responsive.w(12),
//                         ), // 6% of width
//                         borderSide: BorderSide(color: AppColor.red),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(Responsive.w(12)),
//                         borderSide: BorderSide(color: AppColor.red),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: AppColor.red),
//                         borderRadius: BorderRadius.circular(Responsive.w(12)),
//                       ),
//                       prefixIcon: Padding(
//                         padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
//                         child: SvgPicture.asset("assets/icons/search.svg"),
//                       ),
//                       filled: true,

//                       fillColor: AppColor.white.withValues(alpha: 0.08),
//                       hintText: "Search Event ...",
//                       hintStyle: GoogleFonts.dmSans(
//                         color: AppColor.white,
//                         fontWeight: FontWeight.normal,
//                         fontSize: Responsive.sp(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 // color: AppColor.black,
//                 // width: double.infinity,
//                 // height: MediaQuery.sizeOf(context).height,
//                 child: ListView.builder(
//                   // scrollDirection: Axis.horizontal,
//                   itemCount: 10,
//                   padding: EdgeInsets.symmetric(horizontal: 0),
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 2.0,
//                         vertical: 4.0,
//                       ),
//                       child: Container(
//                         child: Container(
//                           width: Responsive.w(50),
//                           height: Responsive.h(36),

//                           decoration: BoxDecoration(
//                             border: BoxBorder.all(
//                               color: AppColor.white.withValues(alpha: 0.1),
//                               // width: Responsive.w(0),
//                             ),
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Image(
//                                   width: double.infinity,
//                                   fit: BoxFit.fill,
//                                   image: AssetImage(
//                                     "assets/images/Frame 1000002190.png",
//                                   ),
//                                 ),
//                                 SizedBox(height: Responsive.h(1)),

//                                 Text(
//                                   "Jake “The Beast” Miller - 🏆 Win (KO)",
//                                   style: TextStyle(
//                                     color: AppColor.white,
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: Responsive.sp(10),
//                                   ),
//                                 ),
//                                 SizedBox(height: Responsive.h(1)),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         _showForgotPasswordBottomSheet(context);
//                                       },
//                                       child: Container(
//                                         width: Responsive.w(40),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Center(
//                                             child: Text(
//                                               "View Details",
//                                               style: GoogleFonts.dmSans(
//                                                 color: AppColor.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             22,
//                                           ),
//                                           color: AppColor.white.withValues(
//                                             alpha: 0.2,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: Responsive.w(40),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             "Interested",
//                                             style: GoogleFonts.dmSans(
//                                               color: AppColor.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(22),
//                                         color: AppColor.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void _showForgotPasswordBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     backgroundColor: AppColor.black,
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: Responsive.w(5),
//           right: Responsive.w(5),
//           top: Responsive.h(3),
//         ),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Fight Details",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(18),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SvgPicture.asset("assets/images/Frame 1000002190.png"),
//               Text(
//                 "Jake “The Beast” Miller - 🏆 Win (KO)",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(10),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(height: Responsive.h(2)),
//               Text(
//                 "Looking for aggressive strikers with clean records. The winner will be featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(10),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(
//                 height: Responsive.h(6),
//                 child: TextFormField(
//                   style: TextStyle(color: AppColor.white),

//                   cursorColor: AppColor.red,
//                   cursorErrorColor: AppColor.red,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Responsive.w(12),
//                       ), // 6% of width
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(Responsive.w(12)),
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColor.red),
//                       borderRadius: BorderRadius.circular(Responsive.w(12)),
//                     ),
//                     prefixIcon: Padding(
//                       padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
//                       child: SvgPicture.asset("assets/icons/mail-02.svg"),
//                     ),
//                     filled: true,
//                     fillColor: AppColor.white.withValues(alpha: 0.08),
//                     hintText: "Email Address",
//                     hintStyle: GoogleFonts.dmSans(
//                       color: AppColor.white,
//                       fontWeight: FontWeight.normal,
//                       fontSize: Responsive.sp(15),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: Responsive.h(2)),
//               AuthButton(
//                 buttontext: "Continue",
//                 onPress: () {
//                   Navigator.pop(context);
//                   Utils.flushBarErrorMassage("Reset link sent!", context);
//                 },
//                 loading: false,
//               ),
//               SizedBox(height: Responsive.h(2)),
//             ],
//           ),
        
//       );
//     },
//   );
// }
