import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/fighting_styles_service.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FightStyleView extends StatefulWidget {
  const FightStyleView({super.key});

  @override
  State<FightStyleView> createState() => _FightStyleViewState();
}

class _FightStyleViewState extends State<FightStyleView> {
  final FightingStylesService _fightingStylesService = FightingStylesService();
  List<String> _fightingStyles = [];
  String? _selectedFightStyle;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFightingStyles();
  }

  Future<void> _loadFightingStyles() async {
    try {
      final styles = await _fightingStylesService.getAllFightingStyles();
      if (kDebugMode) {
        print('Loaded ${styles.length} fighting styles from Firestore');
      }
      setState(() {
        _fightingStyles = styles;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading fighting styles: $e');
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load fighting styles. Please try again.';
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    "What’s your fighting style?",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Choose the martial arts or disciplines you specialize in. You can select more than one style to showcase your full skill set.",
                    style: TextStyle(
                      fontFamily: AppFonts.appFont,
                      color: AppColor.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  if (_isLoading)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
                        border: Border.all(color: AppColor.red),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColor.red),
                        ),
                      ),
                    )
                  else if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _loadFightingStyles,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.red,
                            ),
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  else if (_fightingStyles.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(Responsive.w(12)),
                        border: Border.all(color: AppColor.red),
                      ),
                      child: const Text(
                        'No fighting styles available. Please contact admin.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFightStyle,
                      style: TextStyle(color: AppColor.white),
                      dropdownColor: AppColor.white.withValues(alpha: 0.1),
                      decoration: InputDecoration(
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
                        filled: true,
                        fillColor: AppColor.white.withValues(alpha: 0.08),
                        hintText: "Select",
                        hintStyle: GoogleFonts.dmSans(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      iconEnabledColor: AppColor.white,
                      items: _fightingStyles.map((String style) {
                        return DropdownMenuItem<String>(
                          value: style,
                          child: Text(style),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFightStyle = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 30),

                  Button(
                    text: "Next",
                    enabled: _selectedFightStyle != null && !_isLoading,
                    onTap: () {
                      if (_selectedFightStyle != null) {
                        var uid = Utils.getCurrentUid();
                        authProvider.addUserFieldByRole(
                          uid: uid,
                          fieldName: 'fightingStyle',
                          value: _selectedFightStyle!,
                        );

                        Navigator.pushNamed(
                          context,
                          RoutesName.lastBloodTest_view,
                        );
                      }
                    },
                  ),
                ],
              ), // SizedBox(height: Responsive.h(3)),
            ],
          ),
        ),
      ),
    );
  }
}
