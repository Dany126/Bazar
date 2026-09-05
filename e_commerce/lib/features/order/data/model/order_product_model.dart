import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory OrderProductModel.fromJson(dynamic rawJson) {
    if (rawJson is! Map) {
      return OrderProductModel(
        product: ProductModel(
          id: '',
          name: '',
          images: const <String>[],
          price: 0,
          rating: 0,
          stock: 0,
          soldCount: 0,
          ratingsQuantity: 0,
          category: const CategoryModel(id: '', name: '', imageUrl: ''),
        ),
        quantity: 1,
        price: 0,
      );
    }

    final Map<String, dynamic> json = Map<String, dynamic>.from(rawJson);

    final dynamic productRaw = json['product'];

    ProductModel product;

    if (productRaw is Map) {
      product = ProductModel.fromJson(Map<String, dynamic>.from(productRaw));
    } else {
      product = ProductModel(
        id: productRaw?.toString() ?? '',
        name: '',
        images: const <String>[],
        price: 0,
        rating: 0,
        stock: 0,
        soldCount: 0,
        ratingsQuantity: 0,
        category: const CategoryModel(id: '', name: '', imageUrl: ''),
      );
    }

    return OrderProductModel(
      product: product,
      quantity: _parseInt(json['quantity'], fallback: 1),
      price: _parseDouble(json['price']),
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value.trim()) ?? fallback;
    }

    return fallback;
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
    return {'product': product.id, 'quantity': quantity, 'price': price};
  }
}
