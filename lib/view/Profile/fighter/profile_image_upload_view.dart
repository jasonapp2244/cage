import 'dart:io';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileImageUploadView extends StatefulWidget {
  const ProfileImageUploadView({super.key});

  @override
  State<ProfileImageUploadView> createState() => _ProfileImageUploadViewState();
}

class _ProfileImageUploadViewState extends State<ProfileImageUploadView> {
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

  Future<void> _uploadAndSave() async {
    if (_selectedImage == null) {
      Utils.flushBarErrorMassage("Please select a profile image first", context);
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
        // Save URL to fighterData or promoterData
        await authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'profileImageUrl',
          value: downloadUrl,
        );

        // Go back first, then show success message
        if (mounted) {
          Navigator.pop(context);
          // Show success message on the previous screen
          Future.delayed(Duration(milliseconds: 300), () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Profile image uploaded successfully!"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
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
      appBar: AppBar(
        backgroundColor: AppColor.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upload Profile Image",
          style: GoogleFonts.dmSans(
            color: AppColor.white,
            fontSize: Responsive.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.w(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Responsive.h(2)),
              
              // Instructions
              Text(
                "Upload Profile Image",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Responsive.h(1)),
              Text(
                "Upload a profile image that will be displayed in your profile. This is different from your pose image used on the home screen.",
                style: GoogleFonts.dmSans(
                  color: AppColor.white.withValues(alpha: 0.7),
                  fontSize: Responsive.sp(14),
                ),
              ),
              SizedBox(height: Responsive.h(3)),

              // Image Preview
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColor.black,
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
                },
                child: Container(
                  height: Responsive.h(40),
                  decoration: BoxDecoration(
                    color: AppColor.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColor.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
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
                            SizedBox(height: Responsive.h(2)),
                            Text(
                              "Tap to upload profile image",
                              style: GoogleFonts.dmSans(
                                color: AppColor.white.withValues(alpha: 0.7),
                                fontSize: Responsive.sp(14),
                              ),
                            ),
                            SizedBox(height: Responsive.h(1)),
                            Text(
                              "Camera or Gallery",
                              style: GoogleFonts.dmSans(
                                color: AppColor.white.withValues(alpha: 0.5),
                                fontSize: Responsive.sp(12),
                              ),
                            ),
                          ],
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

              // Upload Button
              Button(
                text: _isUploading ? "Uploading..." : "Upload Profile Image",
                onTap: _isUploading ? () {} : _uploadAndSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
