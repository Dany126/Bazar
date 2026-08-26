import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import 'customer_row.dart';

class CustomerDirectoryTable extends StatelessWidget {
  const CustomerDirectoryTable({super.key, required this.rows, required this.totalCount});

  final List<CustomerRowData> rows;
  final int totalCount;

  static const _headers = ['Customer', 'Joined', 'Orders', 'Total Spent', 'Status'];
  static const _flexes = [3, 2, 1, 2, 2];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const SizedBox(width: 44),
                ...List.generate(_headers.length, (i) {
                  return Expanded(
                    flex: _flexes[i],
                    child: Text(_headers[i],
                        style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11, fontWeight: FontWeight.w600)),
                  );
                }),
              ],
            ),
          ),
          ...rows.map((r) => CustomerRow(data: r)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Showing 1 of ${rows.length} of $totalCount',
                style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}
