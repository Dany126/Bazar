import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/add_product_sheet.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final screenWidth = MediaQuery.sizeOf(context).width;

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
                  const SizedBox(
                    width: double.infinity,
                    child: _ProductsHeader(),
                  ),

                  const SizedBox(height: 24),

                  BlocConsumer<AdminProductsCubit, AdminProductsState>(
                    listener: (context, state) {
                      if (state is AdminProductsFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      // ------------------------------------------------
                      // LOADING
                      // ------------------------------------------------

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

                      // ------------------------------------------------
                      // FAILURE
                      // ------------------------------------------------

                      if (state is AdminProductsFailure) {
                        return _buildErrorState(context, state.message);
                      }

                      // ------------------------------------------------
                      // LOADED
                      // ------------------------------------------------

                      if (state is AdminProductsLoaded) {
                        final products = state.products;

                        // IMPORTANT:
                        // Empty products is NOT an error.
                        if (products.isEmpty) {
                          return _buildEmptyState(context);
                        }

                        return _buildProductsGrid(products, crossAxisCount);
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
  // ERROR STATE
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

              SizedBox(
                width: 450,
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
  // EMPTY STATE
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

  // ============================================================
  // PRODUCTS GRID
  // ============================================================

  Widget _buildProductsGrid(List<ProductModel> products, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return _ProductCard(
          product: product,
          onDelete: () {
            _confirmDelete(context, product);
          },
        );
      },
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
        final width =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        if (width >= 700) {
          return SizedBox(
            width: width,
            child: Row(
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
                    label: const Text(
                      'Add Product',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          width: width,
          child: Column(
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
          ),
        );
      },
    );
  }
}

// ============================================================
// PRODUCT CARD
// ============================================================

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;

  const _ProductCard({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.thumbnailUrl.isNotEmpty
        ? product.thumbnailUrl
        : null;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),

                Positioned(
                  top: 4,
                  right: 4,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: IconButton(
                        tooltip: 'Delete product',
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                // This value comes from your existing
                // ProductModel. We are NOT adding a new
                // stock field to the product form.
                Text(
                  '${product.stock} in stock',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DELETE CONFIRMATION
// ============================================================

Future<void> _confirmDelete(BuildContext context, ProductModel product) async {
  final confirmed = await showDialog<bool>(
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

  await context.read<AdminProductsCubit>().deleteProduct(product.id);
}

// ============================================================
// OPEN ADD PRODUCT
// ============================================================

void _openAddProductSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return const AddProductSheet();
    },
  );
}
