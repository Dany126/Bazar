import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';
import 'package:flutter/material.dart';

class OrderFilterBar extends StatelessWidget {
  const OrderFilterBar({
    super.key,
    required this.onFilterSelected,
    required this.selectedFilter,
  });

  final void Function(OrderStatus filter) onFilterSelected;
  final OrderStatus selectedFilter;

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
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width < 600
        ? 12.0
        : width < 1000
        ? 20.0
        : 24.0;

    final height = width < 360 ? 38.0 : 42.0;

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: OrderStatus.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = OrderStatus.values[index];

          return _FilterChip(
            label: _labels[status]!,
            isSelected: status == selectedFilter,
            onTap: () => onFilterSelected(status),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final horizontalPadding = width < 360
        ? 12.0
        : width < 600
        ? 14.0
        : 16.0;

    final fontSize = width < 360 ? 12.0 : 13.0;

    return Material(
      color: isSelected ? kOrderAccentColor : const Color(0xFFF2F2F5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 7,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
