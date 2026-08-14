// lib/features/payment_method/domin/use_case/get_payment_methods_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/payment_method/domain/entity/payment_method_entity.dart';
import 'package:e_commerce/features/payment_method/domain/repo/payment_method_repo.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository repository;
  GetPaymentMethodsUseCase(this.repository);

  Future<Either<Failure, List<PaymentMethodEntity>>> call() =>
      repository.getPaymentMethods();
}
