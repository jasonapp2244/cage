import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FightStyleView extends StatefulWidget {
  const FightStyleView({super.key});

  @override
  State<FightStyleView> createState() => _FightStyleViewState();
}

class _FightStyleViewState extends State<FightStyleView> {
  final _formKey = GlobalKey<FormState>();
  String? selectedStyle;
  final List<String> fightStyles = [
    "Boxing",
    "Muay Thai",
    "Wrestling",
    "BJJ",
    "Karate",
    "Taekwondo",
    "Judo",
    "Kickboxing",
    "Sambo",
    "Sanda",
  ];

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Form(
            key: _formKey,
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
                      iconEnabledColor: AppColor.white,
                      dropdownColor: AppColor.red,
                      style: GoogleFonts.rethinkSans(
                        color: AppColor.white,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.white.withValues(alpha: 0.08),
                        enabledBorder: UnderlineInputBorder(
                          // borderSide: BorderSide(color: AppColor.white),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.red),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        // prefixIcon: Padding(
                        //   padding: const EdgeInsets.all(12.0),
                        //   child: SvgPicture.asset('assets/icons/building.svg'),
                        // ),
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Industry',
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: Responsive.textScaleFactor * 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.20,
                            ),
                          ),
                        ),
                      ),
                      value: selectedStyle,
                      items: fightStyles.map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStyle = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a language' : null,
                    ),

                    // TextFormField(
                    //   style: TextStyle(color: AppColor.white),
                    //   // controller: emailController,
                    //   // focusNode: emailFoucsNode,
                    //   cursorColor: AppColor.red,
                    //   cursorErrorColor: AppColor.red,
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(
                    //         Responsive.w(12),
                    //       ), // 6% of width
                    //       borderSide: BorderSide(color: AppColor.red),
                    //     ),
                    //     errorBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(Responsive.w(12)),
                    //       borderSide: BorderSide(color: AppColor.red),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: AppColor.red),
                    //       borderRadius: BorderRadius.circular(Responsive.w(12)),
                    //     ),
                    //     // prefixIcon: Padding(
                    //     //   padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
                    //     //   child: SvgPicture.asset("assets/icons/mail-02.svg"),
                    //     // ),
                    //     filled: true,
                    //     fillColor: AppColor.white.withValues(alpha: 0.08),
                    //     hintText: "e.g www.taplogy.com",
                    //     hintStyle: GoogleFonts.dmSans(
                    //       color: AppColor.white,
                    //       fontWeight: FontWeight.normal,
                    //       fontSize: Responsive.sp(15),
                    //     ),
                    //   ),
                    //   // onFieldSubmitted: (value) {
                    //   //   Utils.fieldFoucsChange(
                    //   //     context,
                    //   //     emailFoucsNode,
                    //   //     passwordFoucsNode,
                    //   //   );
                    //   // },
                    // ),
                  ],
                ),
                Button(
                  text: "Next",
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.tapalogy_view);
                  },
                ),
                // SizedBox(height: Responsive.h(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
