import 'package:e_commerce/features/cart/domain/entity/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.image,
    required super.price,
    super.size,
    super.color,
    required super.quantity,
    required super.stock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      productId: json['product'] is String
          ? json['product']
          : json['product']?['_id'] ?? '',
      name: json['product']?['name'] ?? json['name'] ?? '',
      image: (json['product']?['image'] as List?)?.first ?? json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'] ?? 1,
      stock: json['product']?['stock'] ?? json['stock'] ?? 0,
    );
  }
}
