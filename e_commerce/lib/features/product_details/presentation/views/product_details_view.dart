// lib/features/product_details/presenation/view/product_details_view.dart
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/cubit/product_details_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  static const String routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider<ProductDetailsCubit>(
      create: (context) =>
          getIt<ProductDetailsCubit>()..getProductDetails(productId: product),

      child: const Scaffold(body: SafeArea(child: ProductDetailsViewBody())),
    );
  }
}
