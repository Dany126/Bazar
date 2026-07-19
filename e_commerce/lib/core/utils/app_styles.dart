import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Brand colors for the app.
///
/// Naming: {role}{Shade}. Shades follow a light->dark scale where used
/// (50 lightest, 900 darkest), matching common design-token conventions.

/// Text styles for the app.
///
/// Two families are used:
///   - 'Fraunces'  -> headings, prices, hero copy, anything that should
///                    feel characterful
///   - 'WorkSans'  -> body copy, labels, buttons, UI chrome
///
/// Requires the fonts to be registered in pubspec.yaml (see bottom of
/// file for the exact snippet + where to download them).
///
/// Naming: textStyles{Weight}{FontSize}.
class AppStyles {
  // ===========================================================================
  // FRAUNCES — display / characterful
  // ===========================================================================

  /// Use: hero headkDividerColor on splash / onboarding screens.
  static const textStylesBold32 = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.3,
    color: AppColors.kTextColor,
  );

  /// Use: screen titles ("Your Bag", "Checkout", "Profile").
  static const textStylesSemiBold24 = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.kTextColor,
  );

  /// Use: product name on the product detail screen.
  static const textStylesSemiBold20 = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.kTextColor,
  );

  /// Use: section headers on Home ("Just In", "Order History").
  static const textStylesSemiBold18 = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.kTextColor,
  );

  /// Use: price display, large (product detail sticky CTA).
  static const textStylesBold22Mono = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.kPrimaryAccentColorDark,
  );

  /// Use: price display, small (product cards, cart kDividerColor items).
  static const textStylesBold13Mono = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.kPrimaryAccentColorDark,
  );

  // ===========================================================================
  // WORK SANS — body / UI
  // ===========================================================================

  /// Use: button labels (filled + outkDividerColord buttons).
  static const textStylesSemiBold15 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.kMainBackgroundColor,
  );

  /// Use: card titles (product name on grid cards, order item name).
  static const textStylesSemiBold14 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.kTextColor,
  );

  /// Use: body copy — condition reports, descriptions, form values.
  static const textStylesRegular14 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.kTextColor,
  );

  /// Use: card metadata (brand, size, color on product cards).
  static const textStylesRegular12 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondaryTextColor,
  );

  /// Use: form field labels, filter chip text.
  static const textStylesMedium11 = TextStyle(
    fontFamily: 'WorkSans',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: AppColors.kSecondaryTextColor,
  );

  // ===========================================================================
  // SPACE MONO — utility (prices, order numbers, SKUs)
  // ===========================================================================

  /// Use: order numbers, tracking codes, tag prices on product photos.
  static const textStylesBold12Mono = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.kTextColor,
  );

  /// Use: timestamps, order dates, fine print in mono.
  static const textStylesRegular11Mono = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.kSecondaryTextColor,
  );
}

/// Spacing scale — use instead of hardcoding padding/margin numbers.
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

/// Corner radius scale — matches the rounded, soft-edged mockup style.
class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const pill = 999.0;
}

/// App-wide ThemeData, built from the tokens above.
/// Drop this straight into MaterialApp(theme: AppTheme.light).
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

// =============================================================================
// pubspec.yaml setup (required — const TextStyle can't use google_fonts,
// since those functions aren't const):
//
// flutter:
//   fonts:
//     - family: Fraunces
//       fonts:
//         - asset: assets/fonts/Fraunces-Medium.ttf
//           weight: 500
//         - asset: assets/fonts/Fraunces-SemiBold.ttf
//           weight: 600
//         - asset: assets/fonts/Fraunces-Bold.ttf
//           weight: 700
//     - family: WorkSans
//       fonts:
//         - asset: assets/fonts/WorkSans-Regular.ttf
//         - asset: assets/fonts/WorkSans-Medium.ttf
//           weight: 500
//         - asset: assets/fonts/WorkSans-SemiBold.ttf
//           weight: 600
//     - family: SpaceMono
//       fonts:
//         - asset: assets/fonts/SpaceMono-Regular.ttf
//         - asset: assets/fonts/SpaceMono-Bold.ttf
//           weight: 700
//
// Download all three families free from Google Fonts:
//   https://fonts.google.com/specimen/Fraunces
//   https://fonts.google.com/specimen/Work+Sans
//   https://fonts.google.com/specimen/Space+Mono
// =============================================================================
