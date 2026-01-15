import 'package:cage/models/event_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventDetailView extends StatelessWidget {
  final EventModel event;

  const EventDetailView({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(4),
                  vertical: Responsive.h(2),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.w(2)),
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/arrow-left-01.svg",
                          color: AppColor.red,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(3)),
                    Expanded(
                      child: Text(
                        "Event Details",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontSize: Responsive.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Event Image
              if (event.thumbnailImageUrl != null &&
                  event.thumbnailImageUrl!.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: Responsive.h(30),
                  child: CachedNetworkImage(
                    imageUrl: event.thumbnailImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColor.white.withValues(alpha: 0.1),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.red,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColor.white.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.image,
                        color: AppColor.white.withValues(alpha: 0.5),
                        size: 48,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: Responsive.h(30),
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

              // Event Content
              Padding(
                padding: EdgeInsets.all(Responsive.w(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Title
                    Text(
                      event.eventTitle,
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: Responsive.sp(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Event Type Badge
                    if (event.eventType.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(3),
                          vertical: Responsive.h(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColor.red.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          event.eventType,
                          style: GoogleFonts.dmSans(
                            color: AppColor.red,
                            fontSize: Responsive.sp(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    SizedBox(height: Responsive.h(3)),

                    // Description
                    if (event.description.isNotEmpty) ...[
                      Text(
                        "Description",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontSize: Responsive.sp(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Text(
                        event.description,
                        style: GoogleFonts.dmSans(
                          color: AppColor.white.withValues(alpha: 0.8),
                          fontSize: Responsive.sp(14),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: Responsive.h(3)),
                    ],

                    // Event Details Section
                    _buildDetailSection(
                      context,
                      "Event Details",
                      [
                        _buildDetailRow(
                          context,
                          Icons.calendar_today,
                          "Date",
                          DateFormat('MMMM dd, yyyy').format(event.eventDate),
                        ),
                        _buildDetailRow(
                          context,
                          Icons.access_time,
                          "Time",
                          event.eventTime,
                        ),
                        _buildDetailRow(
                          context,
                          Icons.location_on,
                          "Location",
                          event.location,
                        ),
                        if (event.weightClass.isNotEmpty)
                          _buildDetailRow(
                            context,
                            Icons.fitness_center,
                            "Weight Class",
                            event.weightClass,
                          ),
                        if (event.ageLimit.isNotEmpty)
                          _buildDetailRow(
                            context,
                            Icons.person,
                            "Age Limit",
                            event.ageLimit,
                          ),
                        if (event.requiredRecord.isNotEmpty)
                          _buildDetailRow(
                            context,
                            Icons.emoji_events,
                            "Required Record",
                            event.requiredRecord,
                          ),
                        if (event.fightingStylePreferred.isNotEmpty)
                          _buildDetailRow(
                            context,
                            Icons.sports_mma,
                            "Fighting Style",
                            event.fightingStylePreferred,
                          ),
                        _buildDetailRow(
                          context,
                          Icons.event_busy,
                          "Deadline to Apply",
                          DateFormat('MMMM dd, yyyy').format(event.deadlineToApply),
                        ),
                      ],
                    ),

                    SizedBox(height: Responsive.h(2)),

                    // Promoter Info Section
                    _buildDetailSection(
                      context,
                      "Promoter Information",
                      [
                        _buildDetailRow(
                          context,
                          Icons.business,
                          "Promoter",
                          event.promoterName,
                        ),
                      ],
                    ),

                    SizedBox(height: Responsive.h(4)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            color: AppColor.white,
            fontSize: Responsive.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Responsive.h(1.5)),
        Container(
          padding: EdgeInsets.all(Responsive.w(3)),
          decoration: BoxDecoration(
            color: AppColor.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
        SizedBox(height: Responsive.h(2)),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColor.red,
            size: 20,
          ),
          SizedBox(width: Responsive.w(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    color: AppColor.white.withValues(alpha: 0.6),
                    fontSize: Responsive.sp(11),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: Responsive.h(0.3)),
                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
