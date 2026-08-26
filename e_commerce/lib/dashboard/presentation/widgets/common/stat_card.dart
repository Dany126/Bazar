import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// A single KPI card: label, big value, trailing icon chip, and an
/// optional trend/footnote line.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.footnote,
    this.footnoteColor,
    this.iconColor = DashboardColors.accent,
    required this.background,
    required this.valueColor,
    this.labelColor = DashboardColors.textSecondaryDark,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? footnote;
  final Color? footnoteColor;
  final Color iconColor;
  final Color background;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: labelColor, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 6),
            Text(
              footnote!,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: footnoteColor ?? labelColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
