import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/sginupview.dart';
import 'package:flutter/material.dart';

class EditProfileTextfeild extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final FocusNode focusNode;
  // final FocusNode currentfocusNode;
  final FocusNode nextfocusNode;

  EditProfileTextfeild({
    super.key,
    required this.text,
    required this.controller,
    required this.focusNode,
    // required this.currentfocusNode,
    required this.nextfocusNode,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(color: AppColor.white),
      decoration: InputDecoration(
        
        filled: true,
        fillColor: AppColor.white.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.black),
          borderRadius: BorderRadius.circular(28),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.red),
          borderRadius: BorderRadius.circular(28),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.black),
          borderRadius: BorderRadius.circular(28),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.black),
          borderRadius: BorderRadius.circular(28),
        ),
        label: Text(
          text,
          style: TextStyle(fontFamily: AppFonts.appFont, color: AppColor.white),
        ),
      ),
      onFieldSubmitted: (value) {
        Utils.fieldFoucsChange(context, focusNode, nextfocusNode);
      },
    );
  }
}
