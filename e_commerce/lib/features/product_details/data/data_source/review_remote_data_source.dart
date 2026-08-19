import 'package:dio/dio.dart';

import '../model/review_model.dart';

class ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSource({required this.dio});

  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final response = await dio.get(
      '/review',
      queryParameters: {'product': productId},
    );

    final reviews = response.data['review'] as List? ?? [];

    return reviews
        .map((review) => ReviewModel.fromJson(review as Map<String, dynamic>))
        .toList();
  }

  Future<ReviewModel> createReview({
    required String productId,
    required double rating,
    required String description,
  }) async {
    final response = await dio.post(
      '/review',
      data: {
        'product': productId,
        'rating': rating,
        'description': description,
      },
    );

    return ReviewModel.fromJson(response.data['review']);
  }

  Future<void> deleteReview(String reviewId) async {
    await dio.delete('/reviews/$reviewId');
  }
}
