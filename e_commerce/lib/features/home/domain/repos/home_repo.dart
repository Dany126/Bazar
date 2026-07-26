import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/category_entity.dart';
import '../entity/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, List<ProductEntity>>> getBestSellingProducts({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<ProductEntity>>> getNewProducts({
    int page = 1,
    int limit = 10,
  });
}
