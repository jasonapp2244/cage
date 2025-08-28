import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
    final drawerProvider = Provider.of<DrawerControllerProvider>(
      context,
      listen: false,
    );

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/icons/Group 9.svg"),

                    /// ✅ StreamBuilder for user data
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
                        return Column(
                          children: [
                            Text(
                              "Hi👋 ${user.isFighter ? (user.roleData as FighterDataModel).fullName : 'User'}",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(18),
                              ),
                            ),

                            Text(
                              user.isFighter
                                  ? (user.roleData as FighterDataModel)
                                            .location ??
                                        "Location not set"
                                  : "Location not set",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(8.5),
                              ),
                            ),
                          ],
                        );
                      },
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

                // SvgPicture.asset("assets/icons/Mask group (1).svg"),
                Container(
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
                      StreamBuilder<UserModel>(
                        stream: UserRepository.fetchCurrentUserStream(),
                        builder: (context, snapshot) {
                          String weight = "0 LBS";

                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isFighter) {
                            final fighterData =
                                snapshot.data!.roleData as FighterDataModel;
                            weight =
                                fighterData.weight != null &&
                                    fighterData.weight!.isNotEmpty
                                ? "${fighterData.weight} LBS"
                                : "0 LBS";
                          }

                          return RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              weight,
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.18),
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.normal,
                                fontSize: Responsive.sp(40),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // 🔹 Wins / Losses / Knockouts with dynamic data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String wins = "0", losses = "0", knockouts = "0";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isFighter) {
                      final fighterData =
                          snapshot.data!.roleData as FighterDataModel;
                      wins = fighterData.fightWin.toString();
                      losses = fighterData.fightsLose.toString();
                      knockouts = fighterData.fightsKnockout.toString();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard("Wins", wins),
                        _buildStatCard("Losses", losses),
                        _buildStatCard("Knockouts", knockouts),
                      ],
                    );
                  },
                ),
                SizedBox(height: Responsive.h(2)),

                // 🔹 Coach Name with dynamic data
                StreamBuilder<UserModel>(
                  stream: UserRepository.fetchCurrentUserStream(),
                  builder: (context, snapshot) {
                    String coachName = "Not set";

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.isFighter) {
                      final fighterData =
                          snapshot.data!.roleData as FighterDataModel;
                      coachName = fighterData.coachName.isEmpty
                          ? "Not set"
                          : fighterData.coachName;
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Coach Name",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                            Text(
                              coachName,
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
                    );
                  },
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
    );
  }

  /// Reusable Stat Card
  Widget _buildStatCard(String title, String value) {
    return Container(
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

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
