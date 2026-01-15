import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_interest_model.dart';
import 'package:cage/models/notification_model.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/repository/event_interest_repository.dart';
import 'package:cage/repository/notification_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {

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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
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
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<NotificationModel>>(
                  stream: NotificationRepository.getNotificationsForUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.red,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading notifications',
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      );
                    }

                    final notifications = snapshot.data ?? [];

                    if (notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64,
                              color: AppColor.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.5),
                                fontFamily: AppFonts.appFont,
                                fontSize: Responsive.sp(16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _buildNotificationCard(context, notification);
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

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.horizontal,
        background: Container(
          decoration: BoxDecoration(
            color: AppColor.red,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: Icon(
            Icons.delete,
            color: AppColor.white,
            size: 24,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: AppColor.red,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: AppColor.white,
            size: 24,
          ),
        ),
        onDismissed: (direction) async {
          // Delete notification when swiped
          try {
            await NotificationRepository.deleteNotification(notification.id);
          } catch (e) {
            if (context.mounted) {
              Utils.flushBarErrorMassage(
                'Error deleting notification: $e',
                context,
              );
            }
          }
        },
        confirmDismiss: (direction) async {
          // Optional: Show confirmation dialog before deleting
          // For now, we'll delete immediately
          return true;
        },
        child: GestureDetector(
          onTap: () {
            // Mark as read when tapped
            if (!notification.read) {
              NotificationRepository.markAsRead(notification.id);
            }
            
            // Handle event interest notifications - show fighter profile with accept/reject
            if (notification.type == 'event_interest' && 
                notification.interestId != null && 
                notification.interestId!.isNotEmpty) {
              _handleEventInterestNotification(context, notification);
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: notification.read
                    ? AppColor.white.withValues(alpha: 0.3)
                    : AppColor.red.withValues(alpha: 0.5),
                width: notification.read ? 1 : 1.5,
              ),
              borderRadius: BorderRadius.circular(18),
              color: notification.read
                  ? AppColor.black
                  : AppColor.black.withValues(alpha: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColor.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Frame 1410120832.svg",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(14),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          style: TextStyle(
                            color: AppColor.white.withValues(alpha: 0.8),
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.normal,
                            fontSize: Responsive.sp(12),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Time
                  Text(
                    notification.timeAgo,
                    style: TextStyle(
                      color: AppColor.white.withValues(alpha: 0.5),
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.w500,
                      fontSize: Responsive.sp(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle event interest notification tap
  Future<void> _handleEventInterestNotification(
    BuildContext context,
    NotificationModel notification,
  ) async {
    if (notification.interestId == null || notification.interestId!.isEmpty) {
      return;
    }

    try {
      // Fetch the interest details
      final interest = await EventInterestRepository.getInterestById(notification.interestId!);

      if (interest == null) {
        if (context.mounted) {
          Utils.flushBarErrorMassage(
            'Interest request not found',
            context,
          );
        }
        return;
      }

      // Show fighter details bottom sheet
      if (context.mounted) {
        _showFighterDetailsBottomSheet(context, interest);
      }
    } catch (e) {
      if (context.mounted) {
        Utils.flushBarErrorMassage(
          'Error loading request details: $e',
          context,
        );
      }
    }
  }

  // Show fighter details bottom sheet with accept/reject options
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
              final fighterInfo = fighterData['fighterData'] as Map<String, dynamic>?;
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
                                    backgroundColor: AppColor.white.withValues(alpha: 0.1),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.red,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.white.withValues(alpha: 0.1),
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
                                backgroundColor: AppColor.white.withValues(alpha: 0.1),
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
                          _buildDetailRow("Full Name", fighterInfo['fullName'] ?? 'N/A'),
                        if (fighterInfo['age'] != null)
                          _buildDetailRow("Age", fighterInfo['age'].toString()),
                        if (fighterInfo['height'] != null)
                          _buildDetailRow("Height", fighterInfo['height'] ?? 'N/A'),
                        if (fighterInfo['weight'] != null)
                          _buildDetailRow("Weight", fighterInfo['weight']?.toString() ?? 'N/A'),
                        if (fighterInfo['fightingStyle'] != null)
                          _buildDetailRow("Fighting Style", fighterInfo['fightingStyle'] ?? 'N/A'),
                        if (fighterInfo['fightWin'] != null || fighterInfo['fightsLose'] != null)
                          _buildDetailRow(
                            "Record",
                            "${fighterInfo['fightWin'] ?? 0}W - ${fighterInfo['fightsLose'] ?? 0}L",
                          ),
                        if (fighterInfo['fightsKnockout'] != null)
                          _buildDetailRow("KO/TKO", fighterInfo['fightsKnockout'].toString()),
                        if (fighterInfo['coachName'] != null)
                          _buildDetailRow("Coach", fighterInfo['coachName'] ?? 'N/A'),
                        if (fighterInfo['coachContact'] != null)
                          _buildDetailRow("Coach Contact", fighterInfo['coachContact'] ?? 'N/A'),
                        if (fighterInfo['lastExam'] != null)
                          _buildDetailRow("Last Medical Exam", fighterInfo['lastExam'] ?? 'N/A'),
                        if (fighterInfo['lastBlood'] != null)
                          _buildDetailRow("Last Blood Test", fighterInfo['lastBlood'].toString()),
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
      print('Error fetching fighter details: $e');
      return null;
    }
  }

  // Check if image URL is valid (not a social media link)
  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    final lowerUrl = url.toLowerCase();
    return !lowerUrl.contains('facebook.com') &&
        !lowerUrl.contains('instagram.com') &&
        !lowerUrl.contains('twitter.com') &&
        !lowerUrl.contains('linkedin.com') &&
        (lowerUrl.startsWith('http://') || lowerUrl.startsWith('https://'));
  }

  // Build detail row widget
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
