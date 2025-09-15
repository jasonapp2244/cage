import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutCompanayName extends StatefulWidget {
  const AboutCompanayName({super.key});

  @override
  State<AboutCompanayName> createState() => _AboutCompanayNameState();
}

class _AboutCompanayNameState extends State<AboutCompanayName> {
  final TextEditingController fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _companyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus after a short delay to ensure UI is built
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_companyFocusNode);
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    _companyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside the text field
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
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
                      SizedBox(height: Responsive.h(1)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/arrow-left-01.svg",
                          color: AppColor.red,
                        ),
                      ),
                      SizedBox(height: Responsive.h(2)),
                      Text(
                        "Tell us about your company",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Briefly describe what your company does.",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        maxLines: 4,
                        controller: fullNameController,
                        focusNode: _companyFocusNode, // Add this line
                        style: TextStyle(color: AppColor.white),
                        onFieldSubmitted: (value) {
                          // This prevents the form submission when Enter is pressed
                          // but allows the user to continue typing
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Tell Us About Your Company";
                          }
                          return null;
                        },
                        cursorColor: AppColor.red,
                        cursorErrorColor: AppColor.red,
                        keyboardType: TextInputType.multiline, // Changed to multiline
                        textInputAction: TextInputAction.newline, // Changed to newline
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(color: AppColor.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(color: AppColor.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.red),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          filled: true,
                          fillColor: AppColor.white.withValues(alpha: 0.08),
                          hintText: "Description",
                          hintStyle: GoogleFonts.dmSans(
                            color: AppColor.white,
                            fontWeight: FontWeight.normal,
                            fontSize: Responsive.sp(15),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),
                  Button(
                    text: "Next",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, RoutesName.EventHistory);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}