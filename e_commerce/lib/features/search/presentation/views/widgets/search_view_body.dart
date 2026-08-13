import 'package:e_commerce/core/services/get_it_services.dart';

import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_details_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/custom_search_text_faild.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/filter_chips_bar.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/search_no_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchViewBody extends StatefulWidget {
  const SearchViewBody({super.key});

  @override
  State<SearchViewBody> createState() => _SearchViewBodyState();
}

class _SearchViewBodyState extends State<SearchViewBody> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: CustomSearchTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              if (state is SearchInitial) ..._buildInitial(context),
              if (state is SearchLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (state is SearchNoResults)
                SliverFillRemaining(
                  child: SearchNoResultsView(
                    onExploreCategories: () {
                      _controller.clear();
                      context.read<SearchCubit>().clearSearch();
                    },
                  ),
                ),
              if (state is SearchFailure)
                SliverFillRemaining(child: Center(child: Text(state.message))),
              if (state is SearchSuccess) ..._buildResults(context, state),
            ],
          );
        },
      ),
    );
  }

  /// Reuses the same GetCategoriesCubit + CategoryDetailsListView already
  /// used on the Category Details screen for the "Shop by Categories" state.
  List<Widget> _buildInitial(BuildContext context) {
    return [
      BlocProvider<GetCategoriesCubit>(
        create: (_) => getIt<GetCategoriesCubit>()..fetchAllCategories(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
              builder: (context, state) {
                if (state is GetCategoriesLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is GetCategoriesFailure) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                }
                if (state is GetCategoriesSuccess) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: CategoryDetailsListView(
                      categories: state.categories,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildResults(BuildContext context, SearchSuccess state) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: FilterChipsBar(
            filter: state.filter,
            onFilterChanged: context.read<SearchCubit>().applyFilter,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: ProductGridView(products: state.products),
      ),
    ];
  }
}
