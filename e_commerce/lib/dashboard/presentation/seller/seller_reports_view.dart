import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';

class SellerReportsView extends StatelessWidget {
  const SellerReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.reports),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports',
              style: TextStyle(
                color: DashboardColors.textPrimaryLight,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track sales, orders, and store performance.',
              style: TextStyle(
                color: DashboardColors.textSecondaryLight,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: DashboardColors.divider),
              ),
              child: const Text(
                'Sales reports will appear here.',
                style: TextStyle(
                  color: DashboardColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
