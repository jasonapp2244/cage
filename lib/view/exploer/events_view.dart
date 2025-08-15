import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:cage/widgets/likes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                height: Responsive.h(7.0),
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  style: TextStyle(color: AppColor.white),
                  cursorColor: AppColor.red,
                  cursorErrorColor: AppColor.red,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColor.red),
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Responsive.w(3)),
                      child: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.08),
                    hintText: "Search Event ...",
                    hintStyle: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                      fontSize: Responsive.sp(12),
                    ),
                  ),
                ),
              ),

              // Events List
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 4.0,
                      ),
                      child: Container(
                        width: Responsive.w(50),
                        height: Responsive.h(36),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColor.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/Frame 1000002190.png",
                                  width: double.infinity,
                                  height: Responsive.h(20),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: Responsive.h(1)),
                              Text(
                                "Jake \"The Beast\" Miller - � Win (KO)",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontFamily: AppFonts.appFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(10),
                                ),
                              ),
                              SizedBox(height: Responsive.h(1)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // View Details Button
                                  GestureDetector(
                                    onTap: () =>
                                        _showEventDetailsBottomSheet(context),
                                    child: Container(
                                      width: Responsive.w(40),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: AppColor.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "View Details",
                                          style: GoogleFonts.dmSans(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Interested Button
                                  Container(
                                    width: Responsive.w(40),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: AppColor.red,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Interested",
                                        style: GoogleFonts.dmSans(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ratePromoterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: AppColor.black,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: Responsive.w(5),
            right: Responsive.w(5),
            top: Responsive.h(1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rate Promoter",
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontSize: Responsive.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset("assets/icons/IC_cross.svg"),
                  ),
                ],
              ),
              SizedBox(height: Responsive.h(2)),

              TextFormField(
                maxLines: 5,
                style: TextStyle(color: AppColor.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.white.withValues(alpha: 0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  hint: Text(
                    "Describe your experience",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(2)),
              Container(
                width: MediaQuery.sizeOf(context).width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColor.white.withValues(alpha: 0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomRatingBar(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.h(2)),

              AuthButton(
                buttontext: "Submit",
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Utils.flushBarErrorMassage("Reset link sent!", context);
                },
                loading: false,
              ),
              SizedBox(height: Responsive.h(2)),
            ],
          ),
        );
      },
    );
  }

  void _showEventDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: AppColor.white.withValues(alpha: 0.2),
      isScrollControlled: true,
      backgroundColor: AppColor.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: Responsive.w(5),
                right: Responsive.w(5),
                top: Responsive.h(3),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Fight Details",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Event Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/Frame 1000002190.png",
                        width: double.infinity,
                        height: Responsive.h(25),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),

                    // Event Title
                    Text(
                      "Jake \"The Beast\" Miller - 🏆 Win (KO)",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontSize: Responsive.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),

                    // Event Description
                    Text(
                      "Looking for aggressive strikers with clean records. The winner will be "
                      "featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white.withOpacity(0.8),
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                    SizedBox(height: Responsive.h(2)),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColor.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Responsive.h(0.5)),

                    // Additional Info Section
                    _buildDetailRow("Date", "October 15, 2023"),
                    _buildDetailRow("Location", "Las Vegas, NV"),

                    SizedBox(height: Responsive.h(0.5)),
                    SvgPicture.asset("assets/images/Frame 1000002180.svg"),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.red),
                        borderRadius: BorderRadius.circular(22),
                        color: AppColor.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Open Map",
                            style: GoogleFonts.dmSans(
                              color: AppColor.white,
                              fontSize: Responsive.sp(10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildDetailRow("Event Type", "Professional | Lightweight"),
                    _buildDetailRow("Weight Class", "Lightweight 155 lbs"),
                    _buildDetailRow("Required Record", "Min. 2 wins"),
                    _buildDetailRow("Age Limit", "18–35"),
                    _buildDetailRow(
                      "Fighting Style Preferred",
                      "MMA / BJJ / Muay Thai",
                    ),
                    _buildDetailRow("Deadline to Apply", "June 15, 2025"),
                    // Action Button
                    AuthButton(
                      buttontext: "Rate Promoter",
                      onPress: () {
                        _ratePromoterBottomSheet(context);
                        // Navigator.pop(context);

                        // Utils.flushBarErrorMassage("Rate Promoter", context);
                      },
                      loading: false,
                    ),
                    SizedBox(height: Responsive.h(2)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.dmSans(
              color: AppColor.white,
              fontSize: Responsive.sp(9),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              fontSize: Responsive.sp(9),
            ),
          ),
        ],
      ),
    );
  }
}






// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/utils/routes/responsive.dart';
// import 'package:cage/utils/routes/utils.dart';
// import 'package:cage/widgets/auth_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// class EventsView extends StatelessWidget {
//   const EventsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Responsive.init(context);
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             children: [
//               Container(
//                 height: Responsive.h(7.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(6.0),
//                   child: TextField(
//                     scrollController: ScrollController(keepScrollOffset: true),
//                     style: TextStyle(color: AppColor.white),
//                     // controller: phoneController,
//                     // focusNode: phoneFoucsNode,
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
//                       prefixIcon: Padding(
//                         padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
//                         child: SvgPicture.asset("assets/icons/search.svg"),
//                       ),
//                       filled: true,

//                       fillColor: AppColor.white.withValues(alpha: 0.08),
//                       hintText: "Search Event ...",
//                       hintStyle: GoogleFonts.dmSans(
//                         color: AppColor.white,
//                         fontWeight: FontWeight.normal,
//                         fontSize: Responsive.sp(12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 // color: AppColor.black,
//                 // width: double.infinity,
//                 // height: MediaQuery.sizeOf(context).height,
//                 child: ListView.builder(
//                   // scrollDirection: Axis.horizontal,
//                   itemCount: 10,
//                   padding: EdgeInsets.symmetric(horizontal: 0),
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 2.0,
//                         vertical: 4.0,
//                       ),
//                       child: Container(
//                         child: Container(
//                           width: Responsive.w(50),
//                           height: Responsive.h(36),

//                           decoration: BoxDecoration(
//                             border: BoxBorder.all(
//                               color: AppColor.white.withValues(alpha: 0.1),
//                               // width: Responsive.w(0),
//                             ),
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Image(
//                                   width: double.infinity,
//                                   fit: BoxFit.fill,
//                                   image: AssetImage(
//                                     "assets/images/Frame 1000002190.png",
//                                   ),
//                                 ),
//                                 SizedBox(height: Responsive.h(1)),

//                                 Text(
//                                   "Jake “The Beast” Miller - 🏆 Win (KO)",
//                                   style: TextStyle(
//                                     color: AppColor.white,
//                                     fontFamily: AppFonts.appFont,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: Responsive.sp(10),
//                                   ),
//                                 ),
//                                 SizedBox(height: Responsive.h(1)),

//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         _showForgotPasswordBottomSheet(context);
//                                       },
//                                       child: Container(
//                                         width: Responsive.w(40),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Center(
//                                             child: Text(
//                                               "View Details",
//                                               style: GoogleFonts.dmSans(
//                                                 color: AppColor.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             22,
//                                           ),
//                                           color: AppColor.white.withValues(
//                                             alpha: 0.2,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: Responsive.w(40),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Center(
//                                           child: Text(
//                                             "Interested",
//                                             style: GoogleFonts.dmSans(
//                                               color: AppColor.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(22),
//                                         color: AppColor.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void _showForgotPasswordBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     backgroundColor: AppColor.black,
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: Responsive.w(5),
//           right: Responsive.w(5),
//           top: Responsive.h(3),
//         ),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Fight Details",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(18),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SvgPicture.asset("assets/images/Frame 1000002190.png"),
//               Text(
//                 "Jake “The Beast” Miller - 🏆 Win (KO)",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(10),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(height: Responsive.h(2)),
//               Text(
//                 "Looking for aggressive strikers with clean records. The winner will be featured on our official YouTube broadcast with cash bonus + sponsor exposure.",
//                 style: GoogleFonts.dmSans(
//                   color: AppColor.white,
//                   fontSize: Responsive.sp(10),
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(
//                 height: Responsive.h(6),
//                 child: TextFormField(
//                   style: TextStyle(color: AppColor.white),

//                   cursorColor: AppColor.red,
//                   cursorErrorColor: AppColor.red,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(
//                         Responsive.w(12),
//                       ), // 6% of width
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(Responsive.w(12)),
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColor.red),
//                       borderRadius: BorderRadius.circular(Responsive.w(12)),
//                     ),
//                     prefixIcon: Padding(
//                       padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
//                       child: SvgPicture.asset("assets/icons/mail-02.svg"),
//                     ),
//                     filled: true,
//                     fillColor: AppColor.white.withValues(alpha: 0.08),
//                     hintText: "Email Address",
//                     hintStyle: GoogleFonts.dmSans(
//                       color: AppColor.white,
//                       fontWeight: FontWeight.normal,
//                       fontSize: Responsive.sp(15),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: Responsive.h(2)),
//               AuthButton(
//                 buttontext: "Continue",
//                 onPress: () {
//                   Navigator.pop(context);
//                   Utils.flushBarErrorMassage("Reset link sent!", context);
//                 },
//                 loading: false,
//               ),
//               SizedBox(height: Responsive.h(2)),
//             ],
//           ),
        
//       );
//     },
//   );
// }
