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

    if (v.isEmpty) return 'البريد الإلكتروني مطلوب';

    const pattern = r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,7}$';
    if (!RegExp(pattern).hasMatch(v)) {
      return 'أدخل بريداً إلكترونياً صحيحاً';
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

    if (v.isEmpty) return 'كلمة المرور مطلوبة';

    if (v.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'يجب أن تحتوي على حرف كبير واحد على الأقل';
    }
    if (!RegExp(r'[a-z]').hasMatch(v)) {
      return 'يجب أن تحتوي على حرف صغير واحد على الأقل';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(v)) {
      return 'يجب أن تحتوي على رمز خاص واحد على الأقل';
    }

    return null; // valid
  }

  /// Validates that a confirmation field matches the original password.
  ///
  /// Usage:
  ///   TextFormField(
  ///     validator: (v) => AppValidators.confirmPassword(v, _passwordController.text),
  ///   )
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  // ─── Phone ────────────────────────────────────────────────────────────────

  /// Validates an Egyptian mobile phone number.
  ///
  /// Accepted formats (with or without country code):
  ///   010XXXXXXXX  →  Vodafone
  ///   011XXXXXXXX  →  Etisalat (e&)
  ///   012XXXXXXXX  →  Orange
  ///   015XXXXXXXX  →  WE
  ///
  ///   +20 10/11/12/15 XXXXXXXX
  ///   0020 10/11/12/15 XXXXXXXX
  ///
  /// All spaces, dashes, and parentheses are stripped before matching.
  static String? phone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[\s\-()]+'), '');

    if (v.isEmpty) return 'رقم الهاتف مطلوب';

    // Egyptian mobile pattern
    const pattern = r'^(\+20|0020|0)?(10|11|12|15)\d{8}$';
    if (!RegExp(pattern).hasMatch(v)) {
      return 'أدخل رقم هاتف مصري صحيح (مثال: 01012345678)';
    }

    return null; // valid
  }

  // ─── Generic helpers ──────────────────────────────────────────────────────

  /// Not-empty validator. Pass a [fieldName] for a localised message.
  static String? Function(String?) required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName مطلوب';
      }
      return null;
    };
  }
}
