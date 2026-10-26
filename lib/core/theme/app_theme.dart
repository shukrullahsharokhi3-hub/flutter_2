import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Selects the whole app palette from the active locale.
  static ThemeData forLocale(Locale locale) => _buildTheme(
        dari: locale.languageCode == 'fa',
      );

  static ThemeData _buildTheme({required bool dari}) {
    final primaryColor = dari ? const Color(0xFF286D94) : AppColors.darkPurple;
    final buttonColor = dari ? const Color(0xFF91CBE6) : primaryColor;
    final buttonTextColor =
        dari ? const Color(0xFF173B50) : AppColors.white;
    final secondaryColor =
        dari ? const Color(0xFF4B91B7) : AppColors.primaryPurple;
    final accentSurface =
        dari ? const Color(0xFFDDEFF7) : AppColors.lightPurple;
    final secondarySurface =
        dari ? const Color(0xFFEAF6FB) : AppColors.lightPurple;
    final lightAccent = dari ? const Color(0xFFD4ECF7) : AppColors.lightBlue;
    final defaultTextTheme = ThemeData.light().textTheme;
    // Start from Flutter's supported typography and override only its colors.
    final neutralTextTheme = defaultTextTheme.apply(
      bodyColor: AppColors.mainText,
      displayColor: AppColors.mainText,
    );
    // The selected locale chooses the accent family; both palettes keep white
    // surfaces and readable dark text, while Dari uses light-blue controls.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: primaryColor,
      onPrimary: AppColors.white,
      primaryContainer: accentSurface,
      onPrimaryContainer: AppColors.mainText,
      secondary: secondaryColor,
      onSecondary: AppColors.white,
      secondaryContainer: secondarySurface,
      onSecondaryContainer: AppColors.mainText,
      tertiary: lightAccent,
      tertiaryContainer: lightAccent,
      onTertiaryContainer: AppColors.mainText,
      surface: AppColors.white,
      onSurface: AppColors.mainText,
      error: AppColors.error,
      onError: AppColors.white,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.pageBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.mainText,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.secondaryText,
          elevation: 0,
        ),
      ),
      // Text buttons and focused fields use the stronger palette accent.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      // ThemeData owns text selection and cursor colors in this Flutter SDK.
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        labelStyle: const TextStyle(color: AppColors.secondaryText),
        prefixIconColor: primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      textTheme: neutralTextTheme.copyWith(
        headlineSmall: neutralTextTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        titleLarge: neutralTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodySmall: neutralTextTheme.bodySmall?.copyWith(
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
