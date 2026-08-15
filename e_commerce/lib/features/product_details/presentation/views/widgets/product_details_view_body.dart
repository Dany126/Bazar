// lib/features/product_details/presenation/view/widgets/product_details_view_body.dart
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/cubit/product_details_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/cubit/product_details_state.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/color_picker_sheet.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/image_gallery.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/quantity_stepper.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/review_card.dart';
import 'package:e_commerce/features/product_details/presentation/views/widgets/size_picker_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kProductAccentColor = Color(0xFF7B61FF);

class ProductDetailsViewBody extends StatefulWidget {
  const ProductDetailsViewBody({super.key});

  @override
  State<ProductDetailsViewBody> createState() => _ProductDetailsViewBodyState();
}

class _ProductDetailsViewBodyState extends State<ProductDetailsViewBody> {
  String? selectedColor;
  String? selectedSize;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is ProductDetailsLoading || state is ProductDetailsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductDetailsError) {
          return _buildErrorState(context, state.message);
        }

        if (state is ProductDetailsLoaded) {
          final product = state.product;

          selectedColor ??= product.colors.isNotEmpty
              ? product.colors.first
              : null;
          selectedSize ??= product.sizes.isNotEmpty
              ? product.sizes.first
              : null;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverAppBar(
                      expandedHeight:
                          MediaQuery.of(context).size.height * 0.001,

                      floating: true,
                      snap: true,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFF4F4F4),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Transform.rotate(
                                angle: 3.14,
                                child: Image.asset(
                                  Assets.assetsImagesArrowright,
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: const Color(0xFFF4F4F4),
                            child: IconButton(
                              icon: Icon(
                                product.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: product.isFavorite
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  product.isFavorite = !product.isFavorite;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: ProductImageGallery(images: product.images),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTitleAndPrice(product),
                        const SizedBox(height: 16),
                        _buildSizeRow(context, product),
                        const Divider(height: 24),
                        _buildColorRow(context, product),
                        const Divider(height: 24),
                        _buildQuantityRow(product),
                        const SizedBox(height: 20),
                        if (product.description != null)
                          Text(
                            product.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          "Shopping & Returns",
                          style: AppStyles.textStylesBold16Mono(context),
                        ),

                        _buildReviewsHeader(product),
                        const SizedBox(height: 12),
                        ...product.reviews.map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ReviewCard(review: review),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(context, product),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTitleAndPrice(ProductDetailsEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: AppStyles.textStylesBold16Mono(context)),
        const SizedBox(height: 5),
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: AppStyles.textStylesBold16Mono(
            context,
          ).copyWith(color: kProductAccentColor),
        ),
      ],
    );
  }

  Widget _buildSizeRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: () => _openSizeSheet(context, product),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size',
              style: AppStyles.textStylesRegular16(
                context,
              ).copyWith(color: Colors.black),
            ),
            Row(
              children: [
                Text(
                  selectedSize ?? '-',
                  style: AppStyles.textStylesRegular16(context),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: 3.14 / 2, // Rotation angle in radians
                  child: Image.asset(Assets.assetsImagesArrowright, height: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: () => _openColorSheet(context, product),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.kCardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Color',
              style: AppStyles.textStylesRegular16(
                context,
              ).copyWith(color: Colors.black),
            ),
            Row(
              children: [
                if (selectedColor != null)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorFromHex(selectedColor!),
                    ),
                  ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: 3.14 / 2,
                  child: Image.asset(Assets.assetsImagesArrowright, height: 25),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityRow(ProductDetailsEntity product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kCardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Quantity',
            style: AppStyles.textStylesRegular16(
              context,
            ).copyWith(color: Colors.black),
          ),
          QuantityStepper(
            quantity: quantity,
            onChanged: (value) {
              setState(() {
                quantity = value;
              });
            },
            maxQuantity: product.stock,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsHeader(ProductDetailsEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Reviews', style: AppStyles.textStylesBold16Mono(context)),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              '${product.avgRating} Ratings',
              style: AppStyles.textStylesSemiBold24(context),
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${product.ratingsQuantity} Reviews',
          style: AppStyles.textStylesRegular12(context),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      splashColor: AppColors.kPrimaryAccentColor,
      highlightColor: Colors.transparent,
      onTap: () {
        context.read<CartCubit>().addToCart(
          productId: product.id,
          quantity: quantity,
          variantId: product
              .findVariant(size: selectedSize!, color: selectedColor!)!
              .id,
        );
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            decoration: BoxDecoration(
              color: AppColors.kPrimaryAccentColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Text(
                  '\$${(product.price * quantity).toStringAsFixed(0)}',
                  style: AppStyles.textStylesBold16Mono(
                    context,
                  ).copyWith(color: Colors.white),
                ),

                const Spacer(),
                Text(
                  'Add to Cart',
                  style: AppStyles.textStylesBold16Mono(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _openColorSheet(BuildContext context, ProductDetailsEntity product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ColorPickerSheet(
        colors: product.colors,
        selectedColor: selectedColor,
        onSelected: (color) => setState(() => selectedColor = color),
      ),
    );
  }

  void _openSizeSheet(BuildContext context, ProductDetailsEntity product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SizePickerSheet(
        sizes: product.sizes,
        selectedSize: selectedSize,
        onSelected: (size) => setState(() => selectedSize = size),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanHex', radix: 16));
  }
}
