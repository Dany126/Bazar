import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/dispute_resolution_panel.dart';
import 'widgets/platform_order_row.dart';
import 'widgets/platform_order_table.dart';

/// Super Admin: Platform Orders — all marketplace orders, with a dispute
/// resolution panel that opens when a disputed row is selected.
class PlatformOrdersView extends StatefulWidget {
  const PlatformOrdersView({super.key});

  @override
  State<PlatformOrdersView> createState() => _PlatformOrdersViewState();
}

class _PlatformOrdersViewState extends State<PlatformOrdersView> {
  int? _selectedIndex = 0;

  static const _orders = [
    PlatformOrderRowData(
      orderId: '#ORD-9820',
      seller: 'Vintage Sole',
      customerEmail: 'alex.w@example.com',
      date: 'Today, 10:22 AM',
      amount: '\$249.00',
      status: 'DISPUTED',
      statusColor: DashboardColors.danger,
      disputed: true,
    ),
    PlatformOrderRowData(
      orderId: '#ORD-9801',
      seller: 'Baskue Threads',
      customerEmail: 'sam.j@example.com',
      date: 'Today, 08:15 AM',
      amount: '\$84.00',
      status: 'SHIPPED',
      statusColor: DashboardColors.success,
    ),
    PlatformOrderRowData(
      orderId: '#ORD-9709',
      seller: 'Kaia Fabrications',
      customerEmail: 'maria.k@example.com',
      date: 'Yesterday, 19:00',
      amount: '\$412.00',
      status: 'PROCESSING',
      statusColor: DashboardColors.warning,
    ),
    PlatformOrderRowData(
      orderId: '#ORD-9629',
      seller: 'Baskue Threads',
      customerEmail: 'l.tang@example.com',
      date: 'Yesterday, 16:26',
      amount: '\$62.00',
      status: 'DELIVERED',
      statusColor: DashboardColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rowsWithSelection = [
      for (var i = 0; i < _orders.length; i++)
        PlatformOrderRowData(
          orderId: _orders[i].orderId,
          seller: _orders[i].seller,
          customerEmail: _orders[i].customerEmail,
          date: _orders[i].date,
          amount: _orders[i].amount,
          status: _orders[i].status,
          statusColor: _orders[i].statusColor,
          disputed: _orders[i].disputed,
          selected: i == _selectedIndex,
        ),
    ];
    final selectedOrder = _selectedIndex != null ? _orders[_selectedIndex!] : null;

    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.orders),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Platform Orders', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Monitor and manage all platform transactions and disputes.',
                        style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Export CSV', icon: Icons.upload_rounded, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Advanced Filter', icon: Icons.tune_rounded, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL ORDERS TODAY',
                    value: '412',
                    icon: Icons.shopping_bag_outlined,
                    footnote: '+15.2% vs yesterday',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'DISPUTED',
                    value: '3',
                    icon: Icons.report_gmailerrorred_rounded,
                    iconColor: DashboardColors.danger,
                    footnote: 'Requires attention',
                    footnoteColor: DashboardColors.danger,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'REFUND REQUESTS',
                    value: '9',
                    icon: Icons.currency_exchange_rounded,
                    iconColor: DashboardColors.warning,
                    background: DashboardColors.cardBgLight,
                    valueColor: DashboardColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: PlatformOrderTable(
                      totalCount: 25,
                      rows: rowsWithSelection,
                      onRowTap: (i) => setState(() => _selectedIndex = i),
                    ),
                  ),
                  if (selectedOrder != null && selectedOrder.disputed) ...[
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 320,
                      child: DisputeResolutionPanel(
                        orderId: selectedOrder.orderId,
                        filedAt: 'Today, 11:08 AM',
                        customerEmail: selectedOrder.customerEmail,
                        productName: 'Sueded Derby Shoe',
                        customerMessage:
                            'The shoes arrived with a visible scuff on the toe and the color looks different from the photos.',
                        onClose: () => setState(() => _selectedIndex = null),
                        onForceRefund: () {},
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
