import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/data/models/admin_product_variant_model.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_variant_repository.dart';

class GetAdminVariantsUseCase {
  final AdminVariantRepository repository;

  const GetAdminVariantsUseCase(this.repository);

  Future<Either<Failure, List<AdminProductVariantModel>>> call(
    String productId,
  ) {
    return repository.getVariants(productId);
  }
}
