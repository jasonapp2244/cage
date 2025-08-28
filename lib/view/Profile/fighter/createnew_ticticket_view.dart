import 'package:cage/fonts/fonts.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/widgets/button.dart';
import 'package:cage/widgets/edit_profile_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:provider/provider.dart';
import 'package:cage/provider/ticket_provider.dart';

class CreatenewTicticketView extends StatefulWidget {
  CreatenewTicticketView({super.key});

  @override
  State<CreatenewTicticketView> createState() => _CreatenewTicticketViewState();
}

class _CreatenewTicticketViewState extends State<CreatenewTicticketView> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();
  final FocusNode subjectFoucs = FocusNode();
  final FocusNode messageFoucs = FocusNode();
  final FocusNode buttonFoucs = FocusNode();

  @override
  void dispose() {
    subjectController.dispose();
    MessageController.dispose();
    subjectFoucs.dispose();
    messageFoucs.dispose();
    buttonFoucs.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final success = await context.read<TicketProvider>().createTicketWithValidation(
      subjectController.text,
      MessageController.text,
      attachmentUrl: '',
    );

    if (success) {
      Navigator.pop(context);
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.white.withValues(alpha: 0.1),
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
                      Text(
                        "Upload file or take photo",
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          color: AppColor.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        "assets/icons/camera-add-02.svg",
                        color: AppColor.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),

              Spacer(),

              Button(
                text: ticketProvider.isSubmitting ? "Submitting..." : "Submit",
                onTap: ticketProvider.isSubmitting ? () {} : () => _submitTicket(),
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
