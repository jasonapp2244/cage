import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FighterPublicProfile extends StatelessWidget {
  const FighterPublicProfile({super.key});

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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        "assets/icons/arrow-left-01.svg",
                        color: AppColor.red,
                      ),
                    ),
                    Text(
                      "Fighter Profile",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 24,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing:10,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          "Ruben Kenter",
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
                              "+1 2654 564 169",
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
                              "rubenkenter2@gmail.com",
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
                              "12",
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
                                "05",
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
                                "01",
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
                              "12",
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
                                "Boxing",
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
                              "Kianna Septimus",
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
                              "+1 2654 564 169",
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
                          "www.tapology.com",
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
                              "12 Apr 2025",
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
                              "01 Mar 2025",
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
                              "22 Jan 2025",
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image(
                    image: AssetImage("assets/images/Frame 1000002180.png"),
                  ),
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: AssetImage(
                                "assets/images/Frame 1410120835.png",
                              ),
                            ),

                            SizedBox(width: Responsive.w(2)),
                            Text(
                              "Ruben Kenter",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text(
                                  "3h ago",
                                  style: TextStyle(
                                    color: AppColor.white.withValues(
                                      alpha: 0.2,
                                    ),
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                    "assets/icons/material-symbols_star.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.h(1)),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: AppFonts.appFont,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.sp(10),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}
