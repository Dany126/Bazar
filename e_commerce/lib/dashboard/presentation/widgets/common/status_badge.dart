import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

enum StatusTone { success, warning, danger, info, neutral }

/// Small soft-tinted pill used for order/product/seller statuses.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.tone = StatusTone.neutral});

  final String label;
  final StatusTone tone;

  Color get _color {
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
        return DashboardColors.textSecondaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}
