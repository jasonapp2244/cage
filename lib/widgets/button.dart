import 'package:cage/res/components/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool enabled;
  final FocusNode? focusNode;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Focus(
          focusNode: focusNode,
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;

              return GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: AppColor.red,
                    border: Border.all(
                      color: isFocused ? AppColor.white : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        text,
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}








// import 'package:cage/res/components/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Button extends StatefulWidget {
//   final String text;
//   final VoidCallback onTap;
//   final bool enabled;
//   final FocusNode? focusNode;

//   const Button({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.enabled = true,
//     this.focusNode,
//   });

//   @override
//   State<Button> createState() => _ButtonState();
// }

// class _ButtonState extends State<Button> {
//   late FocusNode _internalFocusNode;
//   bool _isFocused = false;

//   FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     _internalFocusNode = FocusNode();
//     _focusNode.addListener(_handleFocusChange);
//   }

//   void _handleFocusChange() {
//     setState(() {
//       _isFocused = _focusNode.hasFocus;
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.removeListener(_handleFocusChange);
//     if (widget.focusNode == null) {
//       _focusNode.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AbsorbPointer(
//       absorbing: !widget.enabled,
//       child: Opacity(
//         opacity: widget.enabled ? 1.0 : 0.5,
//         child: Focus(
//           focusNode: _focusNode,
//           child: GestureDetector(
//             onTap: widget.onTap,
//             child: AnimatedScale(
//               scale: _isFocused ? 1.05 : 1.0,
//               duration: const Duration(milliseconds: 120),
//               curve: Curves.easeOut,
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(22),
//                   color: AppColor.red,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                   child: Center(
//                     child: Text(
//                       widget.text,
//                       style: GoogleFonts.dmSans(
//                         fontSize: 18,
//                         color: AppColor.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







// import 'package:cage/res/components/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Button extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//   final bool enabled;
//   final FocusNode? focusNode;

//   const Button({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.enabled = true,
//     this.focusNode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AbsorbPointer(
//       absorbing: !enabled,
//       child: Opacity(
//         opacity: enabled ? 1.0 : 0.5,
//         child: Focus(
//           focusNode: focusNode,
//           child: GestureDetector(
//             onTap: onTap,
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(22),
//                 color: AppColor.red,
//               ),
              
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0),
//                 child: Center(
//                   child: Text(
//                     text,
//                     style: GoogleFonts.dmSans(
//                       fontSize: 18,
//                       color: AppColor.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cage/res/components/app_color.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class Button extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//   final bool enabled;
//   const Button({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AbsorbPointer(
//       absorbing: !enabled,
//       child: Opacity(
//         opacity: enabled ? 1.0 : 0.5,
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(22),
//               color: AppColor.red,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12.0),
//               child: Center(
//                 child: Text(
//                   text,
//                   style: GoogleFonts.dmSans(
//                     fontSize: 18,
//                     color: AppColor.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
