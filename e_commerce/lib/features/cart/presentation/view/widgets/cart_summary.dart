import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key, required this.cart, this.showCoupon = true});

  final CartEntity cart;
  final bool showCoupon;

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final TextEditingController couponController = TextEditingController();

  final FocusNode couponFocusNode = FocusNode();

  @override
  void dispose() {
    couponController.dispose();
    couponFocusNode.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = couponController.text.trim();

    if (code.isEmpty) return;

    context.read<CartCubit>().applyCoupon(code: code);

    couponFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final subtotal = cart.subtotal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow('Subtotal', subtotal),

          _summaryRow('Shipping Cost', 0),

          _summaryRow('Tax', 0),

          const Divider(height: 20),

          _summaryRow('Total', subtotal, isBold: true),

          if (widget.showCoupon) ...[
            const SizedBox(height: 14),
            _buildCouponField(),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // COUPON
  // ------------------------------------------------------------

  Widget _buildCouponField() {
    return TextField(
      controller: couponController,
      focusNode: couponFocusNode,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _applyCoupon(),
      decoration: InputDecoration(
        hintText: 'Enter Coupon Code',

        hintStyle: const TextStyle(fontSize: 13),

        prefixIcon: const Icon(
          Icons.discount_outlined,
          size: 18,
          color: Colors.grey,
        ),

        filled: true,

        fillColor: AppColors.kCardBackgroundColor,

        contentPadding: const EdgeInsets.symmetric(vertical: 4),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.kPrimaryAccentColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        suffixIcon: IconButton(
          onPressed: _applyCoupon,
          icon: const CircleAvatar(
            minRadius: 14,
            maxRadius: 20,
            backgroundColor: AppColors.kPrimaryAccentColor,
            child: Icon(Icons.arrow_forward, size: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SUMMARY ROW
  // ------------------------------------------------------------

  Widget _summaryRow(String label, double? value, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: 15,
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      color: isBold ? Colors.black87 : Colors.black45,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value == null ? '—' : '\$${value.toStringAsFixed(2)}',
            style: style.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
