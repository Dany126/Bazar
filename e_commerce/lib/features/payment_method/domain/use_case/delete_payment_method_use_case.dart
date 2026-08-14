// lib/features/payment_method/domin/use_case/delete_payment_method_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_method_repo.dart';

class DeletePaymentMethodUseCase {
  final PaymentMethodRepository repository;
  DeletePaymentMethodUseCase(this.repository);

  Future<Either<Failure, void>> call({required String paymentMethodId}) {
    return repository.deletePaymentMethod(paymentMethodId: paymentMethodId);
  }
}
