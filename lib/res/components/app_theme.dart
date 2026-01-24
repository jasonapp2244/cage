import 'package:flutter/material.dart';
import 'package:cage/models/app_theme_model.dart';
import 'package:cage/services/theme_settings_service.dart';

class AppTheme {
  static final ThemeSettingsService _themeService = ThemeSettingsService();
  
  // Default theme (fallback)
  static AppThemeModel _theme = AppThemeModel.getDefault();

  // Getters for theme properties
  static AppThemeModel get theme => _theme;
  static double get fontSize => _theme.fontSize;
  static double get headingFontSize => _theme.headingFontSize;
  static Color get textColor => _theme.textColor;
  static Color get headingTextColor => _theme.headingTextColor;
  static bool get boldText => _theme.boldText;
  static bool get headingBold => _theme.headingBold;
  static TextAlign get textAlign => _theme.textAlign;
  static TextAlign get headingAlign => _theme.headingAlign;
  static Color get primaryColor => _theme.primaryColor;
  static Color get backgroundColor => _theme.backgroundColor;

  // Initialize theme from Firestore
  static Future<void> initialize() async {
    try {
      final settings = await _themeService.getThemeSettings();
      _theme = AppThemeModel.fromMap(settings);
    } catch (e) {
      print('Error initializing app theme: $e');
      // Keep default theme on error
    }
  }

  // Stream for reactive theme updates
  static Stream<AppThemeModel> get themeStream {
    return _themeService.streamThemeSettings().map((settings) {
      _theme = AppThemeModel.fromMap(settings);
      return _theme;
    });
  }

  // Update theme (for reactive updates)
  static void updateTheme(AppThemeModel newTheme) {
    _theme = newTheme;
  }

  // Helper methods for text styles
  static TextStyle textStyle({double? fontSize, Color? color, bool? bold}) {
    return _theme.getTextStyle(fontSize: fontSize, color: color, bold: bold);
  }

  static TextStyle headingStyle({double? fontSize, Color? color, bool? bold}) {
    return _theme.getHeadingStyle(fontSize: fontSize, color: color, bold: bold);
  }
}
