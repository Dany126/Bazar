import 'package:dio/dio.dart';
import 'package:e_commerce/core/services/api_services.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getBestSellingProducts({
    required int page,
    required int limit,
  });

  Future<List<ProductModel>> getNewProducts({
    required int page,
    required int limit,
  });

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
    required int limit,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiService.get('/category');

      final res = response.fold(
        (failure) => throw ServerException(message: failure.toString()),
        (data) => data,
      );

      final List<dynamic> data = res['data']['categories'] as List<dynamic>;

      return data
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch categories',
      );
    }
  }

  @override
  Future<List<ProductModel>> getBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        '/product',
        queryParameters: {'page': page, 'limit': limit},
      );

      final res = response.fold(
        (failure) => throw ServerException(message: failure.toString()),
        (data) => data,
      );

      final List<dynamic> data = res['data']['products'] as List<dynamic>;

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch best sellers',
      );
    }
  }

  @override
  Future<List<ProductModel>> getNewProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        '/product',
        queryParameters: {'page': page, 'limit': limit},
      );

      final res = response.fold(
        (failure) => throw ServerException(message: failure.toString()),
        (data) => data,
      );

      final List<dynamic> data = res['data']['products'] as List<dynamic>;

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch new products',
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        '/product',
        queryParameters: {'category': categoryId, 'page': page, 'limit': limit},
      );

      final res = response.fold(
        (failure) => throw ServerException(message: failure.toString()),
        (data) => data,
      );

      final List<dynamic> data = res['data']['products'] as List<dynamic>;

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] ?? 'Failed to fetch category products',
      );
    }
  }
}
