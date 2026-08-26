import 'package:flutter/material.dart';

/// Provides the active role shell's sidebar navigation callback to dashboard
/// screens without requiring every screen to thread the callback manually.
class DashboardNavigationScope extends InheritedWidget {
  const DashboardNavigationScope({
    super.key,
    required this.onNavItemTap,
    required super.child,
  });

  final ValueChanged<int> onNavItemTap;

  static ValueChanged<int>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DashboardNavigationScope>()
        ?.onNavItemTap;
  }

  @override
  bool updateShouldNotify(DashboardNavigationScope oldWidget) {
    return onNavItemTap != oldWidget.onNavItemTap;
  }
}
