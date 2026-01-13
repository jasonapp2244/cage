import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/event_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/event_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  final EventService _eventService = EventService();

  // Controllers
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _weightClassController = TextEditingController();
  final TextEditingController _requiredRecordController =
      TextEditingController();
  final TextEditingController _ageLimitController = TextEditingController();
  final TextEditingController _fightingStyleController =
      TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  // Focus Nodes
  final FocusNode _eventTitleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _eventDateFocus = FocusNode();
  final FocusNode _eventTimeFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _eventTypeFocus = FocusNode();
  final FocusNode _weightClassFocus = FocusNode();
  final FocusNode _requiredRecordFocus = FocusNode();
  final FocusNode _ageLimitFocus = FocusNode();
  final FocusNode _fightingStyleFocus = FocusNode();
  final FocusNode _deadlineFocus = FocusNode();
  final FocusNode _buttonFocus = FocusNode();

  // State
  File? _thumbnailImage;
  File? _referenceImage;
  DateTime? _selectedEventDate;
  DateTime? _selectedDeadline;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  String? _errorMessage;
  String? _promoterName;
  String? _promoterProfileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPromoterData();
  }

  @override
  void dispose() {
    _eventTitleController.dispose();
    _descriptionController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    _locationController.dispose();
    _eventTypeController.dispose();
    _weightClassController.dispose();
    _requiredRecordController.dispose();
    _ageLimitController.dispose();
    _fightingStyleController.dispose();
    _deadlineController.dispose();

    _eventTitleFocus.dispose();
    _descriptionFocus.dispose();
    _eventDateFocus.dispose();
    _eventTimeFocus.dispose();
    _locationFocus.dispose();
    _eventTypeFocus.dispose();
    _weightClassFocus.dispose();
    _requiredRecordFocus.dispose();
    _ageLimitFocus.dispose();
    _fightingStyleFocus.dispose();
    _deadlineFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  Future<void> _loadPromoterData() async {
    try {
      final userId = Utils.getCurrentUid();
      final userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        if (data['promoterData'] != null) {
          final promoterData = data['promoterData'] as Map<String, dynamic>;
          setState(() {
            _promoterName =
                promoterData['companyName'] ??
                promoterData['name'] ??
                'Unknown Promoter';
            _promoterProfileImage = promoterData['companyLogo'];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _promoterName = 'Unknown Promoter';
        });
      }
    }
  }

  Future<void> _pickThumbnailImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _thumbnailImage = File(image.path);
        });
      }
    } catch (e) {
      Utils.tosatMassage('Failed to pick image: $e');
    }
  }

  Future<void> _pickReferenceImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _referenceImage = File(image.path);
        });
      }
    } catch (e) {
      Utils.tosatMassage('Failed to pick image: $e');
    }
  }

  Future<String?> _uploadImage(File imageFile, String folder) async {
    try {
      final userId = Utils.getCurrentUid();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${folder}_${userId}_$timestamp.jpg';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('events')
          .child(folder)
          .child(fileName);

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Future<void> _selectEventDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.red,
              onPrimary: Colors.white,
              surface: AppColor.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedEventDate = picked;
        _eventDateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.red,
              onPrimary: Colors.white,
              surface: AppColor.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
        _deadlineController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.red,
              onPrimary: Colors.white,
              surface: AppColor.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _eventTimeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedEventDate == null) {
      Utils.tosatMassage('Please select event date');
      return;
    }

    if (_selectedDeadline == null) {
      Utils.tosatMassage('Please select deadline to apply');
      return;
    }

    if (_selectedTime == null) {
      Utils.tosatMassage('Please select event time');
      return;
    }

    if (_thumbnailImage == null) {
      Utils.tosatMassage('Please upload thumbnail image');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = Utils.getCurrentUid();

      // Upload images
      String? thumbnailUrl;
      String? referenceUrl;

      if (_thumbnailImage != null) {
        thumbnailUrl = await _uploadImage(_thumbnailImage!, 'thumbnails');
        if (thumbnailUrl == null) {
          throw Exception('Failed to upload thumbnail image');
        }
      }

      if (_referenceImage != null) {
        referenceUrl = await _uploadImage(_referenceImage!, 'references');
      }

      // Create event
      final event = EventModel(
        id: '', // Will be set by Firestore
        promoterId: userId,
        promoterName: _promoterName ?? 'Unknown Promoter',
        promoterProfileImage: _promoterProfileImage,
        eventTitle: _eventTitleController.text.trim(),
        thumbnailImageUrl: thumbnailUrl,
        referenceImageUrl: referenceUrl,
        description: _descriptionController.text.trim(),
        eventDate: _selectedEventDate!,
        eventTime: _eventTimeController.text.trim(),
        location: _locationController.text.trim(),
        eventType: _eventTypeController.text.trim(),
        weightClass: _weightClassController.text.trim(),
        requiredRecord: _requiredRecordController.text.trim(),
        ageLimit: _ageLimitController.text.trim(),
        fightingStylePreferred: _fightingStyleController.text.trim(),
        deadlineToApply: _selectedDeadline!,
        createdAt: DateTime.now(),
      );

      await _eventService.createEvent(event);

      if (mounted) {
        Utils.tosatMassage('Event created successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create event: $e';
      });
      if (mounted) {
        Utils.tosatMassage('Failed to create event: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/arrow-left-01.svg",
                          color: AppColor.red,
                        ),
                      ),
                      Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: Responsive.textScaleFactor * 24,
                          color: AppColor.white,
                          fontFamily: AppFonts.appFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      margin: EdgeInsets.only(bottom: Responsive.h(2)),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: Responsive.sp(12),
                        ),
                      ),
                    ),

                  // Event Title
                  EditProfileTextfeild(
                    text: 'Event Title',
                    controller: _eventTitleController,
                    focusNode: _eventTitleFocus,
                    nextfocusNode: _descriptionFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocus,
                    maxLines: 4,
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
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.appFont,
                        color: AppColor.white.withValues(alpha: 0.5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Thumbnail Image
                  GestureDetector(
                    onTap: _pickThumbnailImage,
                    child: Container(
                      width: double.infinity,
                      height: Responsive.h(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _thumbnailImage != null
                              ? AppColor.red
                              : AppColor.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        color: AppColor.white.withValues(alpha: 0.05),
                      ),
                      child: _thumbnailImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.file(
                                _thumbnailImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/camera-add-02.svg",
                                  color: AppColor.white.withValues(alpha: 0.7),
                                ),
                                SizedBox(height: Responsive.h(1)),
                                Text(
                                  "Upload Thumbnail Image",
                                  style: TextStyle(
                                    fontFamily: AppFonts.appFont,
                                    color: AppColor.white.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontSize: Responsive.sp(14),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Date
                  GestureDetector(
                    onTap: _selectEventDate,
                    child: AbsorbPointer(
                      child: EditProfileTextfeild(
                        text: 'Event Date',
                        controller: _eventDateController,
                        focusNode: _eventDateFocus,
                        nextfocusNode: _eventTimeFocus,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Time
                  GestureDetector(
                    onTap: _selectTime,
                    child: AbsorbPointer(
                      child: EditProfileTextfeild(
                        text: 'Event Time',
                        controller: _eventTimeController,
                        focusNode: _eventTimeFocus,
                        nextfocusNode: _locationFocus,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Location
                  EditProfileTextfeild(
                    text: 'Location',
                    controller: _locationController,
                    focusNode: _locationFocus,
                    nextfocusNode: _eventTypeFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Event Type
                  EditProfileTextfeild(
                    text: 'Event Type (e.g., Professional | Lightweight)',
                    controller: _eventTypeController,
                    focusNode: _eventTypeFocus,
                    nextfocusNode: _weightClassFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Weight Class
                  EditProfileTextfeild(
                    text: 'Weight Class (e.g., Lightweight 155 lbs)',
                    controller: _weightClassController,
                    focusNode: _weightClassFocus,
                    nextfocusNode: _requiredRecordFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Required Record
                  EditProfileTextfeild(
                    text: 'Required Record (e.g., Min. 2 wins)',
                    controller: _requiredRecordController,
                    focusNode: _requiredRecordFocus,
                    nextfocusNode: _ageLimitFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Age Limit
                  EditProfileTextfeild(
                    text: 'Age Limit (e.g., 18-35)',
                    controller: _ageLimitController,
                    focusNode: _ageLimitFocus,
                    nextfocusNode: _fightingStyleFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Fighting Style Preferred
                  EditProfileTextfeild(
                    text:
                        'Fighting Style Preferred (e.g., MMA / BJJ / Muay Thai)',
                    controller: _fightingStyleController,
                    focusNode: _fightingStyleFocus,
                    nextfocusNode: _deadlineFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Deadline to Apply
                  GestureDetector(
                    onTap: _selectDeadline,
                    child: AbsorbPointer(
                      child: EditProfileTextfeild(
                        text: 'Deadline to Apply',
                        controller: _deadlineController,
                        focusNode: _deadlineFocus,
                        nextfocusNode: _buttonFocus,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(2)),

                  // Reference Image
                  GestureDetector(
                    onTap: _pickReferenceImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _referenceImage != null
                              ? AppColor.red
                              : AppColor.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        color: AppColor.white.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          if (_referenceImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _referenceImage!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            SvgPicture.asset(
                              "assets/icons/camera-add-02.svg",
                              color: AppColor.white.withValues(alpha: 0.7),
                            ),
                          SizedBox(width: Responsive.w(2)),
                          Expanded(
                            child: Text(
                              _referenceImage != null
                                  ? "Reference Image Selected"
                                  : "Upload Reference Image (Optional)",
                              style: TextStyle(
                                fontFamily: AppFonts.appFont,
                                color: _referenceImage != null
                                    ? AppColor.red
                                    : AppColor.white.withValues(alpha: 0.7),
                                fontSize: Responsive.sp(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(3)),

                  // Submit Button
                  Button(
                    text: _isLoading ? "Creating..." : "Create Event",
                    onTap: _isLoading ? () {} : _submitEvent,
                    focusNode: _buttonFocus,
                  ),
                  SizedBox(height: Responsive.h(2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
