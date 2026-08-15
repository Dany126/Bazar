// lib/features/cart/domin/data_source/remote_data_source/cart_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/data/model/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<Either<Failure, CartModel>> getCart();

  Future<Either<Failure, CartModel>> addToCart({
    required String productId,
    required String variantId,
    required int quantity,
  });

  Future<Either<Failure, CartModel>> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  });

  Future<Either<Failure, CartModel>> removeFromCart({required String itemId});

  Future<Either<Failure, CartModel>> removeAllFromCart();

  Future<Either<Failure, CartModel>> applyCoupon({required String code});
}
