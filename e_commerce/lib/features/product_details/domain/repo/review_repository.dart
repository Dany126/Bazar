import '../entity/review_entity_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getProductReviews(String productId);

  Future<ReviewEntity> createReview({
    required String productId,
    required double rating,
    required String description,
  });

  Future<void> deleteReview(String reviewId);
}
