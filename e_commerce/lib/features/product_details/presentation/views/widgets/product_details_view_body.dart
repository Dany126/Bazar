import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';

import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/domain/entity/variant_entity.dart';

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

  String? _lastProductId;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewCubit, ReviewState>(
      listener: (context, reviewState) {
        if (reviewState is ReviewCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review added successfully')),
          );

          _refreshProductAndReviews(context);
        }

        if (reviewState is ReviewDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review deleted successfully')),
          );

          _refreshProductAndReviews(context);
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

            _initializeVariantSelection(product);

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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildTitleAndPrice(product),

                          const SizedBox(height: 16),

                          _buildSelectedVariantInfo(context, product),

                          const SizedBox(height: 12),

                          _buildSizeRow(context, product),

                          const Divider(height: 24),

                          _buildColorRow(context, product),

                          const Divider(height: 24),

                          _buildQuantityRow(product),

                          const SizedBox(height: 20),

                          if (product.description != null &&
                              product.description!.trim().isNotEmpty)
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

  // ============================================================
  // VARIANT INITIALIZATION
  // ============================================================

  void _initializeVariantSelection(ProductDetailsEntity product) {
    if (_lastProductId == product.id) {
      return;
    }

    _lastProductId = product.id;

    quantity = 1;

    if (product.variants.isEmpty) {
      selectedColor = null;
      selectedSize = null;
      return;
    }

    final firstVariant = product.variants.first;

    selectedSize = firstVariant.size.isNotEmpty ? firstVariant.size : null;

    selectedColor = firstVariant.color.isNotEmpty ? firstVariant.color : null;
  }

  // ============================================================
  // FIND SELECTED VARIANT
  // ============================================================

  VariantEntity? _getSelectedVariant(ProductDetailsEntity product) {
    if (selectedSize == null || selectedColor == null) {
      return null;
    }

    if (selectedSize!.isEmpty || selectedColor!.isEmpty) {
      return null;
    }

    return product.findVariant(size: selectedSize!, color: selectedColor!);
  }

  // ============================================================
  // SELECT SIZE
  // ============================================================

  void _selectSize(ProductDetailsEntity product, String size) {
    final variantsWithSize = product.variants
        .where((variant) => variant.size == size)
        .toList();

    if (variantsWithSize.isEmpty) {
      return;
    }

    final currentColorVariant = variantsWithSize.where(
      (variant) => variant.color == selectedColor,
    );

    setState(() {
      selectedSize = size;

      if (currentColorVariant.isEmpty) {
        selectedColor = variantsWithSize.first.color;
      }

      quantity = 1;
    });
  }

  // ============================================================
  // SELECT COLOR
  // ============================================================

  void _selectColor(ProductDetailsEntity product, String color) {
    final variantsWithColor = product.variants
        .where((variant) => variant.color == color)
        .toList();

    if (variantsWithColor.isEmpty) {
      return;
    }

    final currentSizeVariant = variantsWithColor.where(
      (variant) => variant.size == selectedSize,
    );

    setState(() {
      selectedColor = color;

      if (currentSizeVariant.isEmpty) {
        selectedSize = variantsWithColor.first.size;
      }

      quantity = 1;
    });
  }

  // ============================================================
  // BACK BUTTON
  // ============================================================

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

  // ============================================================
  // FAVORITE
  // ============================================================

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

  // ============================================================
  // TITLE + PRICE
  // ============================================================

  Widget _buildTitleAndPrice(ProductDetailsEntity product) {
    final variant = _getSelectedVariant(product);

    final price = variant?.price ?? product.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: AppStyles.textStylesBold16Mono(context)),

        const SizedBox(height: 5),

        Text(
          '\$${price.toStringAsFixed(2)}',
          style: AppStyles.textStylesBold16Mono(
            context,
          ).copyWith(color: kProductAccentColor),
        ),
      ],
    );
  }

  // ============================================================
  // SELECTED VARIANT INFO
  // ============================================================

  Widget _buildSelectedVariantInfo(
    BuildContext context,
    ProductDetailsEntity product,
  ) {
    final variant = _getSelectedVariant(product);

    if (variant == null) {
      if (product.variants.isEmpty) {
        return const SizedBox();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Expanded(child: Text('Please select a valid size and color.')),
          ],
        ),
      );
    }

    final isOutOfStock = variant.stock <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOutOfStock
            ? Colors.red.withOpacity(0.08)
            : Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isOutOfStock
                ? Icons.remove_shopping_cart_outlined
                : Icons.check_circle_outline,
            color: isOutOfStock ? Colors.red : Colors.green,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              isOutOfStock
                  ? 'This variant is out of stock'
                  : '${variant.stock} available',
              style: TextStyle(
                color: isOutOfStock ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIZE
  // ============================================================

  Widget _buildSizeRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: product.sizes.isEmpty
          ? null
          : () => _openSizeSheet(context, product),
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

  // ============================================================
  // COLOR
  // ============================================================

  Widget _buildColorRow(BuildContext context, ProductDetailsEntity product) {
    return InkWell(
      onTap: product.colors.isEmpty
          ? null
          : () => _openColorSheet(context, product),
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

  // ============================================================
  // QUANTITY
  // ============================================================

  Widget _buildQuantityRow(ProductDetailsEntity product) {
    final variant = _getSelectedVariant(product);

    final maxQuantity = variant?.stock ?? product.stock;

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
            maxQuantity: maxQuantity > 0 ? maxQuantity : 1,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REVIEWS
  // ============================================================

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

        final rating = _safeRating(product.avgRating);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            _buildReviewsHeader(context, product, reviews.length, rating),

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

  // ============================================================
  // REVIEWS HEADER
  // ============================================================

  Widget _buildReviewsHeader(
    BuildContext context,
    ProductDetailsEntity product,
    int reviewCount,
    double rating,
  ) {
    final safeRating = _safeRating(rating);

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
              safeRating.toStringAsFixed(1),
              style: AppStyles.textStylesSemiBold24(context),
            ),

            const SizedBox(width: 10),

            _buildStars(safeRating),

            const SizedBox(width: 8),

            Text(
              '($reviewCount)',
              style: AppStyles.textStylesRegular14(context),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STARS
  // ============================================================

  Widget _buildStars(double rating) {
    final safeRating = _safeRating(rating);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;

        if (safeRating >= starNumber) {
          return const Icon(Icons.star, size: 20, color: Colors.amber);
        }

        if (safeRating >= starNumber - 0.5) {
          return const Icon(Icons.star_half, size: 20, color: Colors.amber);
        }

        return const Icon(Icons.star_border, size: 20, color: Colors.amber);
      }),
    );
  }

  // ============================================================
  // EMPTY REVIEWS
  // ============================================================

  Widget _buildEmptyReviews() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          'No reviews yet. Be the first to review this product.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ============================================================
  // REVIEWS ERROR
  // ============================================================

  Widget _buildReviewsError(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),

          const SizedBox(width: 10),

          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar(BuildContext context, ProductDetailsEntity product) {
    final variant = _getSelectedVariant(product);

    final isValidVariant = variant != null && variant.id.trim().isNotEmpty;

    final isOutOfStock = variant != null && variant.stock <= 0;

    final canAddToCart = isValidVariant && !isOutOfStock && quantity > 0;

    final price = variant?.price ?? product.price;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    '\$${(price * quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: canAddToCart
                      ? () => _addToCart(context, product, variant)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kProductAccentColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey.shade600,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isOutOfStock
                        ? 'Out of Stock'
                        : !isValidVariant
                        ? 'Select Variant'
                        : 'Add to Cart',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> _addToCart(
    BuildContext context,
    ProductDetailsEntity product,
    VariantEntity? variant,
  ) async {
    if (variant == null) {
      _showMessage(context, 'Please select a valid size and color.');
      return;
    }

    final variantId = variant.id.trim();

    if (variantId.isEmpty) {
      _showMessage(context, 'This product variant has no valid ID.');
      return;
    }

    final productId = product.id.trim();

    if (productId.isEmpty) {
      _showMessage(context, 'This product has no valid ID.');
      return;
    }

    if (variant.stock <= 0) {
      _showMessage(context, 'This variant is out of stock.');
      return;
    }

    if (quantity <= 0) {
      _showMessage(context, 'Please select a valid quantity.');
      return;
    }

    if (quantity > variant.stock) {
      _showMessage(context, 'Only ${variant.stock} items are available.');
      return;
    }

    try {
      await context.read<CartCubit>().addToCart(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
      );

      if (!context.mounted) {
        return;
      }

      _showMessage(context, 'Added to cart successfully');
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      _showMessage(context, e.toString());
    }
  }
  // ============================================================
  // SIZE SHEET
  // ============================================================

  void _openSizeSheet(BuildContext context, ProductDetailsEntity product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SizePickerSheet(
          sizes: product.sizes,
          selectedSize: selectedSize,
          onSelected: (size) {
            _selectSize(product, size);
          },
        );
      },
    );
  }

  // ============================================================
  // COLOR SHEET
  // ============================================================

  void _openColorSheet(BuildContext context, ProductDetailsEntity product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ColorPickerSheet(
          colors: product.colors,
          selectedColor: selectedColor,
          onSelected: (color) {
            _selectColor(product, color);
          },
        );
      },
    );
  }

  // ============================================================
  // ADD REVIEW
  // ============================================================

  void _showAddReviewSheet(BuildContext context, String productId) {
    final controller = TextEditingController();

    double rating = 5.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Write a review',
                            style: AppStyles.textStylesBold16Mono(context),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Rating',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;

                          return IconButton(
                            onPressed: () {
                              setSheetState(() {
                                rating = star.toDouble();
                              });
                            },
                            icon: Icon(
                              star <= rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 32,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: controller,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Write your review...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            final description = controller.text.trim();

                            if (description.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please write a review.'),
                                ),
                              );
                              return;
                            }

                            Navigator.pop(sheetContext);

                            context.read<ReviewCubit>().createReview(
                              productId: productId,
                              rating: rating.toDouble(),
                              description: description,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kProductAccentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Submit Review',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(controller.dispose);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  void _refreshProductAndReviews(BuildContext context) {
    final routeArguments = ModalRoute.of(context)?.settings.arguments;

    if (routeArguments is! String || routeArguments.trim().isEmpty) {
      return;
    }

    context.read<ProductDetailsCubit>().getProductDetails(
      productId: routeArguments,
    );

    context.read<ReviewCubit>().getProductReviews(routeArguments);
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),

            const SizedBox(height: 16),

            Text(
              'Something went wrong',
              style: AppStyles.textStylesBold16Mono(context),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular14(context),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final routeArguments = ModalRoute.of(
                  context,
                )?.settings.arguments;

                if (routeArguments is String) {
                  context.read<ProductDetailsCubit>().getProductDetails(
                    productId: routeArguments,
                  );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SAFE RATING
  // ============================================================

  double _safeRating(double value) {
    if (!value.isFinite) {
      return 0.0;
    }

    if (value <= 0) {
      return 0.0;
    }

    if (value >= 5) {
      return 5.0;
    }

    return value;
  }

  // ============================================================
  // COLOR FROM HEX
  // ============================================================

  Color _colorFromHex(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '').trim();

      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }

      if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }

      return Colors.grey;
    } catch (_) {
      return Colors.grey;
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
