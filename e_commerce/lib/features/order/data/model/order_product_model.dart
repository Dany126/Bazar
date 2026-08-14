import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      product: json['product'] is Map<String, dynamic>
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : ProductEntity.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product, 'quantity': quantity, 'price': price};
  }
}
