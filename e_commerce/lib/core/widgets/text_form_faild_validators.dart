/// A collection of standard form field validators for use with
/// Flutter's [TextFormField] `validator` parameter.
///
/// Usage:
///   TextFormField(
///     validator: AppValidators.email,
///   )
class AppValidators {
  AppValidators._(); // prevent instantiation

  // ─── Email ────────────────────────────────────────────────────────────────

  /// Validates a standard email address.
  ///
  /// Rules:
  ///  - Required (not empty)
  ///  - Must match RFC-5322-like pattern: local@domain.tld
  ///  - Local part: letters, digits, +, _, ., -
  ///  - Domain: letters, digits, hyphens, dots
  ///  - TLD: 2–7 letters
  static String? email(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) return 'Email is required';

    const pattern = r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,7}$';

    if (!RegExp(pattern).hasMatch(v)) {
      return 'Enter a valid email address';
    }

    return null; // valid
  }

  // ─── Password ─────────────────────────────────────────────────────────────

  /// Validates a secure password.
  ///
  /// Rules:
  ///  - Required (not empty)
  ///  - Minimum 8 characters
  ///  - At least one uppercase letter (A-Z)
  ///  - At least one lowercase letter (a-z)
  ///  - At least one digit (0-9)
  ///  - At least one special character (!@#$%^&*...)
  static String? password(String? value) {
    final v = value ?? '';

    if (v.isEmpty) return 'Password is required';

    if (v.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(v)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(v)) {
      return 'Password must contain at least one special character';
    }

    return null; // valid
  }

  /// Validates that a confirmation field matches the original password.
  ///
  /// Usage:
  ///   TextFormField(
  ///     validator: (v) => AppValidators.confirmPassword(
  ///       v,
  ///       _passwordController.text,
  ///     ),
  ///   )
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != original) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ─── Phone ────────────────────────────────────────────────────────────────

  /// Validates an Egyptian mobile phone number.
  ///
  /// Accepted formats (with or without country code):
  ///   010XXXXXXXX  → Vodafone
  ///   011XXXXXXXX  → Etisalat (e&)
  ///   012XXXXXXXX  → Orange
  ///   015XXXXXXXX  → WE
  ///
  ///   +20 10/11/12/15 XXXXXXXX
  ///   0020 10/11/12/15 XXXXXXXX
  ///
  /// All spaces, dashes, and parentheses are stripped before matching.
  static String? phone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[\s\-()]+'), '');

    if (v.isEmpty) return 'Phone number is required';

    const pattern = r'^(\+20|0020|0)?(10|11|12|15)\d{8}$';

    if (!RegExp(pattern).hasMatch(v)) {
      return 'Enter a valid Egyptian phone number (Example: 01012345678)';
    }

    return null; // valid
  }

  // ─── Generic helpers ──────────────────────────────────────────────────────

  /// Not-empty validator. Pass a [fieldName] for a localized message.
  static String? Function(String?) required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }

      return null;
    };
  }
}
