import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/primary_pill_button.dart';
import '../../widgets/common/status_badge.dart';

class SellerRowData {
  const SellerRowData({
    required this.storeName,
    required this.joinDate,
    required this.productsCount,
    required this.totalSales,
    required this.status,
    required this.statusTone,
    this.logoUrl,
    this.showApproveAction = false,
  });

  final String storeName;
  final String joinDate;
  final String productsCount;
  final String totalSales;
  final String status;
  final StatusTone statusTone;
  final String? logoUrl;
  final bool showApproveAction;
}

class SellerTableRow extends StatelessWidget {
  const SellerTableRow({super.key, required this.data});

  final SellerRowData data;

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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: DashboardColors.cardBgDarkAlt,
              borderRadius: BorderRadius.circular(8),
              image: data.logoUrl != null
                  ? DecorationImage(image: NetworkImage(data.logoUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              data.storeName,
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.joinDate,
              style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              data.productsCount,
              style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              data.totalSales,
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: StatusBadge(label: data.status, tone: data.statusTone),
          ),
          SizedBox(
            width: data.showApproveAction ? 90 : 32,
            child: data.showApproveAction
                ? PrimaryPillButton(label: 'Activate', onPressed: () {})
                : const Icon(Icons.more_horiz, color: DashboardColors.textSecondaryDark, size: 18),
          ),
        ],
      ),
    );
  }
}
