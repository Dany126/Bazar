import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartErrorState extends StatelessWidget {
  const CartErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.textStylesRegular16(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().getCart();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
