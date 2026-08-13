import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/search/presentation/views/search_view.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SearchView.routeName);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.kSecondaryAccentColor.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Image.asset(
                Assets.assetsImagesSearchIcon,
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text('Search', style: AppStyles.textStylesRegular12(context)),
          ],
        ),
      ),
    );
  }
}
