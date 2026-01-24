// main_wrapper.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/Promoter/promoter_profile_view.dart';
import 'package:cage/view/Profile/Promoter/explorefighters_view.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/view/settings_view.dart';
import 'package:cage/view/contact_us_view.dart';
import 'package:cage/view/privacy_policy_view.dart';
import 'package:cage/view/support_view.dart';
import 'package:cage/view/term_condition_view.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PromotorBottomNavBar extends StatefulWidget {
  const PromotorBottomNavBar({super.key});

  @override
  State<PromotorBottomNavBar> createState() => _PromotorBottomNavBarState();
}

class _PromotorBottomNavBarState extends State<PromotorBottomNavBar> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();
  int _currentIndex = 0;
  bool _isDrawerNavigation = false; // Track if we're navigating from drawer

  // We'll create the pages in the build method to access the drawer controller
  List<Widget> get _bottomNavPages => [
    PromoterHome(drawerController: _drawerController), // Promoter Home
    ExploreFightersView(), // Explore Fighters
    NotificationView(), // Notifications
    PromoterProfileView(), // Promoter Profile
  ];

  // Drawer Navigation Pages (Settings/Support Flow)
  List<Widget> get _drawerPages => [
    PromoterHome(
      drawerController: _drawerController,
    ), // Home (same as bottom nav)
    _buildSubscriptionView(), // Subscription
    SupportView(), // Support
    SettingsView(), // Settings
    TermConditionView(),
    PrivacyPolicyView(), // Privacy Policy
    ContactUsView(), // Contact Us
  ];

  void _handleMenuButtonPressed() {
    // This method is not used anymore since we use provider directly
  }

  // Subscription view for drawer navigation
  Widget _buildSubscriptionView() {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: Text('Subscription', style: TextStyle(color: AppColor.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () {
            setState(() {
              _currentIndex = 0;
              _isDrawerNavigation = false;
            });
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.subscriptions, size: 64, color: AppColor.red),
            SizedBox(height: 16),
            Text(
              'Promoter Subscription Plans',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your promoter subscription here',
              style: TextStyle(
                color: AppColor.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColor.red),
      ),
      controller: _drawerController,
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
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 0;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/home.svg"),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 1;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/subcirnbtion.svg"),
                  title: Text('Subscription'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 2;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset(
                    "assets/icons/customer-service.svg",
                  ),
                  title: Text('Support'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 3;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/setting.svg"),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 4;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Terms & Conditions'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 5;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Privacy Policy'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {
                        _currentIndex = 6;
                        _isDrawerNavigation = true;
                      });
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/mail-02.svg"),
                  title: Text('Contact Us'),
                ),
                ListTile(
                  onTap: () async {
                    _drawerController.hideDrawer();
                    await authProvider.logout(context);
                  },
                  leading: SvgPicture.asset("assets/icons/logout-03.svg"),
                  title: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: _isDrawerNavigation
            ? _drawerPages[_currentIndex]
            : _bottomNavPages[_currentIndex],
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildProfileIcon({required bool isSelected}) {
    return StreamBuilder<UserModel>(
      stream: UserRepository.fetchCurrentUserStream(),
      builder: (context, snapshot) {
        String? imageUrl;
        
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          if (user.isFighter && user.roleData is FighterDataModel) {
            final fighter = user.roleData as FighterDataModel;
            imageUrl = fighter.profileImageUrl;
          } else if (user.isPromoter && user.roleData is PromoterDataModel) {
            final promoter = user.roleData as PromoterDataModel;
            imageUrl = promoter.profileImageUrl;
          }
        }

        Widget avatarWidget;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          avatarWidget = CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircleAvatar(
              radius: 15,
              backgroundColor: AppColor.white.withValues(alpha: 0.5),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.red,
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 15,
              backgroundColor: AppColor.white.withValues(alpha: 0.5),
              backgroundImage: AssetImage("assets/images/Ellipse 24 (1).png"),
            ),
          );
        } else {
          avatarWidget = CircleAvatar(
            radius: 15,
            backgroundColor: AppColor.white.withValues(alpha: isSelected ? 1.0 : 0.5),
            backgroundImage: AssetImage("assets/images/Ellipse 24 (1).png"),
          );
        }

        if (isSelected) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.red,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: SizedBox(
                width: 30,
                height: 30,
                child: avatarWidget,
              ),
            ),
          );
        } else {
          return ClipOval(
            child: SizedBox(
              width: 30,
              height: 30,
              child: avatarWidget,
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomNavBar() {
    return StreamBuilder<Map<String, Color>>(
      stream: AppColor.colorStream,
      initialData: {
        'black': AppColor.black,
        'red': AppColor.red,
        'white': AppColor.white,
      },
      builder: (context, snapshot) {
        final black = snapshot.data?['black'] ?? AppColor.black;
        final red = snapshot.data?['red'] ?? AppColor.red;
        
        return BottomNavigationBar(
          currentIndex: _isDrawerNavigation
              ? 0
              : _currentIndex, // Reset to 0 if from drawer
          onTap: (index) => setState(() {
            _currentIndex = index;
            _isDrawerNavigation = false; // Switch to bottom nav mode
          }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: black,
          selectedItemColor: red,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              // assets/icons/home_seleted.svg
              activeIcon: SvgPicture.asset("assets/icons/Group 1000002074.svg"),
              icon: SvgPicture.asset("assets/icons/home_unseleted.svg"),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset("assets/icons/fighetr_selected.svg"),
              icon: SvgPicture.asset("assets/icons/fighter_unselected.svg"),
              label: '',
            ),
            // assets/icons/home_unseleted.svg
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                "assets/icons/notification_selected.svg",
              ),
              icon: SvgPicture.asset("assets/icons/notification.svg"),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: _buildProfileIcon(isSelected: true),
              icon: _buildProfileIcon(isSelected: false),
              label: '',
            ),
          ],
        );
      },
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Stats';
      case 2:
        return 'Training';
      case 3:
        return 'Profile';
      default:
        return 'App';
    }
  }
}
