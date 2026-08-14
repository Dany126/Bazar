// lib/features/product_details/data/repo/product_details_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/product_details/domain/data_source/remote_data_source.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';
import 'package:e_commerce/features/product_details/domain/repo/product_details_repo.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) {
    return remoteDataSource.getProductDetails(productId: productId);
  }

  @override
  Future<Either<Failure, ReviewEntity>> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) {
    return remoteDataSource.addReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
