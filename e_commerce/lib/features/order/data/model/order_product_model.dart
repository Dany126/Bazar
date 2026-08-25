import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/home/data/models/category_model.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';

class OrderProductModel extends OrderProductEntity {
  const OrderProductModel({
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    final productRaw = json['product'];
    final product = productRaw is Map<String, dynamic>
        ? ProductModel.fromJson(productRaw)
        : ProductModel(
            id: productRaw?.toString() ?? '',
            name: '',
            thumbnailUrl: '',
            price: 0,
            rating: 0,
            stock: 0,
            soldCount: 0,
            ratingsQuantity: 0,
            category: const CategoryModel(id: '', name: '', imageUrl: ''),
          );

    return OrderProductModel(
      product: product,
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product, 'quantity': quantity, 'price': price};
  }
}
