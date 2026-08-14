// lib/features/payment_method/data/repo/payment_method_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/data_source/payment_method_remote_data_source.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_method_repo.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;

  PaymentMethodRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() =>
      remoteDataSource.getPaymentMethods();

  @override
  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod({
    required String cardholderName,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) {
    return remoteDataSource.addPaymentMethod(
      cardholderName: cardholderName,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
    );
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod({
    required String paymentMethodId,
  }) => remoteDataSource.deletePaymentMethod(paymentMethodId: paymentMethodId);
}
