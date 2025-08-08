import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/profile_pic.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';

class EidtProfile extends StatelessWidget {
  EidtProfile({super.key});

  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFoucsNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFoucsNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFoucsNode = FocusNode();
  final TextEditingController fightwonController = TextEditingController();
  final FocusNode fightwonFoucsNode = FocusNode();
  final TextEditingController fightloseController = TextEditingController();
  final FocusNode fightloseFoucsNode = FocusNode();
  final TextEditingController fightknockoutController = TextEditingController();
  final FocusNode fightknockoutFoucsNode = FocusNode();
  final TextEditingController weightController = TextEditingController();
  final FocusNode weightFoucsNode = FocusNode();
  final TextEditingController cocahController = TextEditingController();
  final FocusNode cocahFoucsNode = FocusNode();
  final TextEditingController tapologyController = TextEditingController();
  final FocusNode tapologyFoucsNode = FocusNode();
  final FocusNode buttonFoucsNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ProfilePic(),
                ),
                Text(
                  "Remove",
                  style: TextStyle(
                    color: AppColor.red,
                    fontWeight: FontWeight.normal,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
                EditProfileTextfeild(
                  text: 'Name',
                  controller: nameController,
                  focusNode: nameFoucsNode,
                  nextfocusNode: emailFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Email Adress',
                  controller: emailController,
                  focusNode: emailFoucsNode,
                  nextfocusNode: phoneFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Phone No',
                  controller: phoneController,
                  focusNode: phoneFoucsNode,
                  nextfocusNode: fightwonFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Fight Wins',
                  controller: fightwonController,
                  focusNode: fightwonFoucsNode,
                  nextfocusNode: fightloseFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Fight losses',
                  controller: fightloseController,
                  focusNode: fightloseFoucsNode,
                  nextfocusNode: fightknockoutFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Fight Knockouts',
                  controller: fightknockoutController,
                  focusNode: fightknockoutFoucsNode,
                  nextfocusNode: weightFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Fight won',
                  controller: weightController,
                  focusNode: weightFoucsNode,
                  nextfocusNode: cocahFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Coach Name',
                  controller: cocahController,
                  focusNode: cocahFoucsNode,
                  nextfocusNode: tapologyFoucsNode,
                ),
                EditProfileTextfeild(
                  text: 'Fight won',
                  controller: tapologyController,
                  focusNode: tapologyFoucsNode,
                  nextfocusNode: buttonFoucsNode,
                ),
                Button(
                  focusNode: buttonFoucsNode,
                  text: "Save",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
