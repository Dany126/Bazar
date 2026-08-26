import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/simple_tab_bar.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/proposed_product_card.dart';
import 'widgets/risk_assessment_card.dart';
import 'widgets/seller_application_card.dart';

/// Super Admin: Seller Approval — review a single pending application.
class SellerApprovalView extends StatelessWidget {
  const SellerApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.sellers),
      sidebarCtaLabel: 'Add New Seller',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      topBarBadge: 'Super Admin',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('← Back to Sellers',
                style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Seller Approval',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Reject', icon: Icons.close_rounded, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Activate', icon: Icons.check_rounded, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Expanded(
                    flex: 3,
                    child: SellerApplicationCard(
                      storeName: 'Lumina Home Goods',
                      submittedDate: 'Jul 24, 2026',
                      description:
                          'Handcrafted home decor and minimalist furniture sourced from independent artisans across the region.',
                      businessName: 'Lumina Designs LLC',
                      taxId: '70-6903562',
                      businessType: 'Sole Proprietorship',
                      email: 'contact@luminahome.co',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(flex: 2, child: RiskAssessmentCard()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SimpleTabBar(
              labels: ['Proposed Products (12)', 'Fulfillment Plan', 'Store Policies'],
              selectedIndex: 0,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: const [
                ProposedProductCard(name: 'Ceramic Ribbed Vase', category: 'Home Decor · Ceramics', price: '\$34.00'),
                ProposedProductCard(name: 'Oak Wood Table Lamp', category: 'Lighting · Furniture', price: '\$115.00'),
                ProposedProductCard(name: 'Textured Linen Pillows', category: 'Textiles · Living Room', price: '\$48.00'),
                ProposedProductsMoreTile(remainingCount: 9),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
