import 'package:flutter/material.dart';

class AppColors {
  // ---------------------------------------------------------------------
  // BRAND
  // ---------------------------------------------------------------------

  /// Primary ink — main text color, dark UI elements.
  static const kTextColor = Color(0xFF272727);
  static const kPrimaryColor = Color(0xFF8E6CEF);

  /// Canvas — main screen background.
  static const kMainBackgroundColor = Color(0xFFFFFFFF);

  /// Paper — card / surface background, sits on top of canvas.
  static const kCardBackgroundColor = Color(0xFFF4F4F4);

  /// Brass — primary accent (buttons, active states, prices).
  static const kPrimaryAccentColor = Color(0xFF8E6CEF);
  static const kPrimaryAccentColorDark = Color(0xFF8E6CEF);

  /// Moss — secondary accent (success states, secondary buttons).
  static const kSecondaryAccentColor = Color(0xFF566246);

  /// Oxblood — error / destructive actions.
  static const kErrorColor = Color(0xFF7A2E2E);

  // ---------------------------------------------------------------------
  // NEUTRALS
  // ---------------------------------------------------------------------

  /// Hairline dividers, input borders.
  static const kDividerColor = Color(0xFFD8D0BA);

  /// Secondary text — captions, metadata, placeholders.
  static const kSecondaryTextColor = Color(0xFF272727);
}
