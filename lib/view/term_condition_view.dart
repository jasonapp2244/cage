import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/res/components/app_theme.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/Profile/fighter/bottom_wraper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TermConditionView extends StatefulWidget {
  const TermConditionView({super.key});

  @override
  State<TermConditionView> createState() => _TermConditionViewState();
}

class _TermConditionViewState extends State<TermConditionView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String _content = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get user role
      String? role = await Utils.getSavedRole('role');
      
      // If role not in local storage, get from Firestore
      if (role == null) {
        final userId = Utils.getCurrentUid();
        final userDoc = await _firestore
            .collection('userData')
            .doc(userId)
            .get();
        
        if (userDoc.exists && userDoc.data() != null) {
          role = userDoc.data()!['role'] as String?;
          if (role != null) {
            await Utils.saveSavedRole('role', role);
          }
        }
      }

      // Default to Fighter if role is not found
      final userRole = role ?? 'Fighter';
      
      final doc = await _firestore
          .collection('appSettings')
          .doc('termsAndConditions')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final roleKey = userRole.toLowerCase();
        
        // Try to get role-specific content
        if (data.containsKey('${roleKey}Content')) {
          setState(() {
            _content = data['${roleKey}Content'] ?? '';
          });
        } else if (data.containsKey('content')) {
          // Fallback to old format for backward compatibility
          setState(() {
            _content = data['content'] ?? '';
          });
        } else {
          setState(() {
            _content = 'No terms and conditions available yet.';
          });
        }
      } else {
        setState(() {
          _content = 'No terms and conditions available yet.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load terms and conditions: $e';
        _content = 'Error loading terms and conditions. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Try to find MainWrapper state (for drawer navigation)
                      final state = context.findAncestorStateOfType<MainWrapperState>();
                      if (state != null) {
                        state.resetToHome();
                        return;
                      }
                      // Fallback to normal navigation
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                  StreamBuilder(
                    stream: AppTheme.themeStream,
                    builder: (context, themeSnapshot) {
                      final theme = themeSnapshot.hasData 
                          ? themeSnapshot.data! 
                          : AppTheme.theme;
                      return Text(
                        "Terms & Conditions",
                        style: AppTheme.headingStyle(
                          fontSize: Responsive.textScaleFactor * theme.headingFontSize,
                          color: theme.headingTextColor,
                          bold: theme.headingBold,
                        ).copyWith(
                          fontFamily: AppFonts.appFont,
                        ),
                        textAlign: theme.headingAlign,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.red,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppColor.red,
                                size: 48,
                              ),
                              SizedBox(height: Responsive.h(2)),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontSize: Responsive.textScaleFactor * 14,
                                  color: AppColor.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: Responsive.h(3)),
                              ElevatedButton(
                                onPressed: _loadTerms,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.red,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : StreamBuilder(
                          stream: AppTheme.themeStream,
                          builder: (context, themeSnapshot) {
                            final theme = themeSnapshot.hasData 
                                ? themeSnapshot.data! 
                                : AppTheme.theme;
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  _content.isEmpty
                                      ? 'No terms and conditions available yet.'
                                      : _content,
                                  style: AppTheme.textStyle(
                                    fontSize: Responsive.textScaleFactor * theme.fontSize,
                                    color: theme.textColor,
                                    bold: theme.boldText,
                                  ).copyWith(
                                    height: 1.5,
                                  ),
                                  textAlign: theme.textAlign,
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
