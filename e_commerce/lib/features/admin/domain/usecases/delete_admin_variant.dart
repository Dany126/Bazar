import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_variant_repository.dart';

class DeleteAdminVariantUseCase {
  final AdminVariantRepository repository;

  const DeleteAdminVariantUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteVariant(id);
  }
}
