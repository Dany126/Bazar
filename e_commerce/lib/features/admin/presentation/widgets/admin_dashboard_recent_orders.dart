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
            constraints: const BoxConstraints(minWidth: 420),
            child: DataTable(
              columnSpacing: 22,
              headingRowHeight: 42,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 60,
              columns: const [
                DataColumn(label: Text('Order')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Status')),
              ],
              rows: rows
                  .map(
                    (row) => DataRow(
                      cells: [
                        DataCell(Text(row.id)),
                        DataCell(Text(row.customer)),
                        DataCell(Text('£${row.total.toStringAsFixed(2)}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: row.status.toLowerCase() == 'paid'
                                  ? const Color(0xFFEAFBF4)
                                  : row.status.toLowerCase() == 'shipped'
                                  ? const Color(0xFFEAE7FF)
                                  : const Color(0xFFFFF1DB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              row.status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: row.status.toLowerCase() == 'paid'
                                    ? const Color(0xFF1DAF73)
                                    : row.status.toLowerCase() == 'shipped'
                                    ? AppColors.kPrimaryColor
                                    : const Color(0xFFEC8B18),
                              ),
                            ),
                          ),
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
