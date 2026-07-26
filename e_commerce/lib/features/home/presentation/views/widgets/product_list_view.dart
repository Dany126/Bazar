import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key, required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // single derived value, clamped — can never produce min > max
    final listHeight = (screenHeight * 0.4).clamp(280.0, 380.0);

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.42).clamp(150.0, 190.0);

    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: cardWidth,
              child: ProductCard(product: products[index]),
            ),
          );
        },
      ),
    );
  }
}
