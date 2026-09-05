import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/core/utils/assets.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onTap});

  final OrderEntity order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isSmall = width < 360;
        final isPhone = width < 600;

        final horizontalPadding = isSmall
            ? 10.0
            : isPhone
            ? 12.0
            : 16.0;

        final verticalPadding = isSmall
            ? 12.0
            : isPhone
            ? 14.0
            : 16.0;

        final iconContainerSize = isSmall
            ? 38.0
            : isPhone
            ? 42.0
            : 48.0;

        final titleSize = isSmall
            ? 14.0
            : isPhone
            ? 15.0
            : 16.0;

        return Material(
          color: const Color(0xFFF2F2F5),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: iconContainerSize,
                    height: iconContainerSize,
                    alignment: Alignment.center,
                    child: Image.asset(
                      Assets.assetsImagesInActiveReceipt,
                      color: Colors.black,
                      width: isSmall ? 22 : 26,
                      height: isSmall ? 22 : 26,
                    ),
                  ),

                  SizedBox(width: isSmall ? 8 : 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            Text(
                              'Order',
                              style: AppStyles.textStylesRegular16(context)
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: titleSize,
                                  ),
                            ),
                            Text(
                              '#${order.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.textStylesRegular16(context)
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: titleSize,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 3),

                        Text(
                          '${order.products.length} items',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.textStylesRegular12(
                            context,
                          ).copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: isSmall ? 28 : 36,
                    height: isSmall ? 28 : 36,
                    child: Image.asset(
                      Assets.assetsImagesArrowright,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
