// lib/features/product_details/domin/use_case/add_product_review_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';
import 'package:e_commerce/features/product_details/domain/repo/product_details_repo.dart';

class AddProductReviewUseCase {
  final ProductDetailsRepository repository;

  AddProductReviewUseCase(this.repository);

  Future<Either<Failure, ReviewEntity>> call({
    required String productId,
    required double rating,
    required String comment,
  }) {
    return repository.addReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
