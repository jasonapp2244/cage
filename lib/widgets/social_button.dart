import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback ontap;
  final bool loading;

  const SocialButton({
    super.key,
    required this.iconPath,
    required this.ontap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : ontap,
      child: Container(
        height: Responsive.h(6),
        width: Responsive.w(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.w(5.5)),
          color: AppColor.white.withValues(alpha: loading ? 0.04 : 0.08),
        ),
        child: Padding(
          padding: EdgeInsets.all(Responsive.w(3)),
          child: loading
              ? Center(child: CustomLoadingAnimation())
              : SvgPicture.asset(iconPath),
        ),
      ),
    );
  }
}
