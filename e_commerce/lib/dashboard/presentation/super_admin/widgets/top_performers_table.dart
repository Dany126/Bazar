import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class TopPerformerRowData {
  const TopPerformerRowData({
    required this.name,
    required this.orders,
    required this.revenue,
    required this.growthLabel,
    required this.growthPositive,
    this.avatarColor = DashboardColors.accent,
  });

  final String name;
  final String orders;
  final String revenue;
  final String growthLabel;
  final bool growthPositive;
  final Color avatarColor;
}

class TopPerformersTable extends StatelessWidget {
  const TopPerformersTable({super.key, required this.rows});

  final List<TopPerformerRowData> rows;

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
              const Text('Category / Marketplace Rankings',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              const Text('View all', style: TextStyle(color: DashboardColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                SizedBox(width: 36),
                Expanded(flex: 3, child: Text('Name', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Orders', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Revenue', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Growth', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          ...rows.map((r) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DashboardColors.divider))),
                child: Row(
                  children: [
                    CircleAvatar(radius: 12, backgroundColor: r.avatarColor.withOpacity(0.25)),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: Text(r.name, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600))),
                    Expanded(flex: 2, child: Text(r.orders, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12))),
                    Expanded(flex: 2, child: Text(r.revenue, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600))),
                    Expanded(
                      flex: 2,
                      child: Text(
                        r.growthLabel,
                        style: TextStyle(
                          color: r.growthPositive ? DashboardColors.success : DashboardColors.danger,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
