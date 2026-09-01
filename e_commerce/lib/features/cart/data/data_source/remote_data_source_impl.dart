// lib/features/cart/data/data_source/cart_remote_data_source_impl.dart

import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';

import 'package:e_commerce/core/services/api_services.dart';

import 'package:e_commerce/features/cart/data/model/cart_model.dart';
import 'package:e_commerce/features/cart/domain/data_source/remote_data_source.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService apiService;

  CartRemoteDataSourceImpl(this.apiService);

  Either<Failure, CartModel> _parse(dynamic response) {
    try {
      return Right(CartModel.fromResponse(response as Map<String, dynamic>));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    final result = await apiService.get('$kBaseUrl/cart/');

    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> addToCart({
    required String productId,
    required String variantId,
    required int quantity,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/cart',
      data: {
        'products': [
          {'product': productId, 'variant': variantId, 'quantity': quantity},
        ],
      },
    );

    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> updateCartItemQuantity({
    required String itemId,
    required int quantity,
    required String variantId,
  }) async {
    final result = await apiService.patch(
      '$kBaseUrl/cart/',
      data: {'itemId': itemId, 'variant': variantId, 'quantity': quantity},
    );
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> removeFromCart({
    required String itemId,
    required String variantId,
  }) async {
    final result = await apiService.delete(
      '$kBaseUrl/cart/',
      data: {'itemId': itemId, 'variant': variantId},
    );
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> removeAllFromCart() async {
    final result = await apiService.delete('$kBaseUrl/cart');
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> applyCoupon({required String code}) async {
    final result = await apiService.post(
      '$kBaseUrl/cart/coupon',
      data: {'code': code},
    );
    return result.fold((failure) => Left(failure), _parse);
  }
}
