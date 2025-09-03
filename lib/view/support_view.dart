import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class SupportView extends StatelessWidget {
  SupportView({super.key});
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();
  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
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
                  Text(
                    "Support Ticket",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    color: AppColor.white.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7700),
                              border: BoxBorder.all(
                                color: AppColor.white.withValues(alpha: 0.5),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:  8.0),
                              child: Center(
                                child: Text(
                                  "In-progress",
                                  style: TextStyle(
                                    fontSize: Responsive.textScaleFactor * 12,
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "12/12/2025",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 12,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Text(
                        "Issue with Job Application Submission",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 14,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Text(
                        "I encountered a problem while trying to submit my job application for the position of Marketing Specialist at XYZ Company. After filling in all the required details and uploading my resume, I clicked the Submit button, but the page froze, and the application did not go through.",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 12,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Button(
                text: "Create New Ticket",
                onTap: () {},
                focusNode: buttonFoucs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
