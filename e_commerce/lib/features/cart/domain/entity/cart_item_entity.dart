// lib/features/cart/domin/entity/cart_item_entity.dart
class CartItemEntity {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  final String? size;
  final String? color;
  final int quantity;
  final int stock;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.size,
    this.color,
    required this.quantity,
    required this.stock,
  });
}
