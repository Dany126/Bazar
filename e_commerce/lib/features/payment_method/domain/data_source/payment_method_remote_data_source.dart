import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/data/model/payment_method_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods();

  Future<Either<Failure, PaymentMethodModel>> addPaymentMethod({
    required String brand,
    required String last4,
    bool isDefault = false,
  });

  Future<Either<Failure, void>> deletePaymentMethod({
    required String paymentMethodId,
  });
}
