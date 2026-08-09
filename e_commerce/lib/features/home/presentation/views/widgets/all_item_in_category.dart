import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllItemsInCategoryView extends StatelessWidget {
  const AllItemsInCategoryView({super.key});

  static const routeName = 'AllItemsInCategory';

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)!.settings.arguments as CategoryEntity;

    return BlocProvider<GetProductsCubit>(
      create: (_) {
        final cubit = getIt<GetProductsCubit>();
        cubit.fetchAllProductsByCategories(
          page: 1,
          limit: 10,
          categoryId: category.id,
        );
        
        return cubit;
      },
      child: Scaffold(
        appBar: customAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: BlocBuilder<GetProductsCubit, GetProductsState>(
            builder: (context, state) {
              if (state is GetProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetProductsFailure) {
                return Center(child: Text(state.message));
              }
              if (state is GetProductsSuccess) {
                final products = state.products;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Text(
                        "${category.name} ( ${products.length} )",
                        style: AppStyles.textStylesSemiBold24(context),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      sliver: ProductGridView(products: products),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
