import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import '../../data/models/admin_transaction_model.dart';

abstract class AdminTransactionRepository {
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
