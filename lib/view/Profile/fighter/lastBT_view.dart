// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/widgets/button.dart';
// import 'package:cage/utils/routes/responsive.dart';
// import 'package:cage/utils/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';

// class LastbloodtestView extends StatefulWidget {
//   const LastbloodtestView({super.key});

//   @override
//   State<LastbloodtestView> createState() => _LastbloodtestViewState();
// }

// class _LastbloodtestViewState extends State<LastbloodtestView> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _dateController = TextEditingController();
//   DateTime? _selectedDate;

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.red,
//               onSurface: Colors.black,
//               secondary: Colors.red,
//               onPrimary: Colors.black,
//             ),
//             dialogTheme: DialogThemeData(
//               iconColor: AppColor.red,
//               shadowColor: AppColor.red,
//               barrierColor: AppColor.black,
//               surfaceTintColor: AppColor.black,
//               backgroundColor: AppColor.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//             ),
//             // dialogBackgroundColor: Colors.black,
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Responsive.init(context);
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: Responsive.h(2)),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: SvgPicture.asset(
//                       "assets/icons/arrow-left-01.svg",
//                       color: AppColor.red,
//                     ),
//                   ),
//                   SizedBox(height: Responsive.h(2)),
//                   Text(
//                     "When was your last blood test?",
//                     style: TextStyle(
//                       fontFamily: AppFonts.appFont,
//                       color: AppColor.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Select the date your blood was last drawn for medical clearance.",
//                     style: TextStyle(
//                       fontFamily: AppFonts.appFont,
//                       color: AppColor.white,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                   SizedBox(height: Responsive.h(2)),
//                   TextFormField(
//                     controller: _dateController,
//                     decoration: InputDecoration(
//                       labelText: 'Select Date',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectDate(context),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[50],
//                     ),
//                     readOnly: true,
//                     onTap: () => _selectDate(context),
//                   ),
//                   const SizedBox(height: 20),
//                   if (_selectedDate != null)
//                     Text(
//                       'Selected Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate!)}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                 ],
//               ),
//               Button(
//                 text: "Next",
//                 onTap: () {
//                   Navigator.pushNamed(context, RoutesName.physicalText_view);
//                 },
//               ),
//               // SizedBox(height: Responsive.h(3)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }
// }

import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LastbloodtestView extends StatefulWidget {
  const LastbloodtestView({super.key});

  @override
  State<LastbloodtestView> createState() => _LastbloodtestViewState();
}

class _LastbloodtestViewState extends State<LastbloodtestView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red, // Main selection color
              onPrimary: Colors.white, // Text color on primary
              surface: Colors.black, // Background color
              onSurface: Colors.white, // Text color on surface
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.black, // Dialog background
              surfaceTintColor: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Button text color
              ),
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.grey, // Divider color
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                      "When was your last blood test?",
                      style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        color: AppColor.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Select the date your blood was last drawn for medical clearance.",
                      style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        color: AppColor.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),
                    TextFormField(
                      controller: _dateController,
                      style: const TextStyle(color: Colors.white),
                      // decoration: InputDecoration(
                      //   labelText: 'Select Date',
                      //   labelStyle: const TextStyle(color: Colors.grey),
                      //   border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(12.0),
                      //   ),
                      //   suffixIcon: IconButton(
                      //     icon: const Icon(Icons.calendar_today, color: Colors.red),
                      //     onPressed: () => _selectDate(context),
                      //   ),
                      //   filled: true,
                      //   fillColor: Colors.grey[200],
                      // ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Responsive.w(12),
                          ), // 6% of width
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
                        fillColor: AppColor.white.withValues(alpha: 0.08),
                        hintText: "Select Date",
                        hintStyle: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(15),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedDate != null)
                      Text(
                        'Selected Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate!)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                  ],
                ),
                Button(
                  text: "Next",
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.physicalText_view);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
