import 'package:flutter/material.dart';

/// Text styles pulled from the Shoppe Figma file.
///
/// Two families are used:
///   - 'Raleway'    -> headings, titles, buttons, emphasis/accent text
///   - 'NunitoSans' -> body copy, descriptions, small labels
///
/// Requires the fonts to be registered in pubspec.yaml (see bottom of file
/// for the exact snippet + where to download them).
///
/// Naming: textStyles{Weight}{FontSize}. Where two styles share the same
/// weight+size but differ in family/details, the second is suffixed `_2`
/// (matches the pattern already used in your file, e.g. SemiBold13_2).
class AppStyles {
  // ===========================================================================
  // RALEWAY
  // ===========================================================================

  /// sample: "Login" (splash/auth) · count: 2
  static const textStylesBold52 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 52,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.52,
  );

  /// sample: "About Shoppe" · count: 54
  static const textStylesBold28 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29, // 36/28
    letterSpacing: -0.28,
  );

  /// sample: "$17,00" (price display) · count: 4
  static const textStylesExtraBold26 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.19, // 31/26
    letterSpacing: -0.26,
  );

  /// sample: "Recently viewed" (section header) · count: 85
  static const textStylesBold21 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 21,
    fontWeight: FontWeight.w700,
    height: 1.43, // 30/21
    letterSpacing: -0.21,
  );

  /// sample: "Slarda" · count: 32
  static const textStylesExtraBold20 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  /// sample: "Vietnam" (accent color) · count: 18
  static const textStylesBold20 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: Color(0xFF004CFF),
  );

  /// sample: "Voucher" (accent color) · count: 88
  static const textStylesBold18 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.28, // 23/18
    letterSpacing: -0.18,
    color: Color(0xFF004CFF),
  );

  /// sample: "hello@mydomain.com" · count: 158
  static const textStylesBold17 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.24, // 21/17
    letterSpacing: -0.17,
  );

  /// sample: "209" · count: 20
  static const textStylesMedium17 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.24, // 21/17
    letterSpacing: -0.17,
  );

  /// sample: "Attempt to deliver your parcel" (accent color) · count: 24
  static const textStylesBold16 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25, // 20/16
    letterSpacing: -0.16,
    color: Color(0xFF0042E0),
  );

  /// sample: "Sizes" · count: 117
  static const textStylesMedium16 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.25, // 20/16
    letterSpacing: -0.16,
  );

  /// sample: "10+ Orders" · count: 94
  static const textStylesBold15 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.27, // 19/15
    letterSpacing: -0.15,
  );

  /// sample: "Order #92287157" · count: 102
  static const textStylesBold14 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.29, // 18/14
    letterSpacing: -0.14,
  );

  /// sample: "Collected" (white) · count: 117
  static const textStylesMedium14 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.29, // 18/14
    letterSpacing: -0.14,
    color: Colors.white,
  );

  /// sample: "Ordered" · count: 76
  static const textStylesBold13 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.31, // 17/13
    letterSpacing: -0.13,
  );

  /// sample: "3 items" · count: 132
  static const textStylesMedium13 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.31, // 17/13
    letterSpacing: -0.13,
  );

  /// sample: masked card number · count: 18
  static const textStylesBold12 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33, // 16/12
    letterSpacing: -0.12,
  );

  /// sample: "Valid Until 6.20.20" · count: 14
  static const textStylesMedium11 = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.36, // 15/11
    letterSpacing: -0.11,
  );

  // ===========================================================================
  // NUNITO SANS
  // ===========================================================================

  /// sample: "Version 1.0 April, 2020" · count: 224 (most-used style overall)
  static const textStylesRegular12 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.67, // 20/12
  );

  /// sample: "If you need help or you have a..." · count: 51
  static const textStylesLight16 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.69, // 27/16
  );

  /// sample: "You won't be able to restore y..." · count: 26
  static const textStylesSemiBold13 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.54, // 20/13
  );

  /// sample: "Version 1.0 April, 2020" (semibold variant) · count: 33
  static const textStylesSemiBold12 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5, // 18/12
  );

  /// sample: "About Slarda" · count: 33
  static const textStylesSemiBold16 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// sample: "Amanda Morgan" (uppercase label style) · count: 30
  static const textStylesSemiBold10 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.3, // 13/10
    letterSpacing: 1.5,
  );

  /// sample: placeholder body text · count: 23
  static const textStylesRegular10 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.5, // 15/10
  );

  /// sample: "Apply" (light color, on dark bg) · count: 14
  static const textStylesLight22 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 22,
    fontWeight: FontWeight.w300,
    height: 1.41, // 31/22
    color: Color(0xFFF3F3F3),
  );

  /// sample: "Cancel" · count: 9
  static const textStylesLight15 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 15,
    fontWeight: FontWeight.w300,
    height: 1.73, // 26/15
    color: Color(0xFF202020),
  );

  /// sample: "English" (language list) · count: 14
  static const textStylesRegular15 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  /// sample: "Up to 50%" (badge, white) · count: 3
  /// NOTE: duplicate weight+size vs. Raleway's textStylesBold12 above,
  /// so it's suffixed _2 — same convention as your existing SemiBold13_2.
  static const textStylesBold12_2 = TextStyle(
    fontFamily: 'NunitoSans',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.5, // 18/12
    color: Colors.white,
  );
}

// =============================================================================
// pubspec.yaml setup (required — const TextStyle can't use google_fonts,
// since those functions aren't const):
//
// flutter:
//   fonts:
//     - family: Raleway
//       fonts:
//         - asset: assets/fonts/Raleway-Regular.ttf
//         - asset: assets/fonts/Raleway-Medium.ttf
//           weight: 500
//         - asset: assets/fonts/Raleway-Bold.ttf
//           weight: 700
//         - asset: assets/fonts/Raleway-ExtraBold.ttf
//           weight: 800
//     - family: NunitoSans
//       fonts:
//         - asset: assets/fonts/NunitoSans-Light.ttf
//           weight: 300
//         - asset: assets/fonts/NunitoSans-Regular.ttf
//         - asset: assets/fonts/NunitoSans-SemiBold.ttf
//           weight: 600
//         - asset: assets/fonts/NunitoSans-Bold.ttf
//           weight: 700
//
// Download both families free from Google Fonts:
//   https://fonts.google.com/specimen/Raleway
//   https://fonts.google.com/specimen/Nunito+Sans
// =============================================================================
