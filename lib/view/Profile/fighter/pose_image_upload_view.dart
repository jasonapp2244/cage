import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class PoseImageUploadView extends StatefulWidget {
  const PoseImageUploadView({super.key});

  @override
  State<PoseImageUploadView> createState() => _PoseImageUploadViewState();
}

class _PoseImageUploadViewState extends State<PoseImageUploadView> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _imageError;

  // Recommended dimensions for pose image
  static const double recommendedWidth = 1080.0;
  static const double recommendedHeight =
      1920.0; // 9:16 aspect ratio (portrait)
  static const double minWidth = 720.0;
  static const double minHeight = 1280.0;
  static const double maxFileSizeMB = 10.0;

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _imageError = null;
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSizeMB = await file.length() / (1024 * 1024);

        // Check file size
        if (fileSizeMB > maxFileSizeMB) {
          setState(() {
            _imageError =
                'Image size is too large. Please use an image smaller than ${maxFileSizeMB}MB.';
          });
          return;
        }

        // Get image dimensions
        final imageBytes = await file.readAsBytes();
        final codec = await ui.instantiateImageCodec(imageBytes);
        final frame = await codec.getNextFrame();
        final decodedImage = frame.image;
        final width = decodedImage.width.toDouble();
        final height = decodedImage.height.toDouble();

        // Check dimensions
        if (width < minWidth || height < minHeight) {
          setState(() {
            _imageError =
                'Image resolution is too low. Minimum size: ${minWidth.toInt()}x${minHeight.toInt()} pixels.\nRecommended: ${recommendedWidth.toInt()}x${recommendedHeight.toInt()} pixels.';
          });
          decodedImage.dispose();
          return;
        }

        // Check aspect ratio (should be approximately 9:16 for portrait)
        final aspectRatio = width / height;
        // Target aspect ratio is 0.5625 (9:16)

        if (aspectRatio < 0.4 || aspectRatio > 0.7) {
          setState(() {
            _imageError =
                'Image aspect ratio is not suitable. Please use a portrait image (9:16 ratio recommended).';
          });
          decodedImage.dispose();
          return;
        }

        decodedImage.dispose();

        setState(() {
          _selectedImage = file;
          _imageError = null;
        });
      }
    } catch (e) {
      setState(() {
        _imageError = 'Failed to pick image: ${e.toString()}';
      });
    }
  }

  Future<void> _uploadAndContinue() async {
    if (_selectedImage == null) {
      // Skip pose image upload and continue to next screen
      if (mounted) {
        Navigator.pushNamed(context, RoutesName.namecoachview);
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final authProvider = Provider.of<AuthViewmodel>(context, listen: false);
      final uid = Utils.getCurrentUid();

      // Upload pose image
      final downloadUrl = await authProvider.uploadPoseImage(
        _selectedImage!,
        uid,
      );

      if (downloadUrl != null) {
        // Save URL to fighterData
        await authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'poseImageUrl',
          value: downloadUrl,
        );

        // Navigate to next screen (coach name)
        if (mounted) {
          Navigator.pushNamed(context, RoutesName.namecoachview);
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

  Future<void> _skipAndContinue() async {
    // Skip pose image upload and continue to next screen
    if (mounted) {
      Navigator.pushNamed(context, RoutesName.namecoachview);
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                      "Upload Pose Image",
                      style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        color: AppColor.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    Text(
                      "Upload a full-body pose image that will be displayed on your home screen and profile.",
                      style: TextStyle(
                        fontFamily: AppFonts.appFont,
                        color: AppColor.white,
                        fontWeight: FontWeight.normal,
                        fontSize: Responsive.sp(12),
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    Container(
                      padding: EdgeInsets.all(Responsive.w(3)),
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.red.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColor.red,
                                size: Responsive.sp(16),
                              ),
                              SizedBox(width: Responsive.w(2)),
                              Text(
                                "Image Requirements:",
                                style: GoogleFonts.dmSans(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(12),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Responsive.h(1)),
                          _buildRequirementItem(
                            "Resolution: Minimum ${minWidth.toInt()}x${minHeight.toInt()}px",
                          ),
                          _buildRequirementItem(
                            "Recommended: ${recommendedWidth.toInt()}x${recommendedHeight.toInt()}px",
                          ),
                          _buildRequirementItem(
                            "Aspect Ratio: Portrait (9:16 recommended)",
                          ),
                          _buildRequirementItem(
                            "File Size: Maximum ${maxFileSizeMB}MB",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    // Image Preview/Upload Area
                    GestureDetector(
                      onTap: () => _showImageSourceDialog(),
                      child: Container(
                        width: double.infinity,
                        height: Responsive.h(50),
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _selectedImage != null
                                ? AppColor.red
                                : AppColor.white.withValues(alpha: 0.2),
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
                                    "Tap to upload pose image",
                                    style: GoogleFonts.dmSans(
                                      color: AppColor.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: Responsive.sp(14),
                                    ),
                                  ),
                                  SizedBox(height: Responsive.h(1)),
                                  Text(
                                    "Camera or Gallery",
                                    style: GoogleFonts.dmSans(
                                      color: AppColor.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      fontSize: Responsive.sp(12),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    if (_imageError != null) ...[
                      SizedBox(height: Responsive.h(2)),
                      Container(
                        padding: EdgeInsets.all(Responsive.w(3)),
                        decoration: BoxDecoration(
                          color: AppColor.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.red, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColor.red,
                              size: Responsive.sp(16),
                            ),
                            SizedBox(width: Responsive.w(2)),
                            Expanded(
                              child: Text(
                                _imageError!,
                                style: GoogleFonts.dmSans(
                                  color: AppColor.red,
                                  fontSize: Responsive.sp(11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: Responsive.h(1)),
                Column(
                  children: [
                    Button(
                      text: _isUploading ? "Uploading..." : "Continue",
                      enabled: !_isUploading,
                      onTap: _uploadAndContinue,
                    ),
                    SizedBox(height: Responsive.h(1)),
                    TextButton(
                      onPressed: _isUploading ? null : _skipAndContinue,
                      child: Text(
                        "Skip for now",
                        style: GoogleFonts.dmSans(
                          color: AppColor.white.withValues(alpha: 0.7),
                          fontSize: Responsive.sp(14),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: Responsive.w(5), top: Responsive.h(0.5)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColor.red,
            size: Responsive.sp(14),
          ),
          SizedBox(width: Responsive.w(2)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                color: AppColor.white.withValues(alpha: 0.8),
                fontSize: Responsive.sp(11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(Responsive.w(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Responsive.w(15),
              height: 4,
              margin: EdgeInsets.only(bottom: Responsive.h(2)),
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColor.red),
              title: Text(
                "Take Photo",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColor.red),
              title: Text(
                "Choose from Gallery",
                style: GoogleFonts.dmSans(
                  color: AppColor.white,
                  fontSize: Responsive.sp(16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: Responsive.h(2)),
          ],
        ),
      ),
    );
  }
}
