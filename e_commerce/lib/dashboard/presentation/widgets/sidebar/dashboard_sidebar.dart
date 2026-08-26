import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../common/primary_pill_button.dart';
import 'sidebar_header.dart';
import 'sidebar_nav_item.dart';

/// Shared sidebar used by both the Seller and Super Admin shells.
/// [light] switches from the dark navy sidebar to the white sidebar
/// style used across the newer Super Admin screens.
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    required this.title,
    this.subtitle,
    required this.items,
    this.onItemTap,
    this.bottomCtaLabel,
    this.onBottomCtaTap,
    this.width = 240,
    this.light = false,
  });

  final String title;
  final String? subtitle;
  final List<SidebarNavItemData> items;
  final ValueChanged<int>? onItemTap;
  final String? bottomCtaLabel;
  final VoidCallback? onBottomCtaTap;
  final double width;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final isLight = light == true;
    return Container(
      width: width,
      color: isLight
          ? DashboardColors.sidebarBgLight
          : DashboardColors.sidebarBg,
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            SidebarHeader(title: title, subtitle: subtitle, light: isLight),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) => SidebarNavItemTile(
                  data: items[index],
                  light: isLight,
                  onTap: () => onItemTap?.call(index),
                ),
              ),
            ),
            if (bottomCtaLabel != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: PrimaryPillButton(
                  label: bottomCtaLabel!,
                  icon: Icons.add_rounded,
                  expand: true,
                  onPressed: onBottomCtaTap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
