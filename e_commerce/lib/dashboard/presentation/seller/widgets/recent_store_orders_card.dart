import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import '../../widgets/common/status_badge.dart';
import 'recent_store_order_tile.dart';

class RecentStoreOrdersCard extends StatelessWidget {
  const RecentStoreOrdersCard({super.key, required this.orders});

  final List<RecentStoreOrderTile> orders;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Store Orders',
                style: TextStyle(
                  color: DashboardColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const Text(
                'View All',
                style: TextStyle(color: DashboardColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...orders,
        ],
      ),
    );
  }
}

/// Sample tone helper kept close to the card for quick demo wiring.
StatusTone orderStatusTone(String status) {
  switch (status.toLowerCase()) {
    case 'delivered':
      return StatusTone.success;
    case 'shipped':
      return StatusTone.info;
    case 'pending':
      return StatusTone.warning;
    case 'cancelled':
      return StatusTone.danger;
    default:
      return StatusTone.neutral;
  }
}
