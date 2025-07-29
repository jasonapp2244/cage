import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/homeview.dart';
import 'package:cage/view/loginview.dart';
import 'package:cage/view/splash_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings setting) {
    // setting.arguments;
    switch (setting.name) {
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => Homeview());
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => Loginview(),
        );
      case RoutesName.spalsh:
        return MaterialPageRoute(
          builder: (BuildContext context) => SplashView(),
        );

      default:
        RoutesName.home;
        return MaterialPageRoute(builder: (BuildContext context) => Homeview());
    }
  }
}
