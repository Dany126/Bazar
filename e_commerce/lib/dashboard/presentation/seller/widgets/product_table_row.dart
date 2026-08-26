import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

class ProductRowData {
  const ProductRowData({
    required this.name,
    required this.category,
    required this.price,
    required this.stockLabel,
    required this.stockTone,
    required this.status,
    required this.statusTone,
    this.imageUrl,
  });

  final String name;
  final String category;
  final String price;
  final String stockLabel;
  final StatusTone stockTone;
  final String status;
  final StatusTone statusTone;
  final String? imageUrl;
}

class ProductTableRow extends StatelessWidget {
  const ProductTableRow({super.key, required this.data});

  final ProductRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DashboardColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: DashboardColors.cardBgDarkAlt,
              borderRadius: BorderRadius.circular(8),
              image: data.imageUrl != null
                  ? DecorationImage(image: NetworkImage(data.imageUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              data.name,
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.category,
              style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.price,
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: _dotColor(data.stockTone),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  data.stockLabel,
                  style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: StatusBadge(label: data.status, tone: data.statusTone),
          ),
          const SizedBox(
            width: 32,
            child: Icon(Icons.more_horiz, color: DashboardColors.textSecondaryDark, size: 18),
          ),
        ],
      ),
    );
  }

  Color _dotColor(StatusTone tone) {
    switch (tone) {
      case StatusTone.success:
        return DashboardColors.success;
      case StatusTone.warning:
        return DashboardColors.warning;
      case StatusTone.danger:
        return DashboardColors.danger;
      case StatusTone.info:
        return DashboardColors.info;
      case StatusTone.neutral:
        return DashboardColors.textSecondaryDark;
    }
  }
}
