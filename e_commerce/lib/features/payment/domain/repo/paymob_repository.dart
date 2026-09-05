import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';

abstract class PaymobRepository {
  /// Creates a temporary Paymob payment session.
  ///
  /// No Order is created here.
  Future<Either<Failure, Map<String, dynamic>>> createPaymentSession({
    required List<Map<String, dynamic>> products,

    required Map<String, dynamic> shippingAddress,
  });

  /// Checks whether Paymob has completed the payment.
  Future<Either<Failure, Map<String, dynamic>>> getPaymentSessionStatus({
    required String paymentSessionId,
  });
}
