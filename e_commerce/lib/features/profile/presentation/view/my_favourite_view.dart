import 'package:e_commerce/core/widgets/custom_app_bar.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_state.dart';
import 'package:e_commerce/features/profile/presentation/view/widgets/my_favourite_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavouriteView extends StatefulWidget {
  const MyFavouriteView({super.key});
  static const routeName = 'myFavourite';

  @override
  State<MyFavouriteView> createState() => _MyFavouriteViewState();
}

class _MyFavouriteViewState extends State<MyFavouriteView> {
  @override
  initState() {
    super.initState();
    context.read<GetProductsCubit>().fetchFavoriteProducts(page: 10, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Favorites'),
      body: BlocBuilder<GetProductsCubit, GetProductsState>(
        builder: (context, state) {
          if (state is GetProductsSuccess) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            return MyFavouriteViewBody(products: state.products);
          } else if (state is GetProductsFailure) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
