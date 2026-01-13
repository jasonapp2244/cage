import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String _content = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicy();
  }

  Future<void> _loadPrivacyPolicy() async {
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
          .doc('privacyPolicy')
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
            _content = 'No privacy policy available yet.';
          });
        }
      } else {
        setState(() {
          _content = 'No privacy policy available yet.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load privacy policy: $e';
        _content = 'Error loading privacy policy. Please try again later.';
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
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/arrow-left-01.svg",
                      color: AppColor.red,
                    ),
                  ),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 24,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
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
                                onPressed: _loadPrivacyPolicy,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.red,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              _content.isEmpty
                                  ? 'No privacy policy available yet.'
                                  : _content,
                              style: TextStyle(
                                fontSize: Responsive.textScaleFactor * 12,
                                color: AppColor.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
