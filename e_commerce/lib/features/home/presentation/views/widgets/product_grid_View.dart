import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:e_commerce/features/product_details/presentation/views/product_details_view.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key, required this.products});

  final List<ProductEntity> products;

  int _getCrossAxisCount(double width) {
    if (width < 360) {
      return 2;
    }

    if (width < 600) {
      return 2;
    }

    if (width < 900) {
      return 3;
    }

    if (width < 1200) {
      return 4;
    }

    if (width < 1600) {
      return 5;
    }

    return 6;
  }

  double _getAspectRatio(double width) {
    if (width < 600) {
      return 0.68;
    }

    if (width < 900) {
      return 0.72;
    }

    if (width < 1200) {
      return 0.75;
    }

    return 0.78;
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;

        final crossAxisCount = _getCrossAxisCount(width);
        final aspectRatio = _getAspectRatio(width);

        return SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: width >= 900 ? 20 : 16,
            crossAxisSpacing: width >= 900 ? 20 : 16,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductCard(
              product: product,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  ProductDetailsView.routeName,
                  arguments: product.id,
                );
              },
            );
          },
        );
      },
    );
  }
}
