import 'dart:async';

import 'package:cage/firebase_options.dart';
import 'package:cage/provider/change_password_provider.dart';
import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/provider/fighter_provider.dart';
import 'package:cage/provider/location_provider.dart';
import 'package:cage/provider/promoter_provider.dart';
import 'package:cage/provider/role_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/provider/ticket_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/res/components/app_theme.dart';
import 'package:cage/models/app_theme_model.dart';
import 'package:cage/services/block_status_monitor.dart';
import 'package:cage/services/notification_service.dart';
import 'package:cage/services/payment_service.dart';
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
    
    // Initialize app colors from Firestore
    await AppColor.initialize();
    print("App colors initialized successfully");
    
    // Initialize app theme from Firestore
    await AppTheme.initialize();
    print("App theme initialized successfully");
    
    // Initialize local notifications
    await NotificationService.initialize();
    print("Notifications initialized successfully");
    
    // Initialize Stripe with publishable key
    await PaymentService.initializeStripe('pk_test_51SQG7nBw0JTYxvz9IsBUIj0TC8k3m7MDUuOnr8zgRKJXmWAvmRvvNTE1hp2cRJsS1tTYjMF1nSQvOyW92Nrcsq7400wy3sLcI1pub');
    print("Stripe initialized successfully");
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
        ChangeNotifierProvider(create: (_) => PromoterProvider()),
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
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<Map<String, Color>>? _colorSubscription;
  StreamSubscription<AppThemeModel>? _themeSubscription;
  User? _previousUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set up auth state listener after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupAuthStateListener();
      _setupColorListener();
      _setupThemeListener();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authStateSubscription?.cancel();
    _colorSubscription?.cancel();
    _themeSubscription?.cancel();
    _blockMonitor.dispose();
    super.dispose();
  }

  void _setupColorListener() {
    _colorSubscription = AppColor.colorStream.listen((colors) {
      if (mounted) {
        setState(() {
          // Colors are updated automatically in AppColor class
          // This setState will trigger a rebuild with new colors
        });
      }
    });
  }

  void _setupThemeListener() {
    _themeSubscription = AppTheme.themeStream.listen((theme) {
      if (mounted) {
        setState(() {
          // Theme is updated automatically in AppTheme class
          // This setState will trigger a rebuild with new theme
        });
      }
    });
  }

  void _setupAuthStateListener() {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      // Only update if auth state actually changed
      if (user?.uid != _previousUser?.uid) {
        _previousUser = user;
        if (user != null) {
          // User is logged in, start monitoring
          _initializeBlockMonitoring();
        } else {
          // User is logged out, stop monitoring
          _blockMonitor.stopMonitoring();
        }
      }
    });
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
        // Use post-frame callback to ensure Navigator is not locked
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey.currentState != null && mounted) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              RoutesName.login,
              (route) => false,
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      // home: DiscoverView(),
      initialRoute:
          RoutesName.spalsh, // Fixed typo from 'spalsh' to 'splash'
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
