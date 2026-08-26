import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import 'platform_product_row.dart';

class PlatformProductTable extends StatelessWidget {
  const PlatformProductTable({super.key, required this.rows, required this.totalCount});

  final List<PlatformProductRowData> rows;
  final int totalCount;

  static const _headers = ['Product', 'Seller', 'Price', 'Status', 'Actions'];
  static const _flexes = [3, 2, 1, 2];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF6B6880),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Products',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: DashboardColors.contentBgDark, borderRadius: BorderRadius.circular(16)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_rounded, size: 14, color: DashboardColors.textSecondaryDark),
                      SizedBox(width: 6),
                      Text('Search by SKU or name...',
                          style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFB8B6C4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 48),
                ...List.generate(_headers.length - 1, (i) {
                  return Expanded(
                    flex: _flexes[i],
                    child: Text(_headers[i],
                        style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
                  );
                }),
                const SizedBox(width: 90),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(children: rows.map((r) => PlatformProductRow(data: r)).toList()),
          ),
          Container(
            color: const Color(0xFFB8B6C4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showing ${rows.length} of $totalCount products',
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
                Row(
                  children: [
                    _pageDot('1', true),
                    _pageDot('2', false),
                    _pageDot('3', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageDot(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? DashboardColors.accent : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 10.5)),
      ),
    );
  }
}
