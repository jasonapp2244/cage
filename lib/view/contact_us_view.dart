import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/bottom_wraper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContactUs();
  }

  Future<void> _loadContactUs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final doc = await _firestore
          .collection('appSettings')
          .doc('contactUs')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _email = data['email'] as String?;
          _phoneNumber = data['phoneNumber'] as String?;
          _address = data['address'] as String?;
        });
      } else {
        setState(() {
          _email = null;
          _phoneNumber = null;
          _address = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load contact information: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot make phone call'),
              backgroundColor: AppColor.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColor.red,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri =
        Uri.parse('mailto:${Uri.encodeComponent(email)}');
    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email app. Is one installed?'),
            backgroundColor: AppColor.red,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Email launcher error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch email: $e'),
            backgroundColor: AppColor.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _launchMaps(String address) async {
    // Encode the address for Google Maps URL
    final String encodedAddress = Uri.encodeComponent(address);
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
    
    try {
      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot open maps'),
              backgroundColor: AppColor.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColor.red,
          ),
        );
      }
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
                  Text(
                    "Contact Us",
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
                                onPressed: _loadContactUs,
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
                              horizontal: 16.0,
                              vertical: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email
                                if (_email != null && _email!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24.0),
                                    child: InkWell(
                                      onTap: () => _launchEmail(_email!),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SvgPicture.asset(
                                                "assets/icons/mail-02.svg",
                                                color: AppColor.red,
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Email',
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 14,
                                                      color: AppColor.white.withValues(alpha: 0.7),
                                                      fontFamily: AppFonts.appFont,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _email!,
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 16,
                                                      color: AppColor.red,
                                                      fontFamily: AppFonts.appFont,
                                                      fontWeight: FontWeight.w500,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // Phone Number
                                if (_phoneNumber != null && _phoneNumber!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24.0),
                                    child: InkWell(
                                      onTap: () => _launchPhone(_phoneNumber!),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: SvgPicture.asset(
                                                "assets/icons/call.svg",
                                                color: AppColor.red,
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Phone Number',
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 14,
                                                      color: AppColor.white.withValues(alpha: 0.7),
                                                      fontFamily: AppFonts.appFont,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _phoneNumber!,
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 16,
                                                      color: AppColor.red,
                                                      fontFamily: AppFonts.appFont,
                                                      fontWeight: FontWeight.w500,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // Address
                                if (_address != null && _address!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24.0),
                                    child: InkWell(
                                      onTap: () => _launchMaps(_address!),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: Icon(
                                                Icons.location_on,
                                                color: AppColor.red,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Address',
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 14,
                                                      color: AppColor.white.withValues(alpha: 0.7),
                                                      fontFamily: AppFonts.appFont,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _address!,
                                                    style: TextStyle(
                                                      fontSize: Responsive.textScaleFactor * 16,
                                                      color: AppColor.red,
                                                      fontFamily: AppFonts.appFont,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.5,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                // No contact information message
                                if ((_email == null || _email!.isEmpty) &&
                                    (_phoneNumber == null || _phoneNumber!.isEmpty) &&
                                    (_address == null || _address!.isEmpty))
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Text(
                                        'No contact information available yet.',
                                        style: TextStyle(
                                          fontSize: Responsive.textScaleFactor * 14,
                                          color: AppColor.white.withValues(alpha: 0.7),
                                          fontFamily: AppFonts.appFont,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
