import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<String?> _getProfileImage() async {
    // Replace this with your actual logic to get the profile image URL
    return "https://i.postimg.cc/0jqKB6mS/Profile-Image.png";
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });

        // Here you would typically upload the image to your server
        // await _uploadImage(_pickedImage!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return FutureBuilder<String?>(
      future: _getProfileImage(),
      builder: (context, snapshot) {
        // If we have a locally picked image, show that instead of the network image
        if (_pickedImage != null) {
          return _buildImageWithEditButton(
            Image.file(_pickedImage!, fit: BoxFit.cover),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        }

        final imageUrl = snapshot.data;
        final fullImageUrl = (imageUrl != null && imageUrl.isNotEmpty)
            ? "https://devonlinetestserver.com/marcus_la/storage/app/public/profile_image/$imageUrl"
            : "https://i.postimg.cc/0jqKB6mS/Profile-Image.png";

        return _buildImageWithEditButton(
          CachedNetworkImage(
            imageUrl: fullImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(),
            errorWidget: (context, url, error) => _buildPlaceholder(),
          ),
        );
      },
    );
  }

  Widget _buildImageWithEditButton(Widget image) {
    return SizedBox(
      height: Responsive.w(60),
      width: Responsive.w(60),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: SizedBox(
              width: Responsive.w(28),
              height: Responsive.w(28),
              child: image,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return GestureDetector(
      onTap: _pickImage,

      child: CircleAvatar(
        backgroundColor: AppColor.black,
        child: SvgPicture.asset("assets/icons/Frame 1410120931.svg"),
      ),
    );
  }
}
