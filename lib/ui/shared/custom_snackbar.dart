import 'package:flutter/material.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class CustomSnackbar {
  // ✅ SnackBar Success (Hijau)
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.green);
  }

  // ✅ SnackBar Error (Merah)
  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red);
  }

  // private function
  static void _showSnackBar(
    BuildContext context,
    String message,
    Color bgColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppFonts.medium.copyWith(color: Colors.white, fontSize: 12),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
