import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import 'platform_order_row.dart';

class PlatformOrderTable extends StatelessWidget {
  const PlatformOrderTable({super.key, required this.rows, required this.totalCount, this.onRowTap});

  final List<PlatformOrderRowData> rows;
  final int totalCount;
  final ValueChanged<int>? onRowTap;

  static const _headers = ['Order ID', 'Seller', 'Customer', 'Date', 'Amount', 'Status'];
  static const _flexes = [2, 2, 3, 2, 2, 2];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: DashboardColors.contentBgLight, borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, size: 16, color: DashboardColors.textSecondaryLight),
                        SizedBox(width: 8),
                        Text('Search order ID, seller, or customer...',
                            style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: DashboardColors.dividerLight), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('All Statuses', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: DashboardColors.textSecondaryLight),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_headers.length, (i) {
                return Expanded(
                  flex: _flexes[i],
                  child: Text(_headers[i],
                      style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11, fontWeight: FontWeight.w600)),
                );
              }),
            ),
          ),
          for (var i = 0; i < rows.length; i++)
            PlatformOrderRow(data: rows[i], onTap: () => onRowTap?.call(i)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Showing ${rows.length} of $totalCount orders',
                style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}
