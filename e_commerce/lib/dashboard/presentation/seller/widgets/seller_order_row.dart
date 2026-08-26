import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

class SellerOrderRowData {
  const SellerOrderRowData({
    required this.orderId,
    required this.customer,
    required this.date,
    required this.itemsCount,
    required this.total,
    required this.status,
    required this.statusTone,
  });

  final String orderId;
  final String customer;
  final String date;
  final int itemsCount;
  final String total;
  final String status;
  final StatusTone statusTone;
}

class SellerOrderRow extends StatelessWidget {
  const SellerOrderRow({super.key, required this.data, this.onTap});

  final SellerOrderRowData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: DashboardColors.divider))),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(data.orderId, style: const TextStyle(color: DashboardColors.accent, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
            Expanded(flex: 2, child: Text(data.customer, style: const TextStyle(color: Colors.white, fontSize: 12.5))),
            Expanded(flex: 2, child: Text(data.date, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12))),
            Expanded(flex: 1, child: Text('${data.itemsCount}', style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12))),
            Expanded(flex: 1, child: Text(data.total, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600))),
            Expanded(flex: 2, child: StatusBadge(label: data.status, tone: data.statusTone)),
          ],
        ),
      ),
    );
  }
}
