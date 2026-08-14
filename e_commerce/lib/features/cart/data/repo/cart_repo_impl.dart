// lib/features/cart/data/repo/cart_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/data_source/remote_data_source.dart';
import 'package:e_commerce/features/cart/domain/entity/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repo/cart_repo.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, CartEntity>> getCart() => remoteDataSource.getCart();

  @override
  Future<Either<Failure, CartEntity>> addToCart({
    required String productId,
    String? size,
    String? color,
    required int quantity,
  }) {
    return remoteDataSource.addToCart(
      productId: productId,
      size: size,
      color: color,
      quantity: quantity,
    );
  }

  @override
  Future<Either<Failure, CartEntity>> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) {
    return remoteDataSource.updateCartItemQuantity(
      itemId: itemId,
      quantity: quantity,
    );
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart({required String itemId}) {
    return remoteDataSource.removeFromCart(itemId: itemId);
  }

  @override
  Future<Either<Failure, CartEntity>> removeAllFromCart() {
    return remoteDataSource.removeAllFromCart();
  }

  @override
  Future<Either<Failure, CartEntity>> applyCoupon({required String code}) {
    return remoteDataSource.applyCoupon(code: code);
  }
}
