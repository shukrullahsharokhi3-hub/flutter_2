import 'package:flutter/material.dart';

/// Shared colors for the GFMS interface.
/// Keeping these values here lets screens and the app theme stay consistent.
class AppColors {
  AppColors._();

  static const Color darkPurple = Color(0xFF8959B5);
  static const Color navy = darkPurple;
  static const Color white = Colors.white;
  static const Color background = white;
  static const Color mutedText = Color(0xFF666666);

  // Purple carries the GFMS brand; the softer tint supports navigation surfaces.
  static const Color primaryPurple = darkPurple;
  static const Color lightPurple = Color(0xFFEAE2F5);
  // Blue is reserved for a small number of informational highlights.
  static const Color lightBlue = Color(0xFFB8D5F0);
  static const Color pageBackground = white;
  static const Color cardBackground = white;
  static const Color mainText = Color(0xFF1F1F1F);
  static const Color secondaryText = Color(0xFF666666);
  // A quiet neutral outline keeps white cards distinct without adding color noise.
  static const Color border = Color(0xFFE5E1E8);

  // Semantic colors stay distinct from the approved brand palette.
  static const Color success = Color(0xFF27724A);
  static const Color successBackground = Color(0xFFE5F4EB);
  static const Color warning = Color(0xFF946200);
  static const Color warningBackground = Color(0xFFFFF3D7);
  static const Color error = Color(0xFFB3261E);
  static const Color inactiveBackground = Color(0xFFF0F0F4);
}
