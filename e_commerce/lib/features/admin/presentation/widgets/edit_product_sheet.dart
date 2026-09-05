import 'dart:typed_data';

import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProductSheet extends StatefulWidget {
  const EditProductSheet({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductSheet> createState() => _EditProductSheetState();
}

class _EditProductSheetState extends State<EditProductSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  final ImagePicker _imagePicker = ImagePicker();

  CategoryModel? _selectedCategory;

  final List<XFile> _newImages = <XFile>[];

  final Map<String, Uint8List> _imageBytes = <String, Uint8List>{};

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product.name);

    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadCategories();
    });
  }

  void _loadCategories() {
    final AdminCategoriesCubit? cubit = context.read<AdminCategoriesCubit?>();

    if (cubit == null) {
      return;
    }

    final state = cubit.state;

    if (state is AdminCategoriesLoaded) {
      _selectCurrentCategory(state.categories);
      return;
    }

    cubit.loadCategories();
  }

  void _selectCurrentCategory(List<CategoryModel> categories) {
    for (final category in categories) {
      if (category.id == widget.product.category.id) {
        setState(() {
          _selectedCategory = category;
        });

        return;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedImages = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedImages.isEmpty) {
        return;
      }

      for (final image in pickedImages) {
        final bool alreadyAdded = _newImages.any(
          (item) => item.name == image.name,
        );

        if (alreadyAdded) {
          continue;
        }

        final Uint8List bytes = await image.readAsBytes();

        _newImages.add(image);
        _imageBytes[image.name] = bytes;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select images: $error')),
      );
    }
  }

  void _removeNewImage(int index) {
    final XFile image = _newImages[index];

    _imageBytes.remove(image.name);

    setState(() {
      _newImages.removeAt(index);
    });
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));

      return;
    }

    final double? price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final bool success = await context.read<AdminProductsCubit>().updateProduct(
      id: widget.product.id,
      name: _nameController.text.trim(),
      categoryId: _selectedCategory!.id,
      price: price,
      images: _newImages.isEmpty ? null : _newImages,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double screenWidth = mediaQuery.size.width;

    final double sheetWidth = screenWidth > 900 ? 900 : screenWidth;

    final double sheetHeight = mediaQuery.size.height * 0.90;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: sheetWidth,
        height: sheetHeight,
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                _buildHandle(),

                Expanded(
                  child:
                      BlocListener<AdminCategoriesCubit, AdminCategoriesState>(
                        listener: (context, state) {
                          if (state is AdminCategoriesLoaded) {
                            _selectCurrentCategory(state.categories);
                          }

                          if (state is AdminCategoriesError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: screenWidth < 500 ? 16 : 24,
                            right: screenWidth < 500 ? 16 : 24,
                            top: 16,
                            bottom: mediaQuery.viewInsets.bottom + 32,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeader(),

                                const SizedBox(height: 24),

                                _buildProductInformation(),

                                const SizedBox(height: 24),

                                _buildImages(),

                                const SizedBox(height: 32),

                                _buildSubmitButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HANDLE
  // ============================================================

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      width: 45,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 6),

              Text(
                'Update your product information.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Close',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT INFORMATION
  // ============================================================

  Widget _buildProductInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product information',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Product name',
            hintText: 'Enter product name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Price',
            hintText: 'Enter product price',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Price is required';
            }

            final double? price = double.tryParse(value.trim());

            if (price == null || price <= 0) {
              return 'Enter a valid price';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        _buildCategoryDropdown(),
      ],
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategoryDropdown() {
    return BlocBuilder<AdminCategoriesCubit, AdminCategoriesState>(
      builder: (context, state) {
        if (state is AdminCategoriesLoading) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            child: SizedBox(
              height: 24,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (state is AdminCategoriesLoaded) {
          final List<CategoryModel> categories = state.categories;

          if (_selectedCategory != null &&
              !categories.any(
                (category) => category.id == _selectedCategory!.id,
              )) {
            _selectedCategory = null;
          }

          return DropdownButtonFormField<String>(
            value: _selectedCategory?.id,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: _isSubmitting
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }

                    final CategoryModel category = categories.firstWhere(
                      (item) => item.id == value,
                    );

                    setState(() {
                      _selectedCategory = category;
                    });
                  },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Category is required';
              }

              return null;
            },
          );
        }

        if (state is AdminCategoriesError) {
          return InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                IconButton(
                  tooltip: 'Retry',
                  onPressed: () {
                    context.read<AdminCategoriesCubit>().loadCategories();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        }

        return const InputDecorator(
          decoration: InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          child: Text('Loading categories...'),
        );
      },
    );
  }

  // ============================================================
  // IMAGES
  // ============================================================

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Product images',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),

            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add images'),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'Existing images are kept. Add new images only if you want to replace them through the backend.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),

        const SizedBox(height: 16),

        _buildExistingImage(),

        if (_newImages.isNotEmpty) ...[
          const SizedBox(height: 16),

          const Text(
            'New images',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          _buildNewImageGrid(),
        ],
      ],
    );
  }

  // ============================================================
  // EXISTING IMAGE
  // ============================================================

  Widget _buildExistingImage() {
    final String imageUrl = widget.product.thumbnailUrl;

    if (imageUrl.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.image_outlined,
          size: 50,
          color: Colors.grey.shade400,
        ),
      );
    }

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Icon(
            Icons.broken_image_outlined,
            size: 50,
            color: Colors.grey.shade400,
          );
        },
      ),
    );
  }

  // ============================================================
  // NEW IMAGE GRID
  // ============================================================

  Widget _buildNewImageGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;

        if (constraints.maxWidth < 450) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 650) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _newImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final XFile image = _newImages[index];

            final Uint8List? bytes = _imageBytes[image.name];

            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: bytes == null
                        ? Container(color: Colors.grey.shade100)
                        : Image.memory(bytes, fit: BoxFit.cover),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      tooltip: 'Remove image',
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              _removeNewImage(index);
                            },
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // SUBMIT BUTTON
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save Changes'),
      ),
    );
  }
}
