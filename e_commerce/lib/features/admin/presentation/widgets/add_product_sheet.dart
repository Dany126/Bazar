import 'dart:typed_data';

import 'package:e_commerce/features/admin/domain/usecases/create_admin_product_with_variants.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  CategoryModel? _selectedCategory;

  final List<XFile> _images = <XFile>[];

  final Map<String, Uint8List> _imageBytes = <String, Uint8List>{};

  final List<_VariantFormData> _variants = <_VariantFormData>[];

  bool _isSubmitting = false;

  static const List<String> _availableSizes = <String>[
    'S',
    'M',
    'L',
    'XL',
    '2XL',
    '3XL',
  ];

  @override
  void initState() {
    super.initState();

    _addVariant();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final AdminCategoriesCubit categoriesCubit = context
          .read<AdminCategoriesCubit>();

      if (categoriesCubit.state is! AdminCategoriesLoaded) {
        categoriesCubit.loadCategories();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    for (final _VariantFormData variant in _variants) {
      variant.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // IMAGES
  // ============================================================

  Future<void> _pickImages() async {
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

      for (final XFile image in pickedImages) {
        final bool alreadySelected = _images.any(
          (XFile existing) => existing.name == image.name,
        );

        if (alreadySelected) {
          continue;
        }

        final Uint8List bytes = await image.readAsBytes();

        _images.add(image);
        _imageBytes[image.name] = bytes;
      }

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError('Failed to select images: $e');
    }
  }

  void _removeImage(int index) {
    if (_isSubmitting) {
      return;
    }

    if (index < 0 || index >= _images.length) {
      return;
    }

    final XFile image = _images[index];

    _imageBytes.remove(image.name);
    _images.removeAt(index);

    setState(() {});
  }

  // ============================================================
  // VARIANTS
  // ============================================================

  void _addVariant() {
    if (_isSubmitting) {
      return;
    }

    final String basePrice = _priceController.text.trim();

    final _VariantFormData variant = _VariantFormData(price: basePrice);

    setState(() {
      _variants.add(variant);
    });
  }

  void _removeVariant(int index) {
    if (_isSubmitting) {
      return;
    }

    if (_variants.length == 1) {
      _showError('A product must have at least one variant.');
      return;
    }

    if (index < 0 || index >= _variants.length) {
      return;
    }

    final _VariantFormData variant = _variants.removeAt(index);

    variant.dispose();

    setState(() {});
  }

  void _updateVariantPriceFromBasePrice(String value) {
    if (_isSubmitting) {
      return;
    }

    final String trimmed = value.trim();

    if (trimmed.isEmpty) {
      return;
    }

    for (final _VariantFormData variant in _variants) {
      if (variant.priceController.text.trim().isEmpty) {
        variant.priceController.text = trimmed;
      }
    }
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    final FormState? formState = _formKey.currentState;

    if (formState == null) {
      return;
    }

    if (!formState.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showError('Please select a category.');
      return;
    }

    if (_images.isEmpty) {
      _showError('Please select at least one product image.');
      return;
    }

    if (_variants.isEmpty) {
      _showError('Please add at least one variant.');
      return;
    }

    final double? basePrice = double.tryParse(_priceController.text.trim());

    if (basePrice == null || basePrice < 0) {
      _showError('Please enter a valid base price.');
      return;
    }

    final List<AdminProductVariantInput> variantInputs =
        <AdminProductVariantInput>[];

    for (int i = 0; i < _variants.length; i++) {
      final _VariantFormData variant = _variants[i];

      final String color = variant.colorController.text.trim();

      if (color.isEmpty) {
        _showError('Please enter a color for variant ${i + 1}.');
        return;
      }

      final String size = variant.size.trim();

      if (size.isEmpty) {
        _showError('Please select a size for variant ${i + 1}.');
        return;
      }

      final double? variantPrice = double.tryParse(
        variant.priceController.text.trim(),
      );

      if (variantPrice == null || variantPrice < 0) {
        _showError('Please enter a valid price for variant ${i + 1}.');
        return;
      }

      final int? stock = int.tryParse(variant.stockController.text.trim());

      if (stock == null || stock < 0) {
        _showError('Please enter a valid stock for variant ${i + 1}.');
        return;
      }

      variantInputs.add(
        AdminProductVariantInput(
          size: size,
          color: color,
          price: variantPrice,
          stock: stock,
        ),
      );
    }

    final Set<String> combinations = <String>{};

    for (final AdminProductVariantInput variant in variantInputs) {
      final String key =
          '${variant.size.toLowerCase()}_${variant.color.toLowerCase()}';

      if (!combinations.add(key)) {
        _showError(
          'Duplicate variant: '
          '${variant.size} / ${variant.color}.',
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bool success = await context
          .read<AdminProductsCubit>()
          .createProductWithVariants(
            name: _nameController.text.trim(),
            categoryId: _selectedCategory!.id,
            price: basePrice,
            images: _images,
            variants: variantInputs,
          );

      if (!mounted) {
        return;
      }

      if (!success) {
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      /*
       * Do NOT call loadProducts() here.
       *
       * createProductWithVariants()
       * should handle refreshing the products
       * inside the Cubit.
       */

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Product created successfully.')),
        );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showError('Failed to create product: $e');
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _showError(String message) {
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
              children: <Widget>[
                _buildSheetHandle(),

                Expanded(
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

                          const SizedBox(height: 24),

                          _buildImagesSection(),

                          const SizedBox(height: 24),

                          _buildVariantsSection(),

                          const SizedBox(height: 32),

                          _buildSubmitButton(),
                        ],
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
  // SHEET HANDLE
  // ============================================================

  Widget _buildSheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Text(
            'Add Product',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
          'Product Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _nameController,
          enabled: !_isSubmitting,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            hintText: 'Enter product name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shopping_bag_outlined),
          ),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }

            if (value.trim().length < 2) {
              return 'Product name is too short';
            }

            return null;
          },
        ),

        const SizedBox(height: 16),

        _buildCategoryDropdown(),

        const SizedBox(height: 16),

        TextFormField(
          controller: _priceController,
          enabled: !_isSubmitting,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Base Price',
            hintText: 'Enter base price',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.payments_outlined),
          ),
          onChanged: _updateVariantPriceFromBasePrice,
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Price is required';
            }

            final double? price = double.tryParse(value.trim());

            if (price == null) {
              return 'Enter a valid price';
            }

            if (price < 0) {
              return 'Price cannot be negative';
            }

            return null;
          },
        ),
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
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (state is AdminCategoriesError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.error),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),

                const SizedBox(width: 12),

                Expanded(child: Text(state.message)),

                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          context.read<AdminCategoriesCubit>().loadCategories();
                        },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! AdminCategoriesLoaded) {
          return const SizedBox.shrink();
        }

        final List<CategoryModel> categories = state.categories;

        if (categories.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.category_outlined),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No categories available. '
                    'Create a category first.',
                  ),
                ),
              ],
            ),
          );
        }

        return DropdownButtonFormField<CategoryModel>(
          value: _selectedCategory,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: categories.map((CategoryModel category) {
            return DropdownMenuItem<CategoryModel>(
              value: category,
              child: Text(category.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: _isSubmitting
              ? null
              : (CategoryModel? category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
          validator: (CategoryModel? value) {
            if (value == null) {
              return 'Category is required';
            }

            return null;
          },
        );
      },
    );
  }

  // ============================================================
  // IMAGES
  // ============================================================

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Product Images',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

            if (_images.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_images.length} selected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _isSubmitting ? null : _pickImages,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Select Product Images'),
          ),
        ),

        const SizedBox(height: 16),

        if (_images.isEmpty) _buildEmptyImagesState() else _buildImageGrid(),
      ],
    );
  }

  Widget _buildEmptyImagesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.photo_library_outlined, size: 44),
          SizedBox(height: 10),
          Text(
            'No images selected',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Add one or more images '
            'for the product.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
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
          itemCount: _images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            final XFile image = _images[index];

            final Uint8List? bytes = _imageBytes[image.name];

            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: bytes == null
                        ? const Center(child: CircularProgressIndicator())
                        : Image.memory(bytes, fit: BoxFit.cover),
                  ),
                ),

                if (!_isSubmitting)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _removeImage(index);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
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
  // VARIANTS
  // ============================================================

  Widget _buildVariantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Product Variants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Define size, color, '
                    'price and stock.',
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // FIX: Without Flexible, this OutlinedButton.icon can be
            // handed unbounded/infinite width constraints in certain
            // layout situations (e.g. narrow parents, nested
            // Row/Column combos in the scroll view), which crashes
            // with "BoxConstraints forces an infinite width."
            // Wrapping it in Flexible lets the Row give it a bounded
            // width while still sizing to its content when possible.
            Flexible(
              child: OutlinedButton.icon(
                onPressed: _isSubmitting ? null : _addVariant,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Variant',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _variants.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (BuildContext context, int index) {
            return _buildVariantCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildVariantCard(int index) {
    final _VariantFormData variant = _variants[index];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Variant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),

              IconButton(
                tooltip: 'Remove variant',
                onPressed: _isSubmitting
                    ? null
                    : () {
                        _removeVariant(index);
                      },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth < 600;

              if (compact) {
                return Column(
                  children: <Widget>[
                    _buildSizeDropdown(variant),

                    const SizedBox(height: 12),

                    _buildColorField(variant),

                    const SizedBox(height: 12),

                    _buildVariantPriceField(variant),

                    const SizedBox(height: 12),

                    _buildStockField(variant),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: _buildSizeDropdown(variant)),

                  const SizedBox(width: 12),

                  Expanded(child: _buildColorField(variant)),

                  const SizedBox(width: 12),

                  Expanded(child: _buildVariantPriceField(variant)),

                  const SizedBox(width: 12),

                  Expanded(child: _buildStockField(variant)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIZE
  // ============================================================

  Widget _buildSizeDropdown(_VariantFormData variant) {
    return DropdownButtonFormField<String>(
      value: variant.size.isEmpty ? null : variant.size,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Size',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.straighten_outlined),
      ),
      items: _availableSizes.map((String size) {
        return DropdownMenuItem<String>(value: size, child: Text(size));
      }).toList(),
      onChanged: _isSubmitting
          ? null
          : (String? value) {
              if (value == null) {
                return;
              }

              setState(() {
                variant.size = value;
              });
            },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }

        return null;
      },
    );
  }

  // ============================================================
  // COLOR
  // ============================================================

  Widget _buildColorField(_VariantFormData variant) {
    return TextFormField(
      controller: variant.colorController,
      enabled: !_isSubmitting,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Color',
        hintText: 'e.g. Black',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.palette_outlined),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }

        return null;
      },
    );
  }

  // ============================================================
  // PRICE
  // ============================================================

  Widget _buildVariantPriceField(_VariantFormData variant) {
    return TextFormField(
      controller: variant.priceController,
      enabled: !_isSubmitting,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Price',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.payments_outlined),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }

        final double? price = double.tryParse(value.trim());

        if (price == null || price < 0) {
          return 'Invalid';
        }

        return null;
      },
    );
  }

  // ============================================================
  // STOCK
  // ============================================================

  Widget _buildStockField(_VariantFormData variant) {
    return TextFormField(
      controller: variant.stockController,
      enabled: !_isSubmitting,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Stock',
        hintText: '0',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2_outlined),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }

        final int? stock = int.tryParse(value.trim());

        if (stock == null || stock < 0) {
          return 'Invalid';
        }

        return null;
      },
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: _isSubmitting ? null : _submit,
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add_shopping_cart),
                  SizedBox(width: 8),
                  Text(
                    'Create Product',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }
}

// ================================================================
// UI FORM MODEL
// ================================================================

class _VariantFormData {
  _VariantFormData({String price = ''})
    : priceController = TextEditingController(text: price),
      colorController = TextEditingController(),
      stockController = TextEditingController();

  // IMPORTANT:
  // Backend supports:
  // S, M, L, XL, 2XL, 3XL.
  //
  // Start with a valid size so the first
  // variant is immediately valid.
  String size = 'S';

  final TextEditingController colorController;

  final TextEditingController priceController;

  final TextEditingController stockController;

  void dispose() {
    colorController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
