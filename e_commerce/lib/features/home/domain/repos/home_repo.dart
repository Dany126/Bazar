import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/category_entity.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();

  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    required int page,
    required int limit,
  });
  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts({
    required int page,
    required int limit,
  });
  Future<Either<Failure, List<ProductEntity>>> getNewestProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  });
}
