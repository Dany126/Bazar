import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';
import 'package:e_commerce/features/product_details/domain/repo/review_repository.dart';

import '../data_source/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReviewEntity>> getProductReviews(String productId) async {
    return await remoteDataSource.getProductReviews(productId);
  }

  @override
  Future<ReviewEntity> createReview({
    required String productId,
    required double rating,
    required String description,
  }) async {
    return await remoteDataSource.createReview(
      productId: productId,
      rating: rating,
      description: description,
    );
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await remoteDataSource.deleteReview(reviewId);
  }
}
