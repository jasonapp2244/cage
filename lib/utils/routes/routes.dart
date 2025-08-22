import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Payment_View.dart';
import 'package:cage/view/Profile/Promoter/about_company_name.dart';
import 'package:cage/view/Profile/Promoter/company_name_view.dart';
import 'package:cage/view/Profile/Promoter/contact_email_view.dart';
import 'package:cage/view/Profile/Promoter/contact_number_view.dart';
import 'package:cage/view/Profile/Promoter/event_history.dart';
import 'package:cage/view/Profile/Promoter/upload_company_logo.dart';
import 'package:cage/view/Profile/Promoter/who_thePromoter_view.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:cage/view/Profile/fighter/fighter_profile.dart';
import 'package:cage/view/age_view.dart';
import 'package:cage/view/bottom_wraper.dart';
import 'package:cage/view/change_password_view.dart';
import 'package:cage/view/coach_conatct.dart';
import 'package:cage/view/coach_view.dart';
import 'package:cage/view/createnew_ticticket_view.dart';
import 'package:cage/view/enter_name_view.dart';
import 'package:cage/view/exploer/Promoters_view.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:cage/view/eye_test_view.dart';
import 'package:cage/view/fight_knockout_view.dart';
import 'package:cage/view/fight_lose_view.dart';
import 'package:cage/view/fight_style_view.dart';
import 'package:cage/view/fight_win_view.dart';
import 'package:cage/view/hight_view.dart';
import 'package:cage/view/homeview.dart';
import 'package:cage/view/lastBT_view.dart';
import 'package:cage/view/last_physical_exam_view.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:cage/view/map_screen.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/view/otp_view.dart';
import 'package:cage/view/role_selector_view.dart';
import 'package:cage/view/auth/sginupview.dart';
import 'package:cage/view/auth/splash_view.dart';
import 'package:cage/view/support_view.dart';
import 'package:cage/view/tapalogy_view.dart';
import 'package:cage/view/term_condition_view.dart';
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
      case RoutesName.notificationView:
        return MaterialPageRoute(
          builder: (BuildContext context) => NotificationView(),
        );
      case RoutesName.eventsView:
        return MaterialPageRoute(
          builder: (BuildContext context) => EventsView(),
        );
      case RoutesName.CreatenewTicticketView:
        return MaterialPageRoute(
          builder: (BuildContext context) => CreatenewTicticketView(),
        );
      case RoutesName.EidtProfile:
        return MaterialPageRoute(
          builder: (BuildContext context) => EidtProfile(),
        );

      case RoutesName.fighterprofileView:
        return MaterialPageRoute(
          builder: (BuildContext context) => FighterProfile(),
        );
      case RoutesName.PaymentView:
        return MaterialPageRoute(
          builder: (BuildContext context) => PaymentView(),
        );
      case RoutesName.Change_Password_View:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangePasswordView(),
        );
      case RoutesName.TermConditionView:
        return MaterialPageRoute(
          builder: (BuildContext context) => TermConditionView(),
        );

      case RoutesName.promoterView:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightersView(),
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

      case RoutesName.supportView:
        return MaterialPageRoute(
          builder: (BuildContext context) => SupportView(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => MainWrapper(),
        );

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

      case RoutesName.selectLocation:
        return MaterialPageRoute(
          builder: (BuildContext context) => SelectLocationView(),
        );

      case RoutesName.companyName:
        return MaterialPageRoute(
          builder: (BuildContext context) => EnterCompanyNameView(),
        );

      case RoutesName.contactEmail:
        return MaterialPageRoute(
          builder: (BuildContext context) => ContactEmailView(),
        );

      case RoutesName.aboutCompany:
        return MaterialPageRoute(
          builder: (BuildContext context) => AboutCompanyNameView(),
        );

      case RoutesName.historyEvents:
        return MaterialPageRoute(
          builder: (BuildContext context) => EventHistoryView(),
        );

      case RoutesName.whoThePrompter:
        return MaterialPageRoute(
          builder: (BuildContext context) => WhoThepromoterView(),
        );
      case RoutesName.contactNumber:
        return MaterialPageRoute(
          builder: (BuildContext context) => ContactNumberView(),
        );

      case RoutesName.companyLogo:
        return MaterialPageRoute(
          builder: (BuildContext context) => UploadCompanyLogo(),
        );

      case RoutesName.promoterHome:
        return MaterialPageRoute(
          builder: (BuildContext context) => FightersView(),
        );

      default:
        RoutesName.home;
        return MaterialPageRoute(builder: (BuildContext context) => Homeview());
    }
  }
}
