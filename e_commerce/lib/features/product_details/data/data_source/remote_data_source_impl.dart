import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/product_details/data/model/product_details_model.dart';
import 'package:e_commerce/features/product_details/data/model/review_model.dart';
import 'package:e_commerce/features/product_details/domain/data_source/remote_data_source.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ApiService apiService;

  ProductDetailsRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, ProductDetailsModel>> getProductDetails({
    required String productId,
  }) async {
    try {
      // ---------------------------------------------------------
      // 1. Get product details
      // ---------------------------------------------------------

      final result = await apiService.get(
        '$kBaseUrl/product/$productId/variant',
      );

      log('PRODUCT DETAILS RESULT: $result');

      return await result.fold(
        (failure) async {
          return Left(failure);
        },
        (response) async {
          try {
            final variants = response['variants'] as List<dynamic>? ?? [];

            if (variants.isEmpty) {
              return Left(ServerFailure(message: 'No product variants found'));
            }

            final firstVariant = variants.first as Map<String, dynamic>;

            final product = firstVariant['product'] as Map<String, dynamic>;

            // ---------------------------------------------------------
            // 2. Create ProductDetailsModel
            // ---------------------------------------------------------

            final productDetails = ProductDetailsModel.fromVariantsJson(
              product: product,
              variantsJson: variants,
            );

            // ---------------------------------------------------------
            // 3. Check wishlist
            // ---------------------------------------------------------

            final isFavorite = await _isProductFavorite(productId);

            // ---------------------------------------------------------
            // 4. Set favorite status
            // ---------------------------------------------------------

            productDetails.isFavorite = isFavorite;

            log(
              'PRODUCT ID: $productId | '
              'IS FAVORITE: $isFavorite',
            );

            return Right(productDetails);
          } catch (e) {
            log('PRODUCT DETAILS PARSE ERROR: $e');

            return Left(ServerFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      log('PRODUCT DETAILS ERROR: $e');

      return Left(ServerFailure(message: e.toString()));
    }
  }

  // =============================================================
  // Check if product exists in user's wishlist
  // =============================================================

  Future<bool> _isProductFavorite(String productId) async {
    try {
      final result = await apiService.get(
        '$kBaseUrl/wishlist',
        queryParameters: {'page': 1, 'limit': 100},
      );

      return result.fold(
        (failure) {
          log('WISHLIST CHECK FAILED: ${failure.toString()}');

          return false;
        },
        (data) {
          final wishlists = (data['wishList'] as List<dynamic>?) ?? [];

          for (final wishlist in wishlists) {
            if (wishlist is! Map<String, dynamic>) {
              continue;
            }

            final product = wishlist['product'];

            // product is an object
            if (product is Map<String, dynamic>) {
              final id = product['_id']?.toString();

              if (id == productId) {
                return true;
              }
            }

            // product is a list
            if (product is List) {
              for (final item in product) {
                if (item is Map<String, dynamic>) {
                  final id = item['_id']?.toString();

                  if (id == productId) {
                    return true;
                  }
                }
              }
            }
          }

          return false;
        },
      );
    } catch (e) {
      log('WISHLIST CHECK ERROR: $e');
      return false;
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final result = await apiService.post(
      '$kBaseUrl/product/$productId/reviews',
      data: {'rating': rating, 'comment': comment},
    );

    return result.fold((failure) => Left(failure), (response) {
      try {
        final data = response is Map && response.containsKey('review')
            ? response['review'] as Map<String, dynamic>
            : response as Map<String, dynamic>;

        return Right(ReviewModel.fromJson(data));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
  }
}
