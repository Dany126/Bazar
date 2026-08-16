import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/checkout/presentation/views/checkout_view.dart';
import 'package:flutter/material.dart';

class CartCheckoutButton extends StatelessWidget {
  const CartCheckoutButton({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushNamed(CheckoutView.routeName, arguments: cart);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryAccentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          'Checkout',
          style: AppStyles.textStylesSemiBold15(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
