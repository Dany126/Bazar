import 'dart:io';

import 'package:e_commerce/features/admin/presentation/cubit/admin_products_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_products_state.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductSheet extends StatefulWidget {
  final List<CategoryModel> categories;

  const AddProductSheet({super.key, required this.categories});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  CategoryModel? _selectedCategory;
  final List<XFile> _images = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedImages = await _imagePicker.pickMultiImage(imageQuality: 85);

    if (pickedImages.isEmpty) return;

    setState(() {
      _images.addAll(pickedImages);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _createProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showMessage('Please select a category.');
      return;
    }

    if (_images.isEmpty) {
      _showMessage('Please select at least one image.');
      return;
    }

    final price = double.tryParse(_priceController.text.trim());

    final stock = int.tryParse(_stockController.text.trim());

    if (price == null || price < 0) {
      _showMessage('Please enter a valid price.');
      return;
    }

    if (stock == null || stock < 0) {
      _showMessage('Please enter a valid stock.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await context.read<AdminProductsCubit>().createProduct(
      name: _nameController.text.trim(),
      categoryId: _selectedCategory!.id,
      price: price,
      stock: stock,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      imagePaths: _images.map((image) => image.path).toList(),
    );

    if (!mounted) return;

    final state = context.read<AdminProductsCubit>().state;

    if (state is AdminProductsFailure) {
      setState(() {
        _isLoading = false;
      });

      _showMessage(state.message);
      return;
    }

    if (state is AdminProductsLoaded) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully')),
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _priceController,
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
                            return 'Invalid price';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _stockController,
                        label: 'Stock',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }

                          final stock = int.tryParse(value.trim());

                          if (stock == null || stock < 0) {
                            return 'Invalid stock';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter product description',
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

                _buildImages(),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createProduct,
                    child: _isLoading
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
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

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
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<CategoryModel>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: widget.categories.map((category) {
        return DropdownMenuItem<CategoryModel>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: _isLoading
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
        const Text(
          'Product Images',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        OutlinedButton.icon(
          onPressed: _isLoading ? null : _pickImages,
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

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(image.path),
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: _isLoading ? null : () => _removeImage(index),
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
}
