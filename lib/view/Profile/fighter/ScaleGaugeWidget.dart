import 'package:cage/res/components/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';

class ScaleGaugeWidget extends StatefulWidget {
  const ScaleGaugeWidget({super.key});

  @override
  State<ScaleGaugeWidget> createState() => _ScaleGaugeWidgetState();
}

class _ScaleGaugeWidgetState extends State<ScaleGaugeWidget> {
  RulerPickerController? _rulerPickerController;
  num currentValue = 40;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 10, scale: 0.1),
    RulerRange(begin: 10, end: 100, scale: 1),
    RulerRange(begin: 100, end: 1000, scale: 10),
    RulerRange(begin: 1000, end: 10000, scale: 100),
    RulerRange(begin: 10000, end: 100000, scale: 1000)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(currentValue.toInt().toString(),
            style: const TextStyle(color: AppColor.white,fontSize: 24, fontWeight: FontWeight.bold)),
        Container(
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: RulerPicker(
              rulerBackgroundColor: Colors.grey.withOpacity(0.05),
              controller: _rulerPickerController!,
              onBuildRulerScaleText: (index, value) {
                return value.toInt().toString();
              },
              rulerScaleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 14),
              marker: Container(height: 40, width: 2, color:AppColor.red),
              ranges: ranges,
              scaleLineStyleList: const [
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 30, scale: 0),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 25, scale: 5),
                ScaleLineStyle(
                    color: Colors.grey, width: 1, height: 15, scale: -1),
              ],
              onValueChanged: (value) {
                setState(() {
                  currentValue = value;
                });
              },
              width: MediaQuery.of(context).size.width,
              height: 75,
              rulerMarginTop: 0),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }
}
