import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AgeView extends StatefulWidget {
  @override
  _AgeViewState createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  List<int> heightValues = List.generate(
    50,
    (index) => 18 + index,
  ); // 140-189 cm
  int selectedHeight = 99;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpToItem(heightValues.indexOf(selectedHeight));
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
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
                  'What’s your age?',
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your age in years (you must be 18 or older to join).',
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
                        width: 80,
                        child: Stack(
                          children: [
                            // Top line
                            Positioned(
                              top: 170,
                              left: 0,
                              right: 0,
                              child: Container(height: 3, color: AppColor.red),
                            ),
                            // Bottom line
                            Positioned(
                              top: 250,
                              left: 0,
                              right: 0,
                              child: Container(height: 3, color: AppColor.red),
                            ),
                            // Wheel picker
                            ListWheelScrollView(
                              controller: _scrollController,
                              itemExtent: 70,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$height',
                                        style: TextStyle(
                                          fontFamily: AppFonts.appFont,
                                          fontSize:
                                              Responsive.textScaleFactor * 35,
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
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Button(
                        text: "Next",
                        onTap: () {
                          print('Selected Age: $selectedHeight');
                          Navigator.pushNamed(context, RoutesName.hightview);
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
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
