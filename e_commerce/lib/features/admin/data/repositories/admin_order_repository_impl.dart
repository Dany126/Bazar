import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/features/admin/data/datasources/admin_order_remote_data_source.dart';
import 'package:e_commerce/features/admin/domain/entity/admin_orders_page.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_order_repository.dart';

import 'package:e_commerce/features/order/data/model/order_model.dart';

class AdminOrderRepositoryImpl implements AdminOrderRepository {
  final AdminOrderRemoteDataSource remoteDataSource;

  AdminOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminOrdersPage>> getAllOrders({
    required int page,
    required int limit,
  }) {
    return remoteDataSource.getAllOrders(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, OrderModel>> getOrder({required String orderId}) {
    return remoteDataSource.getOrder(orderId: orderId);
  }

  @override
  Future<Either<Failure, OrderModel>> updateOrder({
    required String orderId,
    required Map<String, dynamic> data,
  }) {
    return remoteDataSource.updateOrder(orderId: orderId, data: data);
  }

  @override
  Future<Either<Failure, Unit>> deleteOrder({required String orderId}) {
    return remoteDataSource.deleteOrder(orderId: orderId);
  }
}
