import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/custom_calendar.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EyeTestView extends StatefulWidget {
  @override
  State<EyeTestView> createState() => _EyeTestViewState();
}

class _EyeTestViewState extends State<EyeTestView> {
  TextEditingController _eyeTestController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthViewmodel>(context);

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
                    "When was your last eye exam?",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Enter the date of your most recent vision check.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  GestureDetector(
                    onTap: () async {
                      final date = await showCustomCalendar(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          _eyeTestController.text =
                              "${date.day}/${date.month}/${date.year}";
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.red),
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
                      ),
                      child: TextFormField(
                        style: TextStyle(color: AppColor.white),
                        controller: _eyeTestController,
                        enabled: false, // Make it read-only
                        cursorColor: AppColor.red,
                        cursorErrorColor: AppColor.red,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.w(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Responsive.w(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                              Responsive.w(12),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColor.red,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: AppColor.white.withValues(alpha: 0.08),
                          hintText: "Select Date",
                          hintStyle: GoogleFonts.dmSans(
                            color: AppColor.white,
                            fontWeight: FontWeight.normal,
                            fontSize: Responsive.sp(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
