import 'package:cage/firebase_options.dart';
import 'package:cage/provider/change_password_provider.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/provider/fighter_provider.dart';
import 'package:cage/provider/location_provider.dart';
import 'package:cage/provider/role_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/provider/ticket_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/block_status_monitor.dart';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/viewmodel/notification_settings_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final BlockStatusMonitor _blockMonitor = BlockStatusMonitor();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBlockMonitoring();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _blockMonitor.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-initialize monitoring when app comes to foreground
      _initializeBlockMonitoring();
    } else if (state == AppLifecycleState.paused) {
      // Stop monitoring when app goes to background
      _blockMonitor.stopMonitoring();
    }
  }

  void _initializeBlockMonitoring() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _blockMonitor.startMonitoring(user.uid, () {
        // User was blocked, navigate to login
        if (navigatorKey.currentState != null && mounted) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RoutesName.login,
            (route) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes to start/stop monitoring
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, start monitoring
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeBlockMonitoring();
          });
        } else {
          // User is logged out, stop monitoring
          _blockMonitor.stopMonitoring();
        }

        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColor.red,
              selectionColor: AppColor.red.withValues(
                alpha: 0.5,
              ), // Changed from withValues to withValues(alpha:
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
      },
    );
  }
}
