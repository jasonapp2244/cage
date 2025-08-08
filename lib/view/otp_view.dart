import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(backgroundColor: AppColor.black),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Enter 4 Digit Code",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter the 4 digit code that you received on your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.white),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const OtpForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  TextButton(
                    
                    onPressed: () {},
                    child:  Text(
                      "Resend OTP Code",
                      style: TextStyle(color:AppColor.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 64,
                width: 64,
                child: TextFormField(
                  onSaved: (pin) {},
                  onChanged: (pin) {
                    if (pin.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  // style: TextStyle(color: AppColor.white,fontSize: 18,fontWeight: FontWeight.bold),
                  style:Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.2),
                    hintText: "0",
                    hintStyle: const TextStyle(color: AppColor.white),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
                width: 64,
                child: TextFormField(
                  onSaved: (pin) {},
                  onChanged: (pin) {
                    if (pin.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.2),
                    hintText: "0",
                    hintStyle: const TextStyle(color: AppColor.white),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
                width: 64,
                child: TextFormField(
                  onSaved: (pin) {},
                  onChanged: (pin) {
                    if (pin.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.2),
                    hintText: "0",
                    hintStyle: const TextStyle(color: AppColor.white),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
                width: 64,
                child: TextFormField(
                  onSaved: (pin) {},
                  onChanged: (pin) {
                    if (pin.isNotEmpty) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.2),
                    hintText: "0",
                    hintStyle: const TextStyle(color: AppColor.white),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder,
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: AppColor.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Button(
            text: "Submit",
            onTap: () {
              Navigator.pushNamed(context, RoutesName.roleView);
            },
          ),

          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     backgroundColor: AppColor.red,
          //     foregroundColor: Colors.white,
          //     minimumSize: const Size(double.infinity, 48),
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(16)),
          //     ),
          //   ),
          //   child: const Text("Continue"),
          // ),
        ],
      ),
    );
  }
}
