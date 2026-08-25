import 'package:e_commerce/features/cart/data/model/cart_item_model.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.userId,
    required super.items,
    super.createdAt,
    super.updatedAt,
  });

  /// Parses the root API response: { status, carts: [ {...} ] }
  factory CartModel.fromResponse(Map<String, dynamic> response) {
    final cartsRaw = response['carts'];
    if (cartsRaw is List && cartsRaw.isNotEmpty) {
      final cart = cartsRaw.first;
      if (cart is Map<String, dynamic>) {
        return CartModel.fromJson(cart);
      }
    }

    final cartRaw = response['cart'];
    if (cartRaw is Map<String, dynamic>) {
      return CartModel.fromJson(cartRaw);
    }

    throw const FormatException('No cart found in response');
  }

  /// Parses a single cart object: { _id, user, products: [...], createdAt, updatedAt }
  factory CartModel.fromJson(Map<String, dynamic> json) {
    final productsRaw = json['products'];
    final items = productsRaw is List
        ? productsRaw
              .whereType<Map<String, dynamic>>()
              .map((e) => CartItemModel.fromJson(e))
              .toList()
        : <CartItemModel>[];

    return CartModel(
      id: json['_id'].toString(),
      userId: json['user']?.toString() ?? '',
      items: items,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}
