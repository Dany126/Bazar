import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';

import 'package:e_commerce/features/order/data/model/order_model.dart';

abstract class AdminOrderRemoteDataSource {
  Future<Either<Failure, List<OrderModel>>> getAllOrders();

  Future<Either<Failure, OrderModel>> getOrder({required String orderId});

  Future<Either<Failure, OrderModel>> updateOrder({
    required String orderId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, Unit>> deleteOrder({required String orderId});
}

class AdminOrderRemoteDataSourceImpl implements AdminOrderRemoteDataSource {
  final ApiService apiService;

  AdminOrderRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<OrderModel>>> getAllOrders() async {
    final result = await apiService.get('$kBaseUrl/order');

    return result.fold((failure) => Left(failure), (response) {
      try {
        final List<dynamic> ordersJson = response['orders'] as List<dynamic>;

        final orders = ordersJson
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(orders);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, OrderModel>> getOrder({
    required String orderId,
  }) async {
    final result = await apiService.get('$kBaseUrl/order/$orderId');

    return result.fold((failure) => Left(failure), (response) {
      try {
        return Right(
          OrderModel.fromJson(response['order'] as Map<String, dynamic>),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, OrderModel>> updateOrder({
    required String orderId,
    required Map<String, dynamic> data,
  }) async {
    final result = await apiService.patch(
      '$kBaseUrl/order/$orderId',
      data: data,
    );

    return result.fold((failure) => Left(failure), (response) {
      try {
        return Right(
          OrderModel.fromJson(response['updatedOrder'] as Map<String, dynamic>),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteOrder({required String orderId}) async {
    final result = await apiService.delete('$kBaseUrl/order/$orderId');

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }
}
