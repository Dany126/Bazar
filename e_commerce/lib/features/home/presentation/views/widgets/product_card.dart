import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/home/presentation/viewModel/products_cubit/get_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductEntity product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CachedNetworkImage(
                      imageUrl: fixImageUrl(product.thumbnailUrl),
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ),
                ),

                // ==================================================
                // FAVOURITE BUTTON
                // ==================================================
                Positioned(
                  top: 5,
                  right: 8,
                  child: ValueListenableBuilder<Map<String, bool>>(
                    valueListenable: GetProductsCubit.favoriteProductIds,
                    builder: (context, favoriteStates, child) {
                      final bool isFavorite =
                          favoriteStates[product.id] ?? product.isFavorite;

                      return GestureDetector(
                        onTap: () {
                          context.read<GetProductsCubit>().changeToIsFavourite(
                            productId: product.id,
                            isFavourite: !isFavorite,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: isFavorite
                                    ? const Icon(
                                        Icons.favorite,
                                        key: ValueKey('favorite'),
                                        color: Colors.red,
                                        size: 18,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        key: ValueKey('not_favorite'),
                                        size: 18,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),

                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.textStylesRegular12(context),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppStyles.textStylesRegular12(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
