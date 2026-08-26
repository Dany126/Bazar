import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/core/helper_function/fix_image_utl.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:flutter/material.dart';

class OrderItemsCard extends StatelessWidget {
  final OrderEntity order;

  const OrderItemsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...order.products.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final product = item.product;

            return Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Product image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: product.thumbnailUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: fixImageUrl(product.thumbnailUrl),
                                  fit: BoxFit.fitHeight,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.image_not_supported_outlined,
                                      ),
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported_outlined),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Product name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Quantity: ${item.quantity}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Price
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  if (index != order.products.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Divider(height: 1),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
