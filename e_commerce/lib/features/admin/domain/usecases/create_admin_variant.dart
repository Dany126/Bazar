import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_variant_repository.dart';

class CreateAdminVariantUseCase {
  final AdminVariantRepository repository;

  const CreateAdminVariantUseCase(this.repository);

  Future<Either<Failure, AdminProductVariantModel>> call({
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stock,
  }) {
    return repository.createVariant(
      productId: productId,
      size: size,
      color: color,
      price: price,
      stock: stock,
    );
  }
}
