import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// A row of underline tabs. Presentational only — pass [selectedIndex]
/// and handle [onChanged] to wire up real state.
class SimpleTabBar extends StatelessWidget {
  const SimpleTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: InkWell(
              onTap: () => onChanged?.call(i),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: i == selectedIndex ? DashboardColors.accent : DashboardColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 20,
                    color: i == selectedIndex ? DashboardColors.accent : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
