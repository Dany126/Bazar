import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/services/api_services.dart';
import '../../../../core/error/exceptions.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<ProductModel>> getAllProducts({
    required int page,
    required int limit,
  });

  Future<List<ProductModel>> getBestSellingProducts({
    required int page,
    required int limit,
  });

  Future<List<ProductModel>> getNewestProducts({
    required int page,
    required int limit,
  });

  Future<List<ProductModel>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await apiService.get(kGetAllGategories);

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
  Future<List<ProductModel>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        kGetAllProducts,
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
        message: e.response?.data['message'] ?? 'Failed to fetch products',
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
        kGetNewProductByCategory,
        queryParameters: {'page': page, 'limit': limit, 'sort': "-stock"},
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
        message: e.response?.data['message'] ?? 'Failed to fetch products',
      );
    }
  }

  @override
  Future<List<ProductModel>> getNewestProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        kGetBestSellerProductByCategory,
        queryParameters: {'page': page, 'limit': limit, 'sort': "-createdAt"},
      );

      final res = response.fold(
        (failure) => throw ServerException(message: failure.toString()),
        (data) => data,
      );

      log(res);

      final List<dynamic> data = res['data']['products'] as List<dynamic>;

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to fetch products',
      );
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiService.get(
        "$kGetProductByCategory/$category/product",
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
        message: e.response?.data['message'] ?? 'Failed to fetch products',
      );
    }
  }
}
