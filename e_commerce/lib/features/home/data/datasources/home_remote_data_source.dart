
import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> getAllCategories();
  Future<Either<Failure, List<ProductModel>>> getAllProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getBestSellingProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getNewestProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategories() async {
    final response = await apiService.get(kGetAllGategories);

    return response.fold((failure) => Left(failure), (data) {
      final List<dynamic> categoriesJson = data['categories'] as List<dynamic>;

      final categories = categoriesJson
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(categories);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetAllProducts,
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.fold((failure) => Left(failure), (data) {
      final List<dynamic> productsJson = data['products'] as List<dynamic>;
      final products = productsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(products);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getBestSellingProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetBestSellerProductByCategory,
      queryParameters: {'page': page, 'limit': limit, 'sort': "-stock"},
    );

    return response.fold((failure) => Left(failure), (data) {
      final List<dynamic> productsJson = data['products'] as List<dynamic>;

      final products = productsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(products);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getNewestProducts({
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      kGetNewProductByCategory,
      queryParameters: {'page': page, 'limit': limit, 'sort': "-createdAt"},
    );

    return response.fold((failure) => Left(failure), (data) {
      final List<dynamic> productsJson = data['products'] as List<dynamic>;

      final products = productsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(products);
    });
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String category,
    required int page,
    required int limit,
  }) async {
    final response = await apiService.get(
      "$kGetProductByCategory/$category/product",
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.fold((failure) => Left(failure), (data) {
      final List<dynamic> productsJson = data['products'] as List<dynamic>;

      final products = productsJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(products);
    });
  }
}
