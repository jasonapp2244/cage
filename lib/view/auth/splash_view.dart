import 'dart:async';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Loginview()),
      );
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

// import 'dart:async';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/view/loginview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     Timer(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => Loginview()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Initialize responsive values
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final iconSize = screenWidth * 0.6; // 60% of screen width

//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: iconSize,
//                 height: iconSize,
//                 child: SvgPicture.asset(
//                   "assets/images/icon.svg",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.05),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/view/loginview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     // Add any initialization logic here if needed
//     await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading

//     Timer(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => Loginview()),
//       );
//       // Get.offAllNamed(RoutesName.loginScreen);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [Center(child: SvgPicture.asset("assets/images/icon.svg"))],
//         ),
//       ),
//     );
//   }
// }
