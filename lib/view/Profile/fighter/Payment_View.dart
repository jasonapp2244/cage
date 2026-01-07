import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.h(2)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(2)),
              Text(
                "Boost Your Profile",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Stand out in search results and get noticed by more promoters.",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: Responsive.h(2)),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    color: AppColor.white.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset("assets/icons/diamond.svg"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "\$9.99",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 36,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "/ Month",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 12,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Featured Fighter Plan",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 12,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: AppColor.white, thickness: 1),
                          ),
                        ],
                      ),
                      Text(
                        "You can cancel anytime. This subscription only boosts your profile and does not affect application results directly.",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 10,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: Responsive.h(1)),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/right.svg"),
                          SizedBox(width: Responsive.w(2)),
                          Text(
                            "Appear at the top of promoter searches",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 10,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(0.5)),

                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/right.svg"),
                          SizedBox(width: Responsive.w(2)),
                          Text(
                            "Get a “Featured” badge on your profile",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 10,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(0.5)),

                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/right.svg"),
                          SizedBox(width: Responsive.w(2)),
                          Text(
                            "Priority visibility on event applications",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 10,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(0.5)),

                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/right.svg"),
                          SizedBox(width: Responsive.w(2)),
                          Text(
                            "More chances to get scouted and invited",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 10,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(0.5)),

                      Row(
                       children : [
                          SvgPicture.asset("assets/icons/right.svg"),
                          SizedBox(width: Responsive.w(2)),
                          Text(
                            "Appear at the top of promoter searches",
                            style: TextStyle(
                              fontSize: Responsive.textScaleFactor * 10,
                              color: AppColor.white,
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 8.0),
                        child: Button(text: "Subscribe Now", onTap: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
