import 'package:flutter/material.dart';
import 'package:cage/models/fighter_model.dart';
import 'package:cage/viewmodel/auth_viewmodel.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cage/services/fighting_styles_service.dart';

class ProfileViewModel extends ChangeNotifier {
  // Controllers for form fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController fightwonController;
  late TextEditingController fightloseController;
  late TextEditingController fightknockoutController;
  late TextEditingController weightController;
  late TextEditingController heightFeetController;
  late TextEditingController heightInchesController;
  late TextEditingController coachController;
  late TextEditingController tapologyController;
  late TextEditingController locationController;
  late TextEditingController lastBloodController;
  late TextEditingController lastExamController;
  late TextEditingController eyeExamController;

  // Focus nodes for form fields
  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode fightwonFocusNode;
  late FocusNode fightloseFocusNode;
  late FocusNode fightknockoutFocusNode;
  late FocusNode weightFocusNode;
  late FocusNode heightFeetFocusNode;
  late FocusNode heightInchesFocusNode;
  late FocusNode coachFocusNode;
  late FocusNode tapologyFocusNode;
  late FocusNode locationFocusNode;
  late FocusNode buttonFocusNode;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Fighting style
  String? _selectedFightingStyle;
  String? get selectedFightingStyle => _selectedFightingStyle;
  List<String> _fightingStyles = [];
  List<String> get fightingStyles => _fightingStyles;
  bool _isLoadingFightingStyles = false;
  bool get isLoadingFightingStyles => _isLoadingFightingStyles;

  final FightingStylesService _fightingStylesService = FightingStylesService();

  ProfileViewModel() {
    _initializeControllers();
    _loadFightingStyles();
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
    heightFeetController = TextEditingController();
    heightInchesController = TextEditingController();
    coachController = TextEditingController();
    tapologyController = TextEditingController();
    locationController = TextEditingController();
    lastBloodController = TextEditingController();
    lastExamController = TextEditingController();
    eyeExamController = TextEditingController();

    // Initialize focus nodes
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    fightwonFocusNode = FocusNode();
    fightloseFocusNode = FocusNode();
    fightknockoutFocusNode = FocusNode();
    weightFocusNode = FocusNode();
    heightFeetFocusNode = FocusNode();
    heightInchesFocusNode = FocusNode();
    coachFocusNode = FocusNode();
    tapologyFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    buttonFocusNode = FocusNode();
  }

  /// Load current fighter data into form fields
  void loadCurrentData(FighterDataModel fighterData) {
    nameController.text = fighterData.fullName;
    // Load email from FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? '';
    phoneController.text = fighterData.coachContact;
    fightwonController.text = fighterData.fightWin.toString();
    fightloseController.text = fighterData.fightsLose.toString();
    fightknockoutController.text = fighterData.fightsKnockout.toString();
    weightController.text = fighterData.weight ?? '';
    final heightCm = double.tryParse(fighterData.height);
    if (heightCm != null && heightCm > 0) {
      final totalInches = heightCm / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      heightFeetController.text = feet.toString();
      heightInchesController.text = inches.toString();
    }
    coachController.text = fighterData.coachName;
    tapologyController.text = fighterData.urlProfile;
    locationController.text = fighterData.location ?? '';
    _setMedicalDateIfValid(lastBloodController, fighterData.lastBlood);
    _setMedicalDateIfValid(lastExamController, fighterData.lastExam);
    if (fighterData.eyeExam != null && fighterData.eyeExam!.isNotEmpty) {
      _setMedicalDateIfValid(eyeExamController, fighterData.eyeExam!);
    }
    // Set fighting style
    _selectedFightingStyle = fighterData.fightingStyle;

    notifyListeners();
  }

  void _setMedicalDateIfValid(TextEditingController c, String value) {
    if (value.isEmpty || value == 'Not set' || value == '0') return;
    c.text = value;
  }

  /// Load fighting styles from Firestore
  Future<void> _loadFightingStyles() async {
    _isLoadingFightingStyles = true;
    notifyListeners();
    try {
      _fightingStyles = await _fightingStylesService.getAllFightingStyles();
    } catch (e) {
      print('Error loading fighting styles: $e');
      _fightingStyles = [];
    } finally {
      _isLoadingFightingStyles = false;
      notifyListeners();
    }
  }

  /// Persist height (ft + in) as cm when both provided and valid.
  Future<void> _saveHeightIfValid(
    AuthViewmodel authProvider,
    String uid,
  ) async {
    final ft = int.tryParse(heightFeetController.text.trim());
    final inch = int.tryParse(heightInchesController.text.trim());
    if (ft != null && inch != null && ft >= 0 && inch >= 0 && inch < 12) {
      final totalInches = ft * 12 + inch;
      final cm = (totalInches * 2.54).round();
      await authProvider.addUserFieldByRole(
        uid: uid,
        fieldName: 'height',
        value: cm.toString(),
      );
    }
  }

  /// Set selected fighting style
  void setFightingStyle(String? style) {
    _selectedFightingStyle = style;
    notifyListeners();
  }

  static String _formatMedicalDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  void setLastBloodDate(DateTime d) {
    lastBloodController.text = _formatMedicalDate(d);
    notifyListeners();
  }

  void setLastExamDate(DateTime d) {
    lastExamController.text = _formatMedicalDate(d);
    notifyListeners();
  }

  void setEyeExamDate(DateTime d) {
    eyeExamController.text = _formatMedicalDate(d);
    notifyListeners();
  }

  /// Parse "d/M/yyyy" to DateTime for calendar initialDate. Returns null if invalid.
  static DateTime? parseMedicalDate(String s) {
    if (s.isEmpty || s == 'Not set') return null;
    final parts = s.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0].trim());
    final month = int.tryParse(parts[1].trim());
    final year = int.tryParse(parts[2].trim());
    if (day == null || month == null || year == null) return null;
    if (month < 1 || month > 12 || day < 1 || day > 31) return null;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
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
        _saveHeightIfValid(authProvider, uid),
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
        authProvider.addUserFieldByRole(
          uid: uid,
          fieldName: 'selectLocation',
          value: locationController.text.trim(),
        ),
        if (lastBloodController.text.trim().isNotEmpty)
          authProvider.addUserFieldByRole(
            uid: uid,
            fieldName: 'lastBlood',
            value: lastBloodController.text.trim(),
          ),
        if (lastExamController.text.trim().isNotEmpty)
          authProvider.addUserFieldByRole(
            uid: uid,
            fieldName: 'lastExam',
            value: lastExamController.text.trim(),
          ),
        if (eyeExamController.text.trim().isNotEmpty)
          authProvider.addUserFieldByRole(
            uid: uid,
            fieldName: 'eyeExam',
            value: eyeExamController.text.trim(),
          ),
        if (_selectedFightingStyle != null)
          authProvider.addUserFieldByRole(
            uid: uid,
            fieldName: 'fightingStyle',
            value: _selectedFightingStyle!,
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
      _setError('Coach phone number is required');
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

    final wins = int.tryParse(fightwonController.text.trim()) ?? 0;
    final knockouts = int.tryParse(fightknockoutController.text.trim()) ?? 0;
    if (knockouts > wins) {
      _setError('Knockouts cannot exceed wins');
      return false;
    }

    final ftStr = heightFeetController.text.trim();
    final inStr = heightInchesController.text.trim();
    if (ftStr.isNotEmpty || inStr.isNotEmpty) {
      final ft = int.tryParse(ftStr);
      final inch = int.tryParse(inStr);
      if (ft == null || inch == null || ft < 0 || inch < 0 || inch >= 12) {
        _setError('Height: use feet ≥ 0 and inches 0–11');
        return false;
      }
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
    heightFeetController.dispose();
    heightInchesController.dispose();
    coachController.dispose();
    tapologyController.dispose();
    locationController.dispose();
    lastBloodController.dispose();
    lastExamController.dispose();
    eyeExamController.dispose();

    // Dispose focus nodes
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    fightwonFocusNode.dispose();
    fightloseFocusNode.dispose();
    fightknockoutFocusNode.dispose();
    weightFocusNode.dispose();
    heightFeetFocusNode.dispose();
    heightInchesFocusNode.dispose();
    coachFocusNode.dispose();
    tapologyFocusNode.dispose();
    locationFocusNode.dispose();
    buttonFocusNode.dispose();

    super.dispose();
  }
}
