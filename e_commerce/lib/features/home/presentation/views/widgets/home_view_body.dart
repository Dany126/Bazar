import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/auth/domain/entity/user_entity.dart';
import 'package:e_commerce/features/cart/presentation/view/cart_view.dart';

import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';

import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';

import 'package:e_commerce/features/home/presentation/views/category_details_view.dart';

import 'package:e_commerce/features/home/presentation/views/widgets/category_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/custom_row.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/new_arrivals.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/top_selling.dart';

import 'package:e_commerce/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_commerce/features/profile/presentation/cubit/profile_state.dart';

import 'package:e_commerce/main_view.dart';

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

    // Load the cached user so the profile image/name
    // is immediately available on Home.
    getIt<ProfileCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,

          leading: BlocBuilder<ProfileCubit, ProfileState>(
            bloc: getIt<ProfileCubit>(),
            builder: (context, state) {
              UserEntity? user;

              if (state is ProfileLoaded) {
                user = state.user;
              } else if (state is ProfileUpdating) {
                user = state.user;
              } else if (state is ProfileUpdated) {
                user = state.user;
              }

              return GestureDetector(
                onTap: () {
                  MainView.currentIndex = 3;
                  setState(() {});
                },
                child: _buildProfileImage(user),
              );
            },
          ),

          title: Text("Bazar", style: AppStyles.textStylesSemiBold20(context)),

          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, CartView.routeName);
              },
              child: Padding(
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
            ),
          ],
        ),

        // ----------------------------------------------------------
        // SEARCH
        // ----------------------------------------------------------
        SliverToBoxAdapter(child: CustomSearchBar()),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // ----------------------------------------------------------
        // CATEGORIES TITLE
        // ----------------------------------------------------------
        SliverToBoxAdapter(
          child: CustomRow(
            title: "Categories",
            onTap: () {
              Navigator.pushNamed(context, CategoryDetailsView.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ----------------------------------------------------------
        // CATEGORIES
        // ----------------------------------------------------------
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

        // ----------------------------------------------------------
        // TOP SELLING TITLE
        // ----------------------------------------------------------
        SliverToBoxAdapter(
          child: CustomRow(
            title: "Top Selling",
            onTap: () {
              Navigator.pushNamed(context, TopSelling.routeName);
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // ----------------------------------------------------------
        // TOP SELLING PRODUCTS
        // ----------------------------------------------------------
        SliverToBoxAdapter(
          child: BlocProvider<GetProductsCubit>(
            create: (_) {
              return getIt<GetProductsCubit>()
                ..fetchBestSellingProducts(page: 1, limit: 10);
            },
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

        // ----------------------------------------------------------
        // NEW ARRIVALS TITLE
        // ----------------------------------------------------------
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

        // ----------------------------------------------------------
        // NEW ARRIVALS PRODUCTS
        // ----------------------------------------------------------
        BlocProvider<GetProductsCubit>(
          create: (_) {
            return getIt<GetProductsCubit>()
              ..fetchNewProducts(page: 1, limit: 10);
          },
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

  // ================================================================
  // PROFILE IMAGE
  // ================================================================

  Widget _buildProfileImage(UserEntity? user) {
    final imageUrl = user?.imageUrl?.trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultProfileImage(user);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return _buildDefaultProfileImage(user);
          },
        ),
      );
    }

    return _buildDefaultProfileImage(user);
  }

  // ================================================================
  // DEFAULT PROFILE IMAGE
  // ================================================================

  Widget _buildDefaultProfileImage(UserEntity? user) {
    final name = user?.name.trim() ?? '';

    // No user/name available
    if (name.isEmpty) {
      return Image.asset(Assets.assetsImagesProfile, height: 40, width: 40);
    }

    // Show first letter of user's name
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.kPrimaryColor,
      ),
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}
