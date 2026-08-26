import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/review_card.dart';
import 'widgets/store_rating_card.dart';

/// Seller: Reviews & Ratings — store rating summary and recent reviews.
class SellerReviewsView extends StatelessWidget {
  const SellerReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.reviews),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reviews & Ratings', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Manage customer feedback for your store.', style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 12.5)),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: StoreRatingCard(rating: 4.8, totalReviews: 1369, breakdown: [82, 11, 4, 2, 1]),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recent Reviews', style: TextStyle(color: DashboardColors.textPrimaryLight, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        const ReviewCard(
                          customerName: 'Alex M.',
                          rating: 5,
                          productName: 'Vintage Leather Biker Jacket',
                          reviewText: '"Exceeded my expectations — the leather is buttery soft and the fit is spot on. Shipping was quick too!"',
                        ),
                        const ReviewCard(
                          customerName: 'Nadia R.',
                          rating: 4,
                          productName: 'Classic Canvas High-Tops',
                          reviewText: '"Comfortable and stylish, though sizing runs a little large — I\'d recommend going down half a size."',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
