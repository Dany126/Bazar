import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/all_item_in_category.dart';
import 'package:flutter/material.dart';

class CategoryDetailsListView extends StatelessWidget {
  const CategoryDetailsListView({super.key, required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),

          child: SizedBox(
            height: 50,

            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AllItemsInCategoryView.routeName,
                  arguments: {
                    'category': categories[index],
                    'products': kDumyProducts,
                  },
                );
              },

              contentPadding: const EdgeInsets.symmetric(horizontal: 16),

              tileColor: AppColors.kCardBackgroundColor,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),

              title: Text(
                categories[index].name,
                style: AppStyles.textStylesRegular16(context),
              ),

              leading: ClipOval(
                child: Image.asset(
                  categories[index].imageUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }, childCount: categories.length),
    );
  }
}
