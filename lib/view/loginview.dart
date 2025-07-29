import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/res/components/auth_button.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
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
    final authViewmodel = Provider.of<AuthViewmodel>(context);
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/Frame 1171275875 (2).svg"),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
              Text(
                "Log in to explore about our app",
                style: TextStyle(
                  color: AppColor.white,
                  fontFamily: AppFonts.appFont,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              TextFormField(
                controller: emailController,
                focusNode: emailFoucsNode,

                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  filled: true,
                  fillColor: AppColor.white.withValues(alpha: 0.08),
                  hintText: "Email Address",
                  hintStyle: GoogleFonts.dmSans(
                    color: AppColor.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  prefix: Icon(Icons.alternate_email),
                ),
                onFieldSubmitted: (value) {
                  Utils.fieldFoucsChange(
                    context,
                    emailFoucsNode,
                    passwordFoucsNode,
                  );
                },
              ),
              SizedBox(height: height* 0.05),
              ValueListenableBuilder(
                valueListenable: _obsecurePassword,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: passwordController,
                    focusNode: passwordFoucsNode,
                    obscureText: _obsecurePassword.value,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      // label: Text("Password"),
                      prefix: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          _obsecurePassword.value = !_obsecurePassword.value;
                        },
                        child: Icon(
                          _obsecurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    // onFieldSubmitted: (valuw) {
                    //   Utils.fieldFoucsChange(
                    //       context, passwordFoucsNode, sumbitFoucsNode);
                    // },
                  );
                },
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
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
                      "Please Enter 8 digeits",
                      context,
                    );
                  } else {
                    Map<String, String> headr = {"x-api-key": "reqres-free-v1"};
                    Map data = {
                      'email': emailController.text.toString(),
                      'password': passwordController.text.toString(),
                    };
                    authViewmodel.loginApi(data, headr, context);
                  }
                },
              ),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, RoutesName.login);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
