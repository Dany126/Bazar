// lib/features/cart/domin/use_case/get_cart_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class GetCartUseCase {
  final CartRepository repository;
  GetCartUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call() => repository.getCart();
}
