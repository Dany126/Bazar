import 'package:dartz/dartz.dart';
import 'package:e_commerce/constant.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/services/api_services.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';

abstract class AdminVariantRemoteDataSource {
  Future<Either<Failure, List<AdminProductVariantModel>>> getVariants(
    String productId,
  );

  Future<Either<Failure, AdminProductVariantModel>> createVariant({
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stock,
  });

  Future<Either<Failure, AdminProductVariantModel>> updateVariant({
    required String id,
    String? size,
    String? color,
    double? price,
    int? stock,
  });

  Future<Either<Failure, Unit>> deleteVariant(String id);
}

class AdminVariantRemoteDataSourceImpl implements AdminVariantRemoteDataSource {
  final ApiService apiService;

  AdminVariantRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<Failure, List<AdminProductVariantModel>>> getVariants(
    String productId,
  ) async {
    final result = await apiService.get('$kBaseUrl/product/$productId/variant');

    return result.fold((failure) => Left(failure), (data) {
      final variantsJson = (data['variants'] as List?) ?? [];

      final variants = variantsJson
          .whereType<Map<String, dynamic>>()
          .map(AdminProductVariantModel.fromJson)
          .toList();

      return Right(variants);
    });
  }

  @override
  Future<Either<Failure, AdminProductVariantModel>> createVariant({
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stock,
  }) async {
    final body = {
      'product': productId,
      'size': size,
      'color': color,
      'price': price,
      'stock': stock,
    };

    final result = await apiService.post(
      '$kBaseUrl/product/$productId/variant',
      data: body,
    );

    return result.fold((failure) => Left(failure), (data) {
      final json = Map<String, dynamic>.from(data['variant'] ?? data);

      return Right(AdminProductVariantModel.fromJson(json));
    });
  }

  @override
  Future<Either<Failure, AdminProductVariantModel>> updateVariant({
    required String id,
    String? size,
    String? color,
    double? price,
    int? stock,
  }) async {
    final body = <String, dynamic>{
      if (size != null) 'size': size,
      if (color != null) 'color': color,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
    };

    final result = await apiService.patch('$kBaseUrl/variant/$id', data: body);

    return result.fold((failure) => Left(failure), (data) {
      final json = Map<String, dynamic>.from(
        data['updatedVariant'] ?? data['variant'] ?? data,
      );

      return Right(AdminProductVariantModel.fromJson(json));
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteVariant(String id) async {
    final result = await apiService.delete('$kBaseUrl/variant/$id');

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }
}
