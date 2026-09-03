import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import '../datasources/admin_transaction_remote_data_source.dart';
import '../models/admin_transaction_model.dart';

import '../../domain/repositories/admin_transaction_repository.dart';

class AdminTransactionRepositoryImpl implements AdminTransactionRepository {
  final AdminTransactionRemoteDataSource remoteDataSource;

  AdminTransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdminTransactionsResponse>> getTransactions({
    String search = '',
    String status = 'all',
    String paymentMethod = 'all',
    int page = 1,
    int limit = 20,
    DateTime? from,
    DateTime? to,
  }) {
    return remoteDataSource.getTransactions(
      search: search,
      status: status,
      paymentMethod: paymentMethod,
      page: page,
      limit: limit,
      from: from,
      to: to,
    );
  }

  @override
  Future<Either<Failure, AdminTransactionModel>> getTransaction({
    required String transactionId,
  }) {
    return remoteDataSource.getTransaction(transactionId: transactionId);
  }
}
