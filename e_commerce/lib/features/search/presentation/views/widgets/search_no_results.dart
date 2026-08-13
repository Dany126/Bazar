import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

/// "Sorry, we couldn't find any matching result for your Search"
class SearchNoResultsView extends StatelessWidget {
  const SearchNoResultsView({super.key, required this.onExploreCategories});

  final VoidCallback onExploreCategories;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3D6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 44,
                color: Color(0xFFF5A623),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Sorry, we couldn't find any matching result for your Search",
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular16(context),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onExploreCategories,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text('Explore Categories'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
