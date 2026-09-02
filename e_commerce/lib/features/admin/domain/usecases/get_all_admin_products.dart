import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

class GetAllAdminProductsUseCase {
  final AdminProductRepository repository;
  const GetAllAdminProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call() {
    return repository.getAllProducts();
  }
}