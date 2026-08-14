// lib/features/product_details/domin/data_source/remote_data_source/product_details_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/product_details/data/model/product_details_model.dart';
import 'package:e_commerce/features/product_details/data/model/review_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<Either<Failure, ProductDetailsModel>> getProductDetails({
    required String productId,
  });

  Future<Either<Failure, ReviewModel>> addReview({
    required String productId,
    required double rating,
    required String comment,
  });
}
