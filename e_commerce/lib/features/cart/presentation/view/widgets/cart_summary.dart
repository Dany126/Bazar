// lib/features/cart/presenation/view/widgets/cart_summary.dart

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key, required this.cart});

  final CartEntity cart;

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final TextEditingController couponController = TextEditingController();

  final FocusNode couponFocusNode = FocusNode();

  bool isCouponFocused = false;

  @override
  void initState() {
    super.initState();

    couponFocusNode.addListener(_couponFocusListener);
  }

  void _couponFocusListener() {
    if (!mounted) return;

    setState(() {
      isCouponFocused = couponFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    couponFocusNode.removeListener(_couponFocusListener);

    couponController.dispose();
    couponFocusNode.dispose();

    super.dispose();
  }

  void _applyCoupon() {
    final code = couponController.text.trim();

    if (code.isEmpty) {
      return;
    }

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
          // --------------------------------------------------
          // SUMMARY
          // --------------------------------------------------
          _summaryRow('Subtotal', subtotal),

          _summaryRow('Shipping Cost', 0),

          _summaryRow('Tax', 0),

          const Divider(height: 20),

          _summaryRow('Total', subtotal, isBold: true),

          const SizedBox(height: 14),

          // --------------------------------------------------
          // COUPON
          // --------------------------------------------------
          _buildCouponField(),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // COUPON FIELD
  // ------------------------------------------------------------

  Widget _buildCouponField() {
    return AnimatedBuilder(
      animation: couponFocusNode,
      builder: (context, child) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        final shouldMove = couponFocusNode.hasFocus && keyboardHeight > 0;

        return Transform.translate(
          offset: shouldMove ? Offset(0, -keyboardHeight + 20) : Offset.zero,
          child: child,
        );
      },

      child: TextField(
        controller: couponController,
        focusNode: couponFocusNode,

        textInputAction: TextInputAction.done,

        onSubmitted: (_) {
          _applyCoupon();
        },

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
      ),
    );
  }

  // ------------------------------------------------------------
  // SUMMARY ROW
  // ------------------------------------------------------------

  Widget _summaryRow(String label, double? value, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: 14,

      fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,

      color: isBold ? Colors.black : Colors.black54,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),

          Text(
            value == null ? '—' : '\$${value.toStringAsFixed(2)}',
            style: style,
          ),
        ],
      ),
    );
  }
}
