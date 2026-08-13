import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/category_details_list_view.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';
import 'package:e_commerce/features/search/presentation/cubit/search_cubit.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/filter_chips_bar.dart';
import 'package:e_commerce/features/search/presentation/views/widgets/search_no_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Adjust this to wherever your generated asset class actually lives
// (e.g. package:e_commerce/generated/assets.dart via flutter_gen).

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (_) => getIt<SearchCubit>(),
      child: const SearchViewBody(),
    );
  }
}

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
      /*************  ✨ Windsurf Command ⭐  *************/
      ///
      /// Dispose all the resources used by this widget.
      ///
      /// This is called automatically when the widget is removed from the
      /// tree. In addition, it should be called when this is no longer
      /// needed. Omitting to call this method may result in memory leaks or
      /// other problems.
      /*******  e4f70a69-d688-4a34-800f-5d853c216080  *******/
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
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    style: AppStyles.textStylesRegular12(context),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.kSecondaryAccentColor.withAlpha(40),
                      hintText: 'Search',
                      hintStyle: AppStyles.textStylesRegular12(context),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          Assets.assetsImagesSearchIcon,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      // Single source of truth for the clear button — driven
                      // by _controller directly, so no extra state field
                      // (_hasText) is needed.
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, value, _) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _controller.clear();
                              context.read<SearchCubit>().clearSearch();
                            },
                          );
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: context.read<SearchCubit>().onQueryChanged,
                    onSubmitted: context.read<SearchCubit>().submitQuery,
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
