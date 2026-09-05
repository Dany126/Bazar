import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/admin/domain/repositories/admin_category_repository.dart';
import 'package:e_commerce/features/home/data/models/product_model.dart';

class GetProductsByCategoryUseCase {
  final AdminCategoriesRepository repository;

  const GetProductsByCategoryUseCase({required this.repository});

  Future<Either<Failure, List<ProductModel>>> call({
    required String categoryId,
  }) {
    return repository.getProductsByCategory(categoryId: categoryId);
  }
}
