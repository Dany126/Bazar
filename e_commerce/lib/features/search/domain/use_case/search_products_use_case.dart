import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/home/domain/entity/product_entity.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';
import 'package:e_commerce/features/search/domain/repo/search_repo.dart';
import 'package:equatable/equatable.dart';

class SearchProductsUsecase {
  final SearchRepository repository;

  SearchProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(
    SearchProductsParams params,
  ) {
    return repository.searchProducts(
      query: params.query,
      filter: params.filter,
    );
  }
}

class SearchProductsParams extends Equatable {
  final String query;
  final SearchFilterEntity filter;

  const SearchProductsParams({
    required this.query,
    this.filter = const SearchFilterEntity(),
  });

  @override
  List<Object?> get props => [query, filter];
}
