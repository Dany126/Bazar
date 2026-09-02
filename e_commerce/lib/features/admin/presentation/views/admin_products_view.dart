import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/add_product_sheet.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
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
      builder: (context, outerConstraints) {
        final availableWidth = outerConstraints.maxWidth;
        final crossAxisCount = availableWidth > 900
            ? 4
            : (availableWidth > 600 ? 3 : 2);

        return RefreshIndicator(
          onRefresh: () => context.read<AdminProductsCubit>().loadProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Products',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddProductSheet(context, []);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
                    ),
                  ],
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
                    if (state is AdminProductsLoading ||
                        state is AdminProductsInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is AdminProductsFailure) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Center(
                          child: Text(
                            'Failed to load products:\n${state.message}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final products = state is AdminProductsLoaded
                        ? state.products
                        : <ProductModel>[];

                    if (products.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: Text('No products yet.')),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductCard(
                          product: product,
                          onDelete: () => context
                              .read<AdminProductsCubit>()
                              .deleteProduct(product.id),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProductSheet(
    BuildContext context,
    List<CategoryModel> categories,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return AddProductSheet(categories: categories);
      },
    );
  }
}

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: imageUrl != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
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
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
