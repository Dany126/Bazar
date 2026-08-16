import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _streetController.text.trim().isNotEmpty &&
      _cityController.text.trim().isNotEmpty &&
      _countryController.text.trim().isNotEmpty &&
      _postalCodeController.text.trim().isNotEmpty;

  void _save() {
    if (!_isValid) return;
    context.read<AddressCubit>().addAddress(
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AddressCubit, AddressState>(
          listener: (context, state) {
            if (state is AddressLoaded) {
              Navigator.of(context).pop();
            }
            if (state is AddressError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildField(
                  controller: _streetController,
                  hint: 'Street Address',
                ),
                const SizedBox(height: 12),
                _buildField(controller: _cityController, hint: 'City'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _countryController,
                        hint: 'Country',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _postalCodeController,
                        hint: 'Zip Code',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    final isSaving = state is AddressLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: isSaving ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.kCardBackgroundColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(21),
              child: Ink(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Add Address',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Colors.black38),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
