// ---------------------------------------------------------
// Cancelled Order
// ---------------------------------------------------------

import 'package:flutter/material.dart';

class CancelledOrderCard extends StatelessWidget {
  const CancelledOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'This order has been cancelled.',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
