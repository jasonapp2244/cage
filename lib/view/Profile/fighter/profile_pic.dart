import 'package:cached_network_image/cached_network_image.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/models/user_model.dart';
import 'package:cage/repository/home_repository.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/profile_image_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Future<void> _pickImage() async {
    // Navigate to profile image upload view instead
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileImageUploadView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return StreamBuilder<UserModel>(
      stream: UserRepository.fetchCurrentUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return _buildPlaceholder();
        }

        final user = snapshot.data!;
        String? imageUrl;

        if (user.isFighter && user.roleData is FighterDataModel) {
          final fighter = user.roleData as FighterDataModel;
          imageUrl = fighter.profileImageUrl;
        } else if (user.isPromoter && user.roleData is PromoterDataModel) {
          final promoter = user.roleData as PromoterDataModel;
          imageUrl = promoter.profileImageUrl;
        }

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return _buildImageWithEditButton(
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildPlaceholder(),
              errorWidget: (context, url, error) => _buildPlaceholder(),
            ),
          );
        }

        return _buildPlaceholder();
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
