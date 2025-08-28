import 'package:cage/models/promoter_model.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoterProfileViewModel extends ChangeNotifier {
  // Controllers
  final TextEditingController promoterNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController numberOfEventsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController companyAboutController = TextEditingController();

  // Focus Nodes
  final FocusNode promoterNameFocusNode = FocusNode();
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode contactEmailFocusNode = FocusNode();
  final FocusNode contactNumberFocusNode = FocusNode();
  final FocusNode numberOfEventsFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode companyAboutFocusNode = FocusNode();
  final FocusNode buttonFocusNode = FocusNode();

  // State
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load current data into controllers
  void loadCurrentData(PromoterDataModel promoterData) {
    promoterNameController.text = promoterData.prompterName ?? '';
    companyNameController.text = promoterData.companyName ?? '';
    contactEmailController.text = promoterData.contactEmail ?? '';
    contactNumberController.text = promoterData.contactNumber ?? '';
    numberOfEventsController.text = (promoterData.numberOfEvents ?? 0).toString();
    locationController.text = promoterData.location ?? '';
    companyAboutController.text = promoterData.companyAbout ?? '';
    notifyListeners();
  }

  // Validate form
  bool validateForm() {
    _errorMessage = null;

    // Basic validation
    if (promoterNameController.text.trim().isEmpty) {
      _errorMessage = 'Promoter name is required';
      return false;
    }

    if (companyNameController.text.trim().isEmpty) {
      _errorMessage = 'Company name is required';
      return false;
    }

    if (contactEmailController.text.trim().isEmpty) {
      _errorMessage = 'Contact email is required';
      return false;
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(contactEmailController.text.trim())) {
      _errorMessage = 'Please enter a valid email address';
      return false;
    }

    if (contactNumberController.text.trim().isEmpty) {
      _errorMessage = 'Contact number is required';
      return false;
    }

    // Number of events validation
    final numberOfEvents = int.tryParse(numberOfEventsController.text.trim());
    if (numberOfEvents == null || numberOfEvents < 0) {
      _errorMessage = 'Number of events must be a valid positive number';
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      _errorMessage = 'Location is required';
      return false;
    }

    return true;
  }

  // Save profile
  Future<bool> saveProfile(BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final uid = Utils.getCurrentUid();
      if (uid == null) {
        _errorMessage = 'User not authenticated';
        return false;
      }

      final authProvider = Provider.of<AuthViewmodel>(context, listen: false);

      // Parse number of events
      final numberOfEvents = int.tryParse(numberOfEventsController.text.trim()) ?? 0;

      // Update promoter data fields
      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'prompterName',
        value: promoterNameController.text.trim(),
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'companyName',
        value: companyNameController.text.trim(),
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'contactEmail',
        value: contactEmailController.text.trim(),
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'contactNumber',
        value: contactNumberController.text.trim(),
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'numberOfEvents',
        value: numberOfEvents,
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'location',
        value: locationController.text.trim(),
      );

      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'companyAbout',
        value: companyAboutController.text.trim(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error saving profile: $e';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    promoterNameController.dispose();
    companyNameController.dispose();
    contactEmailController.dispose();
    contactNumberController.dispose();
    numberOfEventsController.dispose();
    locationController.dispose();
    companyAboutController.dispose();

    // Dispose focus nodes
    promoterNameFocusNode.dispose();
    companyNameFocusNode.dispose();
    contactEmailFocusNode.dispose();
    contactNumberFocusNode.dispose();
    numberOfEventsFocusNode.dispose();
    locationFocusNode.dispose();
    companyAboutFocusNode.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }
}
