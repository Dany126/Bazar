// lib/features/product_details/presenation/modelview/cubit/product_details_cubit.dart
import 'package:e_commerce/features/product_details/domain/use_case/add_product_review_use_case.dart';
import 'package:e_commerce/features/product_details/domain/use_case/get_product_details_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final AddProductReviewUseCase addProductReviewUseCase;

  ProductDetailsCubit({
    required this.getProductDetailsUseCase,
    required this.addProductReviewUseCase,
  }) : super(ProductDetailsInitial());

  Future<void> getProductDetails({required String productId}) async {
    emit(ProductDetailsLoading());

    final result = await getProductDetailsUseCase(productId: productId);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }

  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    emit(ReviewSubmitting());

    final result = await addProductReviewUseCase(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    result.fold(
      (failure) => emit(ReviewError(failure.message)),
      (review) => emit(ReviewSubmitted(review)),
    );
  }
}
