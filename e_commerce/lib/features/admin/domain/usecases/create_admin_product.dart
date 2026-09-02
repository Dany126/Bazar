import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

class CreateAdminProductUseCase {
  final AdminProductRepository repository;
  const CreateAdminProductUseCase(this.repository);

  Future<Either<Failure, ProductModel>> call({
    required String name,
    required String categoryId,
    required double price,
    required int stock,
    String? description,
    required List<String> imagePaths,
  }) {
    return repository.createProduct(
      name: name,
      categoryId: categoryId,
      price: price,
      stock: stock,
      description: description,
      imagePaths: imagePaths,
    );
  }
}