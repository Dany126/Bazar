// lib/features/cart/domin/use_case/add_to_cart_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class AddToCartUseCase {
  final CartRepository repository;
  AddToCartUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call({
    required String productId,
    required String variantId,
    required int quantity,
  }) {
    return repository.addToCart(
      productId: productId,
      variantId: variantId,

      quantity: quantity,
    );
  }
}
