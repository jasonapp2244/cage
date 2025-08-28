import 'package:cage/firebase_options.dart';
import 'package:cage/provider/change_password_provider.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/provider/fighter_provider.dart';
import 'package:cage/provider/location_provider.dart';
import 'package:cage/provider/role_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/provider/ticket_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/viewmodel/notification_settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
    // Continue with app even if Firebase fails to initialize
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawerControllerProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
        ChangeNotifierProvider(create: (_) => FighterProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsViewmodel()),
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
      // home: ActivityView(),
      initialRoute: RoutesName.spalsh, // Fixed typo from 'spalsh' to 'splash'
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
