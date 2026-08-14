// lib/features/product_details/domin/repo/product_details_repo.dart
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/product_details/domain/entity/product_details_entity.dart';
import 'package:e_commerce/features/product_details/domain/entity/review_entity_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails({
    required String productId,
  });

  Future<Either<Failure, ReviewEntity>> addReview({
    required String productId,
    required double rating,
    required String comment,
  });
}
