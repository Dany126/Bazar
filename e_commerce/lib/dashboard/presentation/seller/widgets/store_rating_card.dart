import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';
import '../../widgets/common/section_card.dart';

class StoreRatingCard extends StatelessWidget {
  const StoreRatingCard({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.breakdown,
  });

  final double rating;
  final int totalReviews;

  /// Percent (0-100) of reviews for 5,4,3,2,1 stars, in that order.
  final List<int> breakdown;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      background: DashboardColors.cardBgLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Store Rating', style: TextStyle(color: DashboardColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(rating.toStringAsFixed(1), style: const TextStyle(color: DashboardColors.accent, fontSize: 32, fontWeight: FontWeight.w800)),
              const Text(' / 5', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(5, (i) => const Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 18)),
          ),
          const SizedBox(height: 6),
          Text('Based on $totalReviews reviews', style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11.5)),
          const SizedBox(height: 20),
          for (var i = 0; i < breakdown.length; i++) _bar(5 - i, breakdown[i]),
        ],
      ),
    );
  }

  Widget _bar(int stars, int percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('$stars star', style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 6,
                backgroundColor: DashboardColors.contentBgLight,
                valueColor: const AlwaysStoppedAnimation(DashboardColors.accent),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 32, child: Text('$percent%', style: const TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 11))),
        ],
      ),
    );
  }
}
