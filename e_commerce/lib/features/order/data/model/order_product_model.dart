import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      product: json['product'] is String
          ? json['product']
          : json['product']?['_id'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product, 'quantity': quantity, 'price': price};
  }
}
