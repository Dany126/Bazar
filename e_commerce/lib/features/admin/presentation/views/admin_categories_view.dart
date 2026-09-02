import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_cubit.dart';
import 'package:e_commerce/features/home/presentation/viewModel/categories_cubit/get_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetCategoriesCubit>(
          create: (_) => getIt<GetCategoriesCubit>()..fetchAllCategories(),
        ),
        BlocProvider<AdminCategoriesCubit>(
          create: (_) => getIt<AdminCategoriesCubit>(),
        ),
      ],
      child: const _AdminCategoriesViewBody(),
    );
  }
}

class _AdminCategoriesViewBody extends StatelessWidget {
  const _AdminCategoriesViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 16 : 32,
                  vertical: constraints.maxWidth < 600 ? 20 : 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 28),
                    _buildCategories(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 650;

        if (isSmall) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildAddButton(context),
                  const SizedBox(width: 10),
                  _buildRefreshButton(context),
                ],
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTitle(context)),
            const SizedBox(width: 16),
            _buildAddButton(context),
            const SizedBox(width: 10),
            _buildRefreshButton(context),
          ],
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF171A1F),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage and view all product categories.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.kSecondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'Add Category',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<GetCategoriesCubit>().fetchAllCategories();
        },
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text(
          'Refresh',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategories(BuildContext context) {
    return BlocListener<AdminCategoriesCubit, AdminCategoriesState>(
      listener: (context, state) {
        if (state is AdminCategoriesCreated) {
          context.read<GetCategoriesCubit>().fetchAllCategories();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category created successfully')),
          );
        }

        if (state is AdminCategoriesDeleted) {
          context.read<GetCategoriesCubit>().fetchAllCategories();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category deleted successfully')),
          );
        }

        if (state is AdminCategoriesFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
        builder: (context, state) {
          if (state is GetCategoriesLoading) {
            return const _LoadingState();
          }

          if (state is GetCategoriesFailure) {
            return _ErrorState(
              message: state.message,
              onRetry: () {
                context.read<GetCategoriesCubit>().fetchAllCategories();
              },
            );
          }

          if (state is GetCategoriesSuccess) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return const _EmptyState();
            }

            return _CategoriesGrid(
              categories: categories as List<CategoryModel>,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ============================================================
  // ADD CATEGORY DIALOG
  // ============================================================

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final adminCategoriesCubit = context.read<AdminCategoriesCubit>();

    final nameController = TextEditingController();

    Uint8List? imageBytes;
    String? imageName;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: adminCategoriesCubit,
          child: _AddCategoryDialog(
            nameController: nameController,
            onImageSelected: (bytes, name) {
              imageBytes = bytes;
              imageName = name;
            },
            getImageBytes: () => imageBytes,
            getImageName: () => imageName,
          ),
        );
      },
    );

    nameController.dispose();
  }
}

// ================================================================
// ADD CATEGORY DIALOG
// ================================================================

class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog({
    required this.nameController,
    required this.onImageSelected,
    required this.getImageBytes,
    required this.getImageName,
  });

  final TextEditingController nameController;

  final void Function(Uint8List bytes, String name) onImageSelected;

  final Uint8List? Function() getImageBytes;

  final String? Function() getImageName;

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  Uint8List? _imageBytes;
  String? _imageName;

  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();

    if (!mounted) {
      return;
    }

    setState(() {
      _imageBytes = bytes;
      _imageName = file.name;
    });

    widget.onImageSelected(bytes, file.name);
  }

  Future<void> _createCategory() async {
    final name = widget.nameController.text.trim();

    if (name.isEmpty) {
      _showError('Category name is required.');
      return;
    }

    if (_imageBytes == null) {
      _showError('Please select a category image.');
      return;
    }

    setState(() {
      _loading = true;
    });

    final image = MultipartFile.fromBytes(
      _imageBytes!,
      filename: _imageName ?? 'category.jpg',
    );

    await context.read<AdminCategoriesCubit>().createCategory(
      name: name,
      image: image,
    );

    if (!mounted) {
      return;
    }

    final state = context.read<AdminCategoriesCubit>().state;

    if (state is AdminCategoriesCreated) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.nameController,
              enabled: !_loading,
              decoration: InputDecoration(
                labelText: 'Category name',
                hintText: 'Enter category name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _loading ? null : _pickImage,
              child: Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imageBytes!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 42,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 10),
                          const Text('Select category image'),
                          const SizedBox(height: 4),
                          Text(
                            'Click to choose an image',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            if (_imageName != null) ...[
              const SizedBox(height: 8),
              Text(
                _imageName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 120,
          height: 44,
          child: ElevatedButton(
            onPressed: _loading ? null : _createCategory,
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Create'),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// GRID
// ================================================================

class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int count;

        if (width >= 1400) {
          count = 4;
        } else if (width >= 950) {
          count = 3;
        } else if (width >= 600) {
          count = 2;
        } else {
          count = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            return _CategoryCard(category: categories[index]);
          },
        );
      },
    );
  }
}

// ================================================================
// CATEGORY CARD
// ================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: _CategoryImage(imageUrl: category.imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF171A1F),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Delete category',
                  onPressed: () {
                    _deleteCategory(context, category);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(
    BuildContext context,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

    await context.read<AdminCategoriesCubit>().deleteCategory(
      categoryId: category.id,
    );
  }
}

// ================================================================
// IMAGE
// ================================================================

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _placeholder();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return Container(
          color: const Color(0xFFF1F3F5),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF1F3F5),
      child: Icon(
        Icons.category_outlined,
        size: 52,
        color: Colors.grey.shade400,
      ),
    );
  }
}

// ================================================================
// LOADING
// ================================================================

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.kPrimaryColor),
            const SizedBox(height: 16),
            Text(
              'Loading categories...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.kSecondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// EMPTY
// ================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 52, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'No categories found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first category.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ERROR
// ================================================================

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Unable to load categories',
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
                width: 130,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
