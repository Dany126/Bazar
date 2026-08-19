// lib/features/product_details/presenation/view/widgets/product_details_view_body.dart

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';

import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';

import 'package:e_commerce/features/product_details/presentation/model_view/product_details_cubit/product_details_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/product_details_cubit/product_details_state.dart';

import 'package:e_commerce/features/product_details/presentation/model_view/review_cubit/review_cubit.dart';
import 'package:e_commerce/features/product_details/presentation/model_view/review_cubit/review_state.dart';

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
    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, reviewState) {
        if (reviewState is ReviewCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review added successfully')),
          );

          final productId =
              ModalRoute.of(context)!.settings.arguments as String;

          context.read<ProductDetailsCubit>().getProductDetails(
            productId: productId,
          );

          context.read<ReviewCubit>().getProductReviews(productId);
        }

        if (reviewState is ReviewDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review deleted successfully')),
          );

          final productId =
              ModalRoute.of(context)!.settings.arguments as String;

          context.read<ProductDetailsCubit>().getProductDetails(
            productId: productId,
          );

          context.read<ReviewCubit>().getProductReviews(productId);
        }

        if (reviewState is ReviewError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(reviewState.message)));
        }
      },
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading ||
              state is ProductDetailsInitial) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            _buildBackButton(context),
                            _buildFavoriteButton(product),
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
                            'Shopping & Returns',
                            style: AppStyles.textStylesBold16Mono(context),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Free shipping on all orders over \$50.00. Free returns.',
                            style: AppStyles.textStylesRegular14(context),
                          ),

                          _buildReviewsSection(context, product),
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
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFF4F4F4),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Transform.rotate(
          angle: 3.14,
          child: Image.asset(Assets.assetsImagesArrowright),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(ProductDetailsEntity product) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFF4F4F4),
      child: IconButton(
        icon: Icon(
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: product.isFavorite ? Colors.red : Colors.black,
        ),
        onPressed: () {
          setState(() {
            product.isFavorite = !product.isFavorite;
          });
        },
      ),
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

  Widget _buildReviewsSection(
    BuildContext context,
    ProductDetailsEntity product,
  ) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, reviewState) {
        if (reviewState is ReviewLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (reviewState is ReviewError) {
          return _buildReviewsError(context, reviewState.message);
        }

        final reviews = reviewState is ReviewSuccess
            ? reviewState.reviews
            : product.reviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            _buildReviewsHeader(context, product),

            const SizedBox(height: 16),

            if (reviews.isEmpty)
              _buildEmptyReviews()
            else
              ...reviews.map(
                (review) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ReviewCard(review: review),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsHeader(
    BuildContext context,
    ProductDetailsEntity product,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Reviews', style: AppStyles.textStylesBold16Mono(context)),

            const Spacer(),

            TextButton.icon(
              onPressed: () {
                _showAddReviewSheet(context, product.id);
              },
              icon: const Icon(Icons.rate_review_outlined, size: 18),
              label: const Text('Write review'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              product.avgRating.toStringAsFixed(1),
              style: AppStyles.textStylesSemiBold24(context),
            ),

            const SizedBox(width: 10),

            _buildStars(product.avgRating),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          '${product.ratingsQuantity} Reviews',
          style: AppStyles.textStylesRegular12(
            context,
          ).copyWith(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;

        return Icon(
          rating >= value
              ? Icons.star_rounded
              : rating >= value - 0.5
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          size: 19,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.kCardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 42,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            'No reviews yet',
            style: AppStyles.textStylesBold16Mono(context),
          ),

          const SizedBox(height: 6),

          Text(
            'Be the first to review this product.',
            textAlign: TextAlign.center,
            style: AppStyles.textStylesRegular12(
              context,
            ).copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsError(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),

          const SizedBox(height: 8),

          Text(
            message,
            textAlign: TextAlign.center,
            style: AppStyles.textStylesRegular12(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      splashColor: AppColors.kPrimaryAccentColor,
      highlightColor: Colors.transparent,
      onTap: () {
        final variant = product.findVariant(
          size: selectedSize!,
          color: selectedColor!,
        );

        if (variant == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a valid size and color'),
            ),
          );
          return;
        }

        context.read<CartCubit>().addToCart(
          productId: product.id,
          quantity: quantity,
          variantId: variant.id,
        );

        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  void _showAddReviewSheet(BuildContext context, String productId) {
    final reviewCubit = context.read<ReviewCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      requestFocus: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: reviewCubit,
          child: _AddReviewSheet(productId: productId),
        );
      },
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
        onSelected: (color) {
          setState(() {
            selectedColor = color;
          });
        },
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
        onSelected: (size) {
          setState(() {
            selectedSize = size;
          });
        },
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final cleanHex = hex.replaceAll('#', '');

    return Color(int.parse('FF$cleanHex', radix: 16));
  }
}

class _AddReviewSheet extends StatefulWidget {
  const _AddReviewSheet({required this.productId});

  final String productId;

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  final controller = TextEditingController();
  double rating = 5;

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Write a Review',
                  style: AppStyles.textStylesBold16Mono(context),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() => rating = index + 1.0);
                    },
                    icon: Icon(
                      index < rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 34,
                      color: Colors.amber,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                filled: true,
                fillColor: AppColors.kCardBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                final isLoading = state is ReviewCreating;

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final description = controller.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a review')));
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<ReviewCubit>().createReview(
      productId: widget.productId,
      rating: rating,
      description: description,
    );
  }
}
