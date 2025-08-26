import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/sginupview.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HightView extends StatefulWidget {
  @override
  _HightViewState createState() => _HightViewState();
}

class _HightViewState extends State<HightView> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  List<int> heightValues = List.generate(
    50,
    (index) => 110 + index,
  ); // 140-189 cm
  int selectedHeight = 270;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpToItem(heightValues.indexOf(selectedHeight));
    });
  }

  @override
  Widget build(BuildContext context) {
        final authProvider = Provider.of<AuthViewmodel>(context);
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
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
              const Text(
                'What\'s your height?',
                style: TextStyle(
                  color: AppColor.white,
                  fontFamily: AppFonts.appFont,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your height in centimeters',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Wheel picker with selection lines
                    Container(
                      decoration: BoxDecoration(color: AppColor.black),
                      height: 420,
                      width: 105,
                      child: Stack(
                        children: [
                          // Top line
                          Positioned(
                            top: 185,
                            left: 0,
                            right: 0,
                            child: Container(height: 3, color: AppColor.red),
                          ),
                          // Bottom line
                          Positioned(
                            top: 235,
                            left: 0,
                            right: 0,
                            child: Container(height: 3, color: AppColor.red),
                          ),
                          // Wheel picker
                          ListWheelScrollView(
                            controller: _scrollController,
                            itemExtent: 50,
                            perspective: 0.002,
                            diameterRatio: 2.0,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedHeight = heightValues[index];
                              });
                            },
                            children: heightValues.map((height) {
                              return Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$height',
                                      style: TextStyle(
                                        fontFamily: AppFonts.appFont,
                                        fontSize: 42,
                                        color: height == selectedHeight
                                            ? AppColor.white
                                            : Colors.grey,
                                        fontWeight: height == selectedHeight
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'cm',
                                          style: TextStyle(
                                            fontFamily: AppFonts.appFont,
                                            fontSize: 18,
                                            color: height == selectedHeight
                                                ? AppColor.white
                                                : Colors.grey,
                                            fontWeight: height == selectedHeight
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Button(
                      text: "Next",
                      onTap: () {
                        print('Selected height: $selectedHeight cm');
                        var uid = Utils.getCurrentUid();
                        authProvider.addUserFieldByRole
(
                          uid: uid,
                          fieldName: 'height',
                          value: selectedHeight.toString(),
                        );
                        Navigator.pushNamed(context, RoutesName.fightwon);
                      },
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     print('Selected height: $selectedHeight cm');
                    //     // Add your navigation logic here
                    //   },
                    //   child: const Text('Next', style: TextStyle(fontSize: 18)),
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 60,
                    //       vertical: 16,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// import 'package:cage/res/components/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HightView extends StatefulWidget {
//   @override
//   _HightViewState createState() => _HightViewState();
// }

// class _HightViewState extends State<HightView> {
//   final FixedExtentScrollController _scrollController =
//       FixedExtentScrollController();
//   List<int> heightValues = List.generate(
//     50,
//     (index) => 140 + index,
//   ); // Generates values from 140 to 189
//   int selectedHeight = 170;

//   @override
//   void initState() {
//     super.initState();
//     // Set initial position to 170cm (index 30)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.jumpToItem(heightValues.indexOf(selectedHeight));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "What’s your height?",
//                 style: GoogleFonts.dmSans(
//                   fontSize: 32,
//                   color: AppColor.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 "Please enter your height in feet and inches",
//                 style: GoogleFonts.dmSans(
//                   fontSize: 18,
//                   color: AppColor.white,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),

//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 40),
//                     // Wheel picker
//                     Stack(
//                       children: [
//                         Positioned(
//                           top: 5,
//                           left: 5,
//                           child: Container(
//                             height: 20,
//                             width: 20,
//                             child: Text(
//                               "data",
//                               style: TextStyle(
//                                 fontSize: 44,
//                                 color: AppColor.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           color: AppColor.black,
//                           height: 300,
//                           child: ListWheelScrollView(
//                             controller: _scrollController,
//                             itemExtent: 50,
//                             perspective: 0.005,
//                             diameterRatio: 2.5,
//                             onSelectedItemChanged: (index) {
//                               setState(() {
//                                 selectedHeight = heightValues[index];
//                               });
//                             },
//                             children: heightValues.map((height) {
//                               return Center(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border: Border(
//                                       top: BorderSide(
//                                         color: height == selectedHeight
//                                             ? AppColor.red
//                                             : AppColor.black,
//                                       ),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             '$height ',
//                                             style: GoogleFonts.dmSans(
//                                               fontSize: 32,
//                                               color: height == selectedHeight
//                                                   ? AppColor.red
//                                                   : AppColor.white,
//                                               fontWeight:
//                                                   height == selectedHeight
//                                                   ? FontWeight.bold
//                                                   : FontWeight.normal,
//                                             ),
//                                           ),
//                                           Text(
//                                             'cm',
//                                             style: GoogleFonts.dmSans(
//                                               fontSize: 18,
//                                               color: height == selectedHeight
//                                                   ? AppColor.red
//                                                   : AppColor.white,
//                                               fontWeight:
//                                                   height == selectedHeight
//                                                   ? FontWeight.bold
//                                                   : FontWeight.normal,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 40),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle the "Next" button press
//                         print('Selected height: $selectedHeight cm');
//                         // Navigate to next screen or perform action
//                       },
//                       child: Text('Next'),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 40,
//                           vertical: 15,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
