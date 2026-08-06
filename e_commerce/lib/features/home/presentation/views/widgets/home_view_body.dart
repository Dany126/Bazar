import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';

import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/custom_row.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/new_arrivals.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_View.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling.dart';
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
    context.read<GetCategoriesCubit>().fetchAllCategories();
    super.initState();
  }

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

        SliverToBoxAdapter(
          child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetCategoriesSuccess) {
                return CategoryListView(categories: state.categories);
              }
              if (state is GetCategoriesFailure) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Top Selling — own GetProductsCubit instance
        SliverToBoxAdapter(
          child: CustomRow(
            title: 'Top Selling',
            onTap: () {
              Navigator.pushNamed(context, TopSelling.routeName);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(
          child: BlocProvider<GetProductsCubit>(
            create: (_) =>
                getIt<GetProductsCubit>()..fetchAllProducts(page: 1, limit: 10),
            child: BlocBuilder<GetProductsCubit, GetProductsState>(
              builder: (context, state) {
                if (state is GetProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetProductsSuccess) {
                  return ProductListView(products: state.products);
                }
                if (state is GetProductsFailure) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // New Arrivals — separate GetProductsCubit instance
        SliverToBoxAdapter(
          child: CustomRow(
            title: 'New Arrivals',
            withColor: true,
            onTap: () {
              Navigator.pushNamed(context, NewArrivals.routeName);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          sliver: BlocProvider<GetProductsCubit>(
            create: (_) => getIt<GetProductsCubit>()
              ..fetchAllProducts(
                page: 1,
                limit: 10,
              ), // adjust params for "new" sort/filter
            child: BlocBuilder<GetProductsCubit, GetProductsState>(
              builder: (context, state) {
                if (state is GetProductsSuccess) {
                  return ProductGridView(products: state.products);
                }
                if (state is GetProductsLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
