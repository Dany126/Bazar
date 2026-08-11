import 'package:e_commerce/features/order/data/model/order_product_model.dart';
import 'package:e_commerce/features/order/data/model/shipping_address_model.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.user,
    required super.products,
    required super.totalPrice,
    super.shippingAddress,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.orderStatus,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      user: json['user'] is String ? json['user'] : json['user']?['_id'] ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddressModel.fromJson(
              json['shippingAddress'] as Map<String, dynamic>,
            )
          : null,
      paymentMethod: json['paymentMethod'] ?? 'cash',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      orderStatus: json['orderStatus'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'products': products
          .map(
            (product) => {
              'product': product.product,
              'quantity': product.quantity,
              'price': product.price,
            },
          )
          .toList(),
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress == null
          ? null
          : {
              'street': shippingAddress!.street,
              'city': shippingAddress!.city,
              'country': shippingAddress!.country,
              'postalCode': shippingAddress!.postalCode,
            },
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
    };
  }
}
