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
    List<XFile>? images,
  });

  Future<Either<Failure, Unit>> deleteProduct(String id);
}

class AdminProductRemoteDataSourceImpl implements AdminProductRemoteDataSource {
  final ApiService apiService;

  AdminProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    final result = await apiService.get('$kBaseUrl/product');

    return result.fold(
      (failure) {
        if (failure is ServerFailure &&
            failure.statusCode == 404 &&
            failure.message.toLowerCase().contains('no product found')) {
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
        ServerFailure(
          message:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to create product',
        ),
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
    List<XFile>? images,
  }) async {
    try {
      final formData = FormData();

      /*
      |--------------------------------------------------------------------------
      | Text fields
      |--------------------------------------------------------------------------
      */

      if (name != null && name.trim().isNotEmpty) {
        formData.fields.add(MapEntry('name', name.trim()));
      }

      if (categoryId != null && categoryId.trim().isNotEmpty) {
        formData.fields.add(MapEntry('category', categoryId.trim()));
      }

      if (price != null) {
        formData.fields.add(MapEntry('price', price.toString()));
      }

      /*
      |--------------------------------------------------------------------------
      | New images
      |--------------------------------------------------------------------------
      */

      if (images != null && images.isNotEmpty) {
        for (final image in images) {
          final bytes = await image.readAsBytes();

          formData.files.add(
            MapEntry(
              'image',
              MultipartFile.fromBytes(bytes, filename: image.name),
            ),
          );
        }
      }

      /*
      |--------------------------------------------------------------------------
      | Make sure something is actually being updated.
      |--------------------------------------------------------------------------
      */

      if (formData.fields.isEmpty && formData.files.isEmpty) {
        return Left(
          ServerFailure(message: 'No product fields were provided for update'),
        );
      }

      /*
      |--------------------------------------------------------------------------
      | PATCH
      |--------------------------------------------------------------------------
      */

      final result = await apiService.patch(
        '$kBaseUrl/product/$id',
        data: formData,
      );

      return result.fold((failure) => Left(failure), (responseData) {
        /*
           * Backend now returns both:
           *
           * product
           * updatedProduct
           *
           * so support either one.
           */

        final productJson =
            responseData['product'] ??
            responseData['updatedProduct'] ??
            responseData['data'] ??
            responseData;

        if (productJson is! Map<String, dynamic>) {
          return Left(
            ServerFailure(message: 'Product data not found in response'),
          );
        }

        return Right(ProductModel.fromJson(productJson));
      });
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to update product',
        ),
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
        ServerFailure(
          message:
              e.response?.data?['message'] ??
              e.message ??
              'Failed to delete product',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
