import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_colors.dart';

class AppFonts {
  static const String _family = 'Poppins';

  static TextStyle _textStyle({
    required FontWeight fontWeight,
    Color color = AppColors.black,
    double fontSize = 14.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _family,
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize,
      height: height,
    );
  }

  static TextStyle get light => _textStyle(fontWeight: FontWeight.w300);
  static TextStyle get regular => _textStyle(fontWeight: FontWeight.w400);
  static TextStyle get medium => _textStyle(fontWeight: FontWeight.w500);
  static TextStyle get semiBold => _textStyle(fontWeight: FontWeight.w600);
  static TextStyle get bold => _textStyle(fontWeight: FontWeight.w700);
}