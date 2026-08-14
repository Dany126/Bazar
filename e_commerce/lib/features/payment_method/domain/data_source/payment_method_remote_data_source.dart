// lib/features/payment_method/domin/data_source/remote_data_source/payment_method_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/data/model/payment_method_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods();

  Future<Either<Failure, PaymentMethodModel>> addPaymentMethod({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  });

  Future<Either<Failure, void>> deletePaymentMethod({
    required String paymentMethodId,
  });
}
