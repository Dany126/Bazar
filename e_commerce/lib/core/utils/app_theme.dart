import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_radius.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
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
      fontFamily: 'WorkSans',
      textTheme: const TextTheme(
        headlineLarge: AppStyles.textStylesBold32,
        headlineMedium: AppStyles.textStylesSemiBold24,
        titleLarge: AppStyles.textStylesSemiBold20,
        titleMedium: AppStyles.textStylesSemiBold18,
        bodyLarge: AppStyles.textStylesRegular14,
        bodyMedium: AppStyles.textStylesRegular12,
        labelLarge: AppStyles.textStylesSemiBold15,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kTextColor,
          foregroundColor: AppColors.kMainBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppStyles.textStylesSemiBold15,
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
