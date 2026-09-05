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

  factory OrderModel.fromJson(dynamic rawJson) {
    if (rawJson is! Map) {
      return const OrderModel(
        id: '',
        user: '',
        products: <OrderProductModel>[],
        totalPrice: 0,
        shippingAddress: null,
        paymentMethod: 'cash',
        paymentStatus: 'pending',
        orderStatus: 'pending',
      );
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(rawJson);

    // ------------------------------------------------------------
    // USER
    // ------------------------------------------------------------

    final dynamic userRaw = json['user'];

    String userId = '';

    if (userRaw is String) {
      userId = userRaw;
    } else if (userRaw is Map) {
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(userRaw);

      userId = userMap['_id']?.toString() ?? userMap['id']?.toString() ?? '';
    } else if (userRaw != null) {
      userId = userRaw.toString();
    }

    // ------------------------------------------------------------
    // PRODUCTS
    // ------------------------------------------------------------

    final List<OrderProductModel> parsedProducts = <OrderProductModel>[];

    final dynamic productsRaw = json['products'];

    if (productsRaw is List) {
      for (final dynamic item in productsRaw) {
        try {
          parsedProducts.add(OrderProductModel.fromJson(item));
        } catch (_) {
          // Ignore malformed product instead of crashing
        }
      }
    }

    // ------------------------------------------------------------
    // SHIPPING ADDRESS
    // ------------------------------------------------------------

    ShippingAddressModel? shippingAddress;

    final dynamic shippingRaw = json['shippingAddress'];

    if (shippingRaw is Map) {
      shippingAddress = ShippingAddressModel.fromJson(
        Map<String, dynamic>.from(shippingRaw),
      );
    }

    // ------------------------------------------------------------
    // DATES
    // ------------------------------------------------------------

    DateTime? createdAt;

    final dynamic createdRaw = json['createdAt'];

    if (createdRaw != null) {
      createdAt = DateTime.tryParse(createdRaw.toString());
    }

    DateTime? updatedAt;

    final dynamic updatedRaw = json['updatedAt'];

    if (updatedRaw != null) {
      updatedAt = DateTime.tryParse(updatedRaw.toString());
    }

    // ------------------------------------------------------------
    // RETURN
    // ------------------------------------------------------------

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',

      user: userId,

      products: parsedProducts,

      totalPrice: _parseDouble(json['totalPrice']),

      shippingAddress: shippingAddress,

      paymentMethod: json['paymentMethod']?.toString() ?? 'cash',

      paymentStatus: json['paymentStatus']?.toString() ?? 'pending',

      orderStatus: json['orderStatus']?.toString() ?? 'pending',

      createdAt: createdAt,

      updatedAt: updatedAt,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }

    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,

      'products': products.map((product) {
        return {
          'product': product.product.id,
          'quantity': product.quantity,
          'price': product.price,
        };
      }).toList(),

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
