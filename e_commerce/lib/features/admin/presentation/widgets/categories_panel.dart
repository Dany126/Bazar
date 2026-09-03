import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/widgets/add_category_sheet.dart';
import 'package:e_commerce/features/admin/presentation/widgets/category_card.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPanel extends StatelessWidget {
  const CategoriesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE8EAF0)),
      ),
      child: BlocBuilder<AdminCategoriesCubit, AdminCategoriesState>(
        builder: (context, state) {
          if (state is AdminCategoriesLoading) {
            return const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AdminCategoriesError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                context.read<AdminCategoriesCubit>().loadCategories();
              },
            );
          }

          if (state is! AdminCategoriesLoaded) {
            return const _EmptyView(message: 'No categories');
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              const SizedBox(height: 16),

              if (state.categories.isEmpty)
                const SizedBox(
                  height: 120,
                  child: _EmptyView(message: 'No categories found'),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    final category = state.categories[index];

                    final isSelected = state.selectedCategoryId == category.id;

                    return _CategoryItem(
                      category: category,
                      selected: isSelected,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Small screens:
        // Put the button below the title.
        if (width < 450) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff20222F),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: _addCategoryButton(context),
              ),
            ],
          );
        }

        // Normal / desktop layout.
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Expanded(
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff20222F),
                ),
              ),
            ),

            const SizedBox(width: 12),

            _addCategoryButton(context),
          ],
        );
      },
    );
  }

  Widget _addCategoryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _showAddCategorySheet(context);
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Add Category'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AdminCategoriesCubit>(),
          child: const AddCategorySheet(),
        );
      },
    );
  }
}

// ============================================================
// CATEGORY ITEM
// ============================================================

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category, required this.selected});

  final CategoryModel category;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CategoryCard(
          category: category,
          selected: selected,
          onTap: () {
            context.read<AdminCategoriesCubit>().selectCategory(category);
          },
        ),

        Positioned(
          top: 6,
          right: 6,
          child: _EditButton(
            onTap: () {
              _showEditCategorySheet(context, category);
            },
          ),
        ),
      ],
    );
  }

  void _showEditCategorySheet(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AdminCategoriesCubit>(),
          child: AddCategorySheet(category: category),
        );
      },
    );
  }
}

// ============================================================
// EDIT BUTTON
// ============================================================

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: Icon(Icons.edit_outlined, size: 17, color: Color(0xff555A6F)),
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY VIEW
// ============================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xff777B8C)),
        ),
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),

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
    );
  }
}
