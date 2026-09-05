import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/admin_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsPanel extends StatefulWidget {
  const ProductsPanel({super.key});

  @override
  State<ProductsPanel> createState() => _ProductsPanelState();
}

class _ProductsPanelState extends State<ProductsPanel> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCategoriesCubit, AdminCategoriesState>(
      builder: (context, state) {
        if (state is AdminCategoriesLoading ||
            state is AdminCategoriesInitial) {
          return const _ProductsContainer(
            child: SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state is AdminCategoriesError) {
          return _ProductsContainer(
            child: _ErrorProducts(
              message: state.message,
              onRetry: () {
                context.read<AdminCategoriesCubit>().loadCategories();
              },
            ),
          );
        }

        if (state is! AdminCategoriesLoaded) {
          return const _ProductsContainer(
            child: _EmptyProducts(
              icon: Icons.category_outlined,
              title: 'Select a category',
              subtitle:
                  'Products belonging to the selected category will appear here.',
            ),
          );
        }

        // ============================================================
        // IMPORTANT:
        // Use displayedProducts instead of state.products.
        //
        // displayedProducts already filters products by the selected
        // category inside AdminCategoriesLoaded.
        // ============================================================

        final selectedProducts = state.displayedProducts;

        final search = searchController.text.trim().toLowerCase();

        final products = selectedProducts.where((product) {
          if (search.isEmpty) {
            return true;
          }

          return product.name.toLowerCase().contains(search);
        }).toList();

        // No category selected.
        if (state.selectedCategoryId == null) {
          return const _ProductsContainer(
            child: _EmptyProducts(
              icon: Icons.category_outlined,
              title: 'Select a category',
              subtitle:
                  'Products belonging to the selected category will appear here.',
            ),
          );
        }

        return _ProductsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(
                context,
                categoryName: state.selectedCategoryName ?? 'Products',
                totalProducts: selectedProducts.length,
              ),

              const SizedBox(height: 20),

              if (products.isEmpty)
                const SizedBox(
                  height: 250,
                  child: _EmptyProducts(
                    icon: Icons.inventory_2_outlined,
                    title: 'No products found',
                    subtitle: 'This category does not contain any products.',
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 280,
                    mainAxisExtent: 310,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    return AdminProductCard(product: products[index]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String categoryName,
    required int totalProducts,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 650) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff20222F),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$totalProducts ${totalProducts == 1 ? 'product' : 'products'}',
                style: const TextStyle(fontSize: 13, color: Color(0xff858897)),
              ),

              const SizedBox(height: 14),

              SizedBox(width: double.infinity, child: _buildSearchField()),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff20222F),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '$totalProducts ${totalProducts == 1 ? 'product' : 'products'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff858897),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            SizedBox(width: 230, child: _buildSearchField()),
          ],
        );
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (_) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.close, size: 18),
              )
            : null,
        filled: true,
        fillColor: const Color(0xffF8F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ============================================================
// PRODUCTS CONTAINER
// ============================================================

class _ProductsContainer extends StatelessWidget {
  const _ProductsContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE8EAF0)),
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

// ============================================================
// EMPTY PRODUCTS
// ============================================================

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: const Color(0xffA0A3B1)),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff252735),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xff858897)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ERROR PRODUCTS
// ============================================================

class _ErrorProducts extends StatelessWidget {
  const _ErrorProducts({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 42,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(height: 16),

              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
