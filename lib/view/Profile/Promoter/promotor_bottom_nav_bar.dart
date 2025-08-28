// main_wrapper.dart
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/Promoter/test.dart';
import 'package:cage/view/Profile/Promoter/explorefighters_view.dart';
import 'package:cage/view/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';

class PromotorBottomNavBar extends StatefulWidget {
  const PromotorBottomNavBar({Key? key}) : super(key: key);

  @override
  State<PromotorBottomNavBar> createState() => _PromotorBottomNavBarState();
}

class _PromotorBottomNavBarState extends State<PromotorBottomNavBar> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PromoterHome(),
    ExploreFightersView(),
    NotificationView(),
    PromoterView(),
  ];

  void _handleMenuButtonPressed() {
    _drawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
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
                    setState(() => _currentIndex = 0);
                  },
                  leading: SvgPicture.asset("assets/icons/home.svg"),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() => _currentIndex = 1);
                  },
                  leading: SvgPicture.asset("assets/icons/subcirnbtion.svg"),
                  title: Text('Subscription'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() => _currentIndex = 2);
                  },
                  leading: SvgPicture.asset(
                    "assets/icons/customer-service.svg",
                  ),
                  title: Text('Support'),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() => _currentIndex = 3);
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
                  onTap: () {},
                  leading: SvgPicture.asset("assets/icons/logout-03.svg"),
                  title: Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
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

// // main_wrapper.dart
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/view/homeview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:flutter_svg/svg.dart';

// class PromotorBottomNavBar extends StatefulWidget {
//   const PromotorBottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<PromotorBottomNavBar> createState() => _PromotorBottomNavBarState();
// }

// class _PromotorBottomNavBarState extends State<PromotorBottomNavBar> {
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
//     //         colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
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
