import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewView extends StatelessWidget {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "4.8",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 72,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Based on 40 Reviews",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 12,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      // color: AppColor.white,
                      child: Column(
                        spacing: 1,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(22),
                                  backgroundColor: AppColor.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.red,
                                  ), // Progress color
                                  value: 0.5, // Set progress to 50%
                                ),
                              ),
                              SizedBox(width: Responsive.w(1)),
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 12,
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(22),
                                  backgroundColor: AppColor.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.red,
                                  ), // Progress color
                                  value: 0.9, // Set progress to 50%
                                ),
                              ),
                              Text(
                                "2",
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 12,
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(22),
                                  backgroundColor: AppColor.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.red,
                                  ), // Progress color
                                  value: 0.3, // Set progress to 50%
                                ),
                              ),
                              SizedBox(width: Responsive.w(1)),
                              Text(
                                "3",
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 12,
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(22),
                                  backgroundColor: AppColor.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.red,
                                  ), // Progress color
                                  value: 0.7, // Set progress to 50%
                                ),
                              ),
                              SizedBox(width: Responsive.w(1)),
                              Text(
                                "4",
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 12,
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(22),
                                  backgroundColor: AppColor.white.withValues(
                                    alpha: 0.4,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColor.red,
                                  ), // Progress color
                                  value: 0.2, // Set progress to 50%
                                ),
                              ),
                              SizedBox(width: Responsive.w(1)),
                              Text(
                                "5",
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 12,
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: ((context, index) {
                    return Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: AppColor.white.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: AppColor.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                  image: AssetImage(
                                    "assets/images/Frame 1410120835.png",
                                  ),
                                ),

                                SizedBox(width: Responsive.w(2)),
                                Text(
                                  "Ruben ",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontFamily: AppFonts.appFont,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(10),
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "3h ago",
                                      style: TextStyle(
                                        color: AppColor.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        fontFamily: AppFonts.appFont,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.sp(10),
                                      ),
                                    ),
                                    Image(
                                      image: AssetImage(
                                        "assets/icons/material-symbols_star.png",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.h(1)),
                            Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                              style: TextStyle(
                                color: AppColor.white,
                                fontFamily: AppFonts.appFont,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
