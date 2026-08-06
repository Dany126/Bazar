import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_details_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDetailsViewBody extends StatelessWidget {
  const CategoryDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetCategoriesCubit>(
      create: (_) => getIt<GetCategoriesCubit>()..fetchAllCategories(),
      child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
        builder: (context, state) {
          if (state is GetCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetCategoriesFailure) {
            return Center(child: Text(state.message));
            
          }
          if (state is GetCategoriesSuccess) {
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
                  sliver: CategoryDetailsListView(categories: state.categories),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}