import 'package:cage/provider/darwer_provider.dart';
import 'package:cage/provider/role_provider.dart';
import 'package:cage/provider/tab_controller.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/fighter/weight_view.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawerControllerProvider()),
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
          ),
          selectionHandleColor: AppColor.red,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
     home: WeightView(),
      // initialRoute: RoutesName.spalsh, 
      // onGenerateRoute: Routes.generateRoutes,
    );
  }
}
