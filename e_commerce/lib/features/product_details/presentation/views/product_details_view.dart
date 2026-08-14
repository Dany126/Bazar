// lib/features/product_details/presenation/view/product_details_view.dart
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/cubit/product_details_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.productId});

  static const String routeName = '/product-details';

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (context) =>
          getIt<ProductDetailsCubit>()..getProductDetails(productId: productId),
      child: const Scaffold(body: ProductDetailsViewBody()),
    );
  }
}
