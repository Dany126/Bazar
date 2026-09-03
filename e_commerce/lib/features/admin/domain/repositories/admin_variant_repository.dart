import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';

abstract class AdminVariantRepository {
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
