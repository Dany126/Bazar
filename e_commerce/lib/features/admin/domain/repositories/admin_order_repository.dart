import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/order/data/model/order_model.dart';

abstract class AdminOrderRepository {
  Future<Either<Failure, List<OrderModel>>> getAllOrders();

  Future<Either<Failure, OrderModel>> getOrder({required String orderId});

  Future<Either<Failure, OrderModel>> updateOrder({
    required String orderId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, Unit>> deleteOrder({required String orderId});
}
