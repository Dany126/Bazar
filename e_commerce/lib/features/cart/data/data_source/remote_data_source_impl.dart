// lib/features/cart/data/data_source/cart_remote_data_source_impl.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/core/services/hive_server.dart';

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

  String? get _cachedUserId {
    final userMap = HiveService.authBox.get('user');
    if (userMap == null) return null;
    return Map<String, dynamic>.from(userMap)['id'] as String?;
  }

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    // final userId = _cachedUserId;
    // var userId= Hive.box('authBox').get('user')['id'] as String?;
    final result = await apiService.get('$kBaseUrl/user/$_cachedUserId/cart');
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> addToCart({
    required String productId,
    required String variantId,
    required int quantity,
  }) async {
    final userId = _cachedUserId;
    if (userId == null) {
      return Left(
        CacheFailure(message: 'No cached user id — user is not logged in'),
      );
    }

    final result = await apiService.post(
      '$kBaseUrl/cart',
      data: {
        'user': userId,
        'products': [
          {'product': productId, 'variant': variantId, 'quantity': quantity},
        ],
      },
    );
    log(result.toString());
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> updateCartItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    final result = await apiService.patch(
      '$kBaseUrl/cart/$itemId',
      data: {'quantity': quantity},
    );
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> removeFromCart({
    required String itemId,
  }) async {
    final result = await apiService.delete('$kBaseUrl/cart/$itemId');
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
