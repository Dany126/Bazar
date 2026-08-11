import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F2F5),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  Assets.assetsImagesInActiveReceipt,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Order  ',
                          style: AppStyles.textStylesRegular16(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                        Text(
                          '#${order.id}',
                          style: AppStyles.textStylesRegular16(
                            context,
                          ).copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.products.length} items',
                      style: AppStyles.textStylesRegular12(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Image.asset(Assets.assetsImagesArrowright, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
