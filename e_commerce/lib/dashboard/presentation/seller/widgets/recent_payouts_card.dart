import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import '../../widgets/common/status_badge.dart';

class RecentPayoutRowData {
  const RecentPayoutRowData({
    required this.method,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusTone,
    required this.icon,
    required this.iconColor,
  });

  final String method;
  final String date;
  final String amount;
  final String status;
  final StatusTone statusTone;
  final IconData icon;
  final Color iconColor;
}

class RecentPayoutsCard extends StatelessWidget {
  const RecentPayoutsCard({super.key, required this.rows});

  final List<RecentPayoutRowData> rows;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Payouts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
              const Text('View All', style: TextStyle(color: DashboardColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: r.iconColor.withOpacity(0.16), shape: BoxShape.circle),
                    child: Icon(r.icon, size: 15, color: r.iconColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.method, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(r.date, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 10.5)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r.amount, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                      StatusBadge(label: r.status, tone: r.statusTone),
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
