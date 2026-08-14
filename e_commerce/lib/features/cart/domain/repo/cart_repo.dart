// lib/features/cart/domin/repo/cart_repo.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();

  Future<Either<Failure, CartEntity>> addToCart({
    required String productId,
    String? size,
    String? color,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  });

  Future<Either<Failure, CartEntity>> removeFromCart({required String itemId});

  Future<Either<Failure, CartEntity>> removeAllFromCart();

  Future<Either<Failure, CartEntity>> applyCoupon({required String code});
}
