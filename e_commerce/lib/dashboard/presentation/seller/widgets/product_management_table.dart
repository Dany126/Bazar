import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import 'product_table_row.dart';

class ProductManagementTable extends StatelessWidget {
  const ProductManagementTable({
    super.key,
    required this.rows,
    required this.totalCount,
    this.categoryFilterLabel = 'All Categories',
  });

  final List<ProductRowData> rows;
  final int totalCount;
  final String categoryFilterLabel;

  static const _headers = ['Image', 'Product Name', 'Category', 'Price', 'Stock', 'Status', 'Action'];
  static const _flexes = [0, 3, 2, 1, 2, 2, 1];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDark,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: DashboardColors.cardBgDarkAlt,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(categoryFilterLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 12.5)),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: DashboardColors.textSecondaryDark),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: DashboardColors.divider),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Export',
                    style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(_headers.length, (i) {
                if (i == 0) return const SizedBox(width: 48);
                return Expanded(
                  flex: _flexes[i],
                  child: Text(
                    _headers[i],
                    style: const TextStyle(
                      color: DashboardColors.textSecondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ),
          ),
          ...rows.map((r) => ProductTableRow(data: r)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${rows.length} of $totalCount entries',
                  style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5),
                ),
                Row(
                  children: [
                    _PageDot(label: '1', selected: true),
                    const SizedBox(width: 6),
                    _PageDot(label: '2'),
                    const SizedBox(width: 6),
                    _PageDot(label: '3'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.label, this.selected = false});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? DashboardColors.accent : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : DashboardColors.textSecondaryDark,
          fontSize: 11.5,
        ),
      ),
    );
  }
}
