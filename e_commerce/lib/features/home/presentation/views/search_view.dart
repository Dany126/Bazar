
import 'package:e_commerce/features/home/presentation/views/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    super.key,
  });

  static const routeName = 'search';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final query = value.trim();

    // Connect this to SearchCubit later.
    //
    // context.read<SearchCubit>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        titleSpacing: 16,

        title: CustomSearchBar(
          isSearch: false,
          controller: searchController,
          onChanged: _onSearchChanged,
          onSubmitted: (value) {
            final query = value.trim();

            if (query.isEmpty) {
              return;
            }

            // context.read<SearchCubit>().search(query);
          },
          onClear: () {
            // context.read<SearchCubit>().clear();
          },
        ),

        leadingWidth:
            MediaQuery.of(context).size.width * 0.18,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Material(
            color: const Color(0xFFF2F2F5),
            shape: const CircleBorder(),

            child: InkWell(
              customBorder: const CircleBorder(),

              onTap: () {
                Navigator.of(context).maybePop();
              },

              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.chevron_left,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),

      body: const SearchViewBody(),
    );
  }
}

class SearchViewBody extends StatelessWidget {
  const SearchViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),

      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),

          sliver: SliverToBoxAdapter(
            child: Text(
              'Search results',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),

        // Your product grid will go here.
        //
        // SliverGrid(...)
      ],
    );
  }
}

