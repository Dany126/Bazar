import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyFavouriteViewBody extends StatefulWidget {
  final List<ProductEntity> products;

  const MyFavouriteViewBody({super.key, required this.products});

  @override
  State<MyFavouriteViewBody> createState() => _MyFavouriteViewBodyState();
}

class _MyFavouriteViewBodyState extends State<MyFavouriteViewBody> {
  // Seeded once from the initial fetch (passed in by whoever calls
  // fetchFavoriteProducts before opening this screen). From here on,
  // favourite toggles update this local list directly — no refetch.
  late List<ProductEntity> _products = widget.products;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetProductsCubit, GetProductsState>(
      listenWhen: (previous, current) => current is ProductFavouriteChanged,
      listener: (context, state) {
        setState(() {
          _products = (state as ProductFavouriteChanged).products;
        });
      },
      child: Skeletonizer(
        enabled: _products.isEmpty,
        child: ProductGridView(products: _products),
      ),
    );
  }
}
