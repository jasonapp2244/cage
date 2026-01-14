import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/repository/report_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PromoterPublicProfile extends StatelessWidget {
  final UserModel userData;

  const PromoterPublicProfile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    if (userData.roleData is! PromoterDataModel) {
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

    final promoter = userData.roleData as PromoterDataModel;
    final EventService _eventService = EventService();

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
                          "Promoter Profile",
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
                      onTap: () => _showReportDialog(context, userData),
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
                StreamBuilder<List<EventModel>>(
                  stream: _eventService.getActiveEventsByPromoter(userData.id),
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
                          child: CircularProgressIndicator(
                            color: AppColor.red,
                          ),
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
                            "No active events",
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
          child: promoter.companyLogo != null && promoter.companyLogo!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: promoter.companyLogo!,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage("assets/images/image.png"),
                    ),
                  ),
                )
              : Image(image: AssetImage("assets/images/image.png")),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            child: event.thumbnailImageUrl != null &&
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                SizedBox(height: Responsive.h(1)),
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
                SizedBox(height: Responsive.h(0.5)),
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
                      items: [
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
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColor.white),
              ),
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
                        content: Text('Error submitting report: ${e.toString()}'),
                        backgroundColor: AppColor.red,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: AppColor.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
