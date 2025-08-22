import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/profile_pic.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class EidtProfile extends StatefulWidget {
  final FighterDataModel? fighterData;

  const EidtProfile({super.key, this.fighterData});

  @override
  State<EidtProfile> createState() => _EidtProfileState();
}

class _EidtProfileState extends State<EidtProfile> {
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ProfileViewModel();
        // Load data immediately when provider is created
        if (widget.fighterData != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadCurrentData(widget.fighterData!);
          });
        }
        return provider;
      },
      child: _EidtProfileContent(),
    );
  }
}

class _EidtProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
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
                      text: 'Name',
                      controller: profileProvider.nameController,
                      focusNode: profileProvider.nameFocusNode,
                      nextfocusNode: profileProvider.emailFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Email Address',
                      controller: profileProvider.emailController,
                      focusNode: profileProvider.emailFocusNode,
                      nextfocusNode: profileProvider.phoneFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Phone No',
                      controller: profileProvider.phoneController,
                      focusNode: profileProvider.phoneFocusNode,
                      nextfocusNode: profileProvider.fightwonFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Wins',
                      controller: profileProvider.fightwonController,
                      focusNode: profileProvider.fightwonFocusNode,
                      nextfocusNode: profileProvider.fightloseFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Losses',
                      controller: profileProvider.fightloseController,
                      focusNode: profileProvider.fightloseFocusNode,
                      nextfocusNode: profileProvider.fightknockoutFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Knockouts',
                      controller: profileProvider.fightknockoutController,
                      focusNode: profileProvider.fightknockoutFocusNode,
                      nextfocusNode: profileProvider.weightFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Weight',
                      controller: profileProvider.weightController,
                      focusNode: profileProvider.weightFocusNode,
                      nextfocusNode: profileProvider.coachFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Coach Name',
                      controller: profileProvider.coachController,
                      focusNode: profileProvider.coachFocusNode,
                      nextfocusNode: profileProvider.tapologyFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Tapology URL',
                      controller: profileProvider.tapologyController,
                      focusNode: profileProvider.tapologyFocusNode,
                      nextfocusNode: profileProvider.buttonFocusNode,
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
    final profileProvider = Provider.of<ProfileViewModel>(
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
