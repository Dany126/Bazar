import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import 'status_badge.dart';

/// A "Label ..... Value" row used in risk-assessment and summary panels.
/// [valueTone] tints the value text (e.g. green for "Verified").
class LabeledValueRow extends StatelessWidget {
  const LabeledValueRow({
    super.key,
    required this.label,
    required this.value,
    this.valueTone,
  });

  final String label;
  final String value;
  final StatusTone? valueTone;

  Color _toneColor(StatusTone tone) {
    switch (tone) {
      case StatusTone.success:
        return DashboardColors.success;
      case StatusTone.warning:
        return DashboardColors.warning;
      case StatusTone.danger:
        return DashboardColors.danger;
      case StatusTone.info:
        return DashboardColors.info;
      case StatusTone.neutral:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
          Text(
            value,
            style: TextStyle(
              color: valueTone != null ? _toneColor(valueTone!) : Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
