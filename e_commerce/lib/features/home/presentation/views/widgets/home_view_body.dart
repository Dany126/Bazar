import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';

import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';

import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';

import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';
import 'package:e_commerce/features/home/presentation/views/search_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/custom_row.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/new_arrivals.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();

    context.read<GetCategoriesCubit>().fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,

          backgroundColor: Colors.transparent,

          elevation: 0,

          leading: Image.asset(
            Assets.assetsImagesProfile,

            height: 40,

            width: 40,
          ),

          title: Text("Bazar", style: AppStyles.textStylesSemiBold20(context)),

          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),

              child: Container(
                decoration: const ShapeDecoration(
                  color: AppColors.kPrimaryColor,

                  shape: CircleBorder(),
                ),

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
          ],
        ),

        SliverToBoxAdapter(
          child: CustomSearchBar(
            isSearch: false,
            onTap: () {
              Navigator.pushNamed(context, SearchView.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        SliverToBoxAdapter(
          child: CustomRow(
            title: "Categories",

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
                return Skeletonizer(
                  enabled: true,
                  child: CategoryListView(categories: []),
                );
              }

              if (state is GetCategoriesSuccess) {
                return CategoryListView(categories: state.categories);
              }

              if (state is GetCategoriesFailure) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        SliverToBoxAdapter(
          child: CustomRow(
            title: "Top Selling",

            onTap: () {
              Navigator.pushNamed(context, TopSelling.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        SliverToBoxAdapter(
          child: BlocProvider<GetProductsCubit>(
            create: (_) =>
                getIt<GetProductsCubit>()
                  ..fetchBestSellingProducts(page: 1, limit: 10),

            child: BlocBuilder<GetProductsCubit, GetProductsState>(
              builder: (context, state) {
                if (state is GetProductsLoading) {
                  return Skeletonizer(
                    enabled: true,

                    child: ProductListView(products: kFakeProducts),
                  );
                }

                if (state is GetProductsSuccess) {
                  return ProductListView(products: state.products);
                }

                return const SizedBox();
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        SliverToBoxAdapter(
          child: CustomRow(
            title: "New Arrivals",

            withColor: true,

            onTap: () {
              Navigator.pushNamed(context, NewArrivals.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        BlocProvider<GetProductsCubit>(
          create: (_) =>
              getIt<GetProductsCubit>()..fetchNewProducts(page: 1, limit: 10),

          child: BlocBuilder<GetProductsCubit, GetProductsState>(
            builder: (context, state) {
              if (state is GetProductsLoading) {
                return Skeletonizer.sliver(
                  enabled: true,

                  child: ProductGridView(products: kFakeProducts),
                );
              }

              if (state is GetProductsSuccess) {
                return ProductGridView(products: state.products);
              }

              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
