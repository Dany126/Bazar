import 'package:e_commerce/features/product_details/domain/repo/review_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repository;

  ReviewCubit({required this.repository}) : super(ReviewInitial());

  Future<void> getProductReviews(String productId) async {
    try {
      emit(ReviewLoading());

      final reviews = await repository.getProductReviews(productId);

      emit(ReviewSuccess(reviews: reviews));
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }

  Future<void> createReview({
    required String productId,
    required double rating,
    required String description,
  }) async {
    try {
      emit(ReviewCreating());

      final review = await repository.createReview(
        productId: productId,
        rating: rating,
        description: description,
      );

      emit(ReviewCreated(review: review));

      await getProductReviews(productId);
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }

  Future<void> deleteReview({
    required String reviewId,
    required String productId,
  }) async {
    try {
      emit(ReviewDeleting());

      await repository.deleteReview(reviewId);

      emit(ReviewDeleted());

      await getProductReviews(productId);
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }
}
