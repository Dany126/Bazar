import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/platform_product_row.dart';
import 'widgets/platform_product_table.dart';

/// Super Admin: Platform Products — moderate inventory across all sellers.
class PlatformProductsView extends StatelessWidget {
  const PlatformProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.products),
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
                    Text('Platform Products', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Manage and moderate all inventory across the marketplace.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Filter', icon: Icons.filter_list_rounded, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Export', icon: Icons.upload_rounded, outlined: true, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL PRODUCTS',
                    value: '5,243',
                    icon: Icons.grid_view_rounded,
                    footnote: '+2% this week',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'FLAGGED ITEMS',
                    value: '4',
                    icon: Icons.flag_outlined,
                    iconColor: DashboardColors.danger,
                    footnote: 'Requires Action',
                    footnoteColor: DashboardColors.danger,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'ACTIVE SELLERS',
                    value: '128',
                    icon: Icons.storefront_outlined,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'UNPUBLISHED',
                    value: '87',
                    icon: Icons.visibility_off_outlined,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PlatformProductTable(
              totalCount: 5243,
              rows: const [
                PlatformProductRowData(
                  name: 'Urban Sole X1',
                  seller: 'Footwear · Urban Sole',
                  price: '\$129.99',
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                PlatformProductRowData(
                  name: 'Vintage Leather Bag',
                  seller: 'Accessories · Bags',
                  price: '\$254.00',
                  status: 'Flagged',
                  statusTone: StatusTone.danger,
                  flagged: true,
                ),
                PlatformProductRowData(
                  name: 'Signature Chair',
                  seller: 'Apparel · Décor',
                  price: '\$24.00',
                  status: 'Draft',
                  statusTone: StatusTone.neutral,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
