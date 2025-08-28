import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/change_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cage/view/notifications_settings_view.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/view/Profile/Promoter/edit_promoter_profile.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.white.withValues(alpha: 0.6),
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                  Text(
                    "9:41",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_4_bar,
                        color: AppColor.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.battery_full, color: AppColor.white, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Navigation header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Settings options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Notifications button
                    _buildSettingsButton(
                      icon: "assets/icons/solar_bell-bold.svg",
                      title: "Notifications",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationsSettingsView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Edit Profile button
                    StreamBuilder<UserModel>(
                      stream: UserRepository.fetchCurrentUserStream(),
                      builder: (context, snapshot) {
                        return _buildSettingsButton(
                          icon: "assets/icons/lock-password.svg",
                          title: "Change Password",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.Change_Password_View,
                            );
                          },
                          //   if (snapshot.hasData && snapshot.data != null) {
                          //     final user = snapshot.data!;
                          //     if (user.isPromoter) {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => EditPromoterProfile(
                          //             promoterData: user.roleData,
                          //           ),
                          //         ),
                          //       );
                          //     } else if (user.isFighter) {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) =>
                          //               EidtProfile(fighterData: user.roleData),
                          //         ),
                          //       );
                          //     }
                          //   }
                          // },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Change Language button
                    _buildSettingsButton(
                      icon: "assets/icons/Group.svg",
                      title: "Change Language",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationsSettingsView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Home indicator
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColor.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColor.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColor.white,
                fontFamily: AppFonts.appFont,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor.white.withValues(alpha: 0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
