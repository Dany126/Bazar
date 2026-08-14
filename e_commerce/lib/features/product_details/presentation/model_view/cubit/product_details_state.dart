// lib/features/product_details/presenation/modelview/cubit/product_details_state.dart

import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailsEntity product;
  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}

class ReviewSubmitting extends ProductDetailsState {}

class ReviewSubmitted extends ProductDetailsState {
  final ReviewEntity review;
  ReviewSubmitted(this.review);
}

class ReviewError extends ProductDetailsState {
  final String message;
  ReviewError(this.message);
}
