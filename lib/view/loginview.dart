import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/res/components/auth_button.dart';
import 'package:cage/res/components/social_button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_viewmodel.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFoucsNode = FocusNode();
  FocusNode passwordFoucsNode = FocusNode();
  FocusNode sumbitFoucsNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordFoucsNode.dispose();
    emailFoucsNode.dispose();
    _obsecurePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize responsive class
    Responsive.init(context);
    final authViewmodel = Provider.of<AuthViewmodel>(context);

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(5), // 5% of screen width
            vertical: Responsive.h(2), // 2% of screen height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Responsive.h(2)), // 2% of screen height
                SvgPicture.asset(
                  "assets/images/Frame 1171275875 (2).svg",
                  width: Responsive.w(25), // 50% of screen width
                ),
                SizedBox(height: Responsive.h(2)),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontFamily: AppFonts.appFont,
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(25), // Responsive font size
                  ),
                ),
                SizedBox(height: Responsive.h(1)),
                Text(
                  "Log in to explore about our app",
                  style: TextStyle(
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                    fontSize: Responsive.sp(10.5),
                  ),
                ),
                SizedBox(height: Responsive.h(3)),
                TextFormField(
                  style: TextStyle(color: AppColor.white),
                  controller: emailController,
                  focusNode: emailFoucsNode,
                  cursorColor: AppColor.red,
                  cursorErrorColor: AppColor.red,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Responsive.w(12),
                      ), // 6% of width
                      borderSide: BorderSide(color: AppColor.red),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                      borderSide: BorderSide(color: AppColor.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.red),
                      borderRadius: BorderRadius.circular(Responsive.w(12)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Responsive.w(3)), // 2% of width
                      child: SvgPicture.asset("assets/icons/mail-02.svg"),
                    ),
                    filled: true,
                    fillColor: AppColor.white.withValues(alpha: 0.08),
                    hintText: "Email Address",
                    hintStyle: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                      fontSize: Responsive.sp(15),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    Utils.fieldFoucsChange(
                      context,
                      emailFoucsNode,
                      passwordFoucsNode,
                    );
                  },
                ),
                SizedBox(height: Responsive.h(3)),
                ValueListenableBuilder(
                  valueListenable: _obsecurePassword,
                  builder: (context, value, child) {
                    return TextFormField(
                      style: TextStyle(color: AppColor.white),
                      controller: passwordController,
                      focusNode: passwordFoucsNode,
                      cursorColor: AppColor.red,
                      cursorErrorColor: AppColor.red,
                      obscureText: _obsecurePassword.value,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        focusColor: AppColor.white,
                        filled: true,
                        fillColor: AppColor.white.withValues(alpha: 0.08),
                        hintText: "Password",
                        hintStyle: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontWeight: FontWeight.normal,
                          fontSize: Responsive.sp(15),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Responsive.w(12)),
                          borderSide: BorderSide(color: AppColor.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Responsive.w(12)),
                          borderSide: BorderSide(color: AppColor.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.red),
                          borderRadius: BorderRadius.circular(Responsive.w(12)),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(Responsive.w(3)),
                          child: SvgPicture.asset(
                            "assets/icons/lock-password.svg",
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _obsecurePassword.value = !_obsecurePassword.value;
                          },
                          child: Icon(
                            _obsecurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.white,
                            size: Responsive.sp(20),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: Responsive.h(1.5)),
                Padding(
                  padding: EdgeInsets.only(right: Responsive.w(5)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.dmSans(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Responsive.h(2.5)),
                AuthButton(
                  buttontext: "Login",
                  loading: authViewmodel.loading,
                  onPress: () {
                    if (emailController.text.isEmpty) {
                      Utils.flushBarErrorMassage(
                        "Please Enter Email First",
                        context,
                      );
                    } else if (passwordController.text.isEmpty) {
                      Utils.flushBarErrorMassage(
                        "Please Enter Password First",
                        context,
                      );
                    } else if (passwordController.text.length < 8) {
                      Utils.flushBarErrorMassage(
                        "Please Enter 8 digits",
                        context,
                      );
                    } else {
                      Navigator.pushNamed(context, RoutesName.otp);
                      // Map<String, String> headr = {
                      //   "x-api-key": "reqres-free-v1",
                      // };
                      // Map data = {
                      //   'email': emailController.text.toString(),
                      //   'password': passwordController.text.toString(),
                      // };
                      // authViewmodel.loginApi(data, headr, context);
                    }
                  },
                ),
                SizedBox(height: Responsive.h(5)),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColor.white)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.w(3),
                      ),
                      child: Text(
                        "OR",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(10),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColor.white)),
                  ],
                ),
                SizedBox(height: Responsive.h(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(
                      iconPath: 'assets/icons/google.svg',
                      ontap: () {},
                    ),
                    // _buildSocialButton("assets/icons/google.svg"),
                    _buildSocialButton("assets/icons/facebook.svg"),
                    _buildSocialButton("assets/icons/apple.svg"),
                  ],
                ),
                SizedBox(height: Responsive.h(5)),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: "New here? ",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: Responsive.sp(10),
                    ),
                    children: [
                      TextSpan(
                        text: "Create an account",
                        style: TextStyle(
                          color: AppColor.red,
                          fontSize: Responsive.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RoutesName.signup);
                          },
                      ),
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

  Widget _buildSocialButton(String iconPath) {
    return Container(
      height: Responsive.h(6), // 6% of screen height
      width: Responsive.w(25), // 20% of screen width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.w(5.5)),
        color: AppColor.white.withValues(alpha: 0.08),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(3)),
        child: SvgPicture.asset(iconPath),
      ),
    );
  }
}

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    textScaleFactor = _mediaQueryData.textScaleFactor;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double w(double percent) => screenWidth * (percent / 100);
  static double h(double percent) => screenHeight * (percent / 100);
  static double sp(double size) => (size * (screenWidth / 3)) / 100;
  static double wp(double percent) => screenWidth * (percent / 100);
  static double hp(double percent) => screenHeight * (percent / 100);

  static EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.fromLTRB(wp(left), hp(top), wp(right), hp(bottom));
  }

  static EdgeInsets margin({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.fromLTRB(wp(left), hp(top), wp(right), hp(bottom));
  }

  static SizedBox height(double percent) => SizedBox(height: h(percent));
  static SizedBox width(double percent) => SizedBox(width: w(percent));
}

// import 'package:cage/fonts/fonts.dart';
// import 'package:cage/res/components/app_color.dart';
// import 'package:cage/res/components/auth_button.dart';
// import 'package:cage/utils/routes/routes_name.dart';
// import 'package:cage/utils/routes/utils.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import '../viewmodel/auth_viewmodel.dart';

// class Loginview extends StatefulWidget {
//   const Loginview({super.key});

//   @override
//   State<Loginview> createState() => _LoginviewState();
// }

// class _LoginviewState extends State<Loginview> {
//   final ValueNotifier<bool> _obsecurePassword = ValueNotifier<bool>(true);
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   FocusNode emailFoucsNode = FocusNode();
//   FocusNode passwordFoucsNode = FocusNode();
//   FocusNode sumbitFoucsNode = FocusNode();
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     passwordFoucsNode.dispose();
//     emailFoucsNode.dispose();
//     _obsecurePassword.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authViewmodel = Provider.of<AuthViewmodel>(context);
//     final height = MediaQuery.of(context).size.height * 1;
//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 0.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height:15,),
//                 SvgPicture.asset("assets/images/Frame 1171275875 (2).svg"),
//                 Text(
//                   "Welcome Back!",
//                   style: TextStyle(
//                     fontFamily: AppFonts.appFont,
//                     color: AppColor.white,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 25,
//                   ),
//                 ),
//                 Text(
//                   "Log in to explore about our app",
//                   style: TextStyle(
//                     color: AppColor.white,
//                     fontFamily: AppFonts.appFont,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 16,
//                   ),
//                 ),
//                 TextFormField(
//                   style: TextStyle(color: AppColor.white),
//                   controller: emailController,
//                   focusNode: emailFoucsNode,
//                   cursorColor: AppColor.red,
//                   cursorErrorColor: AppColor.red,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(26),
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(26),
//                       borderSide: BorderSide(color: AppColor.red),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColor.red),
//                       borderRadius: BorderRadius.circular(26),
//                     ),
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SvgPicture.asset("assets/icons/mail-02.svg"),
//                     ),
//                     filled: true,
//                     fillColor: AppColor.white.withValues(alpha: 0.08),
//                     hintText: "Email Address",
//                     hintStyle: GoogleFonts.dmSans(
//                       color: AppColor.white,
//                       fontWeight: FontWeight.normal,
//                       fontSize: 16,
//                     ),
//                   ),
//                   onFieldSubmitted: (value) {
//                     Utils.fieldFoucsChange(
//                       context,
//                       emailFoucsNode,
//                       passwordFoucsNode,
//                     );
//                   },
//                 ),
//                 SizedBox(height: height * 0.05),
//                 ValueListenableBuilder(
//                   valueListenable: _obsecurePassword,
//                   builder: (context, value, child) {
//                     return TextFormField(
//                       controller: passwordController,
//                       focusNode: passwordFoucsNode,
//                       cursorColor: AppColor.red,
//                       cursorErrorColor: AppColor.red,
//                       obscureText: _obsecurePassword.value,
//                       obscuringCharacter: "*",
//                       decoration: InputDecoration(
//                         focusColor: AppColor.white,
//                         filled: true,
//                         fillColor: AppColor.white.withValues(alpha: 0.08),
//                         hintText: "Password",
//                         hintStyle: GoogleFonts.dmSans(
//                           color: AppColor.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: 16,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(26),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(26),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColor.red),
//                           borderRadius: BorderRadius.circular(26),
//                         ),
//                         prefixIcon: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: SvgPicture.asset(
//                             "assets/icons/lock-password.svg",
//                           ),
//                         ),
//                         suffixIcon: InkWell(
//                           onTap: () {
//                             _obsecurePassword.value = !_obsecurePassword.value;
//                           },
//                           child: Icon(
//                             _obsecurePassword.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: AppColor.white,
//                           ),
//                         ),
//                       ),
//                       // onFieldSubmitted: (valuw) {
//                       //   Utils.fieldFoucsChange(
//                       //       context, passwordFoucsNode, sumbitFoucsNode);
//                       // },
//                     );
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       "Forgot Passwaord?",
//                       style: GoogleFonts.dmSans(
//                         color: AppColor.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
//                 AuthButton(
//                   buttontext: "Login",
//                   loading: authViewmodel.loading,
//                   onPress: () {
//                     if (emailController.text.isEmpty) {
//                       Utils.flushBarErrorMassage(
//                         "Please Enter Email First",
//                         context,
//                       );
//                     } else if (passwordController.text.isEmpty) {
//                       Utils.flushBarErrorMassage(
//                         "Please Enter Password First",
//                         context,
//                       );
//                     } else if (passwordController.text.length < 8) {
//                       Utils.flushBarErrorMassage(
//                         "Please Enter 8 digeits",
//                         context,
//                       );
//                     } else {
//                       Map<String, String> headr = {
//                         "x-api-key": "reqres-free-v1",
//                       };
//                       Map data = {
//                         'email': emailController.text.toString(),
//                         'password': passwordController.text.toString(),
//                       };
//                       authViewmodel.loginApi(data, headr, context);
//                     }
//                   },
//                 ),
//                 Row(
//                   children: [
//                     Expanded(child: Divider()),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         "OR",
//                         style: GoogleFonts.dmSans(
//                           color: AppColor.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Divider()),
//                   ],
//                 ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: 48,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(22),
//                         color: AppColor.white.withValues(alpha: 0.08),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: SvgPicture.asset("assets/icons/google.svg"),
//                       ),
//                     ),
//                     Container(
//                       height: 48,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(22),
//                         color: AppColor.white.withValues(alpha: 0.08),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: SvgPicture.asset("assets/icons/facebook.svg"),
//                       ),
//                     ),
//                     Container(
//                       height: 48,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(22),
//                         color: AppColor.white.withValues(alpha: 0.08),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: SvgPicture.asset("assets/icons/apple.svg"),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text.rich(
//                   textAlign: TextAlign.center,
//                   TextSpan(
//                     text: "New here? ",
//                     style: TextStyle(color: AppColor.white, fontSize: 16),
//                     children: [
//                       TextSpan(
//                         text: "Create an account",
//                         style: TextStyle(
//                           color: AppColor.red,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.pushNamed(context, RoutesName.login);
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
