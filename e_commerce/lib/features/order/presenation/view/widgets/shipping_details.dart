import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter/material.dart';

class ShippingDetails extends StatelessWidget {
  final OrderEntity order;

  const ShippingDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final address = order.shippingAddress;

    if (address == null) {
      return const Text(
        'No shipping details available',
        style: TextStyle(color: Colors.grey),
      );
    }

    final parts = [
      address.street,
      address.city,
      address.country,
      address.postalCode,
    ].where((value) => value != null && value.trim().isNotEmpty);

    final addressText = parts.join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              addressText.isEmpty
                  ? 'No shipping details available'
                  : addressText,
              style: const TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
