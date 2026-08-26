import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/customer_directory_table.dart';
import 'widgets/customer_row.dart';

/// Super Admin: Customers — platform-wide customer directory.
class CustomersDirectoryView extends StatelessWidget {
  const CustomersDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.customers),
      sidebarCtaLabel: 'Add New Seller',
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
            const Text('Customer Directory', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Manage and view customer activity across the marketplace.',
                style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL CUSTOMERS',
                    value: '12,043',
                    icon: Icons.groups_2_outlined,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'NEW THIS MONTH',
                    value: '482',
                    icon: Icons.person_add_alt_1_rounded,
                    footnote: '+12% vs last month',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'REPEAT RATE',
                    value: '32%',
                    icon: Icons.autorenew_rounded,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomerDirectoryTable(
              totalCount: 12043,
              rows: const [
                CustomerRowData(
                  name: 'David Chen',
                  email: 'david.chen@example.com',
                  joinDate: 'Oct 12, 2025',
                  totalOrders: '24',
                  totalSpent: '\$3,450.00',
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                CustomerRowData(
                  name: 'Sarah Jenkins',
                  email: 's.jenkins@example.com',
                  joinDate: 'Nov 04, 2025',
                  totalOrders: '9',
                  totalSpent: '\$960.50',
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                CustomerRowData(
                  name: 'Elena Rodriguez',
                  email: 'elena.r@example.com',
                  joinDate: 'Jan 15, 2026',
                  totalOrders: '2',
                  totalSpent: '\$145.00',
                  status: 'Inactive',
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
