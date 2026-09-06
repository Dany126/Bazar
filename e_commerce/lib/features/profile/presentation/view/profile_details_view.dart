import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color kProfileAccentColor = Color(0xFF7B61FF);

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({
    super.key,
    this.initialName = '',
    this.initialEmail = '',
    this.initialPhone = '',
    this.initialImageUrl,
  });

  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String? initialImageUrl;

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialName);

    _emailController = TextEditingController(text: widget.initialEmail);

    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    if (!_isEditing || _isSaving) {
      return;
    }

    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedImage == null) {
        return;
      }

      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage('Failed to select image');
    }
  }

  // ============================================================
  // TAKE PHOTO
  // ============================================================

  Future<void> _takePhoto() async {
    if (!_isEditing || _isSaving) {
      return;
    }

    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedImage == null) {
        return;
      }

      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage('Failed to take photo');
    }
  }

  // ============================================================
  // SHOW IMAGE OPTIONS
  // ============================================================

  void _showImageOptions() {
    if (!_isEditing || _isSaving) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Change Profile Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: kProfileAccentColor,
                    child: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),

                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: kProfileAccentColor,
                    child: Icon(Icons.camera_alt_outlined, color: Colors.white),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),

                if (_selectedImage != null ||
                    (widget.initialImageUrl != null &&
                        widget.initialImageUrl!.trim().isNotEmpty))
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    title: const Text('Remove Photo'),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        _selectedImage = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // START EDITING
  // ============================================================

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  // ============================================================
  // CANCEL
  // ============================================================

  void _cancelEditing() {
    setState(() {
      _nameController.text = widget.initialName;

      _emailController.text = widget.initialEmail;

      _phoneController.text = widget.initialPhone;

      _selectedImage = null;

      _isEditing = false;
    });
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    final email = _emailController.text.trim();

    final _ = _phoneController.text.trim();

    if (name.isEmpty) {
      _showMessage('Name cannot be empty');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Email cannot be empty');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage('Please enter a valid email');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    /*
     * IMPORTANT:
     *
     * _selectedImage contains the NEW profile image.
     *
     * When we connect the backend, this File will be uploaded
     * to Cloudinary and the returned URL will be saved in the
     * user's imageUrl field.
     *
     * We are NOT pretending to upload it here.
     */

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    // Return the selected image to ProfileView.
    Navigator.pop(context, _selectedImage);
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  Widget _buildProfileImage() {
    // NEW LOCAL IMAGE
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

    // EXISTING SERVER IMAGE
    final imageUrl = widget.initialImageUrl?.trim();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }

    return _buildDefaultAvatar();
  }

  // ============================================================
  // DEFAULT AVATAR
  // ============================================================

  Widget _buildDefaultAvatar() {
    final name = _nameController.text.trim();

    final letter = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';

    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      color: kProfileAccentColor,
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: _buildProfileImage(),
              ),

              if (_isEditing)
                Positioned(
                  right: -3,
                  bottom: -3,
                  child: GestureDetector(
                    onTap: _showImageOptions,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kProfileAccentColor,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            _nameController.text.trim().isEmpty
                ? 'User'
                : _nameController.text.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            _emailController.text.trim().isEmpty
                ? 'No email'
                : _emailController.text.trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          if (_isEditing) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showImageOptions,
              child: const Text(
                'Change profile photo',
                style: TextStyle(
                  color: kProfileAccentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled ? kProfileAccentColor : Colors.black45,
            ),
            filled: true,
            fillColor: enabled ? Colors.grey.shade100 : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: kProfileAccentColor,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: kProfileAccentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: kProfileAccentColor.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save Changes',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.black45),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tap the edit button to update your profile information.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: _isSaving
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
        ),

        title: const Text(
          'Profile Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined, color: Colors.black),
            )
          else
            IconButton(
              onPressed: _isSaving ? null : _cancelEditing,
              icon: const Icon(Icons.close, color: Colors.black),
            ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),

              const SizedBox(height: 32),

              _buildSectionTitle('Personal Information'),

              const SizedBox(height: 14),

              _buildTextField(
                label: 'Full Name',
                controller: _nameController,
                icon: Icons.person_outline,
                enabled: _isEditing && !_isSaving,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: _isEditing && !_isSaving,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                label: 'Phone Number',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                enabled: _isEditing && !_isSaving,
              ),

              const SizedBox(height: 30),

              if (_isEditing) _buildSaveButton(),

              if (!_isEditing) _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}
