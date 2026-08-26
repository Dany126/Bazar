import 'package:flutter/material.dart';
import '../dashboard_navigation.dart';
import '../theme/dashboard_colors.dart';
import 'sidebar/dashboard_sidebar.dart';
import 'sidebar/sidebar_nav_item.dart';
import 'top_bar/dashboard_top_bar.dart';

/// Shared page frame: sidebar + top bar + a body area whose background
/// color is supplied by the screen. [sidebarLight]/[topBarLight] switch
/// those regions to the white style used on the newer Super Admin screens;
/// both default to false (dark), matching the original Seller screens.
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.sidebarTitle,
    this.sidebarSubtitle,
    required this.navItems,
    this.onNavItemTap,
    this.sidebarCtaLabel,
    this.onSidebarCtaTap,
    required this.topBarBrand,
    this.topBarBadge,
    this.showTopBarBrand = true,
    required this.bodyBackground,
    required this.body,
    this.sidebarLight = false,
    this.topBarLight = false,
  });

  final String sidebarTitle;
  final String? sidebarSubtitle;
  final List<SidebarNavItemData> navItems;
  final ValueChanged<int>? onNavItemTap;
  final String? sidebarCtaLabel;
  final VoidCallback? onSidebarCtaTap;
  final String topBarBrand;
  final String? topBarBadge;
  final bool showTopBarBrand;
  final Color bodyBackground;
  final Widget body;
  final bool sidebarLight;
  final bool topBarLight;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLightMode = true;

  Widget _buildSidebar(ValueChanged<int>? onItemTap) {
    return DashboardSidebar(
      title: widget.sidebarTitle,
      subtitle: widget.sidebarSubtitle,
      items: widget.navItems,
      onItemTap: onItemTap,
      bottomCtaLabel: widget.sidebarCtaLabel,
      onBottomCtaTap: widget.onSidebarCtaTap,
      light: _isLightMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigation =
        widget.onNavItemTap ?? DashboardNavigationScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final sidebar = _buildSidebar(navigation);
        final mobileNavigation = navigation == null
            ? null
            : (index) {
                Navigator.of(context).pop();
                navigation(index);
              };

        return Scaffold(
          key: _scaffoldKey,
          drawer: compact
              ? Drawer(child: _buildSidebar(mobileNavigation))
              : null,
          body: Row(
            children: [
              if (!compact) sidebar,
              Expanded(
                child: Column(
                  children: [
                    DashboardTopBar(
                      brand: widget.topBarBrand,
                      badgeLabel: widget.topBarBadge,
                      light: _isLightMode,
                      showBrand: widget.showTopBarBrand,
                      onMenuPressed: compact
                          ? () => _scaffoldKey.currentState?.openDrawer()
                          : null,
                      onMoodPressed: () => setState(() {
                        _isLightMode = !_isLightMode;
                      }),
                    ),
                    Expanded(
                      child: Container(
                        color: _isLightMode
                            ? DashboardColors.contentBgLight
                            : widget.bodyBackground,
                        child: widget.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
