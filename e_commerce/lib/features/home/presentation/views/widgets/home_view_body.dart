import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/category_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/custom_row.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling_list_view.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,

          elevation: 0,
          leading: FittedBox(
            fit: BoxFit.scaleDown,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  Assets.assetsImagesProfile,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),

          title: Text('Bazar', style: AppStyles.textStylesSemiBold20(context)),
          actions: [
            Container(
              decoration: ShapeDecoration(
                color: AppColors.kPrimaryColor,
                shape: const CircleBorder(),
              ),
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Image.asset(
                    Assets.assetsImagesBagIcon,
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: const CustomSearchBar()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        SliverToBoxAdapter(
          child: CustomRow(title: 'Categories', onTap: () {}),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(child: CategoryListView()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(
          child: CustomRow(title: 'Top Selling', onTap: () {}),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(child: ProductListView()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: CustomRow(
            title: 'New Arrivals',
            withColor: true,
            onTap: () {},
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: ProductListView()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}
