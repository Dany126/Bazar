// lib/features/cart/presenation/view/widgets/cart_summary.dart

import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/view/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key, required this.cart});

  final CartEntity cart;

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final couponController = TextEditingController();

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
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
          const Divider(height: 20),
          _summaryRow('Total', subtotal, isBold: true),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter Coupon Code',
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(
                      Icons.discount_outlined,
                      size: 18,
                      color: Colors.green,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    suffixIcon: IconButton(
                      icon: const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.kPrimaryAccentColor,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (couponController.text.trim().isEmpty) return;
                        context.read<CartCubit>().applyCoupon(
                          code: couponController.text.trim(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
