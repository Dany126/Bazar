import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';

abstract class SearchRepository {
  /// An empty list is a valid (non-error) result — it drives the
  /// "no matching results" state and is NOT a Failure.
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    required SearchFilterEntity filter,
  });
}
