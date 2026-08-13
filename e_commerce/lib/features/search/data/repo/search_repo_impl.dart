import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/search/domain/data_source/search_remote_data.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';
import 'package:e_commerce/features/search/domain/repo/search_repo.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts({
    required String query,
    required SearchFilterEntity filter,
  }) async {
    final result = await remoteDataSource.searchProducts(
      query: query,
      filter: filter,
    );

    return result.fold(
      (failure) => Left(failure),
      (models) =>
          Right(models), // ProductModel extends ProductEntity in most setups
    );
  }
}
