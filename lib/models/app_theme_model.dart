import 'package:flutter/material.dart';

class AppThemeModel {
  final double fontSize;
  final double headingFontSize;
  final Color textColor;
  final Color headingTextColor;
  final bool boldText;
  final bool headingBold;
  final TextAlign textAlign;
  final TextAlign headingAlign;
  final Color primaryColor;
  final Color backgroundColor;

  AppThemeModel({
    required this.fontSize,
    required this.headingFontSize,
    required this.textColor,
    required this.headingTextColor,
    required this.boldText,
    required this.headingBold,
    required this.textAlign,
    required this.headingAlign,
    required this.primaryColor,
    required this.backgroundColor,
  });

  factory AppThemeModel.fromMap(Map<String, dynamic> map) {
    return AppThemeModel(
      fontSize: (map['fontSize'] ?? 14.0).toDouble(),
      headingFontSize: (map['headingFontSize'] ?? 24.0).toDouble(),
      textColor: Color(map['textColor'] ?? 0xFFFFFFFF),
      headingTextColor: Color(map['headingTextColor'] ?? 0xFFFFFFFF),
      boldText: map['boldText'] ?? false,
      headingBold: map['headingBold'] ?? true,
      textAlign: _parseTextAlign(map['textAlign'] ?? 'left'),
      headingAlign: _parseTextAlign(map['headingAlign'] ?? 'left'),
      primaryColor: Color(map['primaryColor'] ?? 0xFFED1C24),
      backgroundColor: Color(map['backgroundColor'] ?? 0xFF060606),
    );
  }

  static TextAlign _parseTextAlign(String align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  // Helper methods for creating text styles
  TextStyle getTextStyle({double? fontSize, Color? color, bool? bold}) {
    return TextStyle(
      fontSize: fontSize ?? this.fontSize,
      color: color ?? textColor,
      fontWeight: (bold ?? boldText) ? FontWeight.bold : FontWeight.normal,
    );
  }

  TextStyle getHeadingStyle({double? fontSize, Color? color, bool? bold}) {
    return TextStyle(
      fontSize: fontSize ?? headingFontSize,
      color: color ?? headingTextColor,
      fontWeight: (bold ?? headingBold) ? FontWeight.bold : FontWeight.normal,
    );
  }

  // Default theme
  static AppThemeModel getDefault() {
    return AppThemeModel(
      fontSize: 14.0,
      headingFontSize: 24.0,
      textColor: const Color(0xFFFFFFFF),
      headingTextColor: const Color(0xFFFFFFFF),
      boldText: false,
      headingBold: true,
      textAlign: TextAlign.left,
      headingAlign: TextAlign.left,
      primaryColor: const Color(0xFFED1C24),
      backgroundColor: const Color(0xFF060606),
    );
  }
}
