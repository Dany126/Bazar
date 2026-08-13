import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';

abstract class SearchRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> searchProducts({
    required String query,
    required SearchFilterEntity filter,
  });
}
