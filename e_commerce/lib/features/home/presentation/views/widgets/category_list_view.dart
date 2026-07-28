import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/all_item_in_category.dart';
import 'package:flutter/material.dart';

class CategoryListView extends StatelessWidget {
  CategoryListView({super.key});
  final List<CategoryEntity> categories = [
    CategoryEntity(id: "1", name: 'hoodies', imageUrl: Assets.assetsImagesC1),
    CategoryEntity(id: "2", name: 'Shorts', imageUrl: Assets.assetsImagesC2),
    CategoryEntity(id: "3", name: 'Bags', imageUrl: Assets.assetsImagesC4),
    CategoryEntity(id: "4", name: 'Shoes', imageUrl: Assets.assetsImagesC3),
    CategoryEntity(
      id: "5",
      name: 'Accessories',
      imageUrl: Assets.assetsImagesC5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final listHeight = (screenHeight * 0.12).clamp(80.0, 110.0);

    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(categories: categories[index]);
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.categories});
  final CategoryEntity categories;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AllItemsInCategoryView.routeName,
          arguments: {'category': categories, 'products': kDumyProducts},
        );
      },
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 10),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Container(
                height: 56,
                width: 56,
                color: AppColors.kSecondaryAccentColor.withAlpha(40),
                child: Image.asset(categories.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              categories.name,
              style: AppStyles.textStylesRegular12(context),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
