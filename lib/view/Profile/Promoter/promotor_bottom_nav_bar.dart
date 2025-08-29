// main_wrapper.dart
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/Promoter/test.dart';
import 'package:cage/view/Profile/Promoter/explorefighters_view.dart';
import 'package:cage/view/Profile/fighter/fighter_personal_profile.dart';
import 'package:cage/view/Profile/fighter/homeview.dart';
import 'package:cage/view/Profile/tab_controller.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/view/settings_view.dart';
import 'package:cage/view/support_view.dart';
import 'package:cage/view/term_condition_view.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PromotorBottomNavBar extends StatefulWidget {
  const PromotorBottomNavBar({Key? key}) : super(key: key);

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
    PromoterHome(drawerController: _drawerController), // Home (same as bottom nav)
    _buildSubscriptionView(), // Subscription
    SupportView(), // Support
    SettingsView(), // Settings
    TermConditionView(),
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
                    setState(() {
                      _currentIndex = 0;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/home.svg"),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() {
                      _currentIndex = 1;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/subcirnbtion.svg"),
                  title: Text('Subscription'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() {
                      _currentIndex = 2;
                      _isDrawerNavigation = true;
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
                    setState(() {
                      _currentIndex = 3;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/setting.svg"),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {},
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Terms & Conditions'),
                ),
                ListTile(
                  onTap: () async {
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

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _isDrawerNavigation
          ? 0
          : _currentIndex, // Reset to 0 if from drawer
      onTap: (index) => setState(() {
        _currentIndex = index;
        _isDrawerNavigation = false; // Switch to bottom nav mode
      }),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
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
          // activeIcon: SvgPicture.asset("assets/icons/notification.svg"),
          icon: CircleAvatar(
            radius: 15,
            backgroundColor: AppColor.white,
            backgroundImage: AssetImage("assets/images/Ellipse 24 (1).png"),
          ),
          label: '',
        ),
      ],
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
