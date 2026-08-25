import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';

import 'package:e_commerce/features/order/data/model/order_model.dart';
import 'package:e_commerce/features/order/domin/data_source/remote_data_source/order_remo_data_source.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;

  OrderRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, OrderModel>> createOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
    required String paymentMethod,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/order',
      data: {
        'products': products,
        'totalPrice': totalPrice,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'pending',
      },
    );
    log(result.toString());

    return result.fold((failure) => Left(failure), (response) {
      try {
        final orderData = response is Map && response.containsKey('order')
            ? response['order'] as Map<String, dynamic>
            : response as Map<String, dynamic>;
        return Right(OrderModel.fromJson(orderData));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getMyOrders({
    required String orderStatus,
  }) async {
    orderStatus = orderStatus.toString().split('.')[1];
    final Either<Failure, dynamic> result;
    if (orderStatus == 'all') {
      result = await apiService.get('$kBaseUrl/order');
    } else {
      result = await apiService.get(
        '$kBaseUrl/order/',
        queryParameters: {'orderStatus': orderStatus},
      );
    }
    log(result.toString());

    return result.fold(
      (failure) {
        // Backend returns 400 + "No Orders Found" style message when the list is empty,
        // instead of 200 + []. Treat that as an empty list, not a real error.
        final message = failure.message.toLowerCase();
        log(message);
        if (message.contains('no order') || message.contains('not found')) {
          return const Right(<OrderModel>[]);
        }
        return Left(failure);
      },
      (response) {
        try {
          final List ordersJson = response is Map
              ? (response['orders'] ?? []) as List
              : response as List;
          log(ordersJson.toString());

          final orders = ordersJson
              .map(
                (order) => OrderModel.fromJson(order as Map<String, dynamic>),
              )
              .toList();
          return Right(orders);
        } catch (e) {
          return Left(ServerFailure(message: e.toString()));
        }
      },
    );
  }
}
