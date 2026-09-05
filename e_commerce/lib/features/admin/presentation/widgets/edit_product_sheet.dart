import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

  // ============================================================
  // MULTI IMAGE STATE
  // ============================================================

  final List<XFile> _newImages = <XFile>[];

  final Map<String, Uint8List> _imageBytes = <String, Uint8List>{};

  List<AdminProductVariantModel> _variants = <AdminProductVariantModel>[];

  bool _isLoadingVariants = true;
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
      _loadVariants();
    });
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  void _loadCategories() {
    final AdminCategoriesCubit cubit = context.read<AdminCategoriesCubit>();

    final AdminCategoriesState state = cubit.state;

    if (state is AdminCategoriesLoaded) {
      _selectCurrentCategory(state.categories);
      return;
    }

    if (state is! AdminCategoriesLoading) {
      cubit.loadCategories();
    }
  }

  void _selectCurrentCategory(List<CategoryModel> categories) {
    for (final CategoryModel category in categories) {
      if (category.id == widget.product.category.id) {
        if (!mounted) {
          return;
        }

        setState(() {
          _selectedCategory = category;
        });

        return;
      }
    }
  }

  // ============================================================
  // VARIANTS
  // ============================================================

  Future<void> _loadVariants() async {
    setState(() {
      _isLoadingVariants = true;
    });

    try {
      final List<AdminProductVariantModel> variants = await context
          .read<AdminProductsCubit>()
          .getVariants(widget.product.id);

      if (!mounted) {
        return;
      }

      setState(() {
        _variants = variants;
        _isLoadingVariants = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingVariants = false;
      });

      _showSnackBar('Failed to load variants: $error');
    }
  }

  // ============================================================
  // MULTI IMAGE PICKER
  // ============================================================

  Future<void> _pickNewPhotos() async {
    if (_isSubmitting) {
      return;
    }

    try {
      final List<XFile> pickedImages = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedImages.isEmpty) {
        return;
      }

      final List<XFile> imagesToAdd = <XFile>[];

      for (final XFile image in pickedImages) {
        // Prevent selecting the exact same file twice.
        final bool alreadySelected = _newImages.any(
          (XFile existing) => existing.name == image.name,
        );

        if (alreadySelected) {
          continue;
        }

        final Uint8List bytes = await image.readAsBytes();

        _imageBytes[image.name] = bytes;

        imagesToAdd.add(image);
      }

      if (imagesToAdd.isEmpty) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _newImages.addAll(imagesToAdd);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showSnackBar('Failed to select images: $error');
    }
  }

  // ============================================================
  // REMOVE ONE IMAGE
  // ============================================================

  void _removeNewPhoto(int index) {
    if (_isSubmitting) {
      return;
    }

    if (index < 0 || index >= _newImages.length) {
      return;
    }

    final XFile image = _newImages[index];

    setState(() {
      _newImages.removeAt(index);
      _imageBytes.remove(image.name);
    });
  }

  // ============================================================
  // REMOVE ALL NEW IMAGES
  // ============================================================

  void _removeAllNewPhotos() {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _newImages.clear();
      _imageBytes.clear();
    });
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  Future<void> _showAddVariantDialog() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return _VariantDialog(
          title: 'Add Variant',
          confirmText: 'Add Variant',
          onSubmit:
              ({
                required String size,
                required String color,
                required double price,
                required int stock,
              }) async {
                return context.read<AdminProductsCubit>().createVariant(
                  productId: widget.product.id,
                  size: size,
                  color: color,
                  price: price,
                  stock: stock,
                );
              },
        );
      },
    );

    if (result == 'success' && mounted) {
      await _loadVariants();
    }
  }

  // ============================================================
  // EDIT VARIANT
  // ============================================================

  Future<void> _showEditVariantDialog(AdminProductVariantModel variant) async {
    final String? variantId = variant.id;

    if (variantId == null || variantId.isEmpty) {
      _showSnackBar('This variant cannot be edited because it has no ID.');

      return;
    }

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return _VariantDialog(
          title: 'Edit Variant',
          confirmText: 'Save Changes',
          initialSize: variant.size,
          initialColor: variant.color,
          initialPrice: variant.price,
          initialStock: variant.stock,
          onSubmit:
              ({
                required String size,
                required String color,
                required double price,
                required int stock,
              }) async {
                return context.read<AdminProductsCubit>().updateVariant(
                  id: variantId,
                  size: size,
                  color: color,
                  price: price,
                  stock: stock,
                );
              },
        );
      },
    );

    if (result == 'success' && mounted) {
      await _loadVariants();
    }
  }

  // ============================================================
  // DELETE VARIANT
  // ============================================================

  Future<void> _deleteVariant(AdminProductVariantModel variant) async {
    final String? variantId = variant.id;

    if (variantId == null || variantId.isEmpty) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete variant?'),
          content: Text('Delete ${variant.size} / ${variant.color}?'),
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

    if (confirmed != true || !mounted) {
      return;
    }

    final String? error = await context
        .read<AdminProductsCubit>()
        .deleteVariant(variantId);

    if (!mounted) {
      return;
    }

    if (error != null) {
      _showSnackBar(error);
      return;
    }

    await _loadVariants();
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBar('Please select a category.');

      return;
    }

    final double? price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) {
      _showSnackBar('Please enter a valid price.');

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ========================================================
      // IMPORTANT:
      //
      // If no new images were selected:
      //
      // images = null
      //
      // Therefore the current backend image(s)
      // are not touched.
      //
      // If new images were selected:
      //
      // images = ALL selected XFiles
      //
      // ========================================================

      final bool success = await context
          .read<AdminProductsCubit>()
          .updateProduct(
            id: widget.product.id,
            name: _nameController.text.trim(),
            categoryId: _selectedCategory!.id,
            price: price,
            images: _newImages.isEmpty ? null : List<XFile>.from(_newImages),
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      if (!success) {
        return;
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showSnackBar('Failed to update product: $error');
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final double screenWidth = mediaQuery.size.width;

    final double screenHeight = mediaQuery.size.height;

    final double sheetWidth = screenWidth.isFinite
        ? screenWidth > 900
              ? 900
              : screenWidth
        : 900;

    final double sheetHeight = screenHeight.isFinite
        ? screenHeight * 0.92
        : 700;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: sheetWidth,
          maxHeight: sheetHeight,
        ),
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
                children: <Widget>[
                  _buildHandle(),

                  Expanded(
                    child:
                        BlocListener<
                          AdminCategoriesCubit,
                          AdminCategoriesState
                        >(
                          listener:
                              (
                                BuildContext context,
                                AdminCategoriesState state,
                              ) {
                                if (state is AdminCategoriesLoaded) {
                                  _selectCurrentCategory(state.categories);
                                }

                                if (state is AdminCategoriesError) {
                                  _showSnackBar(state.message);
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
                                children: <Widget>[
                                  _buildHeader(),

                                  const SizedBox(height: 24),

                                  _buildProductInformation(),

                                  const SizedBox(height: 28),

                                  _buildPhotosSection(),

                                  const SizedBox(height: 28),

                                  _buildVariantsSection(),

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Edit Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Update product information, photos, variants and stock.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: _isSubmitting
              ? null
              : () {
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
      children: <Widget>[
        const Text(
          'Product information',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _nameController,
          enabled: !_isSubmitting,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Product name',
            hintText: 'Enter product name',
            border: OutlineInputBorder(),
          ),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _priceController,
          enabled: !_isSubmitting,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Base price',
            hintText: 'Enter product price',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          validator: (String? value) {
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
      builder: (BuildContext context, AdminCategoriesState state) {
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
                (CategoryModel category) =>
                    category.id == _selectedCategory!.id,
              )) {
            _selectedCategory = null;
          }

          return DropdownButtonFormField<String>(
            value: _selectedCategory?.id,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: categories.map((CategoryModel category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: _isSubmitting
                ? null
                : (String? value) {
                    if (value == null) {
                      return;
                    }

                    final CategoryModel category = categories.firstWhere(
                      (CategoryModel item) => item.id == value,
                    );

                    setState(() {
                      _selectedCategory = category;
                    });
                  },
            validator: (String? value) {
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
              children: <Widget>[
                Expanded(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  tooltip: 'Retry',
                  onPressed: _isSubmitting
                      ? null
                      : () {
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
  // PHOTOS SECTION
  // ============================================================

  Widget _buildPhotosSection() {
    final bool hasNewImages = _newImages.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Product photos',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),

            if (hasNewImages)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_newImages.length} selected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          hasNewImages
              ? 'The selected photos will replace the current product photos when you save.'
              : 'Select multiple photos if you want to replace the current product photo.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 16),

        // ========================================================
        // CURRENT PHOTO
        // ========================================================
        if (!hasNewImages) _buildCurrentPhoto(),

        // ========================================================
        // NEW MULTI PHOTO PREVIEW
        // ========================================================
        if (hasNewImages) _buildNewImagesGrid(),

        const SizedBox(height: 14),

        // ========================================================
        // BUTTONS
        // ========================================================
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool small = constraints.maxWidth < 500;

            if (small) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isSubmitting ? null : _pickNewPhotos,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(
                        hasNewImages
                            ? 'Add More Photos'
                            : 'Add Multiple Photos',
                      ),
                    ),
                  ),

                  if (hasNewImages)
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: _isSubmitting ? null : _removeAllNewPhotos,
                        icon: const Icon(Icons.delete_sweep_outlined),
                        label: const Text('Remove All Selected'),
                      ),
                    ),
                ],
              );
            }

            return Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _pickNewPhotos,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(
                      hasNewImages ? 'Add More Photos' : 'Add Multiple Photos',
                    ),
                  ),
                ),

                if (hasNewImages) ...[
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: _isSubmitting ? null : _removeAllNewPhotos,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('Remove All'),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // CURRENT PHOTO
  // ============================================================

  Widget _buildCurrentPhoto() {
    final String imageUrl = widget.product.thumbnailUrl;

    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isEmpty
          ? Center(
              child: Icon(
                Icons.image_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, String url) {
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (BuildContext context, String url, Object error) {
                return Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
    );
  }

  // ============================================================
  // NEW IMAGE GRID
  // ============================================================

  Widget _buildNewImagesGrid() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
          itemBuilder: (BuildContext context, int index) {
            final XFile image = _newImages[index];

            final Uint8List? bytes = _imageBytes[image.name];

            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // ------------------------------------------------
                  // IMAGE
                  // ------------------------------------------------

                  Container(
                    color: Colors.grey.shade100,
                    child: bytes == null
                        ? const Center(child: CircularProgressIndicator())
                        : Image.memory(bytes, fit: BoxFit.cover),
                  ),

                  // ------------------------------------------------
                  // NUMBER
                  // ------------------------------------------------
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // REMOVE
                  // ------------------------------------------------
                  if (!_isSubmitting)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            _removeNewPhoto(index);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // ------------------------------------------------
                  // MAIN
                  // ------------------------------------------------
                  if (index == 0)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Main',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // VARIANTS SECTION
  // ============================================================

  Widget _buildVariantsSection() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool small = constraints.maxWidth < 500;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (small) ...[
              const Text(
                'Variants & Stock',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _showAddVariantDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Variant'),
                ),
              ),
            ] else ...[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Variants & Stock',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 150,
                    child: OutlinedButton.icon(
                      onPressed: _isSubmitting ? null : _showAddVariantDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Variant'),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),

            Text(
              'Manage size, color, price and available stock for each variant.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 16),

            if (_isLoadingVariants)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_variants.isEmpty)
              _buildEmptyVariants()
            else
              Column(
                children: _variants.map((AdminProductVariantModel variant) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildVariantCard(variant),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EMPTY VARIANTS
  // ============================================================

  Widget _buildEmptyVariants() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inventory_2_outlined,
            size: 42,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          const Text(
            'No variants found',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Add a variant to manage its stock.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VARIANT CARD
  // ============================================================

  Widget _buildVariantCard(AdminProductVariantModel variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${variant.size} • ${variant.color}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              IconButton(
                tooltip: 'Edit variant',
                onPressed: _isSubmitting
                    ? null
                    : () {
                        _showEditVariantDialog(variant);
                      },
                icon: const Icon(Icons.edit_outlined),
              ),

              IconButton(
                tooltip: 'Delete variant',
                onPressed: _isSubmitting
                    ? null
                    : () {
                        _deleteVariant(variant);
                      },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _buildVariantInfo(label: 'Size', value: variant.size),
              _buildVariantInfo(label: 'Color', value: variant.color),
              _buildVariantInfo(
                label: 'Price',
                value: '\$${variant.price.toStringAsFixed(2)}',
              ),
              _buildStockInfo(variant.stock),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantInfo({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey.shade800),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(int stock) {
    final bool outOfStock = stock <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: outOfStock
            ? Colors.red.withValues(alpha: 0.08)
            : Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            outOfStock
                ? Icons.warning_amber_outlined
                : Icons.inventory_2_outlined,
            size: 17,
            color: outOfStock ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 6),
          Text(
            'Stock: $stock',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: outOfStock ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPDATE BUTTON
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton.icon(
        onPressed: _isSubmitting ? null : _submit,
        icon: _isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: Text(_isSubmitting ? 'Updating...' : 'Update Product'),
      ),
    );
  }
}

// ==================================================================
// VARIANT CALLBACK
// ==================================================================

typedef VariantSubmitCallback =
    Future<String?> Function({
      required String size,
      required String color,
      required double price,
      required int stock,
    });

// ==================================================================
// VARIANT DIALOG
// ==================================================================

class _VariantDialog extends StatefulWidget {
  const _VariantDialog({
    required this.title,
    required this.confirmText,
    required this.onSubmit,
    this.initialSize = '',
    this.initialColor = '',
    this.initialPrice = 0,
    this.initialStock = 0,
  });

  final String title;
  final String confirmText;

  final String initialSize;
  final String initialColor;
  final double initialPrice;
  final int initialStock;

  final VariantSubmitCallback onSubmit;

  @override
  State<_VariantDialog> createState() => _VariantDialogState();
}

class _VariantDialogState extends State<_VariantDialog> {
  late final TextEditingController _sizeController;

  late final TextEditingController _colorController;

  late final TextEditingController _priceController;

  late final TextEditingController _stockController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _sizeController = TextEditingController(text: widget.initialSize);

    _colorController = TextEditingController(text: widget.initialColor);

    _priceController = TextEditingController(
      text: widget.initialPrice > 0
          ? widget.initialPrice.toStringAsFixed(2)
          : '',
    );

    _stockController = TextEditingController(
      text: widget.initialStock.toString(),
    );
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _colorController.dispose();
    _priceController.dispose();
    _stockController.dispose();

    super.dispose();
  }

  // ============================================================
  // VARIANT SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double? price = double.tryParse(_priceController.text.trim());

    final int? stock = int.tryParse(_stockController.text.trim());

    if (price == null || price <= 0) {
      return;
    }

    if (stock == null || stock < 0) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final String? error = await widget.onSubmit(
      size: _sizeController.text.trim(),
      color: _colorController.text.trim(),
      price: price,
      stock: stock,
    );

    if (!mounted) {
      return;
    }

    if (error != null) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));

      return;
    }

    Navigator.of(context).pop('success');
  }

  // ============================================================
  // BUILD DIALOG
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _sizeController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    hintText: 'e.g. M, L, XL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Size is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _colorController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    hintText: 'e.g. Black',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Color is required';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _priceController,
                  enabled: !_isSubmitting,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Variant price',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    final double? price = double.tryParse(value?.trim() ?? '');

                    if (price == null || price <= 0) {
                      return 'Enter a valid price';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _stockController,
                  enabled: !_isSubmitting,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Enter available quantity',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  validator: (String? value) {
                    final int? stock = int.tryParse(value?.trim() ?? '');

                    if (stock == null || stock < 0) {
                      return 'Stock must be 0 or greater';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.confirmText),
        ),
      ],
    );
  }
}
