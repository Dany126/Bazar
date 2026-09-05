import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key, this.category});

  final CategoryModel? category;

  bool get isEditing => category != null;

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  late final TextEditingController _nameController;

  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.category?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter a category name.');
      return;
    }

    // Creating a category requires an image.
    if (!widget.isEditing && _selectedImage == null) {
      _showMessage('Please select a category image.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final cubit = context.read<AdminCategoriesCubit>();

    if (widget.isEditing) {
      await cubit.updateCategory(
        id: widget.category!.id,
        name: name,
        image: _selectedImage,
      );
    } else {
      await cubit.createCategory(name: name, image: _selectedImage!);
    }

    if (!mounted) return;

    final state = cubit.state;

    if (state is AdminCategoriesError) {
      setState(() {
        _isSubmitting = false;
      });

      _showMessage(state.message);
      return;
    }

    Navigator.of(context).pop();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminCategoriesCubit, AdminCategoriesState>(
      listener: (context, state) {
        if (state is AdminCategoriesError && _isSubmitting) {
          if (mounted) {
            setState(() {
              _isSubmitting = false;
            });
          }
        }
      },
      child: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 650),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                const SizedBox(height: 24),

                _buildNameField(),

                const SizedBox(height: 20),

                _buildImagePicker(),

                const SizedBox(height: 28),

                _buildSubmitButton(),
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
        Expanded(
          child: Text(
            widget.isEditing ? 'Edit Category' : 'Add Category',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff20222F),
            ),
          ),
        ),

        IconButton(
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

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff20222F),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.done,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            hintText: 'Enter category name',
            filled: true,
            fillColor: const Color(0xffF8F8FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE8EAF0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE8EAF0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff6C63FF),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    final image = _selectedImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Image',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff20222F),
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: _isSubmitting ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xffF8F8FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xffE8EAF0)),
            ),
            child: image != null
                ? _buildSelectedImage(image)
                : _buildExistingOrEmptyImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImage(XFile image) {
    return FutureBuilder<List<int>>(
      future: image.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.memory(
            snapshot.data! as dynamic,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }

  Widget _buildExistingOrEmptyImage() {
    final existingImage = widget.category?.imageUrl;

    if (existingImage != null && existingImage.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              existingImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _buildImagePlaceholder();
              },
            ),
          ),

          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Change image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 42, color: Color(0xff777B8C)),
        SizedBox(height: 10),
        Text(
          'Select image',
          style: TextStyle(
            color: Color(0xff555A6F),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'PNG, JPG or JPEG',
          style: TextStyle(color: Color(0xff999CAA), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff6C63FF),
          disabledBackgroundColor: const Color(0xffB8B5D8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                widget.isEditing ? 'Update Category' : 'Create Category',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
