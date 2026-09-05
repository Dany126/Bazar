import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

abstract class PaymobRepository {
  /*
   * ==========================================================
   * CREATE PAYMENT SESSION
   * ==========================================================
   *
   * Creates Paymob session.
   *
   * It does NOT create an Order.
   */
  Future<Either<Failure, Map<String, dynamic>>> createPaymentSession({
    required List<Map<String, dynamic>> products,

    required Map<String, dynamic> shippingAddress,
  });

  /*
   * ==========================================================
   * GET PAYMENT STATUS
   * ==========================================================
   */
  Future<Either<Failure, Map<String, dynamic>>> getPaymentSessionStatus({
    required String paymentSessionId,
  });
}
