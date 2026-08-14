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
      final data = response is Map && response.containsKey('cart')
          ? response['cart'] as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return Right(CartModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    final result = await apiService.get('$kBaseUrl/cart');
    return result.fold((failure) => Left(failure), _parse);
  }

  @override
  Future<Either<Failure, CartModel>> addToCart({
    required String productId,
    String? size,
    String? color,
    required int quantity,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/cart',
      data: {
        'productId': productId,
        if (size != null) 'size': size,
        if (color != null) 'color': color,
        'quantity': quantity,
      },
    );
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
