import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.customerName,
    required this.rating,
    required this.productName,
    required this.reviewText,
    this.avatarUrl,
  });

  final String customerName;
  final int rating;
  final String productName;
  final String reviewText;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: DashboardColors.cardBgLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: DashboardColors.accentSoft,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Icons.person, size: 16, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customerName, style: const TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, size: 13, color: i < rating ? const Color(0xFFF5A623) : DashboardColors.dividerLight))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: DashboardColors.accentSoft, borderRadius: BorderRadius.circular(8)),
            child: Text(productName, style: const TextStyle(color: DashboardColors.accent, fontSize: 10.5, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          Text(reviewText, style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12, height: 1.5)),
          const SizedBox(height: 8),
          const Text('Reply', style: TextStyle(color: DashboardColors.accent, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
