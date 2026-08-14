// lib/features/checkout/presenation/view/widgets/checkout_selection_row.dart
import 'package:flutter/material.dart';

class CheckoutSelectionRow extends StatelessWidget {
  const CheckoutSelectionRow({
    super.key,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.trailingDot = false,
  });

  final String label;
  final String? value;
  final String placeholder;
  final bool trailingDot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: value == null ? Colors.grey[400] : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingDot)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
