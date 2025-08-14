import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Profile/fighter/fighter_public_profile.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoterHome extends StatefulWidget {
  const PromoterHome({super.key});

  @override
  State<PromoterHome> createState() => _PromoterHomeState();
}

class _PromoterHomeState extends State<PromoterHome> {
  final _advancedDrawerController =
      AdvancedDrawerController(); // Add controller

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColor.red),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SvgPicture.asset("assets/icons/Group 9 (1).svg"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.home);
                  },
                  leading: SvgPicture.asset("assets/icons/home.svg"),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.PaymentView);
                  },
                  leading: SvgPicture.asset("assets/icons/subcirnbtion.svg"),
                  title: Text('Subscription'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.supportView);
                  },
                  leading: SvgPicture.asset(
                    "assets/icons/customer-service.svg",
                  ),
                  title: Text('Support'),
                ),

                ListTile(
                  onTap: () {},
                  leading: SvgPicture.asset("assets/icons/setting.svg"),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.TermConditionView);
                  },
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Terms & Conditions'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.spalsh);
                  },
                  leading: SvgPicture.asset("assets/icons/logout-03.svg"),
                  title: Text('Logout'),
                ),
                // Add more drawer items as needed
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
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
                      Column(
                        children: [
                          Text(
                            "Hi👋Jhon Doe",
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(18),
                            ),
                          ),
                          Text(
                            "San Francisco, California 94124",
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                              fontSize: Responsive.sp(10.5),
                            ),
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: _handleMenuButtonPressed,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
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
                                    fontSize: Responsive.textScaleFactor * 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.w(4)),
                      Expanded(
                        child: Container(
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
                                    fontSize: Responsive.textScaleFactor * 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Fights",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.textScaleFactor * 14,
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

                  Container(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            child: Container(
                              width: Responsive.w(80),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontSize:
                                            Responsive.textScaleFactor * 18,
                                      ),
                                    ),
                                    SizedBox(height: Responsive.h(1)),
                                    GestureDetector(
                                      onTap: () =>
                                          _showEventDetailsBottomSheet(context),
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
                                              "View Details",
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
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),
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

                      // SizedBox(width: Responsive.w(5)),
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
                  Container(
                    height: Responsive.h(28),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            child: Container(
                              width: Responsive.w(50),
                              height: Responsive.h(50),

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
                                        fontSize:
                                            Responsive.textScaleFactor * 14,
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
                                          "Corey Herwitz",
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
                                      onTap: ()=>Navigator.pushNamed(context, RoutesName.FighterPublicProfile),
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
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

void _showEventDetailsBottomSheet(BuildContext context) {
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
                    child: Image.asset(
                      "assets/images/Frame 1000002190.png",
                      width: double.infinity,
                      height: Responsive.h(25),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Title
                  Text(
                    "Jake \"The Beast\" Miller - 🏆 Win (KO)",
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Responsive.h(1)),

                  // Event Description
                  Text(
                    "Looking for aggressive strikers with clean records. The winner will be "
                    "featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
                    style: GoogleFonts.dmSans(
                      color: AppColor.white.withOpacity(0.8),
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
                  _buildDetailRow("Date", "October 15, 2023"),
                  _buildDetailRow("Location", "Las Vegas, NV"),

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
                  _buildDetailRow("Event Type", "Professional | Lightweight"),
                  _buildDetailRow("Weight Class", "Lightweight 155 lbs"),
                  _buildDetailRow("Required Record", "Min. 2 wins"),
                  _buildDetailRow("Age Limit", "18–35"),
                  _buildDetailRow(
                    "Fighting Style Preferred",
                    "MMA / BJJ / Muay Thai",
                  ),
                  _buildDetailRow("Deadline to Apply", "June 15, 2025"),
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
