import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';

abstract class PaymobRepository {
  const PaymobRepository();

  Future<Either<Failure, Map<String, dynamic>>> createPaymentSession({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required Map<String, dynamic> shippingAddress,
  });
}
