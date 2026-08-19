import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopSelling extends StatelessWidget {
  const TopSelling({super.key});
  static const routeName = 'top_selling';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetProductsCubit>(
      create: (_) =>
          getIt<GetProductsCubit>()
            ..fetchBestSellingProducts(page: 1, limit: 50),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Text(
                    'Top Selling',
                    style: AppStyles.textStylesSemiBold24(context),
                  ),
                ),
              ),
              BlocBuilder<GetProductsCubit, GetProductsState>(
                builder: (context, state) {
                  if (state is GetProductsLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is GetProductsFailure) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    );
                  }
                  if (state is GetProductsSuccess) {
                    return ProductGridView(products: state.products);
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
