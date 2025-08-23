import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class CreatenewTicticketView extends StatelessWidget {
  CreatenewTicticketView({super.key});
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();
  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
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
                    "Create New Ticket",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              EditProfileTextfeild(
                text: 'Subject...',
                controller: subjectController,
                focusNode: subjectFoucs,
                nextfocusNode: messageFoucs,
              ),

              TextFormField(
                maxLines: 5,
                controller: MessageController,
                focusNode: messageFoucs,
                style: TextStyle(color: AppColor.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.white.withValues(alpha: 0.05),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  hint: Text(
                    "Message",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                    ),
                  ),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFoucsChange(context, messageFoucs, buttonFoucs);
                },
              ),

              Button(text: "Submit", onTap: () {}, focusNode: buttonFoucs),
            ],
          ),
        ),
      ),
    );
  }
}
