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

class FightStyleView extends StatefulWidget {
  const FightStyleView({super.key});

  @override
  State<FightStyleView> createState() => _FightStyleViewState();
}

class _FightStyleViewState extends State<FightStyleView> {
  var selectedFightStyle = 'Option 1';
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
                    "What’s your fighting style?",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Choose the martial arts or disciplines you specialize in. You can select more than one style to showcase your full skill set.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  DropdownButtonFormField<String>(
                    style: TextStyle(color: AppColor.white),
                    dropdownColor: AppColor.white.withOpacity(
                      0.1,
                    ), // background of dropdown menu
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
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
                      filled: true,
                      fillColor: AppColor.white.withOpacity(0.08),

                      hintText: "Select",
                      hintStyle: GoogleFonts.dmSans(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    iconEnabledColor: AppColor.white, // arrow color
                    items: const [
                      DropdownMenuItem(value: "Boxing", child: Text("Boxing")),
                      DropdownMenuItem(
                        value: "Muay Thai",
                        child: Text("Muay Thai"),
                      ),
                      DropdownMenuItem(
                        value: "Kickboxing",
                        child: Text("Kickboxing"),
                      ),
                      DropdownMenuItem(value: "Karate", child: Text("Karate")),
                      DropdownMenuItem(
                        value: "Taekwondo",
                        child: Text("Taekwondo"),
                      ),
                      DropdownMenuItem(value: "Savate", child: Text("Savate")),
                      DropdownMenuItem(
                        value: "Kung Fu",
                        child: Text("Kung Fu"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFightStyle = value!;
                      });

                      // handle value change here
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  Button(
                    text: "Next",
                    onTap: () {
                      var uid = Utils.getCurrentUid();
                      authProvider.addUserFieldByRole(
                        uid: uid,
                        fieldName: 'fightsStyle',
                        value: selectedFightStyle.toString(),
                      );

                      Navigator.pushNamed(context, RoutesName.tapalogy_view);
                    },
                  ),
                ],
              ), // SizedBox(height: Responsive.h(3)),
            ],
          ),
        ),
      ),
    );
  }
}
