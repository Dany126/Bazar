import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/add_product_sheet.dart';
import 'package:e_commerce/features/admin/presentation/widgets/edit_product_sheet.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminProductsView extends StatelessWidget {
  const AdminProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminProductsCubit>(
      create: (_) => getIt<AdminProductsCubit>()..loadProducts(),
      child: const _AdminProductsBody(),
    );
  }
}

class _AdminProductsBody extends StatelessWidget {
  const _AdminProductsBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.sizeOf(context).width;

        final double width =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : screenWidth;

        final int crossAxisCount;

        if (width >= 1200) {
          crossAxisCount = 4;
        } else if (width >= 800) {
          crossAxisCount = 3;
        } else if (width >= 500) {
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
            child: SizedBox(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _ProductsHeader(),

                  const SizedBox(height: 24),

                  BlocConsumer<AdminProductsCubit, AdminProductsState>(
                    listener: (context, state) {
                      if (state is AdminProductsFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
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
      itemBuilder: (context, index) {
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
            children: [
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

              ElevatedButton.icon(
                onPressed: () {
                  context.read<AdminProductsCubit>().loadProducts();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
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
            children: [
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

              ElevatedButton.icon(
                onPressed: () {
                  _openAddProductSheet(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
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
  const _ProductsHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        if (width >= 700) {
          return Row(
            children: [
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
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: width,
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
      },
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
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
                          placeholder: (context, url) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorWidget: (context, url, error) {
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
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      }

                      if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
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
// ADD
// ============================================================

void _openAddProductSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) {
      return const AddProductSheet();
    },
  );
}

// ============================================================
// EDIT
// ============================================================

void _openEditProductSheet(BuildContext context, ProductModel product) {
  final AdminProductsCubit productsCubit = context.read<AdminProductsCubit>();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) {
      return BlocProvider.value(
        value: productsCubit,
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
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Product'),

        content: Text('Are you sure you want to delete "${product.name}"?'),

        actions: [
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

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        success ? 'Product deleted successfully' : 'Failed to delete product',
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
