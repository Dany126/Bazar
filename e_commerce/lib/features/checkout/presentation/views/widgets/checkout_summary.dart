// lib/features/checkout/presenation/view/widgets/checkout_summary.dart
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:flutter/material.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key, required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.subtotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Subtotal', subtotal),
        const Divider(height: 20),
        _row('Total', subtotal, isBold: true),
      ],
    );
  }

  Widget _row(String label, double? value, {bool isBold = false}) {
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
