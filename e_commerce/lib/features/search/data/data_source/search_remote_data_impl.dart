import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:e_commerce/features/search/domain/data_source/search_remote_data.dart';
import 'package:e_commerce/features/search/domain/entity/search_filter_entity.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService apiService;

  SearchRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts({
    required String query,
    required SearchFilterEntity filter,
  }) async {
    final result = await apiService.get(
      '/product/',
      queryParameters: _buildQuery(query, filter),
    );

    return result.fold((failure) => Left(failure), (response) {
      final List<dynamic> data = response['data'] ?? response['results'] ?? [];
      final products = data.map((json) => ProductModel.fromJson(json)).toList();
      return Right(products);
    });
  }

  Map<String, dynamic> _buildQuery(String query, SearchFilterEntity filter) {
    return {
      'search': query,
      'sort': _sortParam(filter.sortBy),
      if (filter.gender != null) 'gender': filter.gender!.name,
      if (filter.deals != null) 'deals': filter.deals!.name,
      if (filter.minPrice != null) 'minPrice': filter.minPrice,
      if (filter.maxPrice != null) 'maxPrice': filter.maxPrice,
    };
  }

  String _sortParam(SortOption sort) {
    switch (sort) {
      case SortOption.recommended:
        return 'recommended';
      case SortOption.newest:
        return 'newest';
      case SortOption.lowestPrice:
        return 'price_asc';
      case SortOption.highestPrice:
        return 'price_desc';
    }
  }
}
