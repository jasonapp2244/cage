import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cage/provider/ticket_provider.dart';

class CreatenewTicticketView extends StatefulWidget {
  const CreatenewTicticketView({super.key});

  @override
  State<CreatenewTicticketView> createState() => _CreatenewTicticketViewState();
}

class _CreatenewTicticketViewState extends State<CreatenewTicticketView> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();
  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedFile;
  bool _isUploading = false;
  String? _attachmentUrl;

  @override
  void dispose() {
    subjectController.dispose();
    MessageController.dispose();
    subjectFoucs.dispose();
    messageFoucs.dispose();
    buttonFoucs.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() {
          _selectedFile = File(file.path);
          _attachmentUrl = null;
        });
      }
    } catch (e) {
      Utils.tosatMassage('Failed to pick file: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() {
          _selectedFile = File(file.path);
          _attachmentUrl = null;
        });
      }
    } catch (e) {
      Utils.tosatMassage('Failed to take photo: $e');
    }
  }

  Future<String?> _uploadFile() async {
    if (_selectedFile == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final userId = Utils.getCurrentUid();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'ticket_${userId}_$timestamp.jpg';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('supportTickets')
          .child(fileName);

      final uploadTask = storageRef.putFile(_selectedFile!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _attachmentUrl = downloadUrl;
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      Utils.tosatMassage('Failed to upload file: $e');
      return null;
    }
  }

  Future<void> _submitTicket() async {
    String? attachmentUrl = _attachmentUrl;

    // Upload file if selected but not yet uploaded
    if (_selectedFile != null && attachmentUrl == null) {
      attachmentUrl = await _uploadFile();
      if (attachmentUrl == null) {
        Utils.tosatMassage('Failed to upload attachment. Please try again.');
        return;
      }
    }

    final success = await context.read<TicketProvider>().createTicketWithValidation(
      subjectController.text,
      MessageController.text,
      attachmentUrl: attachmentUrl,
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  Future<void> _showFileOptions() async {
    final option = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColor.black,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColor.white),
              title: Text('Choose from Gallery', style: TextStyle(color: AppColor.white)),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColor.white),
              title: Text('Take Photo', style: TextStyle(color: AppColor.white)),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            if (_selectedFile != null)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Remove Attachment', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context, 'remove');
                },
              ),
          ],
        ),
      ),
    );

    if (option == 'gallery') {
      await _pickFile();
    } else if (option == 'camera') {
      await _takePhoto();
    } else if (option == 'remove') {
      setState(() {
        _selectedFile = null;
        _attachmentUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Consumer<TicketProvider>(
      builder: (context, ticketProvider, child) {
        return Scaffold(
          backgroundColor: AppColor.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                        "Create New Ticket",
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

                  // Error message display
                  if (ticketProvider.error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ticketProvider.error!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontFamily: AppFonts.appFont,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => ticketProvider.clearError(),
                            child: Icon(Icons.close, color: Colors.red, size: 20),
                          ),
                        ],
                      ),
                    ),

                  EditProfileTextfeild(
                    text: 'Subject...',
                    controller: subjectController,
                    focusNode: subjectFoucs,
                    nextfocusNode: messageFoucs,
                  ),

                  SizedBox(height: Responsive.h(2)),

                  TextFormField(
                    maxLines: 5,
                    controller: MessageController,
                    focusNode: messageFoucs,
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
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.black),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      hint: Text(
                        "Message",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      Utils.fieldFoucsChange(context, messageFoucs, buttonFoucs);
                    },
                  ),

                  SizedBox(height: Responsive.h(2)),

                  // Upload file or take photo button
                  GestureDetector(
                    onTap: _showFileOptions,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedFile != null 
                              ? AppColor.red 
                              : AppColor.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        color: AppColor.white.withValues(alpha: 0.05),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            if (_isUploading)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.red,
                                ),
                              )
                            else if (_selectedFile != null)
                              Icon(
                                Icons.check_circle,
                                color: AppColor.red,
                                size: 20,
                              )
                            else
                              SvgPicture.asset(
                                "assets/icons/camera-add-02.svg",
                                color: AppColor.white.withValues(alpha: 0.7),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _isUploading
                                    ? "Uploading..."
                                    : _selectedFile != null
                                        ? "File selected (tap to change)"
                                        : "Upload file or take photo",
                                style: TextStyle(
                                  fontFamily: AppFonts.appFont,
                                  color: _selectedFile != null
                                      ? AppColor.red
                                      : AppColor.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  Button(
                    text: (ticketProvider.isSubmitting || _isUploading)
                        ? "Submitting..."
                        : "Submit",
                    onTap: (ticketProvider.isSubmitting || _isUploading)
                        ? () {}
                        : () => _submitTicket(),
                    focusNode: buttonFoucs,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
