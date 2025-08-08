import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FightingStyleView extends StatelessWidget {
  const FightingStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What’s your fighting style?",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Choose the martial arts or disciplines you specialize in. You can select more than one style to showcase your full skill set.",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              TextFormField(
                style: TextStyle(color: AppColor.white),
                // controller: emailController,
                // focusNode: emailFoucsNode,
                cursorColor: AppColor.red,
                cursorErrorColor: AppColor.red,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.w(12),
                    ), // 6% of width
                    borderSide: BorderSide(color: AppColor.red),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Responsive.w(12)),
                    borderSide: BorderSide(color: AppColor.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red),
                    borderRadius: BorderRadius.circular(Responsive.w(12)),
                  ),
                  // prefixIcon: Padding(
                  //   padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
                  //   child: SvgPicture.asset("assets/icons/mail-02.svg"),
                  // ),
                  filled: true,
                  fillColor: AppColor.white.withValues(alpha: 0.08),
                  hintText: "Enter Manger Full Name",
                  hintStyle: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontWeight: FontWeight.normal,
                    fontSize: Responsive.sp(15),
                  ),
                ),
                // onFieldSubmitted: (value) {
                //   Utils.fieldFoucsChange(
                //     context,
                //     emailFoucsNode,
                //     passwordFoucsNode,
                //   );
                // },
              ),

              Button(
                text: "Next",
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.ageview);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
