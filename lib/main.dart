import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/hight_view.dart';
import 'package:cage/view/role_selector_view.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewmodel())],
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
      // home: RoleSelectionScreen(),
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
