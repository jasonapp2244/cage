import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutCompanayName extends StatelessWidget {
  const AboutCompanayName({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();

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
                  SizedBox(height: Responsive.h(1)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),
                  Text(
                    "Tell us about your company",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Briefly describe what your company does.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    maxLines: 4,
                    controller: fullNameController,
                    style: TextStyle(color: AppColor.white),
                    // controller: emailController,
                    // focusNode: emailFoucsNode,
                    cursorColor: AppColor.red,
                    cursorErrorColor: AppColor.red,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22
                        ), // 6% of width
                        borderSide: BorderSide(color: AppColor.red),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide(color: AppColor.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.red),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      // prefixIcon: Padding(
                      //   padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
                      //   child: SvgPicture.asset("assets/icons/mail-02.svg"),
                      // ),
                      filled: true,
                      fillColor: AppColor.white.withValues(alpha: 0.08),
                      hintText: "Description",
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

              SizedBox(height: 40),
              Button(
                text: "Next",
                onTap: () {
                  if (fullNameController.text.isEmpty) {
                    Utils.flushBarErrorMassage(
                      "Please Tell Us About Your Company",
                      context,
                    );
                  } else {
                    Navigator.pushNamed(context, RoutesName.EventHistory);
                    // Map<String, String> headr = {
                    //   "x-api-key": "reqres-free-v1",
                    // };
                    // Map data = {
                    //   'email': emailController.text.toString(),
                    //   'password': passwordController.text.toString(),
                    // };
                    // authViewmodel.loginApi(data, headr, context);

                    // Navigator.pushNamed(context, RoutesName.namecoachview);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
