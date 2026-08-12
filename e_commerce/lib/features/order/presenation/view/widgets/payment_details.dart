import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/info_row.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatelessWidget {
  final OrderEntity order;

  const PaymentDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InfoRow(
            title: 'Payment method',
            value: _capitalize(order.paymentMethod),
          ),
          const SizedBox(height: 10),
          InfoRow(
            title: 'Payment status',
            value: _capitalize(order.paymentStatus),
          ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
