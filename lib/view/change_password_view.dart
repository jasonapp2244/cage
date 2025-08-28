import 'package:cage/fonts/fonts.dart';
import 'package:cage/provider/change_password_provider.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// class ChangePasswordView extends StatefulWidget {
//   ChangePasswordView({super.key});

//   @override
//   State<ChangePasswordView> createState() => _ChangePasswordViewState();
// }

// class _ChangePasswordViewState extends State<ChangePasswordView> {
//   final ValueNotifier<bool> _obsecureOldPassword = ValueNotifier<bool>(true);
//   final ValueNotifier<bool> _obsecureNewPassword = ValueNotifier<bool>(true);
//   final ValueNotifier<bool> _obsecureConfirmPassword = ValueNotifier<bool>(
//     true,
//   );

//   final TextEditingController oldPasswordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   final FocusNode oldPasswordFocus = FocusNode();
//   final FocusNode newPasswordFocus = FocusNode();
//   final FocusNode confirmPasswordFocus = FocusNode();
//   final FocusNode saveFoucs = FocusNode();

//   @override
//   void dispose() {
//     _obsecureOldPassword.dispose();
//     _obsecureNewPassword.dispose();
//     _obsecureConfirmPassword.dispose();
//     oldPasswordController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     oldPasswordFocus.dispose();
//     newPasswordFocus.dispose();
//     confirmPasswordFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Responsive.init(context);

//     return Scaffold(
//       backgroundColor: AppColor.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               spacing: 10,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: SvgPicture.asset(
//                         "assets/icons/arrow-left-01.svg",
//                         color: AppColor.red,
//                       ),
//                     ),
//                     Text(
//                       "Change Password",
//                       style: TextStyle(
//                         fontSize: Responsive.textScaleFactor * 24,
//                         color: AppColor.white,
//                         fontFamily: AppFonts.appFont,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Text(
//                   'Your password must be at least six characters and should include a combination of numbers, letters and special characters (!\$@%)',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),

//                 ValueListenableBuilder(
//                   valueListenable: _obsecureOldPassword,
//                   builder: (context, value, child) {
//                     return TextFormField(
//                       style: TextStyle(color: AppColor.white),
//                       controller: oldPasswordController,
//                       focusNode: oldPasswordFocus,
//                       cursorColor: AppColor.red,
//                       cursorErrorColor: AppColor.red,
//                       obscureText: _obsecureOldPassword.value,
//                       obscuringCharacter: "*",
//                       decoration: InputDecoration(
//                         focusColor: AppColor.white,
//                         filled: true,
//                         fillColor: AppColor.white.withValues(alpha: 0.08),
//                         hintText: "Old Password",
//                         hintStyle: GoogleFonts.dmSans(
//                           color: AppColor.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: Responsive.sp(15),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColor.red),
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                         ),
//                         prefixIcon: Padding(
//                           padding: EdgeInsets.all(Responsive.w(3)),
//                           child: SvgPicture.asset(
//                             "assets/icons/lock-password.svg",
//                           ),
//                         ),
//                         suffixIcon: GestureDetector(
//                           onTap: () {
//                             _obsecureOldPassword.value =
//                                 !_obsecureOldPassword.value;
//                           },
//                           child: Icon(
//                             _obsecureOldPassword.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: _obsecureOldPassword.value
//                                 ? AppColor.white
//                                 : AppColor.red,
//                             size: Responsive.sp(20),
//                           ),
//                         ),
//                       ),
//                       onFieldSubmitted: (value) {
//                         Utils.fieldFoucsChange(
//                           context,
//                           oldPasswordFocus,
//                           newPasswordFocus,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 ValueListenableBuilder(
//                   valueListenable: _obsecureNewPassword,
//                   builder: (context, value, child) {
//                     return TextFormField(
//                       style: TextStyle(color: AppColor.white),
//                       controller: newPasswordController,
//                       focusNode: newPasswordFocus,
//                       cursorColor: AppColor.red,
//                       cursorErrorColor: AppColor.red,
//                       obscureText: _obsecureNewPassword.value,
//                       obscuringCharacter: "*",
//                       decoration: InputDecoration(
//                         focusColor: AppColor.white,
//                         filled: true,
//                         fillColor: AppColor.white.withValues(alpha: 0.08),
//                         hintText: "New Password",
//                         hintStyle: GoogleFonts.dmSans(
//                           color: AppColor.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: Responsive.sp(15),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColor.red),
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                         ),
//                         prefixIcon: Padding(
//                           padding: EdgeInsets.all(Responsive.w(3)),
//                           child: SvgPicture.asset(
//                             "assets/icons/lock-password.svg",
//                           ),
//                         ),
//                         suffixIcon: GestureDetector(
//                           onTap: () {
//                             _obsecureNewPassword.value =
//                                 !_obsecureNewPassword.value;
//                           },
//                           child: Icon(
//                             _obsecureNewPassword.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: _obsecureNewPassword.value
//                                 ? AppColor.white
//                                 : AppColor.red,
//                             size: Responsive.sp(20),
//                           ),
//                         ),
//                       ),
//                       onFieldSubmitted: (value) {
//                         Utils.fieldFoucsChange(
//                           context,
//                           newPasswordFocus,
//                           confirmPasswordFocus,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 ValueListenableBuilder(
//                   valueListenable: _obsecureConfirmPassword,
//                   builder: (context, value, child) {
//                     return TextFormField(
//                       style: TextStyle(color: AppColor.white),
//                       controller: confirmPasswordController,
//                       focusNode: confirmPasswordFocus,
//                       cursorColor: AppColor.red,
//                       cursorErrorColor: AppColor.red,
//                       obscureText: _obsecureConfirmPassword.value,
//                       obscuringCharacter: "*",
//                       decoration: InputDecoration(
//                         focusColor: AppColor.white,
//                         filled: true,
//                         fillColor: AppColor.white.withValues(alpha: 0.08),
//                         hintText: "Confirm Password",
//                         hintStyle: GoogleFonts.dmSans(
//                           color: AppColor.white,
//                           fontWeight: FontWeight.normal,
//                           fontSize: Responsive.sp(15),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                           borderSide: BorderSide(color: AppColor.red),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: AppColor.red),
//                           borderRadius: BorderRadius.circular(Responsive.w(12)),
//                         ),
//                         prefixIcon: Padding(
//                           padding: EdgeInsets.all(Responsive.w(3)),
//                           child: SvgPicture.asset(
//                             "assets/icons/lock-password.svg",
//                           ),
//                         ),
//                         suffixIcon: GestureDetector(
//                           onTap: () {
//                             _obsecureConfirmPassword.value =
//                                 !_obsecureConfirmPassword.value;
//                           },
//                           child: Icon(
//                             _obsecureConfirmPassword.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: _obsecureConfirmPassword.value
//                                 ? AppColor.white
//                                 : AppColor.red,
//                             size: Responsive.sp(20),
//                           ),
//                         ),
//                       ),
//                       onFieldSubmitted: (value) {
//                         Utils.fieldFoucsChange(
//                           context,
//                           confirmPasswordFocus,
//                           saveFoucs,
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 Button(focusNode: saveFoucs, text: "Update", onTap: () {}),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Provider.of with listen:true so it rebuilds when state changes
    final provider = Provider.of<ChangePasswordProvider>(context, listen: true);

    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        "assets/icons/arrow-left-01.svg",
                        color: AppColor.red,
                      ),
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 24,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Text(
                  'Your password must be at least six characters and should include a combination of numbers, letters and special characters (!\$@%)',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                // Old Password
                TextFormField(
                  style: TextStyle(color: AppColor.white),
                  controller: provider.oldPasswordController,
                  focusNode: provider.oldPasswordFocus,
                  obscureText: provider.obscureOldPassword,
                  obscuringCharacter: "*",
                  cursorColor: AppColor.red,
                  decoration: _inputDecoration(
                    hint: "Old Password",
                    isObscured: provider.obscureOldPassword,
                    toggle: provider.toggleOldPasswordVisibility,
                  ),
                  onFieldSubmitted: (_) => Utils.fieldFoucsChange(
                    context,
                    provider.oldPasswordFocus,
                    provider.newPasswordFocus,
                  ),
                ),

                // New Password
                TextFormField(
                  style: TextStyle(color: AppColor.white),
                  controller: provider.newPasswordController,
                  focusNode: provider.newPasswordFocus,
                  obscureText: provider.obscureNewPassword,
                  obscuringCharacter: "*",
                  cursorColor: AppColor.red,
                  decoration: _inputDecoration(
                    hint: "New Password",
                    isObscured: provider.obscureNewPassword,
                    toggle: provider.toggleNewPasswordVisibility,
                  ),
                  onFieldSubmitted: (_) => Utils.fieldFoucsChange(
                    context,
                    provider.newPasswordFocus,
                    provider.confirmPasswordFocus,
                  ),
                ),

                // Confirm Password
                TextFormField(
                  style: TextStyle(color: AppColor.white),
                  controller: provider.confirmPasswordController,
                  focusNode: provider.confirmPasswordFocus,
                  obscureText: provider.obscureConfirmPassword,
                  obscuringCharacter: "*",
                  cursorColor: AppColor.red,
                  decoration: _inputDecoration(
                    hint: "Confirm Password",
                    isObscured: provider.obscureConfirmPassword,
                    toggle: provider.toggleConfirmPasswordVisibility,
                  ),
                  onFieldSubmitted: (_) => Utils.fieldFoucsChange(
                    context,
                    provider.confirmPasswordFocus,
                    provider.saveFocus,
                  ),
                ),

                // Update Button
                Button(
                  focusNode: provider.saveFocus,
                  text: "Update",
                  onTap: () {
                    // Call your save logic
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool isObscured,
    required VoidCallback toggle,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColor.white.withValues(alpha: 0.08),
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(
        color: AppColor.white,
        fontWeight: FontWeight.normal,
        fontSize: Responsive.sp(15),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Responsive.w(12)),
        borderSide: BorderSide(color: AppColor.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Responsive.w(12)),
        borderSide: BorderSide(color: AppColor.red),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(Responsive.w(3)),
        child: SvgPicture.asset("assets/icons/lock-password.svg"),
      ),
      suffixIcon: GestureDetector(
        onTap: toggle,
        child: Icon(
          isObscured ? Icons.visibility_off : Icons.visibility,
          color: isObscured ? AppColor.white : AppColor.red,
          size: Responsive.sp(20),
        ),
      ),
    );
  }
}
