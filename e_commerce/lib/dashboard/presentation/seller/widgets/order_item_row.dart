import 'package:flutter/material.dart';
import '../../theme/dashboard_colors.dart';

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({
    super.key,
    required this.name,
    required this.variant,
    required this.qty,
    required this.price,
    this.imageUrl,
  });

  final String name;
  final String variant;
  final int qty;
  final String price;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DashboardColors.cardBgDarkAlt,
              borderRadius: BorderRadius.circular(10),
              image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                Text(variant, style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Qty $qty', style: const TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 11)),
              Text(price, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
