// lib/features/cart/data/model/cart_model.dart

import 'package:e_commerce/features/cart/data/model/cart_item_model.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.items,
    required super.subtotal,
    required super.shippingCost,
    required super.tax,
    required super.total,
    super.couponCode,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? json['id'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      couponCode: json['couponCode'],
    );
  }
}
