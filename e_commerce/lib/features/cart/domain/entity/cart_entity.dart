// lib/features/cart/domin/entity/cart_entity.dart
import 'cart_item_entity.dart';

class CartEntity {
  final String id;
  final List<CartItemEntity> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final String? couponCode;

  const CartEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.total,
    this.couponCode,
  });
}
