import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:e_commerce/features/product_details/presentation/views/product_details_view.dart';
import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key, required this.products});

  final List<ProductEntity> products;

  double _getCardWidth(double screenWidth) {
    if (screenWidth < 360) {
      return 145;
    }

    if (screenWidth < 600) {
      return 165;
    }

    if (screenWidth < 900) {
      return 200;
    }

    if (screenWidth < 1200) {
      return 220;
    }

    return 240;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final cardWidth = _getCardWidth(screenWidth);

    // Keep the same visual proportions as ProductCard.
    // ProductCard image is approximately square + text section.
    final cardHeight = cardWidth + 78;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];

          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ProductCard(
              product: product,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductDetailsView.routeName,
                  arguments: product.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
