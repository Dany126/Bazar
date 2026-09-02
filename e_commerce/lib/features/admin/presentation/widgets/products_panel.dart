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
        if (state is! AdminCategoriesLoaded) {
          return _ProductsContainer(
            child: _EmptyProducts(
              icon: Icons.category_outlined,
              title: 'Select a category',
              subtitle:
                  'Products belonging to the selected category will appear here.',
            ),
          );
        }

        if (state.selectedCategoryId == null) {
          return _ProductsContainer(
            child: _EmptyProducts(
              icon: Icons.category_outlined,
              title: 'Select a category',
              subtitle:
                  'Products belonging to the selected category will appear here.',
            ),
          );
        }

        if (state.products.isEmpty) {
          return _ProductsContainer(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final search = searchController.text.trim().toLowerCase();

        final products = state.products.where((product) {
          if (search.isEmpty) {
            return true;
          }

          return product.name.toLowerCase().contains(search);
        }).toList();

        return _ProductsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.selectedCategoryName ?? 'Products',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff20222F),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${state.products.length} products',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff858897),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 230,
                    child: TextField(
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: products.isEmpty
                    ? const _EmptyProducts(
                        icon: Icons.inventory_2_outlined,
                        title: 'No products found',
                        subtitle:
                            'This category does not contain any products.',
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductsContainer extends StatelessWidget {
  final Widget child;

  const _ProductsContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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

class _EmptyProducts extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyProducts({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xffA0A3B1)),
            const SizedBox(height: 12),
            Text(
              title,
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
