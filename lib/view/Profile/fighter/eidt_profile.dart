import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/view/Profile/fighter/profile_pic.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/custom_calendar.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  spacing: Responsive.h(1),
                  children: [
                    SizedBox(height: Responsive.h(1)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/arrow-left-01.svg",
                          color: AppColor.red,
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.h(1)),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
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
                    SizedBox(height: Responsive.h(1)),
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
                      text: 'Coach Phone No',
                      controller: profileProvider.phoneController,
                      focusNode: profileProvider.phoneFocusNode,
                      nextfocusNode: profileProvider.fightwonFocusNode,
                      keyboardType: TextInputType.phone,
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Wins',
                      controller: profileProvider.fightwonController,
                      focusNode: profileProvider.fightwonFocusNode,
                      nextfocusNode: profileProvider.fightloseFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Losses',
                      controller: profileProvider.fightloseController,
                      focusNode: profileProvider.fightloseFocusNode,
                      nextfocusNode: profileProvider.fightknockoutFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    EditProfileTextfeild(
                      text: 'Fight Knockouts',
                      controller: profileProvider.fightknockoutController,
                      focusNode: profileProvider.fightknockoutFocusNode,
                      nextfocusNode: profileProvider.weightFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    EditProfileTextfeild(
                      text: 'Weight',
                      controller: profileProvider.weightController,
                      focusNode: profileProvider.weightFocusNode,
                      nextfocusNode: profileProvider.heightFeetFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                    ),
                    EditProfileTextfeild(
                      text: 'Height (ft)',
                      controller: profileProvider.heightFeetController,
                      focusNode: profileProvider.heightFeetFocusNode,
                      nextfocusNode: profileProvider.heightInchesFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    EditProfileTextfeild(
                      text: 'Height (in)',
                      controller: profileProvider.heightInchesController,
                      focusNode: profileProvider.heightInchesFocusNode,
                      nextfocusNode: profileProvider.coachFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      nextfocusNode: profileProvider.locationFocusNode,
                    ),
                    EditProfileTextfeild(
                      text: 'Location',
                      controller: profileProvider.locationController,
                      focusNode: profileProvider.locationFocusNode,
                      nextfocusNode: profileProvider.buttonFocusNode,
                    ),
                    _MedicalDateField(
                      parentContext: context,
                      label: 'Last Blood Test',
                      controller: profileProvider.lastBloodController,
                      onDatePicked: profileProvider.setLastBloodDate,
                    ),
                    _MedicalDateField(
                      parentContext: context,
                      label: 'Last Medical Exam',
                      controller: profileProvider.lastExamController,
                      onDatePicked: profileProvider.setLastExamDate,
                    ),
                    _MedicalDateField(
                      parentContext: context,
                      label: 'Eye Exam',
                      controller: profileProvider.eyeExamController,
                      onDatePicked: profileProvider.setEyeExamDate,
                    ),
                    // Fighting Style Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: profileProvider.selectedFightingStyle != null
                              ? AppColor.black
                              : AppColor.black,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: profileProvider.selectedFightingStyle,
                        decoration: InputDecoration(
                          label: Text(
                            'Fighting Style',
                            style: TextStyle(
                              fontFamily: AppFonts.appFont,
                              color: AppColor.white,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.black),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.red),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.black),
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        dropdownColor: AppColor.black,
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.white.withValues(alpha: 0.7),
                        ),
                        items: profileProvider.isLoadingFightingStyles
                            ? []
                            : profileProvider.fightingStyles.map((
                                String style,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: style,
                                  child: Text(style),
                                );
                              }).toList(),
                        onChanged: profileProvider.isLoadingFightingStyles
                            ? null
                            : (String? value) {
                                profileProvider.setFightingStyle(value);
                              },
                      ),
                    ),
                    if (profileProvider.isLoadingFightingStyles)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.red,
                            ),
                          ),
                        ),
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

class _MedicalDateField extends StatelessWidget {
  final BuildContext parentContext;
  final String label;
  final TextEditingController controller;
  final void Function(DateTime) onDatePicked;

  const _MedicalDateField({
    required this.parentContext,
    required this.label,
    required this.controller,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GestureDetector(
      onTap: () async {
        final initial = ProfileViewModel.parseMedicalDate(controller.text);
        final date = await showCustomCalendar(
          context: parentContext,
          initialDate: initial,
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
          lastDate: DateTime.now(),
        );
        if (date != null) onDatePicked(date);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: AppColor.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white.withValues(alpha: 0.05),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.black),
              borderRadius: BorderRadius.circular(28),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.red),
              borderRadius: BorderRadius.circular(28),
            ),
            label: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.appFont,
                color: AppColor.white,
              ),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: AppColor.red,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
