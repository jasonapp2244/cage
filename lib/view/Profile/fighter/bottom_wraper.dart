// main_wrapper.dart
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/fighter/fighter_profile.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/Promoter/promoter_profile_view.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:cage/view/Profile/fighter/homeview.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {
  final String? userRole;
  const MainWrapper({Key? key, this.userRole}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final AdvancedDrawerController _drawerController = AdvancedDrawerController();
  int _currentIndex = 0;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      print('=== Starting role detection ===');

      // First try to get role from passed parameter
      if (widget.userRole != null) {
        _userRole = widget.userRole;
        print('Role from parameter: $_userRole');
      } else {
        // Try to get from local storage
        _userRole = await Utils.getSavedRole('role');
        print('Role from local storage: $_userRole');

        // If not in local storage, fetch from database
        if (_userRole == null) {
          print('Role not in local storage, fetching from database...');

          // Try to get role from Firestore directly first
          final userId = Utils.getCurrentUid();
          print('User ID: $userId');

          final doc = await FirebaseFirestore.instance
              .collection('userData')
              .doc(userId)
              .get();

          if (doc.exists) {
            final data = doc.data();
            print('Firestore data: $data');
            _userRole = data?['role'];
            print('Role from Firestore: $_userRole');

            // Save to local storage for future use
            if (_userRole != null) {
              await Utils.saveSavedRole('role', _userRole!);
              print('Role saved to local storage: $_userRole');
            }
          } else {
            print('User document does not exist in Firestore');
          }
        }
      }

      print('Final detected role: $_userRole');
      print('Is promoter: ${_userRole == 'Promoter'}');
    } catch (e) {
      print('Error loading user role: $e');
      _userRole = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Widget> get _pages {
    final isPromoter = _userRole == 'Promoter';
    print('Building pages - Role: $_userRole, IsPromoter: $isPromoter');
    print('Home page will be: ${isPromoter ? 'PromoterHome' : 'Homeview'}');
    return [
      isPromoter ? PromoterHome() : Homeview(showDrawer: false),
      EventsView(),
      NotificationView(),
      isPromoter ? PromoterProfileView() : FighterProfile(),
    ];
  }

  void _handleMenuButtonPressed() {
    _drawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColor.black,
        body: Center(child: CircularProgressIndicator(color: AppColor.red)),
      );
    }

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
                  title: Text(
                    _userRole == 'Promoter' ? 'Events' : 'Subscription',
                  ),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() => _currentIndex = 2);
                  },
                  leading: SvgPicture.asset(
                    "assets/icons/customer-service.svg",
                  ),
                  title: Text(
                    _userRole == 'Promoter' ? 'Notifications' : 'Support',
                  ),
                ),
                ListTile(
                  onTap: () {
                    _drawerController.hideDrawer();
                    setState(() => _currentIndex = 3);
                  },
                  leading: SvgPicture.asset("assets/icons/setting.svg"),
                  title: Text('Profile'),
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
    final isPromoter = _userRole == 'Promoter';
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: AppColor.white,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: isPromoter ? 'Events' : 'Stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: isPromoter ? 'Notifications' : 'Training',
        ),
      ],
    );
  }

  String _getTitle(int index) {
    final isPromoter = _userRole == 'Promoter';
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return isPromoter ? 'Events' : 'Stats';
      case 2:
        return isPromoter ? 'Notifications' : 'Training';
      case 3:
        return 'Profile';
      default:
        return 'App';
    }
  }
}
