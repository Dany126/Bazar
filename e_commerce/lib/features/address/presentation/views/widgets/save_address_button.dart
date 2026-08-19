import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_cubit.dart';
import 'package:e_commerce/features/address/presentation/model_view/cubit/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveAddressButton extends StatelessWidget {
  const SaveAddressButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        final isSaving = state is AddressLoading;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              onPressed: isSaving ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.kPrimaryAccentColor,
                disabledBackgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Save address',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
