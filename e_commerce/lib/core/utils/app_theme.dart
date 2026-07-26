import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_radius.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.kMainBackgroundColor,
      primaryColor: AppColors.kPrimaryAccentColor,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kPrimaryAccentColor,
        primary: AppColors.kPrimaryAccentColor,
        surface: AppColors.kCardBackgroundColor,
        error: AppColors.kErrorColor,
      ),

      fontFamily: 'Gabarito',

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.3,
          color: AppColors.kTextColor,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: AppColors.kTextColor,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.kTextColor,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.kTextColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.kTextColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.kSecondaryTextColor,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: AppColors.kMainBackgroundColor,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kTextColor,
          foregroundColor: AppColors.kMainBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kTextColor,
          side: const BorderSide(color: AppColors.kTextColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kCardBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.kDividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.kDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryAccentColor,
            width: 2,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.kCardBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.kDividerColor, width: 1),
        ),
      ),
    );
  }
}
