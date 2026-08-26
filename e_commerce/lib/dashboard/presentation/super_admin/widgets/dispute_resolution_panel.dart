import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/status_badge.dart';

/// Side panel shown when a disputed order row is selected — customer
/// message, evidence photos, and a resolution action.
class DisputeResolutionPanel extends StatelessWidget {
  const DisputeResolutionPanel({
    super.key,
    required this.orderId,
    required this.filedAt,
    required this.customerEmail,
    required this.productName,
    required this.customerMessage,
    this.evidenceImageUrls = const [],
    this.onClose,
    this.onForceRefund,
  });

  final String orderId;
  final String filedAt;
  final String customerEmail;
  final String productName;
  final String customerMessage;
  final List<String> evidenceImageUrls;
  final VoidCallback? onClose;
  final VoidCallback? onForceRefund;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: DashboardColors.danger.withOpacity(0.08),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StatusBadge(label: 'DISPUTED', tone: StatusTone.danger),
                      const SizedBox(height: 6),
                      Text('Filed $filedAt', style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: DashboardColors.textSecondaryLight),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _field('Order ID', orderId),
                    ),
                    Expanded(
                      child: _field('Customer', customerEmail),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  child: const Text('View Profile', style: TextStyle(color: DashboardColors.accent, fontSize: 12)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: DashboardColors.contentBgDark, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(width: 10),
                    Text(productName, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: DashboardColors.danger.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
                  child: Text('"$customerMessage"',
                      style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontStyle: FontStyle.italic, height: 1.5)),
                ),
                const SizedBox(height: 16),
                const Text('Customer Evidence (2)', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(evidenceImageUrls.isEmpty ? 2 : evidenceImageUrls.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: DashboardColors.contentBgDark,
                          borderRadius: BorderRadius.circular(10),
                          image: evidenceImageUrls.isNotEmpty
                              ? DecorationImage(image: NetworkImage(evidenceImageUrls[i]), fit: BoxFit.cover)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Dismiss', style: TextStyle(fontSize: 12.5)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onForceRefund,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DashboardColors.danger,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Force Refund', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
