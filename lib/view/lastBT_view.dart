import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LastbloodtestView extends StatelessWidget {
  const LastbloodtestView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.h(2)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),
                  Text(
                    "When was your last blood test?",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Select the date your blood was last drawn for medical clearance.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

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
                      hintText: "Select Date",
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
                ],
              ),
              Button(
                text: "Next",
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.physicalText_view);
                },
              ),
              // SizedBox(height: Responsive.h(3)),
            ],
          ),
        ),
      ),
    );
  }
}
