import 'package:e_commerce/features/order/domin/entity/order_product_entity.dart';
import 'package:e_commerce/features/order/domin/entity/shipping_adress_entity.dart';

class OrderEntity {
  final String id;
  final String user;
  final List<OrderProductEntity> products;
  final double totalPrice;
  final ShippingAddressEntity? shippingAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.id,
    required this.user,
    required this.products,
    required this.totalPrice,
    this.shippingAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.createdAt,
    this.updatedAt,
  });
}
