import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

class RecentStoreOrderTile extends StatelessWidget {
  const RecentStoreOrderTile({
    super.key,
    required this.productName,
    required this.orderId,
    required this.status,
    required this.tone,
    this.thumbnailUrl,
  });

  final String productName;
  final String orderId;
  final String status;
  final StatusTone tone;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: DashboardColors.contentBgDark,
              borderRadius: BorderRadius.circular(10),
              image: thumbnailUrl != null
                  ? DecorationImage(image: NetworkImage(thumbnailUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: DashboardColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                Text(
                  orderId,
                  style: const TextStyle(
                    color: DashboardColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(label: status, tone: tone),
        ],
      ),
    );
  }
}
