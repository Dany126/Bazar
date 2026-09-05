import 'package:e_commerce/core/utils/app_colors.dart';
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

          // FIX: This panel is placed inside a parent that gives it a
          // fixed height (see the "BoxConstraints(w=..., h=...)" in the
          // overflow error). The Column below must not let its children
          // size themselves to their natural (unbounded) height when
          // there are many categories - it needs to know that the
          // category list is the flexible part that should scroll
          // within the remaining space, not grow past it.
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
                // FIX: Wrapped in Expanded so the list takes the
                // remaining height inside the panel's fixed-height
                // parent instead of trying to be as tall as all of
                // its items combined (which caused the 70px bottom
                // overflow once there were enough categories).
                Expanded(
                  child: ListView.separated(
                    // FIX: Removed shrinkWrap + NeverScrollableScrollPhysics.
                    // Those only make sense when a list sits inside an
                    // unbounded/scrollable ancestor (like the page's own
                    // SingleChildScrollView). Here the panel itself has a
                    // fixed height, so this list needs to scroll on its
                    // own to show all categories without overflowing.
                    padding: EdgeInsets.zero,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final category = state.categories[index];

                      final isSelected =
                          state.selectedCategoryId == category.id;

                      return _CategoryItem(
                        category: category,
                        selected: isSelected,
                      );
                    },
                  ),
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

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Flexible(child: _addCategoryButton(context)),
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
        backgroundColor: AppColors.kPrimaryColor,
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

/*
|--------------------------------------------------------------------------
| CATEGORY ITEM
|--------------------------------------------------------------------------
*/

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CategoryActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit category',
                onTap: () {
                  _showEditCategorySheet(context, category);
                },
              ),

              const SizedBox(width: 6),

              _CategoryActionButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete category',
                onTap: () {
                  _confirmDeleteCategory(context, category);
                },
              ),
            ],
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

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete category?'),
          content: Text(
            'Are you sure you want to delete '
            '"${category.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
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

    await context.read<AdminCategoriesCubit>().deleteCategory(id: category.id);
  }
}

/*
|--------------------------------------------------------------------------
| CATEGORY ACTION BUTTON
|--------------------------------------------------------------------------
*/

class _CategoryActionButton extends StatelessWidget {
  const _CategoryActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 17, color: const Color(0xff555A6F)),
          ),
        ),
      ),
    );
  }
}

/*
|--------------------------------------------------------------------------
| EMPTY
|--------------------------------------------------------------------------
*/

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

/*
|--------------------------------------------------------------------------
| ERROR
|--------------------------------------------------------------------------
*/

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
