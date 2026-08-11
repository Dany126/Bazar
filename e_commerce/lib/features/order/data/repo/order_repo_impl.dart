import 'package:dartz/dartz.dart';
import 'package:e_commerce/features/order/domin/data_source/remote_data_source/order_remo_data_source.dart';
import 'package:e_commerce/features/order/domin/entity/order_entity.dart';
import 'package:e_commerce/features/order/domin/repo/order_repo.dart';
import 'package:e_commerce/features/order/presenation/view/widgets/order_view_body.dart';

import '../../../../core/error/failure.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, OrderEntity>> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  }) {
    return remoteDataSource.createOrder(
      products: products,
      totalPrice: totalPrice,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders({
    required String userId,
    required OrderStatus orderStatus,
  }) {
    return remoteDataSource.getMyOrders(
      userId: userId,
      orderStatus: orderStatus.toString(),
    );
  }
}
