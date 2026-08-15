import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:e_commerce/features/product_details/presentation/views/product_details_view.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: widget.products.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.63,
      ),

      itemBuilder: (context, index) {
        return ProductCard(
          product: widget.products[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailsView.routeName,
              arguments: widget.products.map((e) => e.id).toList()[index],
            );
          },
        );
      },
    );
  }
}
