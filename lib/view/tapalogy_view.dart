import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TapalogyView extends StatelessWidget {
  TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
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
                    "Add your Tapology profile URL",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Paste your Tapology profile link so promoters can verify your fight history and stats. This helps build credibility and trust.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  TextFormField(
                    style: TextStyle(color: AppColor.white),
                    controller: urlController,
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
                      hintText: "e.g www.taplogy.com",
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
                  var uid = Utils.getCurrentUid();
                    authProvider.addUserFieldByRole                        (
                    uid: uid,
                    fieldName: 'urlProfile',
                    value: urlController.text.toString(),
                  );

                  Navigator.pushNamed(context, RoutesName.lastBloodTest_view);
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
