import 'package:flutter/material.dart';

class AppColors {
  // Web Owner primary amber-orange palette
  static const Color primary = Color(0xFFFF9F43);
  static const Color primaryDark = Color(0xFFD97706);
  static const Color primaryDeep = Color(0xFFB45309);
  static const Color primaryLight = Color(0xFFFFF7ED);
  static const Color primarySurface = Color(0xFFFFF2E2);

  // Radiant Web Owner Primary Gradient (Warm, vibrant, fresh — NO dark brown)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF9F43), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Alias amberGradient to primaryGradient for 100% unified consistent gradient everywhere
  static const LinearGradient amberGradient = primaryGradient;

  // Modern Slate & Neutrals
  static const Color dark = Color(0xFF0F172A);
  static const Color slate = Color(0xFF334155);
  static const Color slateLight = Color(0xFF64748B);
  static const Color slateMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);

  // Tailwind/Modern Slate Palette
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Feedback colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Existing colors preserved for full backward compatibility
  static const Color background = Color(0xFFF8FAFC);
  static const Color gray = Color(0xFFCBD5E1);
  static const Color black = Color(0xFF0F172A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFEF4444);
  static const Color orange = Color(0xFFFF9F43);
  static const Color green = Color(0xFF10B981);
  static const Color blue = Color(0xFF3B82F6);
}
