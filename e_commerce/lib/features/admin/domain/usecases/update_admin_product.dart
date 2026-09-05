import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateAdminProductUseCase {
  final AdminProductRepository repository;

  const UpdateAdminProductUseCase(this.repository);

  Future<Either<Failure, ProductModel>> call({
    required String id,
    String? name,
    String? categoryId,
    double? price,
    List<XFile>? images,
  }) {
    return repository.updateProduct(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      images: images,
    );
  }
}