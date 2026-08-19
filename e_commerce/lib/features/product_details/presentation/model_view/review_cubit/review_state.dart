import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final List<ReviewEntity> reviews;

  ReviewSuccess({required this.reviews});
}

class ReviewCreating extends ReviewState {}

class ReviewCreated extends ReviewState {
  final ReviewEntity review;

  ReviewCreated({required this.review});
}

class ReviewDeleting extends ReviewState {}

class ReviewDeleted extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;

  ReviewError({required this.message});
}
