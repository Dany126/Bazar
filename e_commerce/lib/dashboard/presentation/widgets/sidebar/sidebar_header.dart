import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// Brand mark + title shown at the top of the sidebar.
class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.light = false,
  });

  final String title;
  final String? subtitle;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final isLight = light == true;
    final titleColor = isLight
        ? DashboardColors.textPrimaryLight
        : Colors.white;
    final subtitleColor = isLight
        ? DashboardColors.textSecondaryLight
        : DashboardColors.textSecondaryDark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: DashboardColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: subtitleColor, fontSize: 11.5),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
