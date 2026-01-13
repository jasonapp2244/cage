import 'dart:async';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if user is already logged in with Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is already authenticated, check role and navigate
      _navigateBasedOnRole(currentUser.uid);
      return;
    }

    // Check for saved credentials
    final credentials = await Utils.getLoginCredentials();
    final savedEmail = credentials['email'];
    final savedPassword = credentials['password'];
    final isLoggedIn = credentials['isLoggedIn'] == 'true';

    if (isLoggedIn && savedEmail != null && savedPassword != null) {
      // Auto-login with saved credentials
      if (mounted) {
        final authProvider = Provider.of<AuthViewmodel>(context, listen: false);
        try {
          await authProvider.performLogin(
            savedEmail,
            savedPassword,
            context,
          );
          // Navigation will be handled in performLogin method
          return;
        } catch (e) {
          // Login failed, clear credentials and go to login screen
          await Utils.clearLoginCredentials();
          if (mounted) {
            _navigateToLogin();
          }
          return;
        }
      }
    }

    // No saved credentials or auto-login failed, go to login screen
    if (mounted) {
      _navigateToLogin();
    }
  }

  Future<void> _navigateBasedOnRole(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final role = userDoc.data()!['role'];
        if (role == 'Fighter') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, RoutesName.home);
          }
        } else if (role == 'Promoter') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, RoutesName.PromotorBottomNavBar);
          }
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, RoutesName.roleView);
          }
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesName.roleView);
        }
      }
    } catch (e) {
      // Error fetching user data, go to login
      if (mounted) {
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginview()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.6;

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app-logo',
                flightShuttleBuilder:
                    (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) {
                      // You can return different widgets based on the flight direction
                      if (flightDirection == HeroFlightDirection.push) {
                        // When pushing to the new screen (Splash → Login)
                        return ScaleTransition(
                          scale: animation.drive(
                            Tween<double>(
                              begin: 1.0,
                              end: 0.5,
                            ).chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: fromHeroContext.widget,
                        );
                      } else {
                        // When popping back (Login → Splash)
                        return FadeTransition(
                          opacity: animation,
                          child: fromHeroContext.widget,
                        );
                      }
                    },
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: SvgPicture.asset(
                    "assets/images/icon.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
