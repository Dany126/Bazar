import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import 'seller_table_row.dart';

class SellerRegistryTable extends StatelessWidget {
  const SellerRegistryTable({
    super.key,
    required this.rows,
    required this.totalCount,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  final List<SellerRowData> rows;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  static const _headers = ['Logo', 'Store Name', 'Joined', 'Products', 'Total Sales', 'Status', 'Actions'];
  static const _flexes = [0, 3, 2, 1, 2, 2, 1];

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
              const Text(
                'Seller Registry',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: DashboardColors.cardBgDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('All', style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: DashboardColors.textSecondaryDark),
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
                if (i == 0) return const SizedBox(width: 46);
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
          ...rows.map((r) => SellerTableRow(data: r)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${rows.length} of $totalCount sellers',
                  style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5),
                ),
                Row(
                  children: List.generate(totalPages.clamp(1, 4), (i) {
                    final page = i + 1;
                    final selected = page == currentPage;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? DashboardColors.accent : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$page',
                          style: TextStyle(
                            color: selected ? Colors.white : DashboardColors.textSecondaryDark,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
