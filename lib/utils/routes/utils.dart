import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Utils {
  static tosatMassage(String massage) {
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColor.red,
      textColor: AppColor.white,
      webBgColor: AppColor.red,
      msg: massage,
    );
  }

  static void fieldFoucsChange(
    BuildContext context,
    FocusNode current,
    FocusNode nextFoucs,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFoucs);
  }

  static void flushBarErrorMassage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(15),
        //backgroudColors
        message: message,
        borderRadius: BorderRadius.circular(20),
        backgroundColor: AppColor.red,
        title: "Error",
        titleColor: AppColor.white,
        messageColor: AppColor.white,
        positionOffset: 20,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(Icons.error, size: 28, color: Colors.white),
        duration: Duration(seconds: 3),
      )..show(context),
    );
  }

  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static Future<void> saveSavedRole(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> getSavedRole(String key) async {
    return await storage.read(key: key);
  }

  static String getCurrentUid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // This is the uid you pass to addUserFieldByRole
    } else {
      throw Exception('User not logged in');
    }
  }
}

snakBar(String massage, BuildContext context) {
  return ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(massage)));
}
