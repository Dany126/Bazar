import 'package:dartz/dartz.dart';

import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

class UpdateAdminProductUseCase {
  final AdminProductRepository repository;

  const UpdateAdminProductUseCase(this.repository);

  Future<Either<Failure, ProductModel>> call({
    required String id,
    String? name,
    String? categoryId,
    double? price,
  }) {
    return repository.updateProduct(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
    );
  }
}
