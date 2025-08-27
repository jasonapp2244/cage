import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Profile/Promoter/about_company_name.dart';
import 'package:cage/view/Profile/Promoter/company_name_view.dart';
import 'package:cage/view/Profile/Promoter/contact_email_view.dart';
import 'package:cage/view/Profile/Promoter/contact_number_view.dart';
import 'package:cage/view/Profile/Promoter/event_history.dart';
import 'package:cage/view/Profile/Promoter/explorefighters_view.dart';
import 'package:cage/view/Profile/Promoter/promoter_profile_view.dart';
import 'package:cage/view/Profile/Promoter/promotor_subcribtion_view.dart';
import 'package:cage/view/Profile/Promoter/upload_company_logo.dart';
import 'package:cage/view/Profile/Promoter/who_thePromoter_view.dart';
import 'package:cage/view/Profile/Promoter/promoter_home.dart';
import 'package:cage/view/Profile/fighter/Payment_View.dart';
import 'package:cage/view/Profile/fighter/eidt_profile.dart';
import 'package:cage/view/Profile/fighter/fighter_personal_profile.dart';
import 'package:cage/view/Profile/fighter/fighter_public_profile.dart';
import 'package:cage/view/Profile/fighter/age_view.dart';
import 'package:cage/view/Profile/fighter/bottom_wraper.dart';
import 'package:cage/view/Profile/fighter/review_view.dart';
import 'package:cage/view/change_password_view.dart';
import 'package:cage/view/Profile/fighter/coach_conatct.dart';
import 'package:cage/view/Profile/fighter/coach_view.dart';
import 'package:cage/view/Profile/fighter/createnew_ticticket_view.dart';
import 'package:cage/view/Profile/fighter/enter_name_view.dart';
import 'package:cage/view/exploer/events_view.dart';
import 'package:cage/view/Profile/fighter/eye_test_view.dart';
import 'package:cage/view/Profile/fighter/fight_knockout_view.dart';
import 'package:cage/view/Profile/fighter/fight_lose_view.dart';
import 'package:cage/view/Profile/fighter/fight_style_view.dart';
import 'package:cage/view/Profile/fighter/fight_win_view.dart';
import 'package:cage/view/Profile/fighter/hight_view.dart';
import 'package:cage/view/Profile/fighter/homeview.dart';
import 'package:cage/view/Profile/fighter/lastBT_view.dart';
import 'package:cage/view/Profile/fighter/last_physical_exam_view.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:cage/view/map_screen.dart';
import 'package:cage/view/notification_view.dart';
import 'package:cage/view/auth/otp_view.dart';
import 'package:cage/view/Profile/Promoter/promotor_bottom_nav_bar.dart';
import 'package:cage/view/auth/role_selector_view.dart';
import 'package:cage/view/auth/sginupview.dart';
import 'package:cage/view/auth/splash_view.dart';
import 'package:cage/view/support_view.dart';
import 'package:cage/view/Profile/fighter/tapalogy_view.dart';
import 'package:cage/view/term_condition_view.dart';
import 'package:cage/view/Profile/fighter/updateProfle_view.dart';
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

      case RoutesName.fighterpersonalprofileView:
        return MaterialPageRoute(
          builder: (BuildContext context) => FighterPublicProfile(),
        );
      case RoutesName.FighterPublicProfile:
        return MaterialPageRoute(
          builder: (BuildContext context) => FighterPublicProfile(),
        );
      case RoutesName.review:
        return MaterialPageRoute(
          builder: (BuildContext context) => ReviewView(),
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

      // case RoutesName.promoterView:
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) => PromotersView(),
      //   );
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
      case RoutesName.PromotorSubcribtionView:
        return MaterialPageRoute(
          builder: (BuildContext context) => PromotorSubcribtionView(),
        );

      case RoutesName.supportView:
        return MaterialPageRoute(
          builder: (BuildContext context) => SupportView(),
        );
      case RoutesName.UploadCompanyLogo:
        return MaterialPageRoute(
          builder: (BuildContext context) => UploadCompanyLogo(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => MainWrapper(),
        );
      case RoutesName.PromotorBottomNavBar:
        return MaterialPageRoute(
          builder: (BuildContext context) => PromotorBottomNavBar(),
        );
      case RoutesName.WhoThepromoterView:
        return MaterialPageRoute(
          builder: (BuildContext context) => WhoThepromoterView(),
        );
      case RoutesName.PromoterHome:
        return MaterialPageRoute(
          builder: (BuildContext context) => PromoterHome(),
        );
      case RoutesName.PromoterProfileView:
        return MaterialPageRoute(
          builder: (BuildContext context) => PromoterProfileView(),
        );

      case RoutesName.aboutCompanayName:
        return MaterialPageRoute(
          builder: (BuildContext context) => AboutCompanyNameView(),
        );

      case RoutesName.namecoachview:
        return MaterialPageRoute(
          builder: (BuildContext context) => CoachNameView(),
        );
      case RoutesName.EventHistory:
        return MaterialPageRoute(
          builder: (BuildContext context) => EventHistory(),
        );
      case RoutesName.ContactNumberView:
        return MaterialPageRoute(
          builder: (BuildContext context) => ContactNumberView(),
        );
      case RoutesName.ContactEmailView:
        return MaterialPageRoute(
          builder: (BuildContext context) => ContactEmailView(),
        );
      case RoutesName.CompanyNameView:
        return MaterialPageRoute(
          builder: (BuildContext context) => EnterCompanyNameView(),
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

      case RoutesName.UploadCompanyLogo:
        return MaterialPageRoute(
          builder: (BuildContext context) => UploadCompanyLogo(),
        );

      case RoutesName.PromoterHome:
        return MaterialPageRoute(
          builder: (BuildContext context) => ExploreFightersView(),
        );

      default:
        RoutesName.home;
        return MaterialPageRoute(builder: (BuildContext context) => Homeview());
    }
  }
}
