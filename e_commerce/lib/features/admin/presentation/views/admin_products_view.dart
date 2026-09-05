import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/add_product_sheet.dart';
import 'package:e_commerce/features/admin/presentation/widgets/edit_product_sheet.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProductsView extends StatelessWidget {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminProductsCubit>(
          create: (_) => getIt<AdminProductsCubit>()..loadProducts(),
        ),

        BlocProvider<AdminCategoriesCubit>(
          create: (_) => getIt<AdminCategoriesCubit>()..loadCategories(),
        ),
      ],
      child: const _AdminProductsBody(),
    );
  }
}

class _AdminProductsBody extends StatelessWidget {
  const _AdminProductsBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        /*
         * Always use a finite width.
         *
         * Some admin layouts can give this widget an unbounded width.
         * Never pass Infinity to SizedBox/ConstrainedBox/GridView.
         */
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final double contentWidth = availableWidth.isFinite
            ? availableWidth
            : 1200;

        final int crossAxisCount;

        if (contentWidth >= 1200) {
          crossAxisCount = 4;
        } else if (contentWidth >= 800) {
          crossAxisCount = 3;
        } else if (contentWidth >= 500) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return RefreshIndicator(
          onRefresh: () {
            return context.read<AdminProductsCubit>().loadProducts();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ProductsHeader(availableWidth: contentWidth),

                const SizedBox(height: 24),

                BlocConsumer<AdminProductsCubit, AdminProductsState>(
                  listener: (BuildContext context, AdminProductsState state) {
                    if (state is AdminProductsFailure) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    }
                  },
                  builder: (BuildContext context, AdminProductsState state) {
                    if (state is AdminProductsInitial ||
                        state is AdminProductsLoading) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    }

                    if (state is AdminProductsFailure) {
                      return _buildErrorState(context, state.message);
                    }

                    if (state is AdminProductsLoaded) {
                      if (state.products.isEmpty) {
                        return _buildEmptyState(context);
                      }

                      return _buildProductsGrid(
                        context,
                        state.products,
                        crossAxisCount,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // PRODUCTS GRID
  // ============================================================

  Widget _buildProductsGrid(
    BuildContext context,
    List<ProductModel> products,
    int crossAxisCount,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (BuildContext context, int index) {
        final ProductModel product = products[index];

        return _AdminProductCard(
          product: product,
          onEdit: () {
            _openEditProductSheet(context, product);
          },
          onDelete: () {
            _confirmDelete(context, product);
          },
        );
      },
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState(BuildContext context, String message) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),

              const SizedBox(height: 16),

              const Text(
                'Unable to load products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AdminProductsCubit>().loadProducts();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 44,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'No products yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              Text(
                'Add your first product to start building your store.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _openAddProductSheet(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader({required this.availableWidth});

  final double availableWidth;

  @override
  Widget build(BuildContext context) {
    /*
     * IMPORTANT:
     *
     * Do not use:
     *
     * SizedBox(width: width)
     *
     * when width can be Infinity.
     *
     * availableWidth is guaranteed to be finite by the parent.
     */

    if (availableWidth >= 700) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            child: Text(
              'Products',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ),

          SizedBox(
            width: 170,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                _openAddProductSheet(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Products',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 16),

        /*
         * This is now bounded by the parent Column.
         *
         * No width: availableWidth is needed.
         */
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () {
              _openAddProductSheet(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// PRODUCT CARD
// ============================================================

class _AdminProductCard extends StatelessWidget {
  const _AdminProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = fixImageUrl(product.thumbnailUrl);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.kCardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: imageUrl.isEmpty
                      ? const _ImagePlaceholder()
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String url) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget:
                              (BuildContext context, String url, Object error) {
                                return const _ImagePlaceholder();
                              },
                        ),
                ),
              ),

              // ==================================================
              // ADMIN ACTIONS
              // ==================================================
              Positioned(
                top: 5,
                right: 8,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.90),
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: PopupMenuButton<String>(
                    tooltip: 'Product actions',
                    icon: const Icon(Icons.more_vert, size: 20),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (String value) {
                      if (value == 'edit') {
                        onEdit();
                      }

                      if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return const <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
    );
  }
}

// ============================================================
// IMAGE PLACEHOLDER
// ============================================================

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade100,
      child: Icon(Icons.image_outlined, size: 44, color: Colors.grey.shade400),
    );
  }
}

// ============================================================
// ADD PRODUCT
// ============================================================

void _openAddProductSheet(BuildContext context) {
  final productsCubit = context.read<AdminProductsCubit>();
  final categoriesCubit = context.read<AdminCategoriesCubit>();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<AdminProductsCubit>.value(value: productsCubit),
          BlocProvider<AdminCategoriesCubit>.value(value: categoriesCubit),
        ],
        child: const AddProductSheet(),
      );
    },
  );
}
// ============================================================
// EDIT PRODUCT
// ============================================================

void _openEditProductSheet(BuildContext context, ProductModel product) {
  final AdminProductsCubit productsCubit = context.read<AdminProductsCubit>();

  final AdminCategoriesCubit categoriesCubit = context
      .read<AdminCategoriesCubit>();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: productsCubit),
          BlocProvider.value(value: categoriesCubit),
        ],
        child: EditProductSheet(product: product),
      );
    },
  );
}
// ============================================================
// DELETE CONFIRMATION
// ============================================================

Future<void> _confirmDelete(BuildContext context, ProductModel product) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Delete Product'),

        content: Text('Are you sure you want to delete "${product.name}"?'),

        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Cancel'),
          ),

          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final bool success = await context.read<AdminProductsCubit>().deleteProduct(
    product.id,
  );

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Product deleted successfully' : 'Failed to delete product',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
