// lib/features/product_details/data/data_source/product_details_remote_data_source_impl.dart
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
    final result = await apiService.get('$kBaseUrl/product/$productId/variant');

    log(result.toString());

    return result.fold((failure) => Left(failure), (response) {
      try {
        final variants = response['variants'] as List<dynamic>? ?? [];

        if (variants.isEmpty) {
          return Left(ServerFailure(message: 'No product variants found'));
        }

        final firstVariant = variants.first as Map<String, dynamic>;

        final product = firstVariant['product'] as Map<String, dynamic>;

        return Right(
          ProductDetailsModel.fromVariantsJson(
            product: product,
            variantsJson: variants,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    });
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
