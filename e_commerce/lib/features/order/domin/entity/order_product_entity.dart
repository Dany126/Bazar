import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

class OrderProductEntity {
  final ProductEntity product;
  final int quantity;
  final double price;

  const OrderProductEntity({
    required this.product,
    required this.quantity,
    required this.price,
  });
}
