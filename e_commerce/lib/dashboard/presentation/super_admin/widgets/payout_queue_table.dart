import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import 'payout_queue_row.dart';

class PayoutQueueTable extends StatelessWidget {
  const PayoutQueueTable({super.key, required this.rows, required this.totalCount});

  final List<PayoutQueueRowData> rows;
  final int totalCount;

  static const _headers = ['Seller', 'Amount', 'Status/Due'];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDark,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending Queue',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              const Icon(Icons.filter_list_rounded, color: DashboardColors.textSecondaryDark, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 26),
                Expanded(
                    flex: 3,
                    child: Text(_headers[0],
                        style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                Expanded(
                    flex: 2,
                    child: Text(_headers[1],
                        style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                Expanded(
                    flex: 3,
                    child: Text(_headers[2],
                        style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                const SizedBox(width: 130),
              ],
            ),
          ),
          ...rows.map((r) => PayoutQueueRow(data: r)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Showing ${rows.length} of $totalCount pending',
                style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}
