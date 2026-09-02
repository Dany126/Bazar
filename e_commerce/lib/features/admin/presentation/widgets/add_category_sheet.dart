import 'dart:typed_data';

import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_cubit.dart';
import 'package:e_commerce/features/admin/presentation/cubit/admin_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final TextEditingController nameController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  XFile? selectedImage;
  Uint8List? imageBytes;

  bool isSubmitting = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) {
        return;
      }

      final Uint8List bytes = await image.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        selectedImage = image;
        imageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage('Failed to select image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      selectedImage = null;
      imageBytes = null;
    });
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter category name');
      return;
    }

    if (selectedImage == null) {
      _showMessage('Please select category image');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    await context.read<AdminCategoriesCubit>().createCategory(
      name: name,
      image: selectedImage!,
    );

    if (!mounted) {
      return;
    }

    final state = context.read<AdminCategoriesCubit>().state;

    if (state is AdminCategoriesError) {
      setState(() {
        isSubmitting = false;
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xffDDDEE5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Add Category',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff20222F),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Create a new product category',
                style: TextStyle(fontSize: 13, color: Color(0xff858897)),
              ),

              const SizedBox(height: 24),

              const Text(
                'Category Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff252735),
                ),
              ),

              const SizedBox(height: 10),

              _CategoryImagePicker(
                imageBytes: imageBytes,
                onPick: _pickImage,
                onRemove: selectedImage == null ? null : _removeImage,
              ),

              const SizedBox(height: 20),

              const Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff252735),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  filled: true,
                  fillColor: const Color(0xffF8F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xffE8EAF0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff6C63FF)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Color(0xffE1E2E8)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6C63FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Add Category'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onPick;
  final VoidCallback? onRemove;

  const _CategoryImagePicker({
    required this.imageBytes,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;

    return GestureDetector(
      onTap: onPick,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xffF8F9FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffE1E2E8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(imageBytes!, fit: BoxFit.cover),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onRemove,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.white, size: 17),
                          SizedBox(width: 7),
                          Text(
                            'Change image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 42,
                    color: Color(0xff6C63FF),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Upload category image',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Click to choose an image',
                    style: TextStyle(fontSize: 12, color: Color(0xff858897)),
                  ),
                ],
              ),
      ),
    );
  }
}
