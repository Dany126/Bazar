// lib/features/product_details/presenation/view/widgets/quantity_stepper.dart
import 'package:flutter/material.dart';
import 'product_details_view_body.dart' show kProductAccentColor;

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.maxQuantity,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int? maxQuantity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(
          icon: Icons.remove,
          onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        _buildButton(
          icon: Icons.add,
          onTap: (maxQuantity == null || quantity < maxQuantity!)
              ? () => onChanged(quantity + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: onTap == null ? Colors.grey[300] : kProductAccentColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
