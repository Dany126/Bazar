import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

/// Top bar shared across dashboard screens: brand label, search,
/// notification bell and avatar. [light] switches to the white top-bar
/// style used across the newer Super Admin screens.
class DashboardTopBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardTopBar({
    super.key,
    required this.brand,
    this.badgeLabel,
    this.onSearchChanged,
    this.avatarUrl,
    this.light = false,
    this.showBrand = true,
    this.onMenuPressed,
    this.onMoodPressed,
  });

  final String brand;
  final String? badgeLabel;
  final ValueChanged<String>? onSearchChanged;
  final String? avatarUrl;
  final bool light;
  final bool showBrand;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onMoodPressed;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final textColor = light ? DashboardColors.textPrimaryLight : Colors.white;
    final mutedColor = light
        ? DashboardColors.textSecondaryLight
        : DashboardColors.textSecondaryDark;
    final searchFill = light
        ? DashboardColors.contentBgLight
        : Colors.white.withValues(alpha: 0.06);

    return Container(
      height: preferredSize.height,
      color: light
          ? DashboardColors.topBarBgLight
          : DashboardColors.topBarBgDark,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 24),
      child: Row(
        children: [
          if (onMenuPressed != null) ...[
            IconButton(
              icon: Icon(Icons.menu_rounded, color: textColor),
              onPressed: onMenuPressed,
              tooltip: 'Open navigation',
            ),
            const SizedBox(width: 4),
          ],
          if (showBrand && !compact) ...[
            Text(
              brand,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            if (badgeLabel != null) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: DashboardColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeLabel!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 32),
          ],
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 260) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.search_rounded,
                      size: 19,
                      color: mutedColor,
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 38,
                    width: constraints.maxWidth.clamp(0, 420),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: searchFill,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, size: 18, color: mutedColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: onSearchChanged,
                            style: TextStyle(color: textColor, fontSize: 13),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: 'Search...',
                              hintStyle: TextStyle(
                                color: mutedColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          if (!compact)
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: mutedColor),
              onPressed: () {},
            ),
          IconButton(
            icon: Icon(
              light ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: mutedColor,
            ),
            onPressed: onMoodPressed,
            tooltip: light ? 'Switch to dark mood' : 'Switch to light mood',
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: mutedColor),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: DashboardColors.accentSoft,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 16, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
