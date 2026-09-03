import 'dart:typed_data';

import 'package:e_commerce/core/services/get_it_services.dart';
import 'package:e_commerce/features/admin/domain/usecases/get_all_admin_categories.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;

  final List<XFile> _images = [];
  final Map<String, Uint8List> _imageBytes = {};

  final List<_VariantFormData> _variants = [];

  bool _isLoadingCategories = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    // Start with one variant so the form is immediately usable.
    _addVariant();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    for (final variant in _variants) {
      variant.dispose();
    }

    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final result = await getIt<GetAllAdminCategoriesUseCase>()();

      result.fold(
        (failure) {
          if (!mounted) return;

          setState(() {
            _isLoadingCategories = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (categories) {
          if (!mounted) return;

          setState(() {
            _categories = categories;
            _isLoadingCategories = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingCategories = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load categories: $e')));
    }
  }

  Future<void> _pickImages() async {
    if (_isSubmitting) return;

    try {
      final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);

      if (pickedImages.isEmpty) return;

      for (final image in pickedImages) {
        final bytes = await image.readAsBytes();

        if (!_images.any((existing) => existing.name == image.name)) {
          _images.add(image);
          _imageBytes[image.name] = bytes;
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to select images: $e')));
    }
  }

  void _removeImage(int index) {
    if (_isSubmitting) return;

    final image = _images[index];

    _imageBytes.remove(image.name);
    _images.removeAt(index);

    setState(() {});
  }

  void _addVariant() {
    if (_isSubmitting) return;

    final basePrice = double.tryParse(_priceController.text.trim());

    final variant = _VariantFormData(
      price: basePrice != null ? basePrice.toString() : '',
    );

    setState(() {
      _variants.add(variant);
    });
  }

  void _removeVariant(int index) {
    if (_isSubmitting) return;

    if (_variants.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A product must have at least one variant.'),
        ),
      );
      return;
    }

    final variant = _variants.removeAt(index);
    variant.dispose();

    setState(() {});
  }

  void _updateVariantPriceFromBasePrice(String value) {
    if (_isSubmitting) return;

    final trimmed = value.trim();

    if (trimmed.isEmpty) return;

    for (final variant in _variants) {
      if (variant.priceController.text.trim().isEmpty) {
        variant.priceController.text = trimmed;
      }
    }

    setState(() {});
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product image.'),
        ),
      );
      return;
    }

    if (_variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one variant.')),
      );
      return;
    }

    for (int i = 0; i < _variants.length; i++) {
      final variant = _variants[i];

      if (variant.colorController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a color for variant ${i + 1}.')),
        );
        return;
      }

      final price = double.tryParse(variant.priceController.text.trim());

      if (price == null || price < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid price for variant ${i + 1}.'),
          ),
        );
        return;
      }

      final stock = int.tryParse(variant.stockController.text.trim());

      if (stock == null || stock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid stock for variant ${i + 1}.'),
          ),
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final cubit = context.read<AdminProductsCubit>();

      final ProductModel? product = await cubit.createProduct(
        name: _nameController.text.trim(),
        categoryId: _selectedCategory!.id,
        price: double.parse(_priceController.text.trim()),
        images: _images,
      );

      if (!mounted) return;

      if (product == null) {
        setState(() {
          _isSubmitting = false;
        });

        return;
      }

      final productId = product.id;

      if (productId.isEmpty) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Product was created but no product ID was returned.',
            ),
          ),
        );

        return;
      }

      String? variantError;

      for (final variant in _variants) {
        final error = await cubit.createVariant(
          productId: productId,
          size: variant.size,
          color: variant.colorController.text.trim(),
          price: double.parse(variant.priceController.text.trim()),
          stock: int.parse(variant.stockController.text.trim()),
        );

        if (error != null) {
          variantError = error;
          break;
        }
      }

      if (!mounted) return;

      if (variantError != null) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product created, but a variant failed: $variantError',
            ),
          ),
        );

        await cubit.loadProducts();

        if (mounted) {
          Navigator.of(context).pop();
        }

        return;
      }

      await cubit.loadProducts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully.')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create product: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;

            final contentWidth = width > 900 ? 850.0 : width;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildHeader(),
                      const Divider(height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProductInformation(),

                              const SizedBox(height: 24),

                              _buildImages(),

                              const SizedBox(height: 28),

                              _buildVariants(),

                              const SizedBox(height: 32),

                              _buildSubmitButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Add Product',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
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
          ),
          onChanged: _updateVariantPriceFromBasePrice,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Price is required';
            }

            final price = double.tryParse(value.trim());

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

  Widget _buildCategoryDropdown() {
    if (_isLoadingCategories) {
      return const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_categories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No categories available',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text('Create a category first before adding a product.'),
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
      ),
      items: _categories.map((category) {
        return DropdownMenuItem<CategoryModel>(
          value: category,
          child: Text(category.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: _isSubmitting
          ? null
          : (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
      validator: (value) {
        if (value == null) {
          return 'Category is required';
        }

        return null;
      },
    );
  }

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Product Images',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '${_images.length} selected',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // IMPORTANT:
        // This button has finite width and therefore cannot
        // produce BoxConstraints(w=Infinity).
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            onPressed: _isSubmitting ? null : _pickImages,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Select Images'),
          ),
        ),

        const SizedBox(height: 16),

        if (_images.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.photo_library_outlined, size: 42),
                SizedBox(height: 10),
                Text('No images selected'),
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_images.length, (index) {
              final image = _images[index];
              final bytes = _imageBytes[image.name];

              return _buildImagePreview(index: index, bytes: bytes);
            }),
          ),
      ],
    );
  }

  Widget _buildImagePreview({required int index, required Uint8List? bytes}) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: bytes == null
                  ? Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image_outlined, size: 32),
                    )
                  : Image.memory(bytes, fit: BoxFit.cover),
            ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _isSubmitting ? null : () => _removeImage(index),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ),

          if (index == 0)
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Main',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVariants() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 48;

        return SizedBox(
          width: availableWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Variants',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // FIX:
                  // Never use double.infinity here.
                  // This button is inside a Row.
                  SizedBox(
                    width: 130,
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: _isSubmitting ? null : _addVariant,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'Add Variant',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (_variants.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('No variants added.')),
                ),

              ...List.generate(_variants.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildVariantCard(index, _variants[index]),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVariantCard(int index, _VariantFormData variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Variant ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              IconButton(
                tooltip: 'Remove variant',
                onPressed: _isSubmitting ? null : () => _removeVariant(index),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: variant.size,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Size',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'S', child: Text('S')),
              DropdownMenuItem(value: 'M', child: Text('M')),
              DropdownMenuItem(value: 'L', child: Text('L')),
              DropdownMenuItem(value: 'XL', child: Text('XL')),
              DropdownMenuItem(value: '2XL', child: Text('2XL')),
              DropdownMenuItem(value: '3XL', child: Text('3XL')),
            ],
            onChanged: _isSubmitting
                ? null
                : (value) {
                    if (value == null) return;

                    setState(() {
                      variant.size = value;
                    });
                  },
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: variant.colorController,
            enabled: !_isSubmitting,
            decoration: const InputDecoration(
              labelText: 'Color',
              hintText: 'Example: black or #000000',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 500) {
                return Column(
                  children: [
                    TextFormField(
                      controller: variant.priceController,
                      enabled: !_isSubmitting,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: variant.stockController,
                      enabled: !_isSubmitting,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: variant.priceController,
                      enabled: !_isSubmitting,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: TextFormField(
                      controller: variant.stockController,
                      enabled: !_isSubmitting,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

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
            : const Text(
                'Create Product',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

class _VariantFormData {
  String size;

  final TextEditingController colorController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  _VariantFormData({String? price})
    : size = 'S',
      colorController = TextEditingController(),
      priceController = TextEditingController(text: price ?? ''),
      stockController = TextEditingController(text: '0');

  void dispose() {
    colorController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
