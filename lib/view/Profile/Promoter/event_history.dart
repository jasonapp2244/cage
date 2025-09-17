import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});

  @override
  State<EventHistory> createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  final TextEditingController fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _eventFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus after a short delay to ensure UI is built
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_eventFocusNode);
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    _eventFocusNode.dispose();
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
                        "Your event history",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Mention any past events you've organized.",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: fullNameController,
                        focusNode: _eventFocusNode,
                        style: TextStyle(color: AppColor.white),
                        cursorColor: AppColor.red,
                        cursorErrorColor: AppColor.red,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        // Prevent the default behavior of the Enter key
                        onFieldSubmitted: (value) {
                          // This prevents the form submission when Enter is pressed
                          // but allows the user to continue typing
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your event history";
                          }
                          return null;
                        },
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
                          hintText: "No of Events",
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
                        Navigator.pushNamed(context, RoutesName.WhoThepromoterView);
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































// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/widgets/button.dart';
// import 'package:cage/utils/routes/responsive.dart';
// import 'package:cage/utils/routes/routes_name.dart';
// import 'package:cage/utils/routes/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EventHistory extends StatelessWidget {
//   const EventHistory({super.key});

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController fullNameController = TextEditingController();

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
//                   SizedBox(height: Responsive.h(1)),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: SvgPicture.asset(
//                       "assets/icons/arrow-left-01.svg",
//                       color: AppColor.red,
//                     ),
//                   ),
//                   SizedBox(height: Responsive.h(2)),
//                   Text(
//                     "Your event history",
//                     style: TextStyle(
//                       fontFamily: AppFonts.appFont,
//                       color: AppColor.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Mention any past events you've organized.",
//                     style: TextStyle(
//                       fontFamily: AppFonts.appFont,
//                       color: AppColor.white,
//                       fontWeight: FontWeight.normal,
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   TextFormField(
//                     controller: fullNameController,
//                     style: TextStyle(color: AppColor.white),
//                     // controller: emailController,
//                     // focusNode: emailFoucsNode,
//                     cursorColor: AppColor.red,
//                     cursorErrorColor: AppColor.red,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(
//                           Responsive.w(12),
//                         ), // 6% of width
//                         borderSide: BorderSide(color: AppColor.red),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(Responsive.w(12)),
//                         borderSide: BorderSide(color: AppColor.red),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: AppColor.red),
//                         borderRadius: BorderRadius.circular(Responsive.w(12)),
//                       ),
//                       // prefixIcon: Padding(
//                       //   padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
//                       //   child: SvgPicture.asset("assets/icons/mail-02.svg"),
//                       // ),
//                       filled: true,
//                       fillColor: AppColor.white.withValues(alpha: 0.08),
//                       hintText: "No of Events",
//                       hintStyle: GoogleFonts.dmSans(
//                         color: AppColor.white,
//                         fontWeight: FontWeight.normal,
//                         fontSize: Responsive.sp(15),
//                       ),
//                     ),
//                     // onFieldSubmitted: (value) {
//                     //   Utils.fieldFoucsChange(
//                     //     context,
//                     //     emailFoucsNode,
//                     //     passwordFoucsNode,
//                     //   );
//                     // },
//                   ),
//                 ],
//               ),

//               SizedBox(height: 40),
//               Button(
//                 text: "Next",
//                 onTap: () {
//                   if (fullNameController.text.isEmpty) {
//                     Utils.flushBarErrorMassage(
//                       "Please Your event history",
//                       context,
//                     );
//                   } else {
//                     Navigator.pushNamed(context, RoutesName.WhoThepromoterView);
//                     // Map<String, String> headr = {
//                     //   "x-api-key": "reqres-free-v1",
//                     // };
//                     // Map data = {
//                     //   'email': emailController.text.toString(),
//                     //   'password': passwordController.text.toString(),
//                     // };
//                     // authViewmodel.loginApi(data, headr, context);

//                     // Navigator.pushNamed(context, RoutesName.namecoachview);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
