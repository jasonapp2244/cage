import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeighView extends StatefulWidget {
  @override
  WeightState createState() => WeightState();
}

class WeightState extends State<WeighView> {
  double _selectedWeight = 70.0;
  final bool _isKg = false;
  final ScrollController _scrollController = ScrollController();
  final double _itemWidth = 40.0;
  final int _decimalPrecision = 1; // 1 decimal place (0.1 increments)

  @override
  void initState() {
    super.initState();
    // Start at middle of the scrollable area
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo((_selectedWeight - 30) * 10 * _itemWidth);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xff060606),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Selected weight display
          Text(
            '${_selectedWeight.toStringAsFixed(_decimalPrecision)} ${_isKg ? 'kg' : 'lbs'}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),

          // Horizontal weight picker
          SizedBox(
            height: 80,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  setState(() {
                    _selectedWeight =
                        30 + (_scrollController.offset / _itemWidth / 10);
                  });
                }
                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: (150 * 10) + 1, // 30.0 to 180.0 kg in 0.1 increments
                itemBuilder: (context, index) {
                  final weight = 30.0 + (index / 10);
                  final isSelected =
                      weight.toStringAsFixed(_decimalPrecision) ==
                      _selectedWeight.toStringAsFixed(_decimalPrecision);
                  final isMajorTick = weight % 1 == 0; // Whole numbers

                  return Container(
                    width: _itemWidth,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top tick mark
                        Container(
                          height: isSelected ? 20 : (isMajorTick ? 15 : 10),
                          width: isSelected ? 2 : 1,
                          color: isSelected ? Colors.red : Colors.red,
                        ),
                        SizedBox(height: 4),
                        // Weight number (only show for selected and whole numbers)
                        if (isSelected || isMajorTick)
                          Text(
                            isSelected
                                ? weight.toStringAsFixed(_decimalPrecision)
                                : weight.toInt().toString(),
                            style: TextStyle(
                              fontSize: isSelected ? 16 : 12,
                              color: isSelected ? Colors.white : Colors.white,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Measuring bar
          Container(
            height: 4,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          Button(
            text: "Next",
            onTap: () {
              //print('Selected height: $selectedHeight cm');
              var uid = Utils.getCurrentUid();
              authProvider.addUserFieldByRole(
                uid: uid,
                fieldName: 'weight',
                value: _selectedWeight.round().toString(),
              );
              Navigator.pushNamed(context, RoutesName.fightwon);
            },
          ),
        ],
      ),
    );
  }
}
