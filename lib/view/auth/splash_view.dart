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
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Loginview(),
        transitionDuration: const Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
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
// import 'package:cage/view/auth/loginview.dart';
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
//     await Future.delayed(const Duration(seconds: 2));
//     Timer(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => Loginview()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final iconSize = screenWidth * 0.6;

//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Hero(
//                 tag: 'app-logo',
//                 flightShuttleBuilder:
//                     (
//                       flightContext,
//                       animation,
//                       flightDirection,
//                       fromHeroContext,
//                       toHeroContext,
//                     ) {
//                       // You can return different widgets based on the flight direction
//                       if (flightDirection == HeroFlightDirection.pop) {
//                         // When pushing to the new screen (Splash → Login)
//                         return ScaleTransition(
//                           scale: animation.drive(
//                             Tween<double>(
//                               begin: 1.0,
//                               end: 0.5,
//                             ).chain(CurveTween(curve: Curves.slowMiddle)),
//                           ),
//                           child: fromHeroContext.widget,
//                         );
//                       } else {
//                         return FadeTransition(
//                           opacity: animation,
//                           child: fromHeroContext.widget,
//                         );
//                       }
//                     },
//                 child: SizedBox(
//                   width: iconSize,
//                   height: iconSize,
//                   child: SvgPicture.asset(
//                     "assets/images/icon.svg",
//                     fit: BoxFit.contain,
//                   ),
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