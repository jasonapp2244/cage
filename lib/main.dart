import 'package:cage/provider/role_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Payment_View.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/Promoter/promoter_profile_view.dart';
import 'package:cage/view/Profile/Promoter/tab_controller.dart';
import 'package:cage/view/Profile/Promoter/test.dart';
import 'package:cage/view/Profile/fighter/fighter_profile.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:cage/view/change_password_view.dart';
import 'package:cage/view/createnew_ticticket_view.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/view/support_view.dart';
import 'package:cage/view/term_condition_view.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // if using FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase init error: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.red,
          selectionColor: AppColor.red.withValues(
            alpha: 0.5,                                                              
          ), // Changed from withValues to withOpacity
          selectionHandleColor: AppColor.red,
        ),
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColor.red),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // You should use either home or initialRoute, not both
      // home:EventsView(),
      initialRoute: RoutesName.spalsh, // Fixed typo from 'spalsh' to 'splash'
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}

// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/view/splash_view.dart';
// import 'package:cage/viewmodel/auth_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => AuthViewmodel())],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         textSelectionTheme: TextSelectionThemeData(
//           cursorColor: AppColor.red,
//           selectionColor: AppColor.red.withValues(alpha: 0.5),
//           selectionHandleColor: AppColor.red,
//         ),
//         // colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColor.red),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       home:
//       //  SplashView(),
//       initialRoute: RoutesName.spalsh,
//       onGenerateRoute: Routes.generateRoutes,
//     );
//   }
// }
