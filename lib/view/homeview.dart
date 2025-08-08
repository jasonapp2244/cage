import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/darwer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
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

                  // SvgPicture.asset("assets/icons/Mask group (1).svg"),
                  Container(
                    // width: Responsive.w(70),
                    // height: Responsive.h(65),
                    color: AppColor.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Image(
                            width: Responsive.w(70),
                            // height: Responsive.h(65),
                            image: AssetImage("assets/icons/Mask group.png"),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            '143.3 LBS',
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Responsive.w(27),
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
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: Responsive.w(27),
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
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: Responsive.w(27),
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
                                  fontWeight: FontWeight.normal,
                                  fontSize: Responsive.sp(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(2)),

                  Container(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Coach Name",
                            style: TextStyle(
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                              fontSize: Responsive.sp(10),
                            ),
                          ),
                          Text(
                            "Kianna Septimus",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Fights",
                        style: TextStyle(
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(10),
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
                              fontSize: Responsive.sp(10),
                            ),
                          ),
                          SizedBox(width: Responsive.w(2)),
                          SvgPicture.asset("assets/icons/Vector (2).svg"),
                        ],
                      ),
                    ],
                  ),

                  Container(
                    height: 200,
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
                                        fontSize: Responsive.sp(10),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.h(1)),

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
                                        SvgPicture.asset(
                                          "assets/icons/Vector (2).svg",
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
