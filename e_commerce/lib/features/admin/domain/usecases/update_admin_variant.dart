import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_variant_repository.dart';

class UpdateAdminVariantUseCase {
  final AdminVariantRepository repository;

  const UpdateAdminVariantUseCase(this.repository);

  Future<Either<Failure, AdminProductVariantModel>> call({
    required String id,
    String? size,
    String? color,
    double? price,
    int? stock,
  }) {
    return repository.updateVariant(
      id: id,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );
  }
}
