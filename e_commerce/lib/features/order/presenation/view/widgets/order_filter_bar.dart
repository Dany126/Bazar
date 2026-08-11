import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';

class OrderFilterBar extends StatelessWidget {
  final void Function(OrderStatus filter) onFilterSelected;
  final OrderStatus selectedFilter;
  const OrderFilterBar({
    super.key,
    required this.onFilterSelected,
    required this.selectedFilter,
  });

  static const _labels = {
    OrderStatus.all: 'All',
    OrderStatus.processing: 'Processing',
    OrderStatus.shipped: 'Shipped',
    OrderStatus.delivered: 'Delivered',
    OrderStatus.returned: 'Returned',
    OrderStatus.cancelled: 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: OrderStatus.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = OrderStatus.values[index];
          final isSelected = status == selectedFilter;
          return _FilterChip(
            label: _labels[status]!,
            isSelected: isSelected,
            onTap: () => onFilterSelected(status),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? kOrderAccentColor : const Color(0xFFF2F2F5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
