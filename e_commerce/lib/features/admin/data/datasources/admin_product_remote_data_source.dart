import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

abstract class AdminProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();

  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? description,
    required List<String> imagePaths,
  });

  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    int? stock,
    bool? isActive,
    String? description,
  });

  Future<Either<Failure, Unit>> deleteProduct(String id);
}

class AdminProductRemoteDataSourceImpl implements AdminProductRemoteDataSource {
  final ApiService apiService;

  AdminProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    final result = await apiService.get('$kBaseUrl/product');

    return result.fold((failure) => Left(failure), (data) {
      final productsJson = (data['products'] as List?) ?? [];
      final products = productsJson
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
      return Right(products);
    });
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? description,
    required List<String> imagePaths,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'category': categoryId,
      'price': price,
      'stock': stock,
      if (description != null) 'description': description,
      'image': [
        for (final path in imagePaths) await MultipartFile.fromFile(path),
      ],
    });

    final result = await apiService.post('$kBaseUrl/product', data: formData);

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(ProductModel.fromJson(data['product'] ?? data)),
    );
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    int? stock,
    bool? isActive,
    String? description,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (categoryId != null) 'category': categoryId,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (isActive != null) 'isActive': isActive,
      if (description != null) 'description': description,
    };

    final result = await apiService.patch('$kBaseUrl/product/$id', data: body);

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(ProductModel.fromJson(data['product'] ?? data)),
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    final result = await apiService.delete('$kBaseUrl/product/$id');
    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }
}
