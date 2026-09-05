import 'package:dartz/dartz.dart';

import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';

import 'package:e_commerce/features/admin/domain/entity/admin_orders_page.dart';
import 'package:e_commerce/features/order/data/model/order_model.dart';

abstract class AdminOrderRemoteDataSource {
  Future<Either<Failure, AdminOrdersPage>> getAllOrders({
    required int page,
    required int limit,
  });

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

  // ============================================================
  // GET PAGINATED ORDERS
  // ============================================================

  @override
  Future<Either<Failure, AdminOrdersPage>> getAllOrders({
    required int page,
    required int limit,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/order?page=$page&limit=$limit',
    );

    return result.fold((failure) => Left(failure), (response) {
      try {
        final List<dynamic> ordersJson =
            response['orders'] as List<dynamic>? ?? [];

        final List<OrderModel> orders = ordersJson
            .map(
              (json) =>
                  OrderModel.fromJson(Map<String, dynamic>.from(json as Map)),
            )
            .toList();

        final dynamic paginationJson = response['pagination'];

        int currentPage = page;
        int itemsPerPage = limit;
        int totalOrders = 0;
        int totalPages = 1;

        if (paginationJson is Map) {
          currentPage = _toInt(paginationJson['currentPage'], fallback: page);

          itemsPerPage = _toInt(
            paginationJson['itemsPerPage'],
            fallback: limit,
          );

          totalOrders = _toInt(paginationJson['totalOrders'], fallback: 0);

          totalPages = _toInt(paginationJson['totalPages'], fallback: 1);
        } else {
          // Fallback for the current backend response.
          //
          // The current backend only returns noOfOrders for
          // the current page, so totalPages cannot be known
          // correctly without the pagination object.
          final int noOfOrders = _toInt(
            response['noOfOrders'],
            fallback: orders.length,
          );

          totalOrders = noOfOrders;

          if (orders.length < limit) {
            totalPages = page;
          } else {
            totalPages = page + 1;
          }
        }

        if (totalPages < 1) {
          totalPages = 1;
        }

        return Right(
          AdminOrdersPage(
            orders: orders,
            currentPage: currentPage,
            itemsPerPage: itemsPerPage,
            totalOrders: totalOrders,
            totalPages: totalPages,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  // ============================================================
  // GET ONE ORDER
  // ============================================================

  @override
  Future<Either<Failure, OrderModel>> getOrder({
    required String orderId,
  }) async {
    final result = await apiService.get('$kBaseUrl/order/$orderId');

    return result.fold((failure) => Left(failure), (response) {
      try {
        return Right(
          OrderModel.fromJson(
            Map<String, dynamic>.from(response['order'] as Map),
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  // ============================================================
  // UPDATE ORDER
  // ============================================================

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
          OrderModel.fromJson(
            Map<String, dynamic>.from(response['updatedOrder'] as Map),
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  // ============================================================
  // DELETE ORDER
  // ============================================================

  @override
  Future<Either<Failure, Unit>> deleteOrder({required String orderId}) async {
    final result = await apiService.delete('$kBaseUrl/order/$orderId');

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  // ============================================================
  // INTEGER PARSER
  // ============================================================

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }
}
