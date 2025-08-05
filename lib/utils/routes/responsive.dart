import 'package:flutter/widgets.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  
  // For font scaling
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  
  // Text scaling factor
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    
    textScaleFactor = _mediaQueryData.textScaleFactor;
    
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
  
  // Width in percentage
  static double w(double percent) {
    return screenWidth * (percent / 100);
  }
  
  // Height in percentage
  static double h(double percent) {
    return screenHeight * (percent / 100);
  }
  
  // Font size - scales with screen width and considers text scaling
  static double sp(double size) {
    return (size * (screenWidth / 3)) / 100;
  }
  
  // Padding/margin in width percentage
  static double wp(double percent) {
    return screenWidth * (percent / 100);
  }
  
  // Padding/margin in height percentage
  static double hp(double percent) {
    return screenHeight * (percent / 100);
  }
  
  // Get responsive padding
  static EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.fromLTRB(
      wp(left),
      hp(top),
      wp(right),
      hp(bottom),
    );
  }
  
  // Get responsive margin
  static EdgeInsets margin({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.fromLTRB(
      wp(left),
      hp(top),
      wp(right),
      hp(bottom),
    );
  }
  
  // Responsive sized box height
  static SizedBox height(double percent) {
    return SizedBox(height: h(percent));
  }
  
  // Responsive sized box width
  static SizedBox width(double percent) {
    return SizedBox(width: w(percent));
  }
}