import 'package:cage/res/components/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class ScaleGaugeWidget extends StatefulWidget {
  const ScaleGaugeWidget({super.key});

  @override
  State<ScaleGaugeWidget> createState() => _ScaleGaugeWidgetState();
}

class _ScaleGaugeWidgetState extends State<ScaleGaugeWidget> {
  late RulerPickerController _rulerPickerController;
  num currentValue = 150; // default starting value in lbs

  /// Define the ruler ranges (only lbs)
  final List<RulerRange> lbsRanges = const [
    RulerRange(begin: 10, end: 440, scale: 1), // 66 → 440 lbs
  ];

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Current Value Display
        Text(
          "${currentValue.toInt()} lbs",
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        // The ruler widget
        SizedBox(
          height: 120,
          child: RulerPicker(
            controller: _rulerPickerController,
            ranges: lbsRanges,
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
            },
            onBuildRulerScaleText: (index, value) => value.toInt().toString(),
            rulerScaleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            marker: Container(height: 50, width: 3, color: AppColor.red),
            rulerBackgroundColor: Colors.black12,
            scaleLineStyleList: const [
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 30,
                scale: 0,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 20,
                scale: 5,
              ),
              ScaleLineStyle(
                color: Colors.grey,
                width: 1,
                height: 10,
                scale: -1,
              ),
            ],
            width: MediaQuery.of(context).size.width,
            height: 100,
            rulerMarginTop: 16,
          ),
        ),
      ],
    );
  }
}
