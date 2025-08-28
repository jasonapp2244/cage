import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/profile_pic.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:cage/models/promoter_model.dart';
import 'package:cage/viewmodel/promoter_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EditPromoterProfile extends StatefulWidget {
  final PromoterDataModel? promoterData;

  const EditPromoterProfile({super.key, this.promoterData});

  @override
  State<EditPromoterProfile> createState() => _EditPromoterProfileState();
}

class _EditPromoterProfileState extends State<EditPromoterProfile> {
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return ChangeNotifierProvider(
      create: (_) {
        final provider = PromoterProfileViewModel();
        // Load data immediately when provider is created
        if (widget.promoterData != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadCurrentData(widget.promoterData!);
          });
        }
        return provider;
      },
      child: _EditPromoterProfileContent(),
    );
  }
}

class _EditPromoterProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PromoterProfileViewModel>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ProfilePic(),
                    ),
                    Text(
                      "Remove",
                      style: TextStyle(
                        color: AppColor.red,
                        fontWeight: FontWeight.normal,
                        fontFamily: AppFonts.appFont,
                      ),
                    ),
                    EditProfileTextfeild(
                      text: 'Promoter Name',
                      controller: profileProvider.promoterNameController,
                      focusNode: profileProvider.promoterNameFocusNode,
                      nextfocusNode: profileProvider.companyNameFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Company Name',
                      controller: profileProvider.companyNameController,
                      focusNode: profileProvider.companyNameFocusNode,
                      nextfocusNode: profileProvider.contactEmailFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Contact Email',
                      controller: profileProvider.contactEmailController,
                      focusNode: profileProvider.contactEmailFocusNode,
                      nextfocusNode: profileProvider.contactNumberFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Contact Number',
                      controller: profileProvider.contactNumberController,
                      focusNode: profileProvider.contactNumberFocusNode,
                      nextfocusNode: profileProvider.numberOfEventsFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Number of Events',
                      controller: profileProvider.numberOfEventsController,
                      focusNode: profileProvider.numberOfEventsFocusNode,
                      nextfocusNode: profileProvider.locationFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Location',
                      controller: profileProvider.locationController,
                      focusNode: profileProvider.locationFocusNode,
                      nextfocusNode: profileProvider.companyAboutFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Company About',
                      controller: profileProvider.companyAboutController,
                      focusNode: profileProvider.companyAboutFocusNode,
                      nextfocusNode: profileProvider.buttonFocusNode,
                      //  maxLines: 3,
                    ),
                    Button(
                      focusNode: profileProvider.buttonFocusNode,
                      text: profileProvider.isLoading ? "Saving..." : "Save",
                      onTap: profileProvider.isLoading
                          ? () {}
                          : () => _handleSave(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSave(BuildContext context) async {
    final profileProvider = Provider.of<PromoterProfileViewModel>(
      context,
      listen: false,
    );

    // Validate form first
    if (!profileProvider.validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.errorMessage ?? 'Validation failed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColor.red)),
    );

    // Save profile
    final success = await profileProvider.saveProfile(context);

    // Hide loading indicator
    Navigator.pop(context);

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back
      Navigator.pop(context);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileProvider.errorMessage ?? 'Error updating profile',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
