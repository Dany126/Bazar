import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/views/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final List<ProductEntity> products = [
    ProductEntity(
      id: 1,
      name: "Men's Harrington Jacket",
      price: 148.00,
      image: Assets.assetsImagesD1,
    ),
    ProductEntity(
      id: 2,
      name: "Women's Puffer Vest",
      price: 89.00,
      image: Assets.assetsImagesD2,
    ),
  ];

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
              child: ProductCard(
                product: products[index],
                onTap: () {},
                onFavoriteTap: () {
                  products[index].isFavorite = !products[index].isFavorite;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
