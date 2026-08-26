import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';
import '../../widgets/common/status_badge.dart';

class SellerApplicationCard extends StatelessWidget {
  const SellerApplicationCard({
    super.key,
    required this.storeName,
    required this.submittedDate,
    required this.description,
    required this.businessName,
    required this.taxId,
    required this.businessType,
    required this.email,
    this.logoUrl,
  });

  final String storeName;
  final String submittedDate;
  final String description;
  final String businessName;
  final String taxId;
  final String businessType;
  final String email;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: DashboardColors.cardBgDarkAlt,
              borderRadius: BorderRadius.circular(12),
              image: logoUrl != null
                  ? DecorationImage(image: NetworkImage(logoUrl!), fit: BoxFit.cover)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(storeName,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    const StatusBadge(label: 'Pending Review', tone: StatusTone.warning),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Application submitted $submittedDate',
                    style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12)),
                const SizedBox(height: 10),
                Text(description,
                    style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5, height: 1.5)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _field('Business Name', businessName)),
                    Expanded(child: _field('Tax ID', taxId)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _field('Business Type', businessType)),
                    Expanded(child: _field('Email', email)),
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
        Text(label, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
