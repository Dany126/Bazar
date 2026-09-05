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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final imageAspectRatio = cardWidth < 180
            ? 0.95
            : cardWidth < 240
            ? 1.0
            : 1.08;

        final imagePadding = cardWidth < 180
            ? 8.0
            : cardWidth < 240
            ? 12.0
            : 16.0;

        final favoriteSize = cardWidth < 180 ? 22.0 : 26.0;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.kCardBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: imageAspectRatio,
                      child: Padding(
                        padding: EdgeInsets.all(imagePadding),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: fixImageUrl(product.thumbnailUrl),
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 6,
                      right: 6,
                      child: ValueListenableBuilder<Map<String, bool>>(
                        valueListenable: GetProductsCubit.favoriteProductIds,
                        builder: (context, favoriteStates, child) {
                          final isFavorite =
                              favoriteStates[product.id] ?? product.isFavorite;

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<GetProductsCubit>()
                                  .changeToIsFavourite(
                                    productId: product.id,
                                    isFavourite: !isFavorite,
                                  );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 16,
                                  sigmaY: 16,
                                ),
                                child: Container(
                                  height: favoriteSize,
                                  width: favoriteSize,
                                  alignment: Alignment.center,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isFavorite
                                        ? Icon(
                                            Icons.favorite,
                                            key: const ValueKey('favorite'),
                                            color: Colors.red,
                                            size: favoriteSize * 0.7,
                                          )
                                        : Icon(
                                            Icons.favorite_border_outlined,
                                            key: const ValueKey('not_favorite'),
                                            size: favoriteSize * 0.7,
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
                  padding: EdgeInsets.fromLTRB(
                    cardWidth < 180 ? 8 : 10,
                    4,
                    cardWidth < 180 ? 8 : 10,
                    10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.textStylesRegular12(context),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.textStylesRegular12(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
