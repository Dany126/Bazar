// lib/features/cart/domin/use_case/remove_from_cart_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;
  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call({
    required String itemId,
    required String variantId,
  }) {
    return repository.removeFromCart(itemId: itemId, variantId: variantId);
  }
}
