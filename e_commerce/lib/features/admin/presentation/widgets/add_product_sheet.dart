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

  // ============================================================
  // MULTI IMAGE STATE
  // ============================================================

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
  // MULTI PHOTO
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

      final List<XFile> newImages = <XFile>[];

      for (final XFile image in pickedImages) {
        final bool alreadySelected = _images.any(
          (XFile existing) => existing.name == image.name,
        );

        if (alreadySelected) {
          continue;
        }

        final Uint8List bytes = await image.readAsBytes();

        newImages.add(image);
        _imageBytes[image.name] = bytes;
      }

      if (newImages.isEmpty) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _images.addAll(newImages);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError('Failed to select images: $error');
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

    setState(() {
      _images.removeAt(index);
      _imageBytes.remove(image.name);
    });
  }

  void _clearAllImages() {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _images.clear();
      _imageBytes.clear();
    });
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

    // ----------------------------------------------------------
    // MULTI IMAGE VALIDATION
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // BUILD VARIANTS
    // ----------------------------------------------------------

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

    // ----------------------------------------------------------
    // DUPLICATE VARIANT CHECK
    // ----------------------------------------------------------

    final Set<String> combinations = <String>{};

    for (final AdminProductVariantInput variant in variantInputs) {
      final String key =
          '${variant.size.toLowerCase()}_'
          '${variant.color.toLowerCase()}';

      if (!combinations.add(key)) {
        _showError(
          'Duplicate variant: '
          '${variant.size} / ${variant.color}.',
        );
        return;
      }
    }

    // ----------------------------------------------------------
    // SUBMIT
    // ----------------------------------------------------------

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

            // IMPORTANT:
            // Send ALL selected images.
            images: List<XFile>.from(_images),

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

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Product created successfully.')),
        );

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showError('Failed to create product: $error');
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

    final double screenHeight = mediaQuery.size.height;

    final double sheetWidth = screenWidth > 900 ? 900 : screenWidth;

    final double sheetHeight = screenHeight * 0.90;

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
  // HANDLE
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
  // MULTI IMAGE SECTION
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
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.10),
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

        const SizedBox(height: 8),

        Text(
          'Select multiple images for the product.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),

        const SizedBox(height: 14),

        // --------------------------------------------------------
        // ADD MULTIPLE PHOTOS BUTTON
        // --------------------------------------------------------
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _isSubmitting ? null : _pickImages,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              _images.isEmpty ? 'Add Multiple Photos' : 'Add More Photos',
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (_images.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _isSubmitting ? null : _clearAllImages,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Remove All Photos'),
            ),
          ),

        const SizedBox(height: 8),

        // --------------------------------------------------------
        // IMAGE PREVIEW
        // --------------------------------------------------------
        if (_images.isEmpty) _buildEmptyImagesState() else _buildImageGrid(),
      ],
    );
  }

  Widget _buildEmptyImagesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: <Widget>[
          Icon(Icons.photo_library_outlined, size: 48),

          SizedBox(height: 12),

          Text(
            'No images selected',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 6),

          Text(
            'Click "Add Multiple Photos" '
            'to select one or more images.',
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

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                  // IMAGE NUMBER
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
                  // REMOVE BUTTON
                  // ------------------------------------------------
                  if (!_isSubmitting)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            _removeImage(index);
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
                  // MAIN IMAGE LABEL
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
                  Text('Define size, color, price and stock.'),
                ],
              ),
            ),

            const SizedBox(width: 12),

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
  // SUBMIT BUTTON
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
// VARIANT FORM MODEL
// ================================================================

class _VariantFormData {
  _VariantFormData({String price = ''})
    : priceController = TextEditingController(text: price),
      colorController = TextEditingController(),
      stockController = TextEditingController();

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
