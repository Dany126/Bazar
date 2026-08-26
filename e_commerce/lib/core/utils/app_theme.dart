import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_radius.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ------------------------------------------------------------
      // APP COLORS
      // ------------------------------------------------------------
      scaffoldBackgroundColor: AppColors.kMainBackgroundColor,
      primaryColor: AppColors.kPrimaryAccentColor,

      colorScheme: ColorScheme.light(
        primary: AppColors.kPrimaryAccentColor,
        onPrimary: Colors.white,
        secondary: AppColors.kPrimaryAccentColor,
        onSecondary: Colors.white,
        surface: AppColors.kCardBackgroundColor,
        onSurface: AppColors.kTextColor,
        error: AppColors.kErrorColor,
        onError: Colors.white,
      ),

      // ------------------------------------------------------------
      // FONT
      // ------------------------------------------------------------
      fontFamily: 'Gabarito',

      // ------------------------------------------------------------
      // TEXT THEME
      // ------------------------------------------------------------
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.15,
          letterSpacing: -0.5,
          color: AppColors.kTextColor,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 26,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.3,
          color: AppColors.kTextColor,
        ),

        headlineSmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: AppColors.kTextColor,
        ),

        titleLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.25,
          color: AppColors.kTextColor,
        ),

        titleMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.kTextColor,
        ),

        titleSmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.3,
          color: AppColors.kTextColor,
        ),

        bodyLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: AppColors.kTextColor,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.45,
          color: AppColors.kSecondaryTextColor,
        ),

        bodySmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: AppColors.kSecondaryTextColor,
        ),

        labelLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: Colors.white,
        ),

        labelMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.kTextColor,
        ),

        labelSmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.kSecondaryTextColor,
        ),
      ),

      // ------------------------------------------------------------
      // ELEVATED BUTTON
      // ------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,

          backgroundColor: AppColors.kTextColor,
          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 54),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ------------------------------------------------------------
      // OUTLINED BUTTON
      // ------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,

          foregroundColor: AppColors.kTextColor,

          minimumSize: const Size(double.infinity, 54),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),

          side: const BorderSide(color: AppColors.kDividerColor, width: 1),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),

          textStyle: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ------------------------------------------------------------
      // TEXT BUTTON
      // ------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.kTextColor,

          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

          textStyle: const TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ------------------------------------------------------------
      // INPUT FIELDS
      // ------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kCardBackgroundColor,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kSecondaryTextColor,
        ),

        labelStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.kSecondaryTextColor,
        ),

        floatingLabelStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.kPrimaryAccentColor,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.kPrimaryAccentColor,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.kErrorColor, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: AppColors.kErrorColor,
            width: 1.5,
          ),
        ),
      ),

      // ------------------------------------------------------------
      // CARD
      // ------------------------------------------------------------
      cardTheme: CardThemeData(
        color: AppColors.kCardBackgroundColor,
        elevation: 0,

        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kMainBackgroundColor,
        foregroundColor: AppColors.kTextColor,

        elevation: 0,
        scrolledUnderElevation: 0,

        centerTitle: false,

        titleTextStyle: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextColor,
        ),

        iconTheme: IconThemeData(color: AppColors.kTextColor, size: 22),
      ),

      // ------------------------------------------------------------
      // DIVIDER
      // ------------------------------------------------------------
      dividerTheme: const DividerThemeData(
        color: AppColors.kDividerColor,
        thickness: 1,
        space: 1,
      ),

      // ------------------------------------------------------------
      // ICONS
      // ------------------------------------------------------------
      iconTheme: const IconThemeData(color: AppColors.kTextColor, size: 22),

      // ------------------------------------------------------------
      // CHECKBOX
      // ------------------------------------------------------------
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        side: const BorderSide(color: AppColors.kDividerColor),

        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.kPrimaryAccentColor;
          }

          return Colors.transparent;
        }),
      ),

      // ------------------------------------------------------------
      // PROGRESS INDICATOR
      // ------------------------------------------------------------
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.kPrimaryAccentColor,
      ),

      // ------------------------------------------------------------
      // SNACKBAR
      // ------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,

        backgroundColor: AppColors.kTextColor,

        contentTextStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          color: Colors.white,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  // ================================================================
  // DARK THEME
  // ================================================================

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: const Color(0xFF17151C),

      primaryColor: AppColors.kPrimaryAccentColorDark,

      colorScheme: ColorScheme.dark(
        primary: AppColors.kPrimaryAccentColorDark,
        onPrimary: Colors.white,
        secondary: AppColors.kPrimaryAccentColorDark,
        onSecondary: Colors.white,
        surface: const Color(0xFF211E28),
        onSurface: Colors.white,
        error: AppColors.kErrorColor,
        onError: Colors.white,
      ),

      fontFamily: 'Gabarito',

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.15,
          color: Colors.white,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        headlineSmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        titleLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        titleMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        titleSmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),

        bodyLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          height: 1.5,
          color: Colors.white,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 13,
          height: 1.45,
          color: Colors.white70,
        ),

        bodySmall: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 11,
          color: Colors.white60,
        ),

        labelLarge: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        labelMedium: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.kPrimaryAccentColorDark,
          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 54),

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,

          minimumSize: const Size(double.infinity, 54),

          side: const BorderSide(color: Color(0xFF3A3542)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF211E28),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          color: Colors.white54,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.kPrimaryAccentColorDark,
            width: 1.5,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF211E28),
        elevation: 0,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF17151C),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        titleTextStyle: TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        iconTheme: IconThemeData(color: Colors.white, size: 22),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3542),
        thickness: 1,
      ),

      iconTheme: const IconThemeData(color: Colors.white, size: 22),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.kPrimaryAccentColorDark,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF211E28),

        contentTextStyle: const TextStyle(
          fontFamily: 'Gabarito',
          fontSize: 14,
          color: Colors.white,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
