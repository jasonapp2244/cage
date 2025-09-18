import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/view/Profile/fighter/ScaleGaugeWidget.dart';
import 'package:cage/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Column(
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
              const Text(
                'What\'s your weight?',
                style: TextStyle(
                  color: AppColor.white,
                  fontFamily: AppFonts.appFont,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your current weight in kilograms or pounds (e.g., 154 lbs).',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Container(height: 420, child: ScaleGaugeWidget()),
              const SizedBox(height: 40),
              Button(
                text: "Next",
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.fightwon);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
