import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FightKnockoutView extends StatefulWidget {
  const FightKnockoutView({super.key});

  @override
  State<FightKnockoutView> createState() => _FightKnockoutViewState();
}

class _FightKnockoutViewState extends State<FightKnockoutView> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  List<int> heightValues = [0];
  int selectedHeight = 0;
  bool _loadingWins = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWinsAndCapKnockouts());
  }

  Future<void> _loadWinsAndCapKnockouts() async {
    final uid = Utils.getCurrentUid();
    final doc = await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .get();
    int wins = 0;
    final fd = doc.data()?['fighterData'];
    if (fd is Map<String, dynamic>) {
      wins = int.tryParse(fd['fightWin']?.toString() ?? '0') ?? 0;
    }
    if (!mounted) return;
    setState(() {
      _loadingWins = false;
      heightValues = List.generate(wins + 1, (i) => i);
      selectedHeight = selectedHeight.clamp(0, wins);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && heightValues.isNotEmpty && _scrollController.hasClients) {
        final idx = selectedHeight.clamp(0, heightValues.length - 1);
        _scrollController.jumpToItem(idx);
      }
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
                Text(
                  'How many fights have you Knockout?',
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mention the number of official Knockout in your fight record (cannot exceed wins).',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Wheel picker with selection lines
                      if (_loadingWins)
                        Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: CircularProgressIndicator(color: AppColor.red),
                        )
                      else
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
                                          fontSize: 55,
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
                          var uid = Utils.getCurrentUid();
                          authProvider.addUserFieldByRole(
                            uid: uid,
                            fieldName: 'fightsKnockout',
                            value: selectedHeight.toString(),
                          );

                          Navigator.pushNamed(
                            context,
                            RoutesName.fightStyle_view,
                          );
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
