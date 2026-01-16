// main_wrapper.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/fighter/fighter_personal_profile.dart';
import 'package:cage/view/Profile/fighter/homeview.dart';
import 'package:cage/view/Profile/fighter/subscription_plans_view.dart';
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
// main_wrapper.dart
import 'package:cage/view/Profile/tab_controller.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();

  int _currentIndex = 0;
  bool _isDrawerNavigation = false; // Track if we're navigating from drawer

  // Bottom Navigation Pages (Main App Flow)
  final List<Widget> _bottomNavPages = [
    Homeview(), // Home
    DiscoverView(), // Explore/Activity
    NotificationView(), // Notifications
    FighterPublicProfile(), // Profile
  ];

  // Drawer Navigation Pages (Settings/Support Flow)
  final List<Widget> _drawerPages = [
    Homeview(), // Home (same as bottom nav)
    SubscriptionPlansView(), // Subscription Plans
    SupportView(), // Support
    SettingsView(), // Settings
    TermConditionView(), // Terms & Conditions
    PrivacyPolicyView(), // Privacy Policy
    ContactUsView(), // Contact Us
  ];

  void _handleMenuButtonPressed() {
    _drawerController.showDrawer();
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
              'Subscription Plans',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Manage your subscription here',
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
    final drawerProvider = Provider.of<DrawerControllerProvider>(context);
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColor.red),
      ),
      controller: drawerProvider.controller,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: SizedBox(
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
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() {
                      _currentIndex = 4;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Terms & Conditions'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() {
                      _currentIndex = 5;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/term_condition.svg"),
                  title: Text('Privacy Policy'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() {
                      _currentIndex = 6;
                      _isDrawerNavigation = true;
                    });
                  },
                  leading: SvgPicture.asset("assets/icons/mail-02.svg"),
                  title: Text('Contact Us'),
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
                color: AppColor.white,
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
      selectedItemColor: AppColor.white,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          // assets/icons/home_seleted.svg
          activeIcon: SvgPicture.asset("assets/icons/Group 1000002074.svg"),
          icon: SvgPicture.asset("assets/icons/home_unseleted.svg"),
          label: '',
        ),
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset("assets/icons/exploer_seleted.svg"),
          icon: SvgPicture.asset("assets/icons/exploer.svg"),
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

// // main_wrapper.dart
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/view/homeview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:flutter_svg/svg.dart';

// class MainWrapper extends StatefulWidget {
//   const MainWrapper({Key? key}) : super(key: key);

//   @override
//   State<MainWrapper> createState() => _MainWrapperState();
// }

// class _MainWrapperState extends State<MainWrapper> {
//   final AdvancedDrawerController _drawerController = AdvancedDrawerController();
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     Homeview(),
//     Container(color: AppColor.red),
//     Container(color: AppColor.red),
//     Container(color: AppColor.red),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return AdvancedDrawer(
//       backdrop: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: AppColor.red,
//         ),
//       ),
//       controller: _advancedDrawerController,
//       animationCurve: Curves.easeInOut,
//       animationDuration: const Duration(milliseconds: 300),
//       childDecoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//       ),
//       drawer: SafeArea(
//         child: Container(
//           child: ListTileTheme(
//             textColor: Colors.white,
//             iconColor: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                   child: SvgPicture.asset("assets/icons/Group 9 (1).svg"),
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset("assets/icons/home.svg"),
//                   title: Text('Home'),
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset("assets/icons/subcirnbtion.svg"),
//                   title: Text('Subscription'),
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset(
//                     "assets/icons/customer-service.svg",
//                   ),
//                   title: Text('Support'),
//                 ),

//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset("assets/icons/setting.svg"),
//                   title: Text('Settings'),
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset("assets/icons/term_condition.svg"),
//                   title: Text('Terms & Conditions'),
//                 ),
//                 ListTile(
//                   onTap: () {},
//                   leading: SvgPicture.asset("assets/icons/logout-03.svg"),
//                   title: Text('Logout'),
//                 ),
//                 // Add more drawer items as needed
//               ],
//             ),
//           ),
//         ),
//       ),
//       child:Scaffold(
//         body:  _pages[_currentIndex],
//         bottomNavigationBar: _buildBottomNavBar(),
//       ));
//     //  AdvancedDrawer(
//     //   backdrop: Container(
//     //     width: double.infinity,
//     //     height: double.infinity,
//     //     decoration: BoxDecoration(
//     //       gradient: LinearGradient(
//     //         begin: Alignment.topLeft,
//     //         end: Alignment.bottomRight,
//     //         colors: [Colors.blueGrey, Colors.blueGrey.withValues(alpha: (0.2)],
//     //       ),
//     //     ),
//     //   ),
//     //   controller: _drawerController,
//     //   animationCurve: Curves.easeInOut,
//     //   animationDuration: const Duration(milliseconds: 300),
//     //   childDecoration: const BoxDecoration(
//     //     borderRadius: BorderRadius.all(Radius.circular(16)),
//     //   ),
//     //   drawer: _buildDrawer(),
//     //   child: Scaffold(
//     //     appBar: AppBar(
//     //       title: Text(_getTitle(_currentIndex)),
//     //       leading: IconButton(
//     //         onPressed: _handleMenuButtonPressed,
//     //         icon: ValueListenableBuilder<AdvancedDrawerValue>(
//     //           valueListenable: _drawerController,
//     //           builder: (_, value, __) {
//     //             return AnimatedSwitcher(
//     //               duration: Duration(milliseconds: 250),
//     //               child: Icon(
//     //                 value.visible ? Icons.clear : Icons.menu,
//     //                 key: ValueKey<bool>(value.visible),
//     //               ),
//     //             );
//     //           },
//     //         ),
//     //       ),
//     //     ),
//     //     body: _pages[_currentIndex],
//     //     bottomNavigationBar: _buildBottomNavBar(),
//     //   ),
//     // );
//   }

//   Widget _buildDrawer() {
//     return SafeArea(
//       child: Container(
//         child: ListTileTheme(
//           textColor: Colors.white,
//           iconColor: Colors.white,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Container(
//                 width: 128.0,
//                 height: 128.0,
//                 margin: const EdgeInsets.only(top: 24.0, bottom: 64.0),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   color: Colors.black26,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Image.asset('assets/images/flutter_logo.png'),
//               ),
//               ListTile(
//                 onTap: () {
//                   _drawerController.hideDrawer();
//                   setState(() => _currentIndex = 0);
//                 },
//                 leading: Icon(Icons.home),
//                 title: Text('Home'),
//               ),
//               ListTile(
//                 onTap: () {
//                   _drawerController.hideDrawer();
//                   setState(() => _currentIndex = 3); // Profile
//                 },
//                 leading: Icon(Icons.account_circle_rounded),
//                 title: Text('Profile'),
//               ),
//               Spacer(),
//               DefaultTextStyle(
//                 style: TextStyle(fontSize: 12, color: Colors.white54),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(vertical: 16.0),
//                   child: Text('Terms of Service | Privacy Policy'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   BottomNavigationBar _buildBottomNavBar() {
//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: (index) => setState(() => _currentIndex = index),
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.black,
//       selectedItemColor: Colors.red,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.fitness_center),
//           label: 'Training',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//       ],
//     );
//   }

//   String _getTitle(int index) {
//     switch (index) {
//       case 0:
//         return 'Home';
//       case 1:
//         return 'Stats';
//       case 2:
//         return 'Training';
//       case 3:
//         return 'Profile';
//       default:
//         return 'App';
//     }
//   }

//   void _handleMenuButtonPressed() {
//     _drawerController.showDrawer();
//   }
// }
