import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/primary_pill_button.dart';
import '../../widgets/common/status_badge.dart';

class PayoutQueueRowData {
  const PayoutQueueRowData({
    required this.sellerName,
    required this.amount,
    required this.status,
    required this.statusTone,
    required this.dueLabel,
    this.avatarColor = DashboardColors.accent,
  });

  final String sellerName;
  final String amount;
  final String status;
  final StatusTone statusTone;
  final String dueLabel;
  final Color avatarColor;
}

class PayoutQueueRow extends StatelessWidget {
  const PayoutQueueRow({super.key, required this.data});

  final PayoutQueueRowData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DashboardColors.divider)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 14, backgroundColor: data.avatarColor.withOpacity(0.25)),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(data.sellerName,
                style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 2,
            child: Text(data.amount,
                style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                StatusBadge(label: data.status, tone: data.statusTone),
                const SizedBox(width: 8),
                Text(data.dueLabel,
                    style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11.5)),
              ],
            ),
          ),
          SizedBox(
            width: 130,
            child: PrimaryPillButton(label: 'Process Payout', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
