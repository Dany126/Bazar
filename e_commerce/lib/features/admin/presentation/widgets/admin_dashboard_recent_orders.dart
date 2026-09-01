import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_dashboard_data.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_dashboard_panel.dart';
import 'package:flutter/material.dart';

class AdminDashboardRecentOrders extends StatelessWidget {
  const AdminDashboardRecentOrders({super.key, required this.orders});

  final List<AdminRecentOrder> orders;

  @override
  Widget build(BuildContext context) {
    final rows = orders.isEmpty
        ? const [
            AdminRecentOrder(
              id: '#0000',
              customer: 'No orders yet',
              total: 0,
              status: 'Pending',
            ),
          ]
        : orders;

    return AdminDashboardPanel(
      title: 'Recent orders',
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 500),
            child: DataTable(
              columnSpacing: 32,
              headingRowHeight: 48,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 68,
              headingTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.kSecondaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
              columns: const [
                DataColumn(label: Text('Order ID')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Status')),
              ],
              rows: rows
                  .map(
                    (row) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            row.id,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                                child: const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                row.customer,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '\$${row.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.kTextColor,
                            ),
                          ),
                        ),
                        DataCell(
                          _StatusBadge(status: row.status),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    
    final s = status.toLowerCase();
    if (s == 'delivered' || s == 'paid' || s == 'completed') {
      bgColor = const Color(0xFFEAFBF4);
      textColor = const Color(0xFF1DAF73);
    } else if (s == 'shipped' || s == 'processing') {
      bgColor = const Color(0xFFEAE7FF);
      textColor = AppColors.kPrimaryColor;
    } else if (s == 'canceled' || s == 'failed') {
      bgColor = const Color(0xFFFFEBEB);
      textColor = const Color(0xFFDC2626);
    } else {
      // Pending / others
      bgColor = const Color(0xFFFFF1DB);
      textColor = const Color(0xFFEC8B18);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
