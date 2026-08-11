import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';

import '../../../../core/error/failure.dart';
import '../entity/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  });

  Future<Either<Failure, List<OrderEntity>>> getMyOrders({
    required String userId,
    required OrderStatus orderStatus,
  });
}
