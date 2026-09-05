import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/features/payment/data/data_source/paymob_remote_data_source.dart';

import 'package:e_commerce/features/payment/domain/repo/paymob_repository.dart';

class PaymobRepositoryImpl implements PaymobRepository {
  const PaymobRepositoryImpl(this.remoteDataSource);

  final PaymobRemoteDataSource remoteDataSource;

  /*
   * ==========================================================
   * CREATE PAYMENT SESSION
   * ==========================================================
   *
   * The backend creates a temporary PaymentSession.
   *
   * It does NOT create an Order.
   */
  @override
  Future<Either<Failure, Map<String, dynamic>>> createPaymentSession({
    required List<Map<String, dynamic>> products,

    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      final data = await remoteDataSource.createPaymentSession(
        products: products,

        shippingAddress: shippingAddress,
      );

      return Right(data);
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  /*
   * ==========================================================
   * GET PAYMENT SESSION STATUS
   * ==========================================================
   *
   * Flutter uses this after opening Paymob.
   *
   * Possible values:
   *
   * pending
   * paid
   * failed
   * expired
   */
  @override
  Future<Either<Failure, Map<String, dynamic>>> getPaymentSessionStatus({
    required String paymentSessionId,
  }) async {
    try {
      final data = await remoteDataSource.getPaymentSessionStatus(
        paymentSessionId: paymentSessionId,
      );

      return Right(data);
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
