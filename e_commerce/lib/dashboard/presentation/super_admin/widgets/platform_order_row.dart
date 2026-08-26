import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class PlatformOrderRowData {
  const PlatformOrderRowData({
    required this.orderId,
    required this.seller,
    required this.customerEmail,
    required this.date,
    required this.amount,
    required this.status,
    required this.statusColor,
    this.disputed = false,
    this.selected = false,
  });

  final String orderId;
  final String seller;
  final String customerEmail;
  final String date;
  final String amount;
  final String status;
  final Color statusColor;
  final bool disputed;
  final bool selected;
}

class PlatformOrderRow extends StatelessWidget {
  const PlatformOrderRow({super.key, required this.data, this.onTap});

  final PlatformOrderRowData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: data.selected ? DashboardColors.accentSoft : Colors.transparent,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(data.orderId,
                  style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: DashboardColors.accent, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Flexible(child: Text(data.seller, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(data.customerEmail, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12)),
            ),
            Expanded(
              flex: 2,
              child: Text(data.date, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12)),
            ),
            Expanded(
              flex: 2,
              child: Text(data.amount, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ),
            Expanded(
              flex: 2,
              child: Text(data.status, style: TextStyle(color: data.statusColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
