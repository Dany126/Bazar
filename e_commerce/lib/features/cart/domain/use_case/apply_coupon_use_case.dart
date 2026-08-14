// lib/features/cart/domin/use_case/apply_coupon_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class ApplyCouponUseCase {
  final CartRepository repository;
  ApplyCouponUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call({required String code}) {
    return repository.applyCoupon(code: code);
  }
}
