import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PromoterProfileView extends StatelessWidget {
  const PromoterProfileView({super.key});

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
                      "Profile",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColor.white.withValues(alpha: 0.1),
                      child: Image(
                        image: AssetImage("assets/images/image.png"),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "UFC Fighting Club",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EidtProfile()),
                        );
                      },
                      child: SvgPicture.asset("assets/icons/edits.svg"),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(1)),

                Text(
                  "Looking for aggressive strikers with clean records. The winner will be featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                                "No of Event Managed",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                              Text(
                                "20",
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
                                "Average Rating",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(10.5),
                                ),
                              ),
                              Text(
                                "10",
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
                      onTap: () =>
                          Navigator.pushNamed(context, RoutesName.review),
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
                                      alpha: 0.4,
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
                      color: AppColor.white.withValues(alpha:0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Photos will be displayed here",
                      style: TextStyle(color: AppColor.white.withValues(alpha:0.5)),
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
                      color: AppColor.white.withValues(alpha:0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Videos will be displayed here",
                      style: TextStyle(color: AppColor.white.withValues(alpha:0.5)),
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
