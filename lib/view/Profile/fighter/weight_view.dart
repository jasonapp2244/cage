import 'package:cage/res/components/app_color.dart';
import 'package:cage/view/Profile/fighter/ScaleGaugeWidget.dart';
import 'package:flutter/material.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Column(children: [
          ScaleGaugeWidget()
        ],),
      ),
    );
  }
}