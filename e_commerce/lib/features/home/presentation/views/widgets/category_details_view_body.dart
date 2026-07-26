import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_details_list_view.dart';
import 'package:flutter/material.dart';

class CategoryDetailsViewBody extends StatelessWidget {
  CategoryDetailsViewBody({super.key});

  final List<CategoryEntity> categories = [
    CategoryEntity(id: 1, name: 'hoodies', imageUrl: Assets.assetsImagesC1),
    CategoryEntity(id: 2, name: 'Shorts', imageUrl: Assets.assetsImagesC2),
    CategoryEntity(id: 3, name: 'Bags', imageUrl: Assets.assetsImagesC4),
    CategoryEntity(id: 4, name: 'Shoes', imageUrl: Assets.assetsImagesC3),
    CategoryEntity(id: 5, name: 'Accessories', imageUrl: Assets.assetsImagesC5),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'Shop by Categories',
                style: AppStyles.textStylesSemiBold24(context),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: CategoryDetailsListView(categories: categories),
        ),
      ],
    );
  }
}
