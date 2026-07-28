import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/get_category_products_cubit/get_category_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/cubit/home_cubit/home_states.dart';

import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/category_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/custom_row.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_View.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    context.read<CategoryProductsCubit>().fetchProducts();
    // Note: HomeCubit.fetchHomeData() should be called wherever HomeCubit
    // is provided (e.g. in the parent that provides it), not here — this
    // widget is only built once state is already HomeLoaded.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state as HomeLoaded;

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
              child: Image.asset(
                Assets.assetsImagesProfile,
                height: 40,
                width: 40,
              ),
            ),
          ),

          title: Text('Bazar', style: AppStyles.textStylesSemiBold20(context)),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: const ShapeDecoration(
                  color: AppColors.kPrimaryColor,
                  shape: CircleBorder(),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Image(
                      image: AssetImage(Assets.assetsImagesBagIcon),
                      height: 16,
                      width: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Search
        const SliverToBoxAdapter(child: CustomSearchBar()),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Categories
        SliverToBoxAdapter(
          child: CustomRow(
            title: 'Categories',
            onTap: () {
              Navigator.pushNamed(context, CategoryDetailsView.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(child: CategoryListView()),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Top Selling
        SliverToBoxAdapter(
          child: CustomRow(title: 'Top Selling', onTap: () {}),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(
          child: ProductListView(products: state.bestSellingProducts),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // New Arrivals
        SliverToBoxAdapter(
          child: CustomRow(
            title: 'New Arrivals',
            withColor: true,
            onTap: () {},
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: ProductGridView(products: state.newProducts),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
