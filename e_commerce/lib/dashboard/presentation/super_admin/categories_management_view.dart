import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/category_card.dart';

/// Super Admin: Categories Management — organize marketplace-wide categories.
class CategoriesManagementView extends StatelessWidget {
  const CategoriesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.categories),
      sidebarCtaLabel: 'Add New Seller',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories Management', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Organize and moderate marketplace catalog.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                PrimaryPillButton(label: 'Add Category', icon: Icons.add_rounded, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: DashboardColors.cardBgDarkAlt, borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, size: 16, color: DashboardColors.textSecondaryDark),
                        SizedBox(width: 8),
                        Text('Search categories...', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                PrimaryPillButton(label: 'Filter', icon: Icons.filter_list_rounded, outlined: true, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: const [
                CategoryCard(icon: Icons.devices_other_rounded, name: 'Electronics', productCount: 1284),
                CategoryCard(icon: Icons.checkroom_rounded, name: 'Apparel', productCount: 2312),
                CategoryCard(icon: Icons.home_outlined, name: 'Home & Garden', productCount: 985),
                CategoryCard(icon: Icons.sports_soccer_rounded, name: 'Sports & Outdoors', productCount: 542),
                CategoryCard(icon: Icons.spa_outlined, name: 'Beauty & Personal Care', productCount: 764),
                CategoryCard(icon: Icons.toys_outlined, name: 'Toys & Games', productCount: 318),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
