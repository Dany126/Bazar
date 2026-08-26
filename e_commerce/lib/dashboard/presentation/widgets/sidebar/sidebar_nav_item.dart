import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// Config for a single sidebar destination.
class SidebarNavItemData {
  const SidebarNavItemData({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
}

/// A single row in [DashboardSidebar].
///
/// [light] switches between the dark-sidebar style (solid purple pill,
/// white selected text) and the white-sidebar style (soft lavender pill,
/// purple selected text) seen across the newer Super Admin screens.
class SidebarNavItemTile extends StatelessWidget {
  const SidebarNavItemTile({
    super.key,
    required this.data,
    this.onTap,
    this.light = false,
  });

  final SidebarNavItemData data;
  final VoidCallback? onTap;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final isLight = light == true;
    final unselectedColor = isLight
        ? DashboardColors.textSecondaryLight
        : DashboardColors.textSecondaryDark;
    final selectedColor = isLight ? DashboardColors.accent : Colors.white;
    final selectedBg = isLight
        ? DashboardColors.accentSoft
        : DashboardColors.accent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: data.selected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  size: 18,
                  color: data.selected ? selectedColor : unselectedColor,
                ),
                const SizedBox(width: 12),
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: data.selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: data.selected ? selectedColor : unselectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
