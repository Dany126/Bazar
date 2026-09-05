import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/datasources/admin_variant_remote_data_source.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_variant_repository.dart';

class AdminVariantRepositoryImpl implements AdminVariantRepository {
  final AdminVariantRemoteDataSource remoteDataSource;

  AdminVariantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AdminProductVariantModel>>> getVariants(
    String productId,
  ) {
    return remoteDataSource.getVariants(productId);
  }

  @override
  Future<Either<Failure, AdminProductVariantModel>> createVariant({
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stock,
  }) {
    return remoteDataSource.createVariant(
      productId: productId,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );
  }

  @override
  Future<Either<Failure, AdminProductVariantModel>> updateVariant({
    required String id,
    String? size,
    String? color,
    double? price,
    int? stock,
  }) {
    return remoteDataSource.updateVariant(
      id: id,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteVariant(String id) {
    return remoteDataSource.deleteVariant(id);
  }
}
