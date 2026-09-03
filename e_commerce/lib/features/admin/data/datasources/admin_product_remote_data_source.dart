import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class AdminProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();

  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required List<XFile> images,
  });

  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
  });

  Future<Either<Failure, Unit>> deleteProduct(String id);
}

class AdminProductRemoteDataSourceImpl implements AdminProductRemoteDataSource {
  final ApiService apiService;

  AdminProductRemoteDataSourceImpl({required this.apiService});

  @override
  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final result = await apiService.get('$kBaseUrl/product');

      return result.fold(
        (failure) {
          // Backend returns 404 when there are no products.
          // For the admin products screen, that means an empty list,
          // not an actual application error.
          if (failure is ServerFailure &&
              failure.message.toLowerCase().contains('no product')) {
            return const Right(<ProductModel>[]);
          }

          return Left(failure);
        },
        (data) {
          final productsJson = (data['products'] as List?) ?? [];

          final products = productsJson
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList();

          return Right(products);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct({
    required String name,
    required String categoryId,
    required double price,
    required List<XFile> images,
  }) async {
    try {
      final formData = FormData();

      formData.fields.add(MapEntry('name', name));

      formData.fields.add(MapEntry('category', categoryId));

      formData.fields.add(MapEntry('price', price.toString()));

      for (final image in images) {
        final bytes = await image.readAsBytes();

        formData.files.add(
          MapEntry(
            'image',
            MultipartFile.fromBytes(bytes, filename: image.name),
          ),
        );
      }

      final result = await apiService.post('$kBaseUrl/product', data: formData);

      return result.fold((failure) => Left(failure), (data) {
        final productJson = data['product'] ?? data['data'] ?? data;

        if (productJson is! Map<String, dynamic>) {
          return Left(
            ServerFailure(message: 'Invalid product data returned from server'),
          );
        }

        return Right(ProductModel.fromJson(productJson));
      });
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.response?.data['message'] ?? e.message),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct({
    required String id,
    String? name,
    String? categoryId,
    double? price,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (name != null && name.trim().isNotEmpty) {
        data['name'] = name.trim();
      }

      if (categoryId != null && categoryId.trim().isNotEmpty) {
        data['category'] = categoryId;
      }

      if (price != null) {
        data['price'] = price;
      }

      if (data.isEmpty) {
        return Left(
          ServerFailure(message: 'No product fields were provided for update'),
        );
      }

      final result = await apiService.patch(
        '$kBaseUrl/product/$id',
        data: data,
      );

      return result.fold((failure) => Left(failure), (responseData) {
        final productJson =
            responseData['product'] ?? responseData['data'] ?? responseData;

        if (productJson is! Map<String, dynamic>) {
          return Left(
            ServerFailure(message: 'Product data not found in response'),
          );
        }

        return Right(ProductModel.fromJson(productJson));
      });
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.response?.data['message'] ?? e.message),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      final result = await apiService.delete('$kBaseUrl/product/$id');

      return result.fold((failure) => Left(failure), (_) => const Right(unit));
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.response?.data['message'] ?? e.message),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
