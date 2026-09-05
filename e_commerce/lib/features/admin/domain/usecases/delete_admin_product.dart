import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';

class DeleteAdminProductUseCase {
  final AdminProductRepository repository;
  const DeleteAdminProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteProduct(id);
  }
}
