import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class PaymentSummaryLine {
  const PaymentSummaryLine(this.label, this.value, {this.negative = false});
  final String label;
  final String value;
  final bool negative;
}

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({
    super.key,
    required this.customerLines,
    required this.platformLines,
    required this.totalPaidByCustomer,
    required this.netEarning,
  });

  final List<PaymentSummaryLine> customerLines;
  final List<PaymentSummaryLine> platformLines;
  final String totalPaidByCustomer;
  final String netEarning;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDarkAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          ...customerLines.map(_line),
          const Divider(color: DashboardColors.divider, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Paid by Customer', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
              Text(totalPaidByCustomer, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          ...platformLines.map(_line),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: DashboardColors.accentSoft, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Net Earning', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                Text(netEarning, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(PaymentSummaryLine l) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l.label, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
          Text(l.value, style: TextStyle(color: l.negative ? DashboardColors.danger : DashboardColors.textSecondaryDark, fontSize: 12)),
        ],
      ),
    );
  }
}
