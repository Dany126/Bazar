// lib/features/product_details/presenation/view/widgets/product_details_view_body.dart
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
                        _buildExpandableRow('Shipping & Returns'),
                        const Divider(height: 24),
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
        Text(
          product.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kProductAccentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSizeRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: () => _openSizeSheet(context, product),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Size', style: TextStyle(fontSize: 15)),
          Row(
            children: [
              Text(
                selectedSize ?? '-',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: () => _openColorSheet(context, product),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Color', style: TextStyle(fontSize: 15)),
          Row(
            children: [
              if (selectedColor != null)
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _colorFromHex(selectedColor!),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityRow(ProductDetailsEntity product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Quantity', style: TextStyle(fontSize: 15)),
        QuantityStepper(
          quantity: quantity,
          onChanged: (value) => setState(() => quantity = value),
          maxQuantity: product.stock,
        ),
      ],
    );
  }

  Widget _buildExpandableRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const Icon(Icons.keyboard_arrow_down, size: 20),
      ],
    );
  }

  Widget _buildReviewsHeader(ProductDetailsEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${product.avgRating} Ratings',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              '${product.ratingsQuantity} Reviews',
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetailsEntity product) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: product.stock > 0 ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kProductAccentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Add to Bag'),
              ),
            ),
          ],
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
