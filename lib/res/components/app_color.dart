import 'package:flutter/material.dart';
import 'package:cage/services/app_colors_service.dart';

class AppColor {
  static final AppColorsService _colorsService = AppColorsService();

  // Default colors (fallback) - these are const for use in const contexts
  static const Color defaultBlack = Color(0xFF060606);
  static const Color defaultRed = Color(0xFFED1C24);
  static const Color defaultWhite = Color(0xFFFFFFFF);

  // Current colors (will be updated from Firestore)
  static Color _black = defaultBlack;
  static Color _red = defaultRed;
  static Color _white = defaultWhite;

  // Getters for colors (non-const, dynamic from Firestore)
  static Color get black => _black;
  static Color get red => _red;
  static Color get white => _white;

  // Const values for use in const contexts (uses defaults)
  // Note: These use default colors in const contexts, but runtime will use Firestore values
  static const Color constBlack = defaultBlack;
  static const Color constRed = defaultRed;
  static const Color constWhite = defaultWhite;

  // Initialize colors from Firestore
  static Future<void> initialize() async {
    try {
      final colors = await _colorsService.getAppColors();
      _black = Color(colors['black']!);
      _red = Color(colors['red']!);
      _white = Color(colors['white']!);
    } catch (e) {
      print('Error initializing app colors: $e');
      // Keep default colors on error
    }
  }

  // Stream for reactive color updates
  static Stream<Map<String, Color>> get colorStream {
    return _colorsService.streamAppColors().map((colorMap) {
      _black = Color(colorMap['black']!);
      _red = Color(colorMap['red']!);
      _white = Color(colorMap['white']!);
      return {'black': _black, 'red': _red, 'white': _white};
    });
  }

  // Update colors (for reactive updates)
  static void updateColors({
    required Color black,
    required Color red,
    required Color white,
  }) {
    _black = black;
    _red = red;
    _white = white;
  }
}
