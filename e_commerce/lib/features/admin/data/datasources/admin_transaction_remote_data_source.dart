import 'package:dartz/dartz.dart';

import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';

import '../models/admin_transaction_model.dart';

abstract class AdminTransactionRemoteDataSource {
  Future<Either<Failure, AdminTransactionsResponse>> getTransactions({
    String search,
    String status,
    String paymentMethod,
    int page,
    int limit,
    DateTime? from,
    DateTime? to,
  });

  Future<Either<Failure, AdminTransactionModel>> getTransaction({
    required String transactionId,
  });
}

class AdminTransactionRemoteDataSourceImpl
    implements AdminTransactionRemoteDataSource {
  final ApiService apiService;

  AdminTransactionRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, AdminTransactionsResponse>> getTransactions({
    String search = '',
    String status = 'all',
    String paymentMethod = 'all',
    int page = 1,
    int limit = 20,
    DateTime? from,
    DateTime? to,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      'status': status,
      'paymentMethod': paymentMethod,
    };

    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (from != null) {
      queryParameters['from'] = _dateOnly(from);
    }

    if (to != null) {
      queryParameters['to'] = _dateOnly(to);
    }

    final result = await apiService.get(
      '$kBaseUrl/admin/transactions',
      queryParameters: queryParameters,
    );

    return result.fold((failure) => Left(failure), (response) {
      try {
        final data = response['data'] as Map<String, dynamic>;

        return Right(AdminTransactionsResponse.fromJson(data));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, AdminTransactionModel>> getTransaction({
    required String transactionId,
  }) async {
    final result = await apiService.get(
      '$kBaseUrl/admin/transactions/$transactionId',
    );

    return result.fold((failure) => Left(failure), (response) {
      try {
        final data = response['data'] as Map<String, dynamic>;

        final transaction = data['transaction'] as Map<String, dynamic>;

        return Right(AdminTransactionModel.fromJson(transaction));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }

  String _dateOnly(DateTime value) {
    final local = value.toLocal();

    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}
