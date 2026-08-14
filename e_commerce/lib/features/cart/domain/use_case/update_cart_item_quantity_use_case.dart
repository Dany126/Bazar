// lib/features/cart/domin/use_case/update_cart_item_quantity_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class UpdateCartItemQuantityUseCase {
  final CartRepository repository;
  UpdateCartItemQuantityUseCase(this.repository);

  Future<Either<Failure, CartEntity>> call({
    required String itemId,
    required int quantity,
  }) {
    return repository.updateCartItemQuantity(
      itemId: itemId,
      quantity: quantity,
    );
  }
}
