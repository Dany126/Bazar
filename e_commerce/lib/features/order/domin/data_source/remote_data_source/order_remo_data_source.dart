import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/order/data/model/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, OrderModel>> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  });

  Future<Either<Failure, List<OrderModel>>> getMyOrders({
    required String userId,
    required String orderStatus,
  });
}
