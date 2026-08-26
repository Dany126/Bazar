import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';

class SellerCustomersView extends StatelessWidget {
  const SellerCustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.customers),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgLight,
      body: _SellerPageBody(
        title: 'Customers',
        subtitle: 'View customers who have purchased from your store.',
        icon: Icons.people_outline_rounded,
        value: '1,248',
        label: 'TOTAL CUSTOMERS',
      ),
    );
  }
}

class _SellerPageBody extends StatelessWidget {
  const _SellerPageBody({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.label,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: DashboardColors.textPrimaryLight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: DashboardColors.textSecondaryLight,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 24),
          _MetricCard(icon: icon, value: value, label: label),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DashboardColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: DashboardColors.accent, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: DashboardColors.textSecondaryLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: DashboardColors.textPrimaryLight,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
