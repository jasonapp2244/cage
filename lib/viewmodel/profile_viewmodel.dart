import 'package:flutter/material.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  // Controllers for form fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController fightwonController;
  late TextEditingController fightloseController;
  late TextEditingController fightknockoutController;
  late TextEditingController weightController;
  late TextEditingController coachController;
  late TextEditingController tapologyController;

  // Focus nodes for form fields
  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode fightwonFocusNode;
  late FocusNode fightloseFocusNode;
  late FocusNode fightknockoutFocusNode;
  late FocusNode weightFocusNode;
  late FocusNode coachFocusNode;
  late FocusNode tapologyFocusNode;
  late FocusNode buttonFocusNode;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileViewModel() {
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize text controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    fightwonController = TextEditingController();
    fightloseController = TextEditingController();
    fightknockoutController = TextEditingController();
    weightController = TextEditingController();
    coachController = TextEditingController();
    tapologyController = TextEditingController();

    // Initialize focus nodes
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    fightwonFocusNode = FocusNode();
    fightloseFocusNode = FocusNode();
    fightknockoutFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    coachFocusNode = FocusNode();
    tapologyFocusNode = FocusNode();
    buttonFocusNode = FocusNode();
  }

  /// Load current fighter data into form fields
  void loadCurrentData(FighterDataModel fighterData) {
    nameController.text = fighterData.fullName ?? '';
    phoneController.text = fighterData.coachContact ?? '';
    fightwonController.text = fighterData.fightWin.toString();
    fightloseController.text = fighterData.fightsLose.toString();
    fightknockoutController.text = fighterData.fightsKnockout.toString();
    weightController.text = fighterData.weight ?? '';
    coachController.text = fighterData.coachName ?? '';
    tapologyController.text = fighterData.urlProfile ?? '';

    notifyListeners();
  }

  /// Save profile data to Firestore
  Future<bool> saveProfile(BuildContext context) async {
    try {
      _setLoading(true);
      _clearError();

      final uid = Utils.getCurrentUid();
      final authProvider = Provider.of<AuthViewmodel>(context, listen: false);

      // Update all fields in parallel
      await Future.wait([
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'fullName',
          value: nameController.text.trim(),
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'coachContact',
          value: phoneController.text.trim(),
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'fightWin',
          value: int.tryParse(fightwonController.text.trim()) ?? 0,
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'fightsLose',
          value: int.tryParse(fightloseController.text.trim()) ?? 0,
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'fightsKnockout',
          value: int.tryParse(fightknockoutController.text.trim()) ?? 0,
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'weight',
          value: weightController.text.trim(),
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'coachName',
          value: coachController.text.trim(),
        ),
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'urlProfile',
          value: tapologyController.text.trim(),
        ),
      ]);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Error updating profile: $e');
      return false;
    }
  }

  /// Validate form data
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      _setError('Name is required');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      _setError('Phone number is required');
      return false;
    }

    // Validate numeric fields
    if (int.tryParse(fightwonController.text.trim()) == null) {
      _setError('Fight wins must be a number');
      return false;
    }

    if (int.tryParse(fightloseController.text.trim()) == null) {
      _setError('Fight losses must be a number');
      return false;
    }

    if (int.tryParse(fightknockoutController.text.trim()) == null) {
      _setError('Fight knockouts must be a number');
      return false;
    }

    _clearError();
    return true;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message (public method)
  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    fightwonController.dispose();
    fightloseController.dispose();
    fightknockoutController.dispose();
    weightController.dispose();
    coachController.dispose();
    tapologyController.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    fightwonFocusNode.dispose();
    fightloseFocusNode.dispose();
    fightknockoutFocusNode.dispose();
    weightFocusNode.dispose();
    coachFocusNode.dispose();
    tapologyFocusNode.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }
}
