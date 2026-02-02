import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileImageUploadSignupView extends StatefulWidget {
  const ProfileImageUploadSignupView({super.key});

  @override
  State<ProfileImageUploadSignupView> createState() => _ProfileImageUploadSignupViewState();
}

class _ProfileImageUploadSignupViewState extends State<ProfileImageUploadSignupView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _imageError;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _imageError = null;
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageError = null;
        });
      }
    } catch (e) {
      setState(() {
        _imageError = 'Failed to pick image: ${e.toString()}';
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColor.white),
              title: Text(
                "Camera",
                style: TextStyle(color: AppColor.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColor.white),
              title: Text(
                "Gallery",
                style: TextStyle(color: AppColor.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAndContinue() async {
    if (_selectedImage == null) {
      // Skip profile image upload and continue to next screen
      if (mounted) {
        Navigator.pushNamed(context, RoutesName.poseImageUploadView);
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final authProvider = Provider.of<AuthViewmodel>(context, listen: false);
      final uid = Utils.getCurrentUid();

      // Upload profile image
      final downloadUrl = await authProvider.uploadProfileImage(
        _selectedImage!,
        uid,
      );

      if (downloadUrl != null) {
        // Save URL to fighterData
        await authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'profileImageUrl',
          value: downloadUrl,
        );

        // Navigate to next screen (pose image)
        if (mounted) {
          Navigator.pushNamed(context, RoutesName.poseImageUploadView);
        }
      } else {
        if (mounted) {
          Utils.flushBarErrorMassage(
            "Failed to upload image. Please try again.",
            context,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Utils.flushBarErrorMassage("Error: ${e.toString()}", context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.w(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Responsive.h(2)),
              Text(
                "Upload Profile Image",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(24),
                ),
              ),
              SizedBox(height: Responsive.h(1)),
              Text(
                "Upload a circular profile image that will be displayed in your profile. This is different from your pose image.",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontWeight: FontWeight.normal,
                  fontSize: Responsive.sp(12),
                ),
              ),
              SizedBox(height: Responsive.h(3)),

              // Circular Image Preview
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: Responsive.w(50),
                    height: Responsive.w(50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: _selectedImage != null
                            ? AppColor.red
                            : AppColor.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColor.white.withValues(alpha: 0.5),
                                size: Responsive.sp(48),
                              ),
                              SizedBox(height: Responsive.h(1)),
                              Text(
                                "Tap to upload",
                                style: GoogleFonts.dmSans(
                                  color: AppColor.white.withValues(alpha: 0.7),
                                  fontSize: Responsive.sp(12),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // Error message
              if (_imageError != null) ...[
                SizedBox(height: Responsive.h(2)),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColor.red.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    _imageError!,
                    style: GoogleFonts.dmSans(
                      color: AppColor.red,
                      fontSize: Responsive.sp(12),
                    ),
                  ),
                ),
              ],

              SizedBox(height: Responsive.h(4)),

              // Continue Button
              Button(
                text: _isUploading ? "Uploading..." : "Continue",
                onTap: _isUploading ? () {} : _uploadAndContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
