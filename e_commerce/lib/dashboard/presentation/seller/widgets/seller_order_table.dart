import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import 'seller_order_row.dart';

class SellerOrderTable extends StatelessWidget {
  const SellerOrderTable({super.key, required this.rows, required this.totalCount, this.onRowTap});

  final List<SellerOrderRowData> rows;
  final int totalCount;
  final ValueChanged<int>? onRowTap;

  static const _headers = ['Order ID', 'Customer', 'Date', 'Items', 'Total', 'Status'];
  static const _flexes = [2, 2, 2, 1, 1, 2];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: DashboardColors.cardBgDark, borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_rounded, size: 14, color: DashboardColors.textSecondaryDark),
                    SizedBox(width: 6),
                    Text('Search by order ID...', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_headers.length, (i) {
                return Expanded(
                  flex: _flexes[i],
                  child: Text(_headers[i], style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600)),
                );
              }),
            ),
          ),
          for (var i = 0; i < rows.length; i++) SellerOrderRow(data: rows[i], onTap: () => onRowTap?.call(i)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Showing ${rows.length} of $totalCount orders', style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
          ),
        ],
      ),
    );
  }
}
