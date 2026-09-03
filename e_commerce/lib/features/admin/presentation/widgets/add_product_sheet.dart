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

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  CategoryModel? _selectedCategory;

  final List<CategoryModel> _categories = [];

  final List<XFile> _images = [];

  final Map<String, Uint8List> _imageBytes = {};

  final List<_VariantFormData> _variants = [];

  bool _loadingCategories = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _loadCategories();

    // Start with one variant.
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

  // ============================================================
  // CATEGORIES
  // ============================================================

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
    });

    final result = await getIt<GetAllAdminCategoriesUseCase>()();

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loadingCategories = false;
        });

        _showMessage(failure.message);
      },
      (categories) {
        setState(() {
          _categories
            ..clear()
            ..addAll(categories);

          _loadingCategories = false;
        });
      },
    );
  }

  // ============================================================
  // IMAGES
  // ============================================================

  Future<void> _pickImages() async {
    if (_isSubmitting) return;

    try {
      final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);

      if (pickedImages.isEmpty) return;

      for (final image in pickedImages) {
        final bytes = await image.readAsBytes();

        if (!mounted) return;

        setState(() {
          _images.add(image);
          _imageBytes[image.name] = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage('Failed to select images: $e');
    }
  }

  void _removeImage(int index) {
    if (_isSubmitting) return;

    final image = _images[index];

    setState(() {
      _images.removeAt(index);
      _imageBytes.remove(image.name);
    });
  }

  // ============================================================
  // VARIANTS
  // ============================================================

  void _addVariant() {
    setState(() {
      _variants.add(_VariantFormData(price: _priceController.text));
    });
  }

  void _removeVariant(int index) {
    if (_isSubmitting) return;

    if (_variants.length == 1) {
      _showMessage('At least one variant is required.');
      return;
    }

    final variant = _variants[index];

    variant.dispose();

    setState(() {
      _variants.removeAt(index);
    });
  }

  // ============================================================
  // CREATE PRODUCT + VARIANTS
  // ============================================================

  Future<void> _createProduct() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showMessage('Please select a category.');
      return;
    }

    if (_images.isEmpty) {
      _showMessage('Please select at least one product image.');
      return;
    }

    if (_variants.isEmpty) {
      _showMessage('Please add at least one variant.');
      return;
    }

    final basePrice = double.tryParse(_priceController.text.trim());

    if (basePrice == null || basePrice < 0) {
      _showMessage('Please enter a valid price.');
      return;
    }

    // Validate variants manually.
    for (int i = 0; i < _variants.length; i++) {
      final variant = _variants[i];

      if (variant.size == null) {
        _showMessage('Please select a size for variant ${i + 1}.');
        return;
      }

      final color = variant.colorController.text.trim();

      if (color.isEmpty) {
        _showMessage('Please enter a color for variant ${i + 1}.');
        return;
      }

      final variantPrice = double.tryParse(variant.priceController.text.trim());

      if (variantPrice == null || variantPrice < 0) {
        _showMessage('Please enter a valid price for variant ${i + 1}.');
        return;
      }

      final stock = int.tryParse(variant.stockController.text.trim());

      if (stock == null || stock < 0) {
        _showMessage('Please enter valid stock for variant ${i + 1}.');
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    final cubit = context.read<AdminProductsCubit>();

    // ------------------------------------------------------------
    // STEP 1: CREATE PRODUCT
    // ------------------------------------------------------------

    final ProductModel? product = await cubit.createProduct(
      name: _nameController.text.trim(),
      categoryId: _selectedCategory!.id,
      price: basePrice,
      images: _images,
    );

    if (!mounted) return;

    if (product == null) {
      setState(() {
        _isSubmitting = false;
      });

      return;
    }

    // ------------------------------------------------------------
    // STEP 2: CREATE VARIANTS
    // ------------------------------------------------------------

    final List<String> variantErrors = [];

    for (final variant in _variants) {
      final variantPrice = double.parse(variant.priceController.text.trim());

      final stock = int.parse(variant.stockController.text.trim());

      final error = await cubit.createVariant(
        productId: product.id,
        size: variant.size!,
        color: variant.colorController.text.trim(),
        price: variantPrice,
        stock: stock,
      );

      if (error != null) {
        variantErrors.add(error);
      }
    }

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // ------------------------------------------------------------
    // RESULT
    // ------------------------------------------------------------

    if (variantErrors.isNotEmpty) {
      _showMessage(
        'Product was created, but some variants failed:\n'
        '${variantErrors.join('\n')}',
      );

      // Still refresh products.
      await cubit.loadProducts();

      if (!mounted) return;

      Navigator.of(context).pop();
      return;
    }

    await cubit.loadProducts();

    if (!mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product and variants created successfully'),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                _buildTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  hint: 'Enter product name',
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

                _buildTextField(
                  controller: _priceController,
                  label: 'Base Price',
                  hint: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }

                    final price = double.tryParse(value.trim());

                    if (price == null || price < 0) {
                      return 'Invalid price';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildImages(),

                const SizedBox(height: 28),

                _buildVariants(),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _createProduct,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Create Product',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
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
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: !_isSubmitting,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ============================================================
  // CATEGORY DROPDOWN
  // ============================================================

  Widget _buildCategoryDropdown() {
    if (_loadingCategories) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading categories...'),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          errorText: 'No categories available',
        ),
        child: const Text('Create a category first'),
      );
    }

    return DropdownButtonFormField<CategoryModel>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  // ============================================================
  // IMAGES
  // ============================================================

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: _isSubmitting ? null : _pickImages,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Select Images'),
        ),

        if (_images.isNotEmpty) ...[
          const SizedBox(height: 12),

          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final image = _images[index];
                final bytes = _imageBytes[image.name];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: bytes == null
                          ? Container(
                              width: 110,
                              height: 110,
                              color: Colors.grey.shade200,
                              child: const CircularProgressIndicator(),
                            )
                          : Image.memory(
                              bytes,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                    ),

                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: _isSubmitting ? null : () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // VARIANTS
  // ============================================================

  Widget _buildVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Variants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _addVariant,
              icon: const Icon(Icons.add),
              label: const Text('Add Variant'),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...List.generate(_variants.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildVariantCard(index, _variants[index]),
          );
        }),
      ],
    );
  }

  Widget _buildVariantCard(int index, _VariantFormData variant) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Variant ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove variant',
                  onPressed: _isSubmitting ? null : () => _removeVariant(index),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: variant.size,
              decoration: InputDecoration(
                labelText: 'Size',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const ['S', 'M', 'L', 'XL', '2XL', '3XL'].map((size) {
                return DropdownMenuItem<String>(value: size, child: Text(size));
              }).toList(),
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      setState(() {
                        variant.size = value;
                      });
                    },
              validator: (value) {
                if (value == null) {
                  return 'Size is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            _buildTextField(
              controller: variant.colorController,
              label: 'Color',
              hint: '#FF0000 or Red',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Color is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: variant.priceController,
                    label: 'Price',
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }

                      final price = double.tryParse(value.trim());

                      if (price == null || price < 0) {
                        return 'Invalid';
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildTextField(
                    controller: variant.stockController,
                    label: 'Stock',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }

                      final stock = int.tryParse(value.trim());

                      if (stock == null || stock < 0) {
                        return 'Invalid';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// VARIANT FORM DATA
// ============================================================

class _VariantFormData {
  String? size;

  final TextEditingController colorController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController stockController = TextEditingController(
    text: '0',
  );

  _VariantFormData({String? price}) {
    if (price != null && price.isNotEmpty) {
      priceController.text = price;
    }
  }

  void dispose() {
    colorController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}
