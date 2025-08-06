import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/age_view.dart';
import 'package:cage/view/coach_conatct.dart';
import 'package:cage/view/coach_view.dart';
import 'package:cage/view/enter_name_view.dart';
import 'package:cage/view/eye_test_view.dart';
import 'package:cage/view/fight_knockout_view.dart';
import 'package:cage/view/fight_lose_view.dart';
import 'package:cage/view/fight_style_view.dart';
import 'package:cage/view/fight_win_view.dart';
import 'package:cage/view/hight_view.dart';
import 'package:cage/view/homeview.dart';
import 'package:cage/view/lastBT_view.dart';
import 'package:cage/view/last_physical_exam_view.dart';
import 'package:cage/view/loginview.dart';
import 'package:cage/view/otp_view.dart';
import 'package:cage/view/role_selector_view.dart';
import 'package:cage/view/sginupview.dart';
import 'package:cage/view/splash_view.dart';
import 'package:cage/view/tapalogy_view.dart';
import 'package:cage/view/updateProfle_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings setting) {
    // setting.arguments;
    switch (setting.name) {
      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => Sginupview(),
        );

      case RoutesName.otp:
        return MaterialPageRoute(
          builder: (BuildContext context) => OtpScreen(),
        );

      case RoutesName.fightwon:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightWinView(),
        );

      case RoutesName.coach_name_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => CoachNameView(),
        );

      case RoutesName.cocahContact_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => CoachConatctView(),
        );
      case RoutesName.eyeTest_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => EyeTestView(),
        );
      case RoutesName.fightStyle_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightStyleView(),
        );
      case RoutesName.physicalText_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => LastPhysicalExamView(),
        );
      case RoutesName.lastBloodTest_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => LastbloodtestView(),
        );
      case RoutesName.tapalogy_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => TapalogyView(),
        );
      case RoutesName.updateProilePic_view:
        return MaterialPageRoute(
          builder: (BuildContext context) => UpdateprofleView(),
        );

      case RoutesName.fightlose:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightLoseView(),
        );

      case RoutesName.fightKnouckout:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightKnockoutView(),
        );

      case RoutesName.hightview:
        return MaterialPageRoute(
          builder: (BuildContext context) => HightView(),
        );

      case RoutesName.ageview:
        return MaterialPageRoute(builder: (BuildContext context) => AgeView());

      case RoutesName.nameview:
        return MaterialPageRoute(
          builder: (BuildContext context) => EnterNameView(),
        );

      case RoutesName.roleView:
        return MaterialPageRoute(
          builder: (BuildContext context) => RoleSelectionScreen(),
        );

      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => Homeview());

      case RoutesName.namecoachview:
        return MaterialPageRoute(
          builder: (BuildContext context) => CoachNameView(),
        );

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
