import 'package:flutter/material.dart';

class AppColors {
  // ============================================================
  // Core Clinical Palette
  // ============================================================

  static const Color backgroundLight = Color(0xFFF2F7F9);
  static const Color surface = Color(0xFFE7F1F5);
  static const Color white = Colors.white;

  static const Color primary = Color(0xFF124E63);
  static const Color primaryDark = Color(0xFF0E3E4F); // Added depth
  static const Color accent = Color(0xFF2CBECF);

  static const Color textPrimary = Color(0xFF1C2B33);
  static const Color textSecondary = Color(0xFF5B6B73);

  static const Color success = Color(0xFF2E7D5B);
  static const Color warning = Color(0xFFB07A2A);
  static const Color danger = Color(0xFF9C3D3D);

  // ============================================================
  // Auth Gradient
  // ============================================================

  static const LinearGradient authGradient = LinearGradient(
    colors: [primaryDark, primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
