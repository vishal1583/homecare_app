import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFFF6F7F4);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF176B57);
  static const primaryDark = Color(0xFF103F35);
  static const primarySoft = Color(0xFFE7F1EB);
  static const ink = Color(0xFF182C26);
  static const muted = Color(0xFF64756D);
  static const border = Color(0xFFDCE5DE);
  static const accent = Color(0xFFC56845);
  static const accentSoft = Color(0xFFFAEDE5);
  static const error = Color(0xFFB74444);
}

// Compatibility names for the existing screens.
const Color vanillaShade = AppColors.surface;
const Color vanilla = AppColors.background;
const Color softBlue = AppColors.primary;
const Color lightBlueAccent = AppColors.border;
const Color darkBlue = AppColors.primaryDark;
const Color accentOrange = AppColors.primary;
const Color cream = AppColors.primarySoft;
