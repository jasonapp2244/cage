import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/fighting_styles_service.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FightingStyleView extends StatefulWidget {
  const FightingStyleView({super.key});

  @override
  State<FightingStyleView> createState() => _FightingStyleViewState();
}

class _FightingStyleViewState extends State<FightingStyleView> {
  final FightingStylesService _fightingStylesService = FightingStylesService();
  List<String> _fightingStyles = [];
  String? _selectedFightingStyle;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFightingStyles();
  }

  Future<void> _loadFightingStyles() async {
    try {
      final styles = await _fightingStylesService.getAllFightingStyles();
      setState(() {
        _fightingStyles = styles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.h(2)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/arrow-left-01.svg",
                  color: AppColor.red,
                ),
              ),
              SizedBox(height: Responsive.h(2)),
              Text(
                "What's your fighting style?",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Responsive.h(1)),
              Text(
                "Choose the martial arts or disciplines you specialize in. You can select more than one style to showcase your full skill set.",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.normal,
                  fontSize: Responsive.sp(14),
                ),
              ),
              SizedBox(height: Responsive.h(3)),
              if (_isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.red),
                    ),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Responsive.w(12)),
                    border: Border.all(
                      color: _selectedFightingStyle != null
                          ? AppColor.red
                          : AppColor.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedFightingStyle,
                    decoration: InputDecoration(
                      hintText: "Select your fighting style",
                      hintStyle: GoogleFonts.dmSans(
                        color: AppColor.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    dropdownColor: AppColor.black,
                    style: GoogleFonts.dmSans(
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                      fontSize: Responsive.sp(15),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.white.withValues(alpha: 0.7),
                    ),
                    items: _fightingStyles.map((String style) {
                      return DropdownMenuItem<String>(
                        value: style,
                        child: Text(style),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFightingStyle = value;
                      });
                    },
                  ),
                ),
              const Spacer(),
              Button(
                text: "Next",
                enabled: _selectedFightingStyle != null,
                onTap: () {
                  if (_selectedFightingStyle != null) {
                    var uid = Utils.getCurrentUid();
                    authProvider.addUserFieldByRole(
                      uid: uid,
                      fieldName: 'fightingStyle',
                      value: _selectedFightingStyle!,
                    );
                    Navigator.pushNamed(context, RoutesName.ageview);
                  }
                },
              ),
              SizedBox(height: Responsive.h(2)),
            ],
          ),
        ),
      ),
    );
  }
}
