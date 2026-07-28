import 'package:dio/dio.dart';
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
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/categories');
      final List data = response.data['data'] as List;
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
      final response = await dio.get(
        '/products/best-selling',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
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
      final response = await dio.get(
        '/products/new',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch new arrivals',
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
      final response = await dio.get(
        '/categories/$categoryId/products',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message:
            e.response?.data['message'] ??
            'Failed to fetch products for this category',
      );
    }
  }
}
