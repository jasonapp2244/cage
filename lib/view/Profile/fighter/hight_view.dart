import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HightView extends StatefulWidget {
  @override
  _HightViewState createState() => _HightViewState();
}

class _HightViewState extends State<HightView> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  List<String> heightValues = List.generate(
    (8 * 12) - (2 * 12) + 1, // 2'0" → 8'0"
    (index) {
      int totalInches = (2 * 12) + index; // start from 24 inches (2 ft)
      int feet = totalInches ~/ 12;
      int inch = totalInches % 12;
      return "$feet'$inch\"";
    },
  );

  String selectedHeight = "5'7\""; // example

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
                                        fontSize: Responsive.sp(25),
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
                                          'ft in',
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
                        Navigator.pushNamed(context, RoutesName.weightview);
                      },
                    ),
                  ],
                ),
              ),

              // 👇 Static CM text in center
              // After your wheel picker container (inside the Stack)
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
