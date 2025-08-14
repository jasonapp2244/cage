import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Profile/fighter/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UploadCompanyLogo extends StatelessWidget {
  const UploadCompanyLogo({super.key});

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
                    "Upload company logo",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Add a clear image that represents your company or brand.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ProfilePic()],
                  ),
                ],
              ),
              Button(
                text: "Next",
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.PromotorBottomNavBar);
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
