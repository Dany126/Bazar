import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// A labeled rounded text field for light-background forms (as opposed
/// to [SettingsField], which is styled for dark admin forms).
class LightFormField extends StatelessWidget {
  const LightFormField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.maxLines = 1,
    this.prefixText,
  });

  final String label;
  final String? hint;
  final String? initialValue;
  final int maxLines;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            prefixText: prefixText,
            hintStyle: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: DashboardColors.dividerLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: DashboardColors.accent),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
