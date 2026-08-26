import 'package:flutter/material.dart';

/// Shared color tokens for the Seller & Super Admin dashboards.
/// Sidebar/top bar stay dark across both themes; only the main
/// content background switches between [dark] and [light].
class DashboardColors {
  const DashboardColors._();

  static const Color accent = Color(0xFF7B5CFA);
  static const Color accentSoft = Color(0x337B5CFA);

  static const Color sidebarBg = Color(0xFF1E1B2E);
  static const Color sidebarBgLight = Colors.white;
  static const Color topBarBgDark = Color(0xFF2A2740);
  static const Color topBarBgLight = Colors.white;

  static const Color contentBgDark = Color(0xFF16141F);
  static const Color cardBgDark = Color(0xFF211E30);
  static const Color cardBgDarkAlt = Color(0xFF2A2740);

  static const Color contentBgLight = Color(0xFFF7F7FA);
  static const Color cardBgLight = Colors.white;

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFF9C98B4);

  static const Color textPrimaryLight = Color(0xFF1E1B2E);
  static const Color textSecondaryLight = Color(0xFF8B879E);

  static const Color success = Color(0xFF3ECF8E);
  static const Color warning = Color(0xFFE8A33D);
  static const Color danger = Color(0xFFE85D5D);
  static const Color info = Color(0xFF5C9CFA);

  static const Color divider = Color(0x1AFFFFFF);
  static const Color dividerLight = Color(0x14000000);
}
