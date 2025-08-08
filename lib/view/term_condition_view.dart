import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TermConditionView extends StatelessWidget {
  const TermConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 24,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(3)),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Non egestas ornare volutpat lectus scelerisque nulla risus. Tellus commodo odio mi convallis risus ipsum elementum dis. Egestas dictum nisl leo netus aliquet tincidunt. Turpis accumsan iaculis odio adipiscing nulla sollicitudin non.',
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(height: Responsive.h(5)),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Non egestas ornare volutpat lectus scelerisque nulla risus. Tellus commodo odio mi convallis risus ipsum elementum dis. Egestas dictum nisl leo netus aliquet tincidunt. Turpis accumsan iaculis odio adipiscing nulla sollicitudin non.',
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(height: Responsive.h(5)),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Non egestas ornare volutpat lectus scelerisque nulla risus. Tellus commodo odio mi convallis risus ipsum elementum dis. Egestas dictum nisl leo netus aliquet tincidunt. Turpis accumsan iaculis odio adipiscing nulla sollicitudin non.',
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(height: Responsive.h(5)),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Non egestas ornare volutpat lectus scelerisque nulla risus. Tellus commodo odio mi convallis risus ipsum elementum dis. Egestas dictum nisl leo netus aliquet tincidunt. Turpis accumsan iaculis odio adipiscing nulla sollicitudin non.',
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(height: Responsive.h(5)),
                Text(
                  'Lorem ipsum dolor sit amet consectetur. Non egestas ornare volutpat lectus scelerisque nulla risus. Tellus commodo odio mi convallis risus ipsum elementum dis. Egestas dictum nisl leo netus aliquet tincidunt. Turpis accumsan iaculis odio adipiscing nulla sollicitudin non.',
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 12,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
