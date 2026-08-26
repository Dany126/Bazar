import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/labeled_value_row.dart';
import '../../widgets/common/section_card.dart';
import '../../widgets/common/status_badge.dart';

class RiskAssessmentCard extends StatelessWidget {
  const RiskAssessmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Assessment',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          const Divider(color: DashboardColors.divider, height: 20),
          const LabeledValueRow(label: 'Identity Verification', value: 'Verified', valueTone: StatusTone.success),
          const LabeledValueRow(label: 'Bank Account', value: 'Linked', valueTone: StatusTone.success),
          const LabeledValueRow(label: 'Risk Score', value: 'Low Risk (12/100)', valueTone: StatusTone.success),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View Full Background Check',
                  style: TextStyle(color: DashboardColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
