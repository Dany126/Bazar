import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/product_management_table.dart';
import 'widgets/product_table_row.dart';

/// Seller: My Products — product management screen.
class SellerProductsView extends StatelessWidget {
  const SellerProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.products),
      sidebarCtaLabel: 'Add New Product',
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
                    Text(
                      'Product Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage inventory, pricing, and status for your items.',
                      style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5),
                    ),
                  ],
                ),
                PrimaryPillButton(
                  label: 'Add New Product',
                  icon: Icons.add_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL PRODUCTS',
                    value: '1,248',
                    icon: Icons.grid_view_rounded,
                    footnote: '+48 this month',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'LOW STOCK',
                    value: '34',
                    icon: Icons.person_outline_rounded,
                    iconColor: DashboardColors.warning,
                    footnote: 'Needs attention',
                    footnoteColor: DashboardColors.warning,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'ACTIVE CATEGORIES',
                    value: '12',
                    icon: Icons.category_outlined,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProductManagementTable(
              totalCount: 1248,
              rows: [
                ProductRowData(
                  name: 'Urban Sole X1',
                  category: 'Footwear',
                  price: '\$129.99',
                  stockLabel: '124 units',
                  stockTone: StatusTone.success,
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                ProductRowData(
                  name: 'Highfall Leather Boot',
                  category: 'Boots',
                  price: '\$210.00',
                  stockLabel: '8 units',
                  stockTone: StatusTone.warning,
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                ProductRowData(
                  name: 'Cityscape Crossbody',
                  category: 'Accessories',
                  price: '\$89.50',
                  stockLabel: '0 units',
                  stockTone: StatusTone.danger,
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
